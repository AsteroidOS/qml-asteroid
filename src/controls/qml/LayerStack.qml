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

import QtQuick 2.0

Item {
    id: layersStack
    anchors.fill: parent
    objectName: "LayerStack"

    property var firstPage
    property var layers: []
    property var currentLayer: layers.length > 0 ? layers[layers.length-1] : null

    Flickable {
        id: contentArea
        anchors.fill: parent
        interactive: false
        Row { id: content }
    }

    NumberAnimation {
        id: pushAnim
        target: contentArea
        property: "contentX"
        duration: 200
        easing.type: Easing.OutQuint
    }

    Component.onCompleted: {
        var params = {}
        params["width"] = Qt.binding(function() { return width })
        params["height"] =  Qt.binding(function() { return height })
        params["x"] = 0
        params["y"] = 0
        if(typeof firstPage != 'undefined' && firstPage.status === Component.Ready)
            var itm=firstPage.createObject(content, params)
    }

    function push(component, params) {
        if (component.status === Component.Ready) {
            if (typeof params === 'undefined') params = {}
            params["width"] = Qt.binding(function() { return width })
            params["height"] =  Qt.binding(function() { return height })
            params["depth"] = (layers.length+1)
            params["x"] = params["depth"]*width
            params["y"] = 0

            var layer;
            params["pop"] = function() { layersStack.pop(layer); }
            layer = component.createObject(content, params);
            layers.push(layer);
            pushAnim.to = layers.length*width
            pushAnim.start();
            parent.setOverridesSystemGestures(layers.length > 0) // /!\ TODO: find AppWindow instead of using parent
            layersChanged();
        }
    }

    function pop(layer) {
        layer.destroy();
        layers.pop(layer);
        contentArea.contentX = layers.length*width
        parent.setOverridesSystemGestures(layers.length > 0) // /!\ TODO: find AppWindow instead of using parent
        layersChanged();
    }

    BorderGestureArea {
        id: gestureArea
        anchors.fill: parent
        enabled: layers.length > 0
        acceptsRight: true

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
                    target: contentArea
                    contentX: gestureArea.horizontal ? layers.length*width-gestureArea.value : 0
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

            PropertyAction {
                target: gestureArea
                property: "state"
                value: ""
            }

            ScriptAction { script: pop(currentLayer) }
        }
    }
}
