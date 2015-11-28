/*
 * Qt Quick Controls Asteroid - User interface components for AsteroidOS
 *
 * Copyright (C) 2015 Tim Süberkrüb <tim.sueberkrueb@web.de>
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
    LayerStack {
        id: watchLayerStack

        Layer {
            id: myWatchLayer
            Rectangle {
                anchors.fill: parent
                color: "green"

                Button {
                    anchors.centerIn: parent
                    text: "Sub"
                    onClicked: {
                        mySubWL.show();
                    }
                }

            }
        }

        Layer {
            z:5
            id: mySubWL
            Rectangle {
                anchors.fill: parent
            }
        }
    }

    Button {
        anchors.bottom: parent.bottom
        text: "Action"
        onClicked: {
            myWatchLayer.show();
        }
    }
    \endqml
*/

Item {
    id: layersStack
    z: 25
    anchors.fill: parent
    objectName: "LayerStack"

    property var layers: []
    property var currentLayer: layers.length > 0 ? layers[layers.length-1] : null

    function push(layer) {
        if (currentLayer !== layer)
            layers.push(layer);
        layersChanged();
    }

    function pop(layer) {
        layers.pop(layer);
        layersChanged();
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent

        hoverEnabled: true
        propagateComposedEvents: true

        property int proposedX: layersStack.currentLayer ? mouseArea.mouseX-layersStack.currentLayer.width/2 : 0

        onClicked: {
            mouse.accepted = false;
        }

        onPressed: {
            if (layersStack.currentLayer)
                layersStack.currentLayer.x = Qt.binding(function(){return mouseArea.proposedX < 0 ? 0 : mouseArea.proposedX;})
            else
                mouse.accepted = false;
        }

        onPressAndHold: {
            mouse.accepted = false;
        }

        onReleased: {
            layersStack.currentLayer.x = layersStack.currentLayer.x;
            if (layersStack.currentLayer.isAboutToHide)
                layersStack.currentLayer.hide();
            else
                layersStack.currentLayer.cancelHide();
            mouse.accepted = false;
        }
        onPositionChanged: {
            mouse.accepted = false;
        }
        onDoubleClicked: {
            mouse.accepted = false;
        }
    }
}
