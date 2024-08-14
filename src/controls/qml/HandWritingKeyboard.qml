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

/*!
    \qmltype HandWritingKeyboard
    \inqmlmodule AsteroidControls

    \brief A hand writing keyboard for AsteroidOS.

    The HandWritingKeyboard is a virtual keyboard that allows 
    a user to input text without a physical keyboard.
    The HandWritingKeyboard is the default virtual keyboard for 
    AsteroidOS.
   
    In this example, a simple \l TextField is created in the center 
    of the screen with preview text "sample text".  

    \qml
    import QtQuick 2.9
    import org.asteroid.controls 1.0

    Item {
        HandWritingKeyboard {
            anchors.fill: parent
        }
        
        TextField {
            width: parent.width * 0.8
            textWidth: parent.width *0.75
            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }
            previewText: "sample text"
        }
    }
    \endqml

*/
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
