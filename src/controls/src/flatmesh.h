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

#ifndef FLATMESH_H
#define FLATMESH_H

#include <QQuickItem>
#include <QSGNode>
#include <QColor>
#include <QTimer>

class FlatMesh : public QQuickItem
{
    Q_OBJECT
    Q_PROPERTY(QColor centerColor WRITE setCenterColor READ getCenterColor)
    Q_PROPERTY(QColor outerColor WRITE setOuterColor READ getOuterColor)
    Q_PROPERTY(bool animated WRITE setAnimated READ getAnimated NOTIFY animatedChanged)

public:
    FlatMesh(QQuickItem *parent = 0);

    bool getAnimated() const { return m_animated; }
    void setAnimated(bool animated);

    QColor getCenterColor() const { return m_centerColor; }
    void setCenterColor(QColor c);

    QColor getOuterColor() const { return m_outerColor; }
    void setOuterColor(QColor c);

signals:
    void animatedChanged();

protected:
    QSGNode *updatePaintNode(QSGNode *node, UpdatePaintNodeData *data);

private:
    QColor m_centerColor, m_outerColor;
    bool m_animated;
    QTimer m_timer;
};

#endif // FLATMESH_H
