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

import QtQuick 2.4

/*!
    \qmltype CircularScrollIndicator
    \inqmlmodule org.asteroid.controls
    \inherits Item
    \brief Scroll indicator shapped as a circle.

    You can customize the color, background and the line width.
    In order to use this element you need to provide a Flickable.

    Example:
    \qml
    ListView {
      id: listView

      height: 500
      width: 500

      model: 100
      delegate: Text { text: index }
    }

    CircularScrollIndicator {
        anchors.centerIn: listView

        height: 500
        width: 500

        flickable: listView

        color: "#3498db"
        backgroundColor: "#e5e6e8"
    }
    \endqml
*/

Item {
    id: root

    /*! This defines the flickable element. */
    property Flickable flickable

    /*! This defines the color for the handle. */
    property alias color: progressCircle.color

    /*! This defines the color for the background. */
    property alias backgroundColor: progressCircle.backgroundColor

    /*! This defines the width of the background. */
    property alias backgroundLineWidth: progressCircle.backgroundLineWidth

    /*! This defines the width of the handle. */
    property alias progressLineWidth: progressCircle.progressLineWidth

    height: flickable ? flickable.height : 100
    width: flickable ? flickable.width : 100

    ProgressCircle {
        id: progressCircle

        readonly property real position: flickable ? flickable.visibleArea.yPosition : 0
        readonly property real pageSize: flickable ? flickable.visibleArea.heightRatio : 0

        anchors.fill: parent

        value: pageSize
        rotation: (360 - (360 * pageSize)) * (position  / (1 - pageSize)) - 90
        animationEnabled: false
    }
}
