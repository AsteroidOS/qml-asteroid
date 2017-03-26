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

import QtQuick 2.4

Item {
    id: toggleSwitch
    width: 60; height: 0.35*width

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

    TiltedSquare {
        id: background
        color: "#555"
        borderColor: "#111"
        opacity: 0.25
        anchors.fill: parent
    }
    TiltedSquare {
        id: knob
        color: "#b5b5b5"
        borderColor: "#888"
        height: toggleSwitch.height
        width: toggleSwitch.width/2

        Text {
            id: off
            anchors.centerIn: parent
            text: "OFF"
            font.italic: true
            color: "#888"
            font.pixelSize: knob.height*0.48
            opacity: 1.0
        }
        Text {
            id: on
            anchors.centerIn: parent
            text: "ON"
            font.italic: true
            color: "white"
            font.pixelSize: knob.height*0.48
            opacity: 0.0
        }
    }

    states: [
        State {
            name: "on"
            PropertyChanges { target: knob; x: toggleSwitch.width - knob.width }
            PropertyChanges { target: knob; color: "#129a36" }
            PropertyChanges { target: knob; borderColor: "#336f0b" }
            PropertyChanges { target: off; opacity: 0.0 }
            PropertyChanges { target: on; opacity: 1.0 }
            PropertyChanges { target: toggleSwitch; checked: true }
        },
        State {
            name: "off"
            PropertyChanges { target: knob; x: 0 }
            PropertyChanges { target: knob; color: "#b5bbaf" }
            PropertyChanges { target: knob; borderColor: "#888" }
            PropertyChanges { target: off; opacity: 1.0 }
            PropertyChanges { target: on; opacity: 0.0 }
            PropertyChanges { target: toggleSwitch; checked: false }
        }
    ]

    transitions: Transition {
        ParallelAnimation {
            NumberAnimation { properties: "x"; easing.type: Easing.InOutQuad; duration: 300 }
            NumberAnimation { properties: "opacity"; easing.type: Easing.InOutQuad; duration: 300 }
            ColorAnimation  { duration: 300 }
        }
    }
}
