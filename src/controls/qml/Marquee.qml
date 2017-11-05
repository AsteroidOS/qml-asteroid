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
import org.asteroid.controls 1.0

Item {
    id: container
    clip: true

    property alias text: animatedText.text
    property alias font: animatedText.font
    property alias color: animatedText.color

    function originX() {
        var ret = container.width-animatedText.width
        if(ret > 0) return ret/2
        else        return 0
    }

    function destinationX() {
        var ret = container.width-animatedText.width
        if(ret < 0) return ret
        else        return originX()
    }

    function restartAnimation() {
        animation.stop()
        animation1.from = originX()
        animation1.to = originX()
        animation2.to = destinationX()
        animation.start()
    }

    onWidthChanged: restartAnimation()

    Text {
        id: animatedText
        width: contentWidth
        onWidthChanged: restartAnimation()
    }

    SequentialAnimation {
        id: animation
        loops: Animation.Infinite

        NumberAnimation {
            id: animation1
            target: animatedText
            property: "x"
            duration: 2000
        }

        NumberAnimation {
            id: animation2
            target: animatedText
            property: "x"
            duration: (animatedText.width)/Dims.w(0.08)
            easing.type: Easing.InOutQuad
        }

        NumberAnimation {
            target: animatedText
            property: "x"
            duration: 2000
        }
    }
}

