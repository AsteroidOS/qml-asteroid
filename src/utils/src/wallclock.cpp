/*
 * Copyright (C) 2012 Jolla Ltd.
 * Contact: Martin Jones <martin.jones@jollamobile.com>
 * Copyright (C) 2026 - Florent Revest <revestflo@gmail.com>
 *
 * You may use this file under the terms of the BSD license as follows:
 *
 * "Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *   * Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in
 *     the documentation and/or other materials provided with the
 *     distribution.
 *   * Neither the name of Jolla Ltd. nor the names of its contributors
 *     may be used to endorse or promote products derived from this
 *     software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
 */

#include "wallclock.h"

#include <QTime>

WallClock::WallClock(QObject *parent)
    : QObject(parent), m_updateFrequency(Second), m_enabled(true)
{
    m_timer.setSingleShot(true);
    m_timer.setTimerType(Qt::PreciseTimer);
    connect(&m_timer, &QTimer::timeout, this, [this]() {
        emit timeChanged();
        scheduleTick();
    });
    scheduleTick();
}

bool WallClock::enabled() const
{
    return m_enabled;
}

void WallClock::setEnabled(bool enabled)
{
    if (m_enabled == enabled)
        return;

    m_enabled = enabled;
    scheduleTick();
    emit enabledChanged();
    if (m_enabled)
        emit timeChanged();
}

QDateTime WallClock::time() const
{
    return QDateTime::currentDateTime();
}

WallClock::UpdateFrequency WallClock::updateFrequency() const
{
    return m_updateFrequency;
}

void WallClock::setUpdateFrequency(UpdateFrequency frequency)
{
    if (m_updateFrequency == frequency)
        return;

    m_updateFrequency = frequency;
    scheduleTick();
    emit updateFrequencyChanged();
}

void WallClock::scheduleTick()
{
    if (!m_enabled) {
        m_timer.stop();
        return;
    }

    // Arm the timer for the remainder of the current second/minute/day so
    // ticks land right on the boundary rather than drifting.
    QTime now = QTime::currentTime();
    int delay = 0;
    switch (m_updateFrequency) {
    case Day:
        delay += (23 - now.hour()) * 3600 * 1000;
        delay += (59 - now.minute()) * 60 * 1000;
        // fall through
    case Minute:
        delay += (59 - now.second()) * 1000;
        // fall through
    case Second:
        delay += 1000 - now.msec();
    }

    m_timer.start(delay);
}
