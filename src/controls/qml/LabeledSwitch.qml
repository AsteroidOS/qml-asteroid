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
    property alias checked: toggle.checked
    property alias text: label.text

    width: parent.width
    height: parent.height

    Label {
        id: label

        anchors {
            left: parent.left
            leftMargin: Dims.w(15)
            right: toggle.left
        }
        text: value
        font.pixelSize: Dims.l(6)
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.Wrap
        height: parent.height
    }

    Switch {
        id: toggle

        anchors {
            right: parent.right
            rightMargin: Dims.w(15)
            verticalCenter: parent.verticalCenter
        }
        height: Dims.w(20)
        width: height
    }

    HighlightBar {
        onClicked: function() {toggle.checked = !toggle.checked}
    }
}
