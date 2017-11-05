/*
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

import QtQuick 2.9
import QtQuick.VirtualKeyboard 2.1

HandwritingInputPanel {
    z: 99
    anchors.fill: parent
    inputPanel: inputPanel
    Component.onCompleted: {
        active = true
        available = true
    }

    Rectangle {
        z: -1
        anchors.fill: parent
        color: "black"
        opacity: 0.7
        transitions: Transition {
            PropertyAnimation { properties: "opacity"; easing.type: Easing.InOutQuad }
        }
    }

    InputPanel {
        id: inputPanel
        visible: false
    }

    IconButton {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height/28

        iconName: "ios-checkmark-circle-outline"

        onClicked: Qt.inputMethod.hide()
    }
}
