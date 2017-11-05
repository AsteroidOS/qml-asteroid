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

ListView {
    property alias showSeparator: separator.visible

    function zeroPadding(x) {
        if (x<10) return "0"+x;
        else      return x;
    }

    id: lv
    preferredHighlightBegin: height / 2 - Dims.h(5)
    preferredHighlightEnd: height / 2 + Dims.h(5)
    highlightRangeMode: ListView.StrictlyEnforceRange
    spacing: Dims.h(2)
    clip: true

    delegate: Item {
        width: lv.width
        height: Dims.h(10)
        Text {
            text: zeroPadding(index)
            anchors.centerIn: parent
            color: parent.ListView.isCurrentItem ? "#FFFFFF" : "#88FFFFFF"
            scale: parent.ListView.isCurrentItem ? 1.7 : 1
            Behavior on scale { NumberAnimation { duration: 200 } }
            Behavior on color { ColorAnimation { duration: 200 } }
        }
    }

    Rectangle {
        id: separator
        width: 1
        height: parent.height*0.8
        color: "#88FFFFFF"
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        visible: false
    }
}
