/*
 * Copyright (C) 2015 Florent Revest <revestflo@gmail.com>
 *               2014 Aleksi Suomalainen <suomalainen.aleksi@gmail.com>
 *               2013 John Brooks <john.brooks@dereferenced.net>
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

import QtQuick 2.0
import QtQuick.Window 2.0

MouseArea {
    id: root

    property int boundary: 20
    property bool delayReset

    signal gestureStarted(string gesture)
    signal gestureFinished(string gesture)

    // Current gesture
    property bool active: gesture != ""
    property string gesture
    property int value
    property int max
    property real progress: Math.abs(value) / max
    property bool horizontal: gesture === "left" || gesture === "right"
    property bool inverted: gesture === "left" || gesture === "up"

    // Internal
    property int _mouseStart
    property variant _gestures: ["down", "left", "up", "right"]

    onPressed: {
        if (mouse.x < boundary) {
            gesture = "right"
            max = width - mouse.x
        } else if (width - mouse.x < boundary) {
            gesture = "left"
            max = mouse.x
        } else if (mouse.y < boundary) {
            gesture = "down"
            max = height - mouse.y
        } else if (height - mouse.y < boundary) {
            gesture = "up"
            max = mouse.y
        } else {
            mouse.accepted = false
            return
        }

        value = 0
        if (horizontal)
            _mouseStart = mouse.x
        else
            _mouseStart = mouse.y

        gestureStarted(gesture)
    }

    onPositionChanged: {
        var p = horizontal ? mouse.x : mouse.y
        value = Math.max(Math.min(p - _mouseStart, max), -max)
    }

    function reset() {
        gesture = ""
        value = max = 0
        _mouseStart = 0
    }

    onDelayResetChanged: {
        if (!delayReset)
            reset()
    }

    onReleased: {
        gestureFinished(gesture)
        if (!delayReset)
            reset()
    }
}

