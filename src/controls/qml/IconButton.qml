/*
 * Qt Quick Controls Asteroid - User interface components for AsteroidOS
 *
 * Copyright (C) 2015 Tim Süberkrüb <tim.sueberkrueb@web.de>
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

import QtQuick 2.4
import org.asteroid.controls 1.0

Item {
    id: iconButton

    signal clicked()

    property color iconColor: "black"
    property alias iconName: icon.name
    property alias iconSize: icon.size

    property bool hovered: mouseArea.containsMouse
    property alias hoverEnabled: mouseArea.hoverEnabled

    width: iconSize
    height: iconSize

    Icon {
        id: icon
        color: iconColor
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent

        hoverEnabled: true

        onClicked: iconButton.clicked()
    }
}
