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

Row {
    // labelWidthRatio is the ratio of label width to the total width
    property real labelWidthRatio: 0.7143
    // fontToHeightRatio is the ratio of the font size to the height
    property real fontToHeightRatio: 0.3
    property alias checked: toggle.checked
    property alias text: label.text

    height: parent.height
    width: parent.width

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
