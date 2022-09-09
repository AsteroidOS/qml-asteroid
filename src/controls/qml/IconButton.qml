/*
 * Copyright (C) 2017 - Florent Revest <revestflo@gmail.com>
 *               2015 - Tim Süberkrüb <tim.sueberkrueb@web.de>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 2.1 of the
 * License, or (at your option) any later version.
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
    id: iconButton

    signal clicked()

    property color iconColor: "#FFFFFFFF"
    property color pressedIconColor: "#FFFFFFFF"
    property alias iconName: icon.name
    property alias pressed: mouseArea.containsPress

    width: Dims.l(20)
    height: width

    Icon {
        id: icon
        name: "ios-circle-outline"
        anchors.fill: parent
        color: pressed ? pressedIconColor : iconColor
        opacity: mouseArea.containsPress ? 0.7 : 1.0
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: iconButton.clicked()
    }

}
