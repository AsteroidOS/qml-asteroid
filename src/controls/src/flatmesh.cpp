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
#include "flatmeshnode.h"

FlatMesh::FlatMesh(QQuickItem *parent) : QQuickItem(parent)
{
    m_timer.setInterval(90);
    m_timer.setSingleShot(false);
    connect(&m_timer, SIGNAL(timeout()), this, SLOT(update()));
    m_timer.start();

    m_centerColor = QColor("#ffaa39");
    m_outerColor = QColor("#df4829");

    connect(this, SIGNAL(visibleChanged()), this, SLOT(maybeEnableAnimation()));

    setFlag(ItemHasContents);
    setAnimated(true);
}

void FlatMesh::setCenterColor(QColor c)
{
    if (c == m_centerColor)
        return;
    m_centerColor = c;
    update();
}

void FlatMesh::setOuterColor(QColor c)
{
    if (c == m_outerColor)
        return;
    m_outerColor = c;
    update();
}

void FlatMesh::maybeEnableAnimation()
{
    if (isVisible() && m_animated) {
        m_timer.start();
    } else {
        m_timer.stop();
    }
    update();
}

void FlatMesh::setAnimated(bool animated)
{
    if (animated == m_animated)
        return;
    m_animated = animated;
    emit animatedChanged();
    maybeEnableAnimation();
}

QSGNode *FlatMesh::updatePaintNode(QSGNode *old, UpdatePaintNodeData *)
{
    FlatMeshNode *n = static_cast<FlatMeshNode *>(old);
    if (!n)
        n = new FlatMeshNode(window(), boundingRect());

    n->setAnimated(m_animated);
    n->setRect(boundingRect());
    n->setCenterColor(m_centerColor);
    n->setOuterColor(m_outerColor);

    return n;
}
