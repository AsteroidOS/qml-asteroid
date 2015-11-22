import QtQuick 2.4
import QtGraphicalEffects 1.0


FocusScope {
    id: item

    width: stack.width
    height: stack.height

    x: item.width

    property var stack: parent.objectName === "LayerStack" ? parent : null
    property bool active: stack.currentLayer === item
    enabled: active
    property bool isAboutToHide: x < -(width*(1/4)) || x > (width*(1/4))

    visible: x < item.width

    function hide() {
        stack.pop(this);
        hideAnimation.start();
    }

    function cancelHide() {
        backToOriginAnimation.start()
    }

    function show () {
        forceActiveFocus();
        stack.push(this);
        showAnimation.start();
    }


    NumberAnimation {
        id: hideAnimation
        target: item
        property: "x"
        from:  item.x
        to: item.width + 10
        duration: 200
        easing.type: Easing.InOutQuad
    }

    NumberAnimation {
        id: backToOriginAnimation
        target: item
        property: "x"
        from:  item.x
        to: 0
        duration: 200
        easing.type: Easing.InOutQuad
    }

    NumberAnimation {
        id: showAnimation
        target: item
        property: "x"
        from: item.width + 10
        to: 0
        duration: 200
        easing.type: Easing.InOutQuad
    }
}
