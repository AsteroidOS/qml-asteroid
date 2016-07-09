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
    width: 100; height: 0.37*width

    property bool checked: false

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
        border.width: 1
        border.color: "#757575"
        gradient: Gradient {
            GradientStop { id: backgroundColor1; position: 1.0; color: "#bfbfbf" }
            GradientStop { id: backgroundColor2; position: 1.0; color: "#b3b3b3" }
        }
        width: toggleSwitch.width*0.9
        height: toggleSwitch.height - (toggleSwitch.width-width)
        radius: height/2
        anchors.centerIn: parent
    }

    Rectangle {
        id: knob
        border.width: 1
        border.color: "#8a8a8a"
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#f8f8f8" }
            GradientStop { position: 1.0; color: "#dbdbdb" }
        }
        height: toggleSwitch.height
        width: height
        radius: width/2
    }

    states: [
        State {
            name: "on"
            PropertyChanges { target: knob; x: toggleSwitch.width - knob.width }
            PropertyChanges { target: backgroundColor1; color: "#0a58ad" }
            PropertyChanges { target: backgroundColor2; color: "#2094dd" }
            PropertyChanges { target: background; border.color: "#035899" }
            PropertyChanges { target: toggleSwitch; checked: true }
        },
        State {
            name: "off"
            PropertyChanges { target: knob; x: 0 }
            PropertyChanges { target: backgroundColor1; color: "#bfbfbf" }
            PropertyChanges { target: backgroundColor2; color: "#b3b3b3" }
            PropertyChanges { target: background; border.color: "#757575" }
            PropertyChanges { target: toggleSwitch; checked: false }
        }
    ]

    transitions: Transition {
        ParallelAnimation {
            NumberAnimation { properties: "x"; easing.type: Easing.InOutQuad; duration: 150 }
            ColorAnimation  { duration: 150 }
        }
    }
}
