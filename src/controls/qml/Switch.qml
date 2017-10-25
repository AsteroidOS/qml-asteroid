/*
 * Qt Quick Controls Asteroid - User interface components for AsteroidOS
 *
 * Copyright (C) 2016 Florent Revest <revestflo@gmail.com>
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

import QtQuick 2.5
import org.asteroid.controls 1.0

Item {
    id: toggleSwitch
    width: Dims.l(30); height: width

    property bool checked
    state: checked ? "on" : "off"

    MouseArea {
        anchors.fill: parent;
        onClicked: {
            if (toggleSwitch.state == "on")
                toggleSwitch.state = "off";
            else
                toggleSwitch.state = "on";
        }
    }

    Rectangle {
        id: background
        radius: width/2
        anchors.fill: parent
        opacity: 0.6
    }

    Rectangle {
        id: overlay
        color: "#333"
        border.color: "#b5bbaf"
        radius: width/2
        anchors.fill: parent
        anchors.margins: parent.width*0.16
    }

    Text {
        id: off
        anchors.centerIn: parent
        text: "OFF"
        font.italic: true
        color: "#ccc"
        font.pixelSize: parent.height*0.2
        opacity: 1.0
    }
    Text {
        id: on
        anchors.centerIn: parent
        text: "ON"
        font.italic: true
        color: "white"
        font.pixelSize: parent.height*0.2
        opacity: 0.0
    }

    states: [
        State {
            name: "on"
            PropertyChanges { target: background; color: "#129a36" }
            PropertyChanges { target: background; border.color: "#336f0b" }
            PropertyChanges { target: overlay; border.color: "#336f0b" }
            PropertyChanges { target: off; opacity: 0.0 }
            PropertyChanges { target: on; opacity: 1.0 }
            PropertyChanges { target: toggleSwitch; checked: true }
        },
        State {
            name: "off"
            PropertyChanges { target: background; color: "#aaa" }
            PropertyChanges { target: background; border.color: "#bbbbbb" }
            PropertyChanges { target: overlay; border.color: "#bbbbbb" }
            PropertyChanges { target: off; opacity: 1.0 }
            PropertyChanges { target: on; opacity: 0.0 }
            PropertyChanges { target: toggleSwitch; checked: false }
        }
    ]

    transitions: Transition {
        ParallelAnimation {
            NumberAnimation { properties: "opacity"; easing.type: Easing.InOutQuad; duration: 300 }
            ColorAnimation  { duration: 300 }
        }
    }
}
