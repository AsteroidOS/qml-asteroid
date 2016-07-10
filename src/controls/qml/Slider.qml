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
    id: slider

    property int value: 5
    property int minimumValue: 0
    property int maximumValue: 100

    width: 1000
    height: 30

    MouseArea {
        anchors.fill: parent
        function updateValue(mouse) {
            var pos = mouse.x / slider.width * (slider.maximumValue - slider.minimumValue) + slider.minimumValue;
            if (pos > slider.maximumValue) pos = slider.maximumValue;
            else if (pos < slider.minimumValue) pos = slider.minimumValue;
            slider.value = pos
        }
        onPositionChanged: updateValue(mouse)
        onClicked: updateValue(mouse)
    }

    Rectangle {
        id: background
        border.width: 1
        border.color: "#757575"
        gradient: Gradient {
            GradientStop { position: 1.0; color: "#bfbfbf" }
            GradientStop { position: 1.0; color: "#b3b3b3" }
        }
        width: slider.width
        height: 10
        radius: 5
        anchors.centerIn: parent
    }

    Rectangle {
        id: progress
        border.width: 1
        border.color: "#035899"
        gradient: Gradient {
            GradientStop { position: 1.0; color: "#0a58ad" }
            GradientStop { position: 1.0; color: "#2094dd" }
        }
        width: ((parent.width-handle.width)/slider.maximumValue) * slider.value+handle.width/2
        height: 10
        radius: 5
        anchors.verticalCenter: parent.verticalCenter
        Behavior on width { NumberAnimation { duration: 100 } }
    }

    Rectangle {
        id: handle
        border.width: 1
        border.color: "#8a8a8a"
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#f8f8f8" }
            GradientStop { position: 1.0; color: "#dbdbdb" }
        }
        height: 30
        width: 30
        radius: 15
        anchors.verticalCenter: parent.verticalCenter
        x: (((parent.width-width) / slider.maximumValue) * slider.value)

        Behavior on x { NumberAnimation { duration: 100 } }
    }
}
