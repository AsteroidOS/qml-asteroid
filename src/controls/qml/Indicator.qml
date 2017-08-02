/*
 * Qt Quick Controls Asteroid - User interface components for AsteroidOS
 *
 * Copyright (C) 2017 Florent Revest <revestflo@gmail.com>
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

import QtQuick 2.0

Item {
    property int edge: Qt.TopEdge

    function animate() {
        bodyWidthAnim.restart()
        fishOffsetAnim.restart()
        bodyOpacityAnim.restart()
    }

    id: fish
    width: body.width
    height: body.height
    anchors.verticalCenter: {
        if(edge === Qt.LeftEdge || edge === Qt.RightEdge) return parent.verticalCenter
        else if(edge === Qt.TopEdge)                      return parent.top
        else                                              return parent.bottom
    }
    anchors.horizontalCenter: {
        if(edge === Qt.TopEdge || edge === Qt.BottomEdge) return parent.horizontalCenter
        else if(edge === Qt.RightEdge)                    return parent.right
        else                                              return parent.left
    }
    rotation: {
        if(edge === Qt.RightEdge)    return 45
        else if(edge === Qt.TopEdge) return -45
        else if(edge== Qt.LeftEdge)  return -135
        else                         return 135
    }

    SequentialAnimation {
        id: fishOffsetAnim
        running: false
        NumberAnimation {
            target: fish
            property:  {
                if(edge === Qt.TopEdge || edge === Qt.BottomEdge) return "anchors.verticalCenterOffset"
                else                                              return "anchors.horizontalCenterOffset"
            }
            to: {
                if(edge === Qt.TopEdge || edge === Qt.LeftEdge) return 10
                else                                            return -10
            }
            duration: 300
        }
        NumberAnimation {
            target: fish
            property: {
                if(edge === Qt.TopEdge || edge === Qt.BottomEdge) return "anchors.verticalCenterOffset"
                else                                              return "anchors.horizontalCenterOffset"
            }
            to: 0
            duration: 400
        }
    }

    Rectangle {
        id: body
        width: 6
        height: width
        color: Qt.rgba(215, 215, 215)
        opacity: 0.6

        SequentialAnimation {
            id: bodyWidthAnim
            running: false
            NumberAnimation {
                target: body
                property: "width"
                to: 10
                duration: 300
            }
            NumberAnimation {
                target: body
                property: "width"
                to: 6
                duration: 400
            }
        }

        SequentialAnimation {
            id: bodyOpacityAnim
            running: false
            NumberAnimation {
                target: body
                property: "opacity"
                to: 0.8
                duration: 300
            }
            NumberAnimation {
                target: body
                property: "opacity"
                to: 0.6
                duration: 400
            }
        }
    }

    Rectangle {
        id: fin1
        width: 5
        height: width
        color: Qt.rgba(0, 0, 0, 0.19)
        anchors.top: parent.top
        anchors.left: body.right
    }

    Rectangle {
        id: fin2
        width: 5
        height: width
        color: Qt.rgba(0, 0, 0, 0.19)
        anchors.bottom: parent.top
        anchors.right: body.right
    }
}
