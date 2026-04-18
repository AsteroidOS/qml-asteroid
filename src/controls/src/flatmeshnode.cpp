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
#include "flatmeshgeometry.h"

#include <math.h>

#include <QScreen>
#include <QElapsedTimer>
#include <QSettings>

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
      m_animationState(0), m_animated(true), m_window(window), m_loopCount(0)
{
    connect(window, SIGNAL(afterRendering()), this, SLOT(maybeAnimate()));

    QSettings machineConf("/etc/asteroid/machine.conf", QSettings::IniFormat);
    m_screenScaleFactor = machineConf.value("Display/ROUND", false).toBool() ? 1.2f : 1.7f;

    /* Create triangle nodes based on pre-computed indices */
    int numTriangles = flatmesh_indices_sz / 3;

    for (int i = 0; i < numTriangles; i++) {
        QSGGeometryNode *triangle = new QSGGeometryNode();

        QSGFlatColorMaterial *color = new QSGFlatColorMaterial;
        triangle->setOpaqueMaterial(color);
        triangle->setFlag(QSGNode::OwnsMaterial);

        QSGGeometry *geometry = new QSGGeometry(QSGGeometry::defaultAttributes_Point2D(), 3);
        triangle->setGeometry(geometry);
        triangle->setFlag(QSGNode::OwnsGeometry);

        appendChildNode(triangle);
    }

    maybeAnimate();
}

void FlatMeshNode::updateColors()
{
    int numTriangles = flatmesh_indices_sz / 3;
    QSGGeometryNode *triangle = static_cast<QSGGeometryNode *>(firstChild());

    for (int i = 0; i < numTriangles; i++) {
        /* Get the first vertex index of this triangle to get the color ratio (stored in Z) */
        unsigned short srcIdx = flatmesh_indices[i * 3];
        float ratio = flatmesh_vertices[srcIdx].z();

        QSGFlatColorMaterial *color = static_cast<QSGFlatColorMaterial *>(triangle->opaqueMaterial());
        color->setColor(interpolateColors(m_centerColor, m_outerColor, ratio));
        triangle->setOpaqueMaterial(color);
        triangle->markDirty(QSGNode::DirtyMaterial);

        triangle = static_cast<QSGGeometryNode *>(triangle->nextSibling());
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
        m_animationState += 0.02f;

        float shiftMix = m_animationState;
        float xOffset = rect().x();
        float yOffset = rect().y();
        float itemWidth = rect().width();
        float itemHeight = rect().height();

        int numTriangles = flatmesh_indices_sz / 3;
        QSGGeometryNode *triangle = static_cast<QSGGeometryNode *>(firstChild());

        for (int i = 0; i < numTriangles; i++) {
            QSGGeometry::Point2D *verts = triangle->geometry()->vertexDataAsPoint2D();

            for (int j = 0; j < 3; j++) {
                unsigned short srcIdx = flatmesh_indices[i * 3 + j];

                float baseX = flatmesh_vertices[srcIdx].x();
                float baseY = flatmesh_vertices[srcIdx].y();

                int xHash = static_cast<int>(baseX * 100.0f);
                int yHash = static_cast<int>(baseY * 100.0f);
                int shiftIndex = m_loopCount + xHash + yHash;

                int idxA = (shiftIndex % flatmesh_shifts_nb + flatmesh_shifts_nb) % flatmesh_shifts_nb;
                int idxB = ((shiftIndex + 1) % flatmesh_shifts_nb + flatmesh_shifts_nb) % flatmesh_shifts_nb;

                float shiftX = flatmesh_shifts[idxA * 2] + (flatmesh_shifts[idxB * 2] - flatmesh_shifts[idxA * 2]) * shiftMix;
                float shiftY = flatmesh_shifts[idxA * 2 + 1] + (flatmesh_shifts[idxB * 2 + 1] - flatmesh_shifts[idxA * 2 + 1]) * shiftMix;

                /* Transform: scale by screenScaleFactor, then translate by 0.5, then scale by item size */
                verts[j].x = xOffset + ((baseX + shiftX) * m_screenScaleFactor + 0.5f) * itemWidth;
                verts[j].y = yOffset + ((baseY + shiftY) * m_screenScaleFactor + 0.5f) * itemHeight;
            }

            triangle->markDirty(QSGNode::DirtyGeometry);
            triangle = static_cast<QSGGeometryNode *>(triangle->nextSibling());
        }

        if (m_animationState >= 1.0f) {
            m_animationState = 0.0f;
            m_loopCount++;
        }
    }
}

