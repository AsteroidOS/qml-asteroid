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
import QtQuick.Window 2.2
import org.asteroid.controls 1.0


Item {
    id: item

    property real size: Units.dp(24)
    property string name
    property color color: "white"

    width: size
    height: size

    Image {
        id: image
        anchors.fill: parent
        visible: false
        source: name ? Qt.resolvedUrl("/usr/share/icons/asteroid/" + name + ".svg") : Qt.resolvedUrl("")

        sourceSize {
            width: size
            height: size
        }
    }

    ColorOverlay {
        id: overlay

        anchors.fill: parent
        source: image
        color: Qt.rgba (item.color.r, item.color.g, item.color.b, 1)
        cached: true
        visible: image.source !== ""
        opacity: item.color.a
    }

}
