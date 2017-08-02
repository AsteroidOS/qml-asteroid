/*
 * Qt Quick Controls Asteroid - User interface components for AsteroidOS
 *
 * Copyright (C) 2015 Isaac Salazar <iktwo.sh@gmail.com>
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

/*!
    \qmltype ProgressCircle
    \inqmlmodule org.asteroid.controls
    \inherits Canvas
    \brief Progress indicator shapped as a circle.

    You can customize the color, background and the line width.

    Example:
    \qml
    ProgressCircle {
        anchors.centerIn: parent

        height: 500
        width: 500

        color: "#3498db"
        backgroundColor: "#e5e6e8"
    }
    \endqml
*/

Canvas {
    id: root

    /*! This defines the color for the percentage of the circle. */
    property color color: "#3aadd9"

    /*! This defines the color for the background of the circle. */
    property color backgroundColor: "#e5e6e8"

    /*! This defines the percentage from 0 to 1. */
    property double value: 0

    /*! This defineds the background line width. */
    property real backgroundLineWidth: _radius / 14

    /*! This defines the progress line width. */
    property real progressLineWidth: _radius / 13

    /*! This defines if the animation is enabled. */
    property alias animationEnabled: behaviorOnValue.enabled

    /*! \internal */
    property point _center: Qt.point(width / 2, height / 2)

    /*! \internal */
    property real _radius: Math.min(width / 2, height / 2.15)

    /*! \internal */
    property real _start_angle: 0

    /*! \internal */
    property real _end_angle: Math.PI * 2

    antialiasing: true

    height: 200
    width: 200

    onValueChanged: requestPaint()
    onColorChanged: requestPaint()
    onBackgroundColorChanged: requestPaint()

    onPaint: {
        var ctx = getContext('2d')

        ctx.reset()
        ctx.clearRect(0, 0, width, height)

        ctx.strokeStyle = backgroundColor
        ctx.lineWidth = backgroundLineWidth

        ctx.beginPath()
        ctx.arc(_center.x, _center.y, _radius, root._start_angle, root._end_angle)
        ctx.stroke()

        ctx.strokeStyle = color
        ctx.lineWidth = progressLineWidth

        ctx.beginPath()
        ctx.arc(_center.x, _center.y, _radius, _start_angle, 2*Math.PI*value + _start_angle)
        ctx.stroke()
    }

    Behavior on value { id: behaviorOnValue; NumberAnimation { } }
}
