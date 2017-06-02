/*
 * Copyright (C) 2016 Florent Revest <revestflo@gmail.com>
 * All rights reserved.
 *
 * You may use this file under the terms of BSD license as follows:
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of the author nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include "flatmeshnode.h"

#include <math.h>

#include <QScreen>
#include <QElapsedTimer>

#define FRAMES_PER_ANIM 34

/* Used to compute a triangle color from its distance to the center */
static inline QColor interpolateColors(const QColor& color1, const QColor& color2, qreal ratio)
{
    /* Linear scale is too harsh, this looks better. This is not supposed to be called very often */
    ratio = pow(ratio, 1.7);
    if (ratio>1) ratio=1;

    int r = color1.red()*(1-ratio) + color2.red()*ratio;
    int g = color1.green()*(1-ratio) + color2.green()*ratio;
    int b = color1.blue()*(1-ratio) + color2.blue()*ratio;

    return QColor(r, g, b);
}

FlatMeshNode::FlatMeshNode(QQuickWindow *window, QRectF boundingRect)
    : QSGSimpleRectNode(boundingRect, Qt::transparent),
      m_animationState(0), m_animated(true)
{
    connect(window, SIGNAL(afterRendering()), this, SLOT(maybeAnimate()));

    connect(window, SIGNAL(widthChanged(int)), this, SLOT(generateGrid()));
    connect(window, SIGNAL(heightChanged(int)), this, SLOT(generateGrid()));

    srand(time(NULL));
    generateGrid();

    for(int y = 0; y < NUM_POINTS_Y-1; y++) {
        for(int x = 0; x < NUM_POINTS_X-1; x++) {
            for(int n = 0; n < 2; n++) {
                QSGGeometryNode *triangle = new QSGGeometryNode();

                QSGFlatColorMaterial *color = new QSGFlatColorMaterial;
                triangle->setOpaqueMaterial(color);
                triangle->setFlag(QSGNode::OwnsMaterial);

                QSGGeometry *geometry = new QSGGeometry(QSGGeometry::defaultAttributes_Point2D(), 3);
                triangle->setGeometry(geometry);
                triangle->setFlag(QSGNode::OwnsGeometry);

                appendChildNode(triangle);
            }
        }
    }

    maybeAnimate();
}

void FlatMeshNode::updateColors()
{
    int centerX = m_unitWidth*((NUM_POINTS_X-2)/2);
    int centerY = m_unitHeight*((NUM_POINTS_Y-2)/2);
    int radius = rect().width()*0.6;

    QSGGeometryNode *triangle = static_cast<QSGGeometryNode *>(firstChild());
    for(int y = 0; y < NUM_POINTS_Y-1; y++) {
        for(int x = 0; x < NUM_POINTS_X-1; x++) {
            for(int n = 0; n < 2; n++) {
                QSGFlatColorMaterial *color = static_cast<QSGFlatColorMaterial *>(triangle->opaqueMaterial());
                color->setColor(interpolateColors(m_centerColor, m_outerColor,
                                sqrt(pow(m_points[y*NUM_POINTS_Y+x].centerX-centerX, 2) + pow(m_points[y*NUM_POINTS_Y+x].centerY-centerY, 2))/radius));
                triangle->setOpaqueMaterial(color);

                triangle->markDirty(QSGNode::DirtyMaterial);
                triangle = static_cast<QSGGeometryNode *>(triangle->nextSibling());
            }
        }
    }
}

void FlatMeshNode::setCenterColor(QColor c)
{
    if (c == m_centerColor)
        return;
    m_centerColor = c;
    updateColors();
}

void FlatMeshNode::setOuterColor(QColor c)
{
    if (c == m_outerColor)
        return;
    m_outerColor = c;
    updateColors();
}

/* When the size changes, regenerate a grid of points that serves as a base for further operations */
void FlatMeshNode::generateGrid()
{
    m_unitWidth = rect().width()/(NUM_POINTS_X-2);
    m_unitHeight = rect().height()/(NUM_POINTS_Y-2);

    for(int y = 0; y < NUM_POINTS_Y; y++) {
        for(int x = 0; x < NUM_POINTS_X; x++) {
            Point *point = &m_points[y*NUM_POINTS_Y+x];
            point->centerX = m_unitWidth*x;
            point->centerY = m_unitHeight*y;

            if(x != 0 && x != (NUM_POINTS_X-1) && y != 0 && y != (NUM_POINTS_Y-1)) {
                int offsetX = rand()%m_unitWidth - m_unitWidth/3;
                int offsetY = rand()%m_unitHeight - m_unitHeight/3;
                float normalization = ((float)m_unitWidth)/(2*(abs(offsetX)+abs(offsetY)));
                offsetX*=normalization;
                offsetY*=normalization;
                point->currentPos.x = point->centerX + offsetX;
                point->currentPos.y = point->centerY + offsetY;

                offsetX = rand()%m_unitWidth - m_unitWidth/3;
                offsetY = rand()%m_unitHeight - m_unitHeight/3;
                normalization = ((float)m_unitWidth)/(2*(abs(offsetX)+abs(offsetY)));
                offsetX*=normalization;
                offsetY*=normalization;

                point->animDeltaX = (point->centerX + offsetX - point->currentPos.x)/FRAMES_PER_ANIM;
                point->animDeltaY = (point->centerY + offsetY - point->currentPos.y)/FRAMES_PER_ANIM;
            }
            else {
                point->currentPos.x = point->centerX;
                point->currentPos.y = point->centerY;
            }
        }
    }
}

void FlatMeshNode::setAnimated(bool animated)
{
    m_animated = animated;
}

void FlatMeshNode::maybeAnimate()
{
    static QElapsedTimer t;
    bool firstFrame = false;
    if(!t.isValid()) {
        t.start();
        firstFrame = true;
    }
    if (firstFrame || (m_animated && t.elapsed() >= 80)) {
        t.restart();
        m_animationState++;

        /* Move points according to their deltaX and deltaY */
        for(int i = 0; i < NUM_POINTS_X*NUM_POINTS_Y; i++) {
            Point *p = &m_points[i];

            p->currentPos.x += p->animDeltaX;
            p->currentPos.y += p->animDeltaY;
        }

        /* Update all triangles' geometries according to the new points position */
        qreal lastCenterX = m_unitWidth*(NUM_POINTS_X-1);
        qreal lastcenterY = m_unitHeight*(NUM_POINTS_Y-1);
        QSGGeometryNode *triangle = static_cast<QSGGeometryNode *>(firstChild());
        for(int i = 0; i < NUM_POINTS_X*NUM_POINTS_Y; i++) {
            if(m_points[i].centerX != lastCenterX && m_points[i].centerY != lastcenterY) {
                QSGGeometry::Point2D *lowerV = triangle->geometry()->vertexDataAsPoint2D();
                lowerV[0] = m_points[i].currentPos;
                lowerV[1] = m_points[i+NUM_POINTS_X].currentPos;
                lowerV[2] = m_points[i+NUM_POINTS_X+1].currentPos;
                triangle->markDirty(QSGNode::DirtyGeometry);
                triangle = static_cast<QSGGeometryNode *>(triangle->nextSibling());

                QSGGeometry::Point2D *upperV = triangle->geometry()->vertexDataAsPoint2D();
                upperV[0] = m_points[i].currentPos;
                upperV[1] = m_points[i+1].currentPos;
                upperV[2] = m_points[i+NUM_POINTS_X+1].currentPos;
                triangle = static_cast<QSGGeometryNode *>(triangle->nextSibling());
            }
        }

        /* Regenerate a set of animation end points when the animation is finished */
        if(m_animationState >= FRAMES_PER_ANIM) {
            m_animationState = 0;

            for(int y = 0; y < NUM_POINTS_Y; y++) {
                for(int x = 0; x < NUM_POINTS_X; x++) {
                    Point *point = &m_points[y*NUM_POINTS_Y+x];

                    if(x != 0 && x != (NUM_POINTS_X-1) && y != 0 && y != (NUM_POINTS_Y-1)) {
                        int offsetX = rand()%m_unitWidth - m_unitWidth/3;
                        int offsetY = rand()%m_unitHeight - m_unitHeight/3;
                        float normalization = ((float)m_unitWidth)/(2*(abs(offsetX)+abs(offsetY)));
                        offsetX*=normalization;
                        offsetY*=normalization;

                        point->animDeltaX = (point->centerX + offsetX - point->currentPos.x)/FRAMES_PER_ANIM;
                        point->animDeltaY = (point->centerY + offsetY - point->currentPos.y)/FRAMES_PER_ANIM;
                    }
                }
            }
        }
    }
}
