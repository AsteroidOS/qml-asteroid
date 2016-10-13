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

#ifndef FLATMESHNODE_H
#define FLATMESHNODE_H

#include <QObject>
#include <QQuickWindow>
#include <QSGSimpleRectNode>

#define NUM_POINTS_X 13
#define NUM_POINTS_Y 13

struct Point {
    qreal centerX;
    qreal centerY;

    qreal animOriginX;
    qreal animOriginY;

    qreal animEndX;
    qreal animEndY;

    QSGGeometry::Point2D currentPos;
};

class FlatMeshNode : public QObject, public QSGSimpleRectNode
{
    Q_OBJECT
public:
    FlatMeshNode(QQuickWindow *window, QRectF rect);
    void setAnimated(bool animated);

    void setCenterColor(QColor c);
    void setOuterColor(QColor c);

public slots:
    void maybeAnimate();
    void generateGrid();

private:
    void updateColors();

    qreal m_animationState;
    bool m_animated;
    int m_unitWidth, m_unitHeight;
    QColor m_centerColor, m_outerColor;
    QQuickWindow *m_window;
    Point m_points[NUM_POINTS_X*NUM_POINTS_Y];
};


#endif // FLATMESHNODE_H
