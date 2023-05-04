/*
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

/*!
    \qmltype LabeledSwitch
    \inqmlmodule org.controls.asteroid 1.0

    \brief This combines Label and Switch in a convenient package.

    This is a LabeledSwitch.

    This example shows a centered red square and a LabeledSwitch centered below it.
    The square turns green when the toggle is checked, and red when it is unchecked.

    \qml
    import QtQuick 2.9
    import org.asteroid.controls 1.0

    Item {
        anchors.centerIn: parent
        anchors.fill: parent
        Rectangle {
            id: square
            anchors.centerIn: parent
            width: 100
            height: 100
            color: "blue"
        }
        LabeledSwitch {
            anchors.top: square.bottom
            anchors.horizontalCenter: square.horizontalCenter
            width: Dims.l(80)
            height: Dims.l(20)
            text: "Enable"
            checked: false
            onCheckedChanged: {
                if (checked) {
                    square.color = "green"
                } else { 
                    square.color = "red"
                }
            }
        }
    }

    \endqml
*/
Row {
    // labelWidthRatio is the ratio of label width to the total width
    property real labelWidthRatio: 0.7143
    // fontToHeightRatio is the ratio of the font size to the height
    property real fontToHeightRatio: 0.3
    property alias checked: toggle.checked
    property alias text: label.text

    Label {
        id: label
        text: value
        font.pixelSize: parent.height * fontToHeightRatio
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.Wrap
        width: parent.width * labelWidthRatio
        height: parent.height
    }

    Switch {
        id: toggle
        height: parent.height
        width: height
    }
}
