/*
 * Qt Quick Controls Asteroid - User interface components for AsteroidOS
 *
 * Copyright (C) 2016 Florent Revest <revestflo@gmail.com>
 *               2015 Tim Süberkrüb <tim.sueberkrueb@web.de>
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

/*!
    \qmltype LayerStack
    \inqmlmodule org.asteroid.controls
    \inherits Item
    \brief Provides a stack of swipable layers.

    Example:
    \qml
    Component {
        id: blueRect
        Rectangle { color: "blue" }
    }

    Component {
        id: redRect
        Rectangle { color: "red"
            Button {
                text: "Open 2nd Layer"
                anchors.centerIn: parent
                onClicked: layerStack.push(blueRect)
            }
        }
    }

    Button {
        text: "Open Layer"
        anchors.centerIn: parent
        onClicked: layerStack.push(redRect)
    }

    LayerStack { id: layerStack }
    \endqml
*/

Item {
    id: layersStack
    z: 25
    anchors.fill: parent
    objectName: "LayerStack"

    property var layers: []
    property var currentLayer: layers.length > 0 ? layers[layers.length-1] : null

    Component { // Blocks mouse events between layers
        id: layer
        MouseArea { width: parent.width; height: parent.height }
    }

    function push(component, params) {
        if (typeof params === 'undefined') params = {}
        params["width"] = width
        params["height"] = height

        if (component.status === Component.Ready) {
            var mouseBlocker = layer.createObject(parent);
            component.createObject(mouseBlocker, params);
            layers.push(mouseBlocker);
        }
        parent.setOverridesSystemGestures(layers.length > 0) // /!\ TODO: find AppWindow instead of using parent
        layersChanged();
    }

    function pop(layer) {
        layers.pop(layer);
        parent.setOverridesSystemGestures(layers.length > 0) // /!\ TODO: find AppWindow instead of using parent
        layersChanged();
    }

    BorderGestureArea {
        id: gestureArea
        anchors.fill: parent
        enabled: layers.length > 0

        property real swipeThreshold: 0.15

        onGestureStarted: {
            swipeAnimation.stop()
            cancelAnimation.stop()
            if(gesture == "right")
                state = "swipe"
        }

        onGestureFinished: {
            if(gesture == "right") {
                if (gestureArea.progress >= swipeThreshold) {
                    swipeAnimation.valueTo = inverted ? -max : max
                    swipeAnimation.start()
                } else
                    cancelAnimation.start()
            } else
                cancelAnimation.start()
        }

        states: [
            State {
                name: "swipe"

                PropertyChanges {
                    target: gestureArea
                    delayReset: true
                }

                PropertyChanges {
                    target: currentLayer
                    x: gestureArea.horizontal ? gestureArea.value : 0
                }
            }
        ]

        SequentialAnimation {
            id: cancelAnimation

            NumberAnimation {
                target: gestureArea
                property: "value"
                to: 0
                duration: 200
                easing.type: Easing.OutQuint
            }

            PropertyAction {
                target: gestureArea
                property: "state"
                value: ""
            }
        }

        SequentialAnimation {
            id: swipeAnimation

            property alias valueTo: valueAnimation.to

            NumberAnimation {
                id: valueAnimation
                target: gestureArea
                property: "value"
                duration: 200
                easing.type: Easing.OutQuint
            }

            ScriptAction {
                script: {
                    currentLayer.destroy()
                    pop(currentLayer)
                }
            }

            PropertyAction {
                target: gestureArea
                property: "state"
                value: ""
            }
        }
    }
}
