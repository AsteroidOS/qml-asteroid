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

/*!
    \qmltype IntSelector
    \inqmlmodule org.asteroid.controls

    \brief A control to select an integer value from a range by scrubbing a pill-shaped track.

    IntSelector displays a pill-shaped track that fills proportionally to the current value.
    A floating indicator pill shows the current value label and rides the track from left to right.

    The user can interact in three ways:
    \list
    \li Tap anywhere on the row to seek the value to that position instantly.
    \li Press and hold to activate scrubbing, then drag horizontally to adjust continuously.
    \li Swipe horizontally to scrub — vertical deviation is ignored once a horizontal swipe
        is detected, allowing the finger to move away from the track while keeping control.
    \endlist

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
    /*! minimum allowed value.  Default is 0 */
    property int min: 0
    /*! maximum allowed value. Default is 100 */
    property int max: 100
    /*! step size per button actuation. Default is 10 */
    property int stepSize: 10
    /*! unitMarker value appended to value display between buttons. Default is % */
    property string unitMarker: "%"
    /*! initial value of the control. Default is 0 */
    property int value: 0
    /*! whether the actual value should be shown */
    property bool valueLabelVisible: true

    highlightBarEnabled: false

    Rectangle {
        id: track
        anchors {
            left: parent.left
            leftMargin: Dims.l(1.9)
            right: parent.right
            rightMargin: rowMargin + Dims.l(1.9)
            verticalCenter: parent.verticalCenter
        }
        height: iconSize - Dims.l(3.6)
        radius: height / 2
        color: Qt.rgba(0, 0, 0, 0)

        Rectangle {
            id: indicator
            property real fraction: max > min ? Math.max(0, Math.min(1, (value - min) / (max - min))) : 0
            width: height + fraction * (track.width - height)
            height: parent.height
            radius: height / 2
            color: dragArea.tracking ? Qt.rgba(0, 0, 0, 0.6) : Qt.rgba(0, 0, 0, 0.4)
            visible: valueLabelVisible

            Behavior on width {
                enabled: !dragArea.tracking
                NumberAnimation {
                    duration: 120
                    easing.type: Easing.OutQuad
                }
            }

            Label {
                id: valueLabel
                x: Math.max(
                    track.width / 2 - width / 2,
                    parent.width - width - Dims.l(6)
                )
                anchors.verticalCenter: parent.verticalCenter
                text: value + unitMarker
                font {
                    pixelSize: dragArea.tracking ? labelFontSize * 1.4 : labelFontSize * 1.1
                    family: "Noto Sans SemiCondensed"
                    bold: true
                }
                color: Qt.rgba(1, 1, 1, 1.0)
            }
        }

        Rectangle {
            anchors.fill: parent
            color: Qt.rgba(0, 0, 0, 0)
            radius: parent.radius
            border {
                color: Qt.rgba(1, 1, 1, 1.0)
                width: Dims.l(0.7)
            }
        }
    }

    MouseArea {
        id: dragArea
        anchors.fill: parent
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
            if (tracking) {
                updateValue(mouseX)
            } else {
                var dx = Math.abs(mouseX - startX)
                var dy = Math.abs(mouseY - startY)
                if (dx < threshold && dy < threshold) updateValue(mouseX)
            }
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
            var f = Math.max(0, Math.min(1, (mx - track.x - halfPill) / Math.max(1, track.width - track.height)))
            value = Math.max(min, Math.min(max, Math.round((min + f * (max - min)) / stepSize) * stepSize))
        }
    }
}
