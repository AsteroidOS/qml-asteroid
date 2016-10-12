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

#include "flatmesh.h"

#include <QSGSimpleRectNode>
#include <math.h>

/* Used to compute a triangle color from its distance to the center */
static inline QColor interpolateColors(const QColor& color1, const QColor& color2, qreal ratio)
{
    /* Linear scale is too harsh, this looks better */
    ratio = pow(ratio, 1.7);
    if (ratio>1) ratio=1;

    int r = color1.red()*(1-ratio) + color2.red()*ratio;
    int g = color1.green()*(1-ratio) + color2.green()*ratio;
    int b = color1.blue()*(1-ratio) + color2.blue()*ratio;

    return QColor(r, g, b);
}

/* Used to compute a position during an animation */
static inline QSGGeometry::Point2D interpolatePos(Point p, qreal ratio)
{
    QSGGeometry::Point2D ret;

    ret.x = p.animOriginX + (p.animEndX-p.animOriginX)*ratio;
    ret.y = p.animOriginY + (p.animEndY-p.animOriginY)*ratio;

    return ret;
}

FlatMesh::FlatMesh(QQuickItem *parent) : QQuickItem(parent)
{
    setFlag(ItemHasContents);
    previousHeight = previousWidth = 0.0;
    points = new Point[NUM_POINTS_X*NUM_POINTS_Y];
    centerColor = QColor("#ffaa39");
    outerColor = QColor("#df4829");
    animationState = 0.0;

    timer = new QTimer(this);
    timer->setInterval(40);
    connect(timer, SIGNAL(timeout()), this, SLOT(update()));
    // timer->start();
}

void FlatMesh::setAnimated(bool animated)
{
    if(animated && !timer->isActive())
        timer->start();
    else if(!animated && timer->isActive())
        timer->stop();
}

bool FlatMesh::getAnimated()
{
    return timer->isActive();
}

QSGNode *FlatMesh::updatePaintNode(QSGNode *n, UpdatePaintNodeData *)
{
    const QRectF rect = boundingRect();
    srand(time(NULL));

    int unitWidth = rect.width()/(NUM_POINTS_X-2);
    int unitHeight = rect.height()/(NUM_POINTS_Y-2);

    /* When the size changes, regenerate a grid of points that serves as a base for further operations */
    if(rect.width() != previousWidth || rect.height() != previousHeight)
    {
        for(int y = 0; y < NUM_POINTS_Y; y++) {
            for(int x = 0; x < NUM_POINTS_X; x++) {
                Point point;
                point.centerX = unitWidth*x;
                point.centerY = unitHeight*y;

                if(x != 0 && x != (NUM_POINTS_X-1)) {
                    point.animOriginX = unitWidth*x + rand()%unitWidth-unitWidth/2;
                    point.animEndX = unitWidth*x + rand()%unitWidth-unitWidth/2;
                }
                else {
                    point.animOriginX = unitWidth*x;
                    point.animEndX = point.animOriginX;
                }
                if(y != 0 && y != (NUM_POINTS_Y-1)) {
                    point.animOriginY = unitHeight*y + rand()%unitHeight-unitHeight/2;
                    point.animEndY = unitHeight*y + rand()%unitHeight-unitHeight/2;
                }
                else {
                    point.animOriginY = unitHeight*y;
                    point.animEndY = point.animOriginY;
                }

                points[y*NUM_POINTS_Y+x] = point;
            }
        }
        previousHeight = rect.height();
        previousWidth = rect.width();
    }

    /* On first run, create an empty rendering tree with a root and as many triangles as needed */
    QSGSimpleRectNode *rootNode = static_cast<QSGSimpleRectNode *>(n);
    if (!rootNode) {
        int centerX = unitWidth*((NUM_POINTS_X-2)/2);
        int centerY = unitHeight*((NUM_POINTS_Y-2)/2);
        int radius = rect.width()*0.6;
        rootNode = new QSGSimpleRectNode(QRectF(0, 0, 0, 0), Qt::transparent);

        for(int y = 0; y < NUM_POINTS_Y-1; y++) {
            for(int x = 0; x < NUM_POINTS_X-1; x++) {
                for(int n = 0; n < 2; n++) {
                    QSGGeometryNode *triangle = new QSGGeometryNode();

                    QSGFlatColorMaterial *color = new QSGFlatColorMaterial;
                    color->setColor(interpolateColors(centerColor, outerColor,
                                                sqrt(pow(points[y*NUM_POINTS_Y+x].centerX-centerX, 2) + pow(points[y*NUM_POINTS_Y+x].centerY-centerY, 2))/radius));
                    triangle->setMaterial(color);

                    QSGGeometry *geometry = new QSGGeometry(QSGGeometry::defaultAttributes_Point2D(), 3);
                    triangle->setGeometry(geometry);

                    rootNode->appendChildNode(triangle);
                }
            }
        }
    }

    /* Update all triangles' geometries according to the animationState */
    QSGGeometryNode *triangle = static_cast<QSGGeometryNode *>(rootNode->firstChild());
    for(int i = 0; i < NUM_POINTS_X*NUM_POINTS_Y; i++) {
        if(points[i].centerX != unitWidth*(NUM_POINTS_X-1) && points[i].centerY != unitHeight*(NUM_POINTS_Y-1)) {
            int random = rand()%2;
            for(int n = 0; n < 2; n++) {
                QSGGeometry::Point2D *v = triangle->geometry()->vertexDataAsPoint2D();
                if(random==0) {
                    if(n==0) {
                        v[0] = interpolatePos(points[i], animationState);
                        v[1] = interpolatePos(points[i+NUM_POINTS_X], animationState);
                        v[2] = interpolatePos(points[i+NUM_POINTS_X+1], animationState);
                    } else if(n==1) {
                        v[0] = interpolatePos(points[i], animationState);
                        v[1] = interpolatePos(points[i+1], animationState);
                        v[2] = interpolatePos(points[i+NUM_POINTS_X+1], animationState);
                    }
                } else {
                    if(n==0) {
                        v[0] = interpolatePos(points[i], animationState);
                        v[1] = interpolatePos(points[i+NUM_POINTS_X], animationState);
                        v[2] = interpolatePos(points[i+1], animationState);
                    } else if(n==1) {
                        v[0] = interpolatePos(points[i+NUM_POINTS_X], animationState);
                        v[1] = interpolatePos(points[i+1], animationState);
                        v[2] = interpolatePos(points[i+NUM_POINTS_X+1], animationState);
                    }
                }
                triangle->markDirty(QSGNode::DirtyGeometry);
                triangle = static_cast<QSGGeometryNode *>(triangle->nextSibling());
            }
        }
    }

    /* Regenerate a destination point when the animation is finished */
    animationState += 0.012;
    if(animationState >= 1.0) {
        animationState = 0.0;

        for(int y = 0; y < NUM_POINTS_Y; y++) {
            for(int x = 0; x < NUM_POINTS_X; x++) {
                Point *point = &points[y*NUM_POINTS_Y+x];

                if(x != 0 && x != (NUM_POINTS_X-1)) {
                    point->animOriginX = point->animEndX;
                    point->animEndX = point->centerX + rand()%unitWidth-unitWidth/2;
                }
                if(y != 0 && y != (NUM_POINTS_Y-1)) {
                    point->animOriginY = point->animEndY;
                    point->animEndY = point->centerY + rand()%unitHeight-unitHeight/2;
                }
            }
        }
    }

    return rootNode;
}

