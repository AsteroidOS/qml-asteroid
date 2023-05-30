/*
 * Copyright (C) 2023 - Timo Könnecke <github.com/eLtMosen>
 * Copyright (C) 2022 - Ed Beroset <github.com/beroset>
 * Copyright (C) 2020 - Darrel Griët <idanlcontact@gmail.com>
 * Copyright (C) 2015 - Florent Revest <revestflo@gmail.com>
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

Item {
    // minimum allowed value
    property int min: 0
    // maximum allowed value
    property int max: 100
    // step size per button actuation
    property int stepSize: 10
    // unitMarker value appended to value display between buttons
    property string unitMarker: "%"
    // initial value of the control
    property int value: 0
    // left and right margin for the row content
    property int rowMargin: Dims.w(15)
    // size of the icon/s
    property int iconSize: Dims.l(20)
    // size of the label text
    property int labelFontSize: Dims.l(6)

    width: parent.width
    height: parent.height

    IconButton {
        id: buttonLeft

        iconName: "ios-remove-circle-outline"
        anchors {
            left: parent.left
            leftMargin: rowMargin
            verticalCenter: parent.verticalCenter
        }
        height: iconSize
        width: height
        onClicked: {
            var newVal = value - stepSize
            if(newVal < min) newVal = min
            value = newVal
        }
    }

    Label {
        text: value + unitMarker
        anchors {
            left: buttonLeft.right
            right: buttonRight.left
        }
        font.pixelSize: labelFontSize
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.Wrap
        height: parent.height
    }

    IconButton {
        id: buttonRight

        iconName: "ios-add-circle-outline"
        anchors {
            right: parent.right
            rightMargin: rowMargin
            verticalCenter: parent.verticalCenter
        }
        height: iconSize
        width: height
        onClicked: {
            var newVal = value + stepSize
            if(newVal > max) newVal = max
            value = newVal
        }
    }
}
