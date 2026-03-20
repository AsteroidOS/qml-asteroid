/*
 * Copyright (C) 2026 - Timo Könnecke  <github.com/eLtMosen>
 *               2022 - Ed Beroset     <github.com/beroset>
 *               2020 - Darrel Griët   <idanlcontact@gmail.com>
 *               2015 - Florent Revest <revestflo@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.9
import org.asteroid.controls 1.0
import QtGraphicalEffects 1.15

/*!
    \qmltype IntSelector
    \inqmlmodule org.asteroid.controls

    \brief A control to select an integer value from a range using a pill-shaped scrubber track.

    IntSelector displays a pill-shaped track that fills proportionally to the current value.
    The current value label is displayed at the track center. Minus and plus buttons sit at
    the left and right ends of the track for precise single-step adjustments.

    The user can interact in three ways:
    \list
    \li Tap the \c - or \c + button to decrement or increment by \l stepSize.
    \li Press and hold anywhere on the track to activate scrubbing, then drag horizontally
        to adjust continuously.
    \li Swipe horizontally anywhere on the track to scrub — vertical deviation is ignored
        once a horizontal swipe is detected, allowing the finger to move away from the track
        while keeping control.
    \endlist

    Here is a short example that shows two \l IntSelector controls.
    The top one uses mostly defaults and sets the value to 50%, incrementing
    or decrementing 10% at each step. The lower one uses a range of -10
    to +10 mV and starts at a value of -3, incrementing or decrementing
    by 1 mV each step.

    \qml
    import QtQuick 2.9
    import org.asteroid.controls 1.0

    Item {
        IntSelector {
            id: first
            anchors.bottom: parent.verticalCenter
            height: parent.height * 0.2
            value: 50
        }
        IntSelector {
            anchors.top: first.bottom
            height: parent.height * 0.2
            min: -10
            max: +10
            stepSize: 1
            value: -3
            unitMarker: "mV"
        }
    }
    \endqml
*/

ListRow {
    /*!
        \qmlproperty int IntSelector::min
        Minimum allowed value. Default is 0.
    */
    property int min: 0

    /*!
        \qmlproperty int IntSelector::max
        Maximum allowed value. Default is 100.
    */
    property int max: 100

    /*!
        \qmlproperty int IntSelector::stepSize
        Step size per button actuation. Default is 10.
    */
    property int stepSize: 10

    /*!
        \qmlproperty string IntSelector::unitMarker
        Unit string appended to the value label. Default is %.
    */
    property string unitMarker: "%"

    /*!
        \qmlproperty int IntSelector::value
        Current value of the control. Default is 0.
    */
    property int value: 0

    /*!
        \qmlproperty bool IntSelector::valueLabelVisible
        Whether the value label and indicator are shown. Default is true.
    */
    property bool valueLabelVisible: true

    highlightBarEnabled: false

    Rectangle {
        id: track
        anchors {
            left: parent.left
            leftMargin: Dims.l(1.8)
            right: parent.right
            rightMargin: rowMargin + Dims.l(1.8)
            verticalCenter: parent.verticalCenter
        }
        height: iconSize - Dims.l(3.6)
        radius: height / 2
        color: Qt.rgba(0, 0, 0, 0)

        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Rectangle {
                width: track.width
                height: track.height
                radius: track.radius
            }
        }

        Rectangle {
            id: indicator
            property real fraction: max > min ? Math.max(0, Math.min(1, (value - min) / (max - min))) : 0
            width: track.width * fraction
            height: parent.height
            color: dragArea.tracking ? Qt.rgba(0, 0, 0, 0.6) : Qt.rgba(0, 0, 0, 0.4)
            visible: valueLabelVisible

            Behavior on width {
                enabled: !dragArea.tracking
                NumberAnimation {
                    duration: 120
                    easing.type: Easing.OutQuad
                }
            }
        }

        Rectangle {
            anchors.fill: parent
            color: Qt.rgba(0, 0, 0, 0)
            radius: parent.radius
            border {
                color: Qt.rgba(1, 1, 1, 1.0)
                width: Dims.l(0.64)
            }
        }

        IconButton {
            id: buttonMinus
            iconName: "ios-remove"
            anchors {
                left: parent.left
                leftMargin: -Dims.l(1.5)
                verticalCenter: parent.verticalCenter
            }
            width: iconSize
            height: iconSize
            opacity: value <= min ? 0.3 : 1.0
            onClicked: value = Math.max(min, value - stepSize)
        }

        IconButton {
            id: buttonPlus
            iconName: "ios-add"
            anchors {
                right: parent.right
                rightMargin: -Dims.l(1.5)
                verticalCenter: parent.verticalCenter
            }
            width: iconSize
            height: iconSize
            opacity: value >= max ? 0.3 : 1.0
            onClicked: value = Math.min(max, value + stepSize)
        }

        Label {
            anchors.centerIn: parent
            text: value + unitMarker
            font {
                pixelSize: dragArea.tracking ? labelFontSize * 1.4 : labelFontSize * 1.1
                family: "Noto Sans SemiCondensed"
                bold: true
            }
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: Qt.rgba(1, 1, 1, 1.0)
            visible: valueLabelVisible
        }

        MouseArea {
            id: dragArea
            anchors.fill: parent
            propagateComposedEvents: true
            preventStealing: false

            property int startX: 0
            property int startY: 0
            property bool tracking: false
            property int threshold: Dims.l(2)

            onPressed: {
                startX = mouseX
                startY = mouseY
                tracking = false
            }

            onPositionChanged: {
                if (!tracking) {
                    var dx = Math.abs(mouseX - startX)
                    var dy = Math.abs(mouseY - startY)
                    if (dx < threshold && dy < threshold) return
                    if (dx >= dy) {
                        tracking = true
                        preventStealing = true
                    } else {
                        mouse.accepted = false
                        return
                    }
                }
                updateValue(mouseX)
            }

            onReleased: {
                preventStealing = false
                tracking = false
            }

            onPressAndHold: {
                tracking = true
                preventStealing = true
                updateValue(mouseX)
            }

            onCanceled: {
                preventStealing = false
                tracking = false
            }

            function updateValue(mx) {
                var halfPill = track.height / 2
                var f = Math.max(0, Math.min(1, (mx - halfPill) / Math.max(1, track.width - track.height)))
                value = Math.max(min, Math.min(max, Math.round((min + f * (max - min)) / stepSize) * stepSize))
            }
        }
    }
}
