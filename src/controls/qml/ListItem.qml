/*
 * Copyright (C) 2023 - Timo Könnecke <github.com/eLtMosen>
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
import org.asteroid.utils 1.0

Item {
    property alias title: label.text
    property alias iconName: icon.name
    property alias highlight: highlight.forceOn
    signal clicked()

    width: parent.width
    height: Dims.h(21)

    HighlightBar {
        id: highlight

        onClicked: function() { parent.clicked() }
    }

    Icon {
        id: icon

        width: parent.height - Dims.h(6)
        height: width

        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: DeviceInfo.hasRoundScreen ? Dims.w(18) : Dims.w(12)
        }
    }

    Label {
        id: label

        anchors {
            leftMargin: DeviceInfo.hasRoundScreen ? Dims.w(6) : Dims.w(10)
            left: icon.right
            verticalCenter: parent.verticalCenter
        }
        font {
            pixelSize: Dims.l(9)
            styleName: "SemiCondensed Light"
        }
    }
}
