/*
 * Copyright (C) 2026 Timo Könnecke <github.com/moWerk>
 *               2017 Florent Revest <revestflo@gmail.com>
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

/*!
    \qmltype Marquee
    \inqmlmodule org.asteroid.controls

    \brief Display text that may be longer than the available space.

    The \l Marquee control shows as much as possible of the string
    initially, then animates it scrolling left until the end of the
    string is visible, pauses briefly, then scrolls back to the start
    and repeats.

    Scrolling only runs when the text is wider than the available width.
    When text fits no animation runs. The \l paused property allows
    callers to suppress scrolling entirely, for example when the
    containing page is not visible.

    Here is a short example:

    \qml
    import QtQuick 2.0
    import org.asteroid.controls 1.0

    Item {
        Marquee {
            text: "The quick brown fox jumps over the lazy dog."
            height: parent.height * 0.3
            width: parent.width * 0.8
            anchors.centerIn: parent
        }
    }
    \endqml
*/
Item {
    id: container
    clip: true

    /*! the text to display */
    property alias text: animatedText.text
    /*! the text \l Font */
    property alias font: animatedText.font
    /*! the text color */
    property alias color: animatedText.color
    /*! suspend scrolling, e.g. when the containing page is not visible */
    property bool paused: false

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
        if(paused || animatedText.width <= container.width) return
            var scrollDuration = 1000 * animatedText.width / (container.width > 0 ? container.width : 1)
            animHold.from = originX()
            animHold.to = originX()
            animForward.to = destinationX()
            animForward.duration = scrollDuration
            animHoldEnd.from = destinationX()
            animHoldEnd.to = destinationX()
            animBack.to = originX()
            animBack.duration = scrollDuration
            animation.start()
    }

    onWidthChanged: restartAnimation()
    onPausedChanged: restartAnimation()

    Label {
        id: animatedText
        width: contentWidth
        onWidthChanged: restartAnimation()
        elide: Text.ElideNone
    }

    SequentialAnimation {
        id: animation
        loops: Animation.Infinite

        NumberAnimation {
            id: animHold
            target: animatedText
            property: "x"
            duration: 2000
        }

        NumberAnimation {
            id: animForward
            target: animatedText
            property: "x"
            easing.type: Easing.InOutQuad
        }

        NumberAnimation {
            id: animHoldEnd
            target: animatedText
            property: "x"
            duration: 400
        }

        NumberAnimation {
            id: animBack
            target: animatedText
            property: "x"
            easing.type: Easing.InOutQuad
        }
    }
}
