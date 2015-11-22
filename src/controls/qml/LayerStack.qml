import QtQuick 2.4


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
