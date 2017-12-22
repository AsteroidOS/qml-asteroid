/*
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

import QtQuick 2.9

Item {
    id: layersStack
    anchors.fill: parent
    objectName: "LayerStack"

    property var firstPage
    property var layers: []
    property var currentLayer: layers.length > 0 ? layers[layers.length-1] : null
    property QtObject win: parent  // Can be set to null if you don't want indicators animations and systemgestures override. If your LayerStack isn't directly a child element of your window, you can also specify the window via this parameter.

    Flickable {
        id: contentArea
        anchors.fill: parent
        interactive: false
        Row { id: content }
    }

    SequentialAnimation {
        id: pushAnim

        NumberAnimation {
            id: pushAnimX
            target: contentArea
            property: "contentX"
            duration: 200
            easing.type: Easing.OutQuint
        }

        ScriptAction { script: if(win !== null) win.animIndicators() }
    }

    Component.onCompleted: {
        var params = {}
        params["width"] = Qt.binding(function() { return width })
        params["height"] =  Qt.binding(function() { return height })
        params["x"] = 0
        params["y"] = 0
        if(typeof firstPage != 'undefined' && firstPage.status === Component.Ready) {
            var itm=firstPage.createObject(content, params)
            itm.clip = true
        }
    }

    function push(component, params) {
        if (component.status === Component.Ready) {
            if (typeof params === 'undefined') params = {}
            params["width"] = Qt.binding(function() { return width })
            params["height"] =  Qt.binding(function() { return height })
            params["depth"] = (layers.length+1)
            params["x"] = params["depth"]*width
            params["y"] = 0
            params["clip"] = true

            var layer;
            params["pop"] = function() { layersStack.popAnim(); }
            layer = component.createObject(content, params);
            layers.push(layer);
            pushAnimX.to = layers.length*width
            pushAnim.start();
            if(win !== null)
                win.setOverridesSystemGestures(layers.length > 0)
            layersChanged();
        }
    }

    function popAnim() {
        swipeAnimation.valueTo = width
        swipeAnimation.start();
    }

    function pop(layer) {
        layer.destroy();
        layers.pop(layer);
        contentArea.contentX = layers.length*width
        if(win !== null)
            win.setOverridesSystemGestures(layers.length > 0)
        layersChanged();
        if(win !== null)
            win.animIndicators()
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
                    swipeAnimation.valueTo = width
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
                    contentX: layers.length*width - gestureArea.value
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

            ScriptAction { script: if(win !== null) win.animIndicators() }
        }

        SequentialAnimation {
            id: swipeAnimation

            property alias valueTo: valueAnimation.to

            PropertyAction {
                target: gestureArea
                property: "state"
                value: "swipe"
            }

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
