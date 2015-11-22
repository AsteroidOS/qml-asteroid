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
