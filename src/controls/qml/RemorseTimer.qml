/*
 * Copyright (C) 2025 Timo Könnecke <github.com/eLtMosen>
 *
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

import QtQuick 2.9
import org.asteroid.controls 1.0

/*!
    \qmltype RemorseTimer
    \inqmlmodule org.asteroid.controls
    \brief A full-screen timer component for cancellable actions with a visual countdown.

    This component displays a semi-transparent overlay with a segmented arc countdown,
    an action message (e.g., "Powering Off"), and a "Tap to cancel" prompt. It triggers
    a specified action after a set interval unless cancelled by tapping the screen.
    Used for confirming critical actions like power off or reboot.

    The countdown is visualized by a SegmentedArc gauge, with configurable segment count,
    start angle, and arc length for flexible styling.

    Example usage in a quick settings toggle:
    \qml
    import QtQuick 2.9
    import org.asteroid.controls 1.0

    Item {
        id: root
        RemorseTimer {
            id: remorse
            action: qsTrId("id-power-off")
            interval: 3000
            gaugeSegmentAmount: 6
            gaugeStartDegree: -130
            gaugeEndFromStartDegree: 265
            onTriggered: console.log("Power off executed")
            onCancelled: console.log("Power off cancelled")
        }

        MouseArea {
            anchors.fill: parent
            onClicked: remorse.start()
        }
    }
    \endqml
*/
Rectangle {
    id: remorseTimer
    anchors.fill: parent
    color: Qt.rgba(0, 0, 0, 0.8)
    visible: false
    z: 100
    opacity: 0

    /*!
        \qmlproperty string RemorseTimer::cancelText
        The text displayed for the cancel prompt (e.g., "Tap to cancel"). Can be a translated string.
    */
    property string cancelText: "Tap to cancel"

    /*!
        \qmlproperty string RemorseTimer::action
        The action message displayed (e.g., "Powering Off"). Should be a translated string.
    */
    property string action: ""

    /*!
        \qmlproperty int RemorseTimer::interval
        The duration (in milliseconds) before the action is triggered.
    */
    property int interval: 3000

    /*!
        \qmlproperty int RemorseTimer::gaugeSegmentAmount
        The number of segments in the countdown arc gauge.
    */
    property int gaugeSegmentAmount: 6

    /*!
        \qmlproperty real RemorseTimer::gaugeStartDegree
        The starting angle of the arc gauge (in degrees).
    */
    property real gaugeStartDegree: -130

    /*!
        \qmlproperty real RemorseTimer::gaugeEndFromStartDegree
        The arc length from the start angle (in degrees).
    */
    property real gaugeEndFromStartDegree: 265

    /*!
        \qmlsignal RemorseTimer::triggered
        Emitted when the timer completes without cancellation.
    */
    signal triggered()

    /*!
        \qmlsignal RemorseTimer::cancelled
        Emitted when the user cancels the action by tapping.
    */
    signal cancelled()

    Timer {
        id: timer
        interval: remorseTimer.interval
        running: false
        repeat: false
        onTriggered: {
            remorseTimer.visible = false;
            remorseTimer.opacity = 0;
            remorseTimer.triggered();
        }
    }

    property real arcValue: 100
    property int countdownSeconds: Math.floor(interval / 1000)

    SegmentedArc {
        id: countdownArc
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }
        width: Dims.l(22)
        height: width
        segmentAmount: remorseTimer.gaugeSegmentAmount
        inputValue: remorseTimer.arcValue
        fgColor: "#ffffff"
        bgColor: Qt.rgba(1, 1, 1, 0.2)
        start: remorseTimer.gaugeStartDegree
        endFromStart: remorseTimer.gaugeEndFromStartDegree
    }

    Label {
        id: countdownLabel
        anchors.centerIn: countdownArc
        font {
            pixelSize: Dims.l(18)
            styleName: "SemiBoldCondensed"
        }
        color: "#ffffff"
        text: remorseTimer.countdownSeconds // Direct integer display
        z: countdownArc.z + 1
    }

    Label {
        id: actionLabel
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: countdownArc.top
            bottomMargin: Dims.l(1)
        }
        font.pixelSize: Dims.l(6)
        color: "#ffffff"
        text: action
    }

    Label {
        id: cancelLabel
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: countdownArc.bottom
            topMargin: Dims.l(1)
        }
        font.pixelSize: Dims.l(6)
        color: "#ffffff"
        text: cancelText
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            timer.stop();
            fadeAnimation.stop();
            arcAnimation.stop();
            syncTimer.stop();
            fadeOutAnimation.start();
        }
    }

    NumberAnimation {
        id: fadeAnimation
        target: remorseTimer
        property: "opacity"
        from: 0
        to: 1
        duration: 300
    }

    NumberAnimation {
        id: fadeOutAnimation
        target: remorseTimer
        property: "opacity"
        from: 1
        to: 0
        duration: 300
        easing.type: Easing.InOutQuad
        onStopped: {
            remorseTimer.visible = false;
            remorseTimer.cancelled();
        }
    }

    NumberAnimation {
        id: arcAnimation
        target: remorseTimer
        property: "arcValue"
        from: 100
        to: 0
        duration: remorseTimer.interval
        easing.type: Easing.Linear
    }

    Timer {
        id: syncTimer
        interval: remorseTimer.interval / Math.floor(remorseTimer.interval / 1000) // 1000ms for 3000ms
        running: false
        repeat: true
        property int steps: Math.floor(remorseTimer.interval / 1000) // 3 steps
        onTriggered: {
            steps--;
            remorseTimer.countdownSeconds = steps;
            if (steps <= 0) {
                syncTimer.stop();
            }
        }
    }

    // Start the timer and show the overlay
    function start() {
        countdownSeconds = Math.floor(interval / 1000); // Reset to 3
        arcValue = 100; // Reset arc
        syncTimer.steps = Math.floor(interval / 1000); // Reset steps
        visible = true;
        fadeAnimation.start();
        timer.start();
        arcAnimation.start();
        syncTimer.start();
    }
}
