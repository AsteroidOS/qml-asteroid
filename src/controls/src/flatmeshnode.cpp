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

#include <QSGVertexColorMaterial>

/* Used to compute a triangle color from its distance to the center */
static inline QColor interpolateColors(const QColor& color1, const QColor& color2, qreal ratio)
{
    int r = color1.red()*(1-ratio) + color2.red()*ratio;
    int g = color1.green()*(1-ratio) + color2.green()*ratio;
    int b = color1.blue()*(1-ratio) + color2.blue()*ratio;

    return QColor(r, g, b);
}

FlatMeshNode::FlatMeshNode(float screenScaleFactor)
    : m_screenScaleFactor(screenScaleFactor)
{
    /* All triangles live in a single non-indexed geometry so the scene graph
     * can draw the whole mesh in one call. Each triangle keeps its flat color
     * because its three dedicated vertices carry the same color. */
    QSGGeometry *geometry = new QSGGeometry(QSGGeometry::defaultAttributes_ColoredPoint2D(), flatmesh_indices_sz);
    geometry->setDrawingMode(QSGGeometry::DrawTriangles);
    geometry->setVertexDataPattern(QSGGeometry::DynamicPattern);
    setGeometry(geometry);
    setFlag(QSGNode::OwnsGeometry);

    setMaterial(new QSGVertexColorMaterial);
    setFlag(QSGNode::OwnsMaterial);

    m_baseVertices.reserve(flatmesh_indices_sz);
    for (int i = 0; i < flatmesh_indices_sz; i++) {
        unsigned short srcIdx = flatmesh_indices[i];
        float baseX = flatmesh_vertices[srcIdx].x();
        float baseY = flatmesh_vertices[srcIdx].y();
        int shiftHash = static_cast<int>(baseX * 100.0f) + static_cast<int>(baseY * 100.0f);
        m_baseVertices.push_back({baseX, baseY, shiftHash});
    }
}

void FlatMeshNode::updateColors(const QColor &centerColor, const QColor &outerColor)
{
    QSGGeometry::ColoredPoint2D *verts = geometry()->vertexDataAsColoredPoint2D();

    for (int i = 0; i < flatmesh_indices_sz; i += 3) {
        /* Get the first vertex index of this triangle to get the color ratio (stored in Z) */
        unsigned short srcIdx = flatmesh_indices[i];
        float ratio = flatmesh_vertices[srcIdx].z();

        QColor color = interpolateColors(centerColor, outerColor, ratio);
        for (int j = 0; j < 3; j++) {
            verts[i + j].r = color.red();
            verts[i + j].g = color.green();
            verts[i + j].b = color.blue();
            verts[i + j].a = 255;
        }
    }

    markDirty(QSGNode::DirtyGeometry);
}

void FlatMeshNode::updateGeometry(const QRectF &rect, float animationState, int loopCount)
{
    float xOffset = rect.x();
    float yOffset = rect.y();
    float itemWidth = rect.width();
    float itemHeight = rect.height();

    QSGGeometry::ColoredPoint2D *verts = geometry()->vertexDataAsColoredPoint2D();

    for (int i = 0; i < flatmesh_indices_sz; i++) {
        const BaseVertex &base = m_baseVertices[i];

        int shiftIndex = loopCount + base.shiftHash;
        int idxA = (shiftIndex % flatmesh_shifts_nb + flatmesh_shifts_nb) % flatmesh_shifts_nb;
        int idxB = ((shiftIndex + 1) % flatmesh_shifts_nb + flatmesh_shifts_nb) % flatmesh_shifts_nb;

        float shiftX = flatmesh_shifts[idxA * 2] + (flatmesh_shifts[idxB * 2] - flatmesh_shifts[idxA * 2]) * animationState;
        float shiftY = flatmesh_shifts[idxA * 2 + 1] + (flatmesh_shifts[idxB * 2 + 1] - flatmesh_shifts[idxA * 2 + 1]) * animationState;

        /* Transform: scale by screenScaleFactor, then translate by 0.5, then scale by item size */
        verts[i].x = xOffset + ((base.x + shiftX) * m_screenScaleFactor + 0.5f) * itemWidth;
        verts[i].y = yOffset + ((base.y + shiftY) * m_screenScaleFactor + 0.5f) * itemHeight;
    }

    markDirty(QSGNode::DirtyGeometry);
}
