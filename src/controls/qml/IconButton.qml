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

    // For free placing
    readonly property int undefinedEdge: 2 * Qt.BottomEdge
    property int edge: Qt.BottomEdge

    property color iconColor: "#FFFFFFFF"
    property color pressedIconColor: "#FFFFFFFF"
    property alias iconName: icon.name
    property alias pressed: mouseArea.containsPress

    width: Dims.l(20)
    height: width

    enabled: visible

    Icon {
        id: icon
        anchors.fill: parent
        color: pressed ? pressedIconColor : iconColor
        opacity: mouseArea.containsPress ? 0.7 : 1.0
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent

        onClicked: iconButton.clicked()
    }

    anchors {
        top:    (edge === Qt.TopEdge)    ? parent.top    : undefined
        bottom: (edge === Qt.BottomEdge) ? parent.bottom : undefined
        right:  (edge === Qt.RightEdge)  ? parent.right  : undefined
        left:   (edge === Qt.LeftEdge)   ? parent.left   : undefined

        horizontalCenter: {
            if(edge === Qt.TopEdge || edge === Qt.BottomEdge)
                return parent.horizontalCenter
            else
                return undefined
        }
        verticalCenter: {
            if(edge === Qt.LeftEdge || edge === Qt.RightEdge)
                return parent.verticalCenter
            else
                return undefined
        }

        topMargin:    (edge === Qt.TopEdge)    ? Dims.iconButtonMargin : 0
        bottomMargin: (edge === Qt.BottomEdge) ? Dims.iconButtonMargin : 0
        rightMargin:  (edge === Qt.RightEdge)  ? Dims.iconButtonMargin : 0
        leftMargin:   (edge === Qt.LeftEdge)   ? Dims.iconButtonMargin : 0
    }
}
