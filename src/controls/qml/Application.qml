/*
 * Copyright (C) 2016 Florent Revest <revestflo@gmail.com>
 *               2015 Tim Süberkrüb <tim.sueberkrueb@web.de>
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
import org.asteroid.utils 1.0

/*!
    \qmltype Application
    \inqmlmodule org.asteroid.controls
    \brief Shows a flat mesh background with indicators.

    The Application type is intended to be used as the top level QML object
    for graphical applications on AsteroidOS.  By default only the top and
    left indicators are visible and the bottom and right indicators are not.

    Here's a short example:

    \qml
    import QtQuick 2.9
    import org.asteroid.controls 1.0

    Application {
        // show a purple-ish flat mesh background
        id: myapp
        centerColor: "#00010B"
        outerColor: "#E044A6"
        // make all indicators visible
        rightIndicVisible: true
        bottomIndicVisible: true

        Rectangle {
            id: square
            anchors.centerIn: parent
            color: "yellow"
            width: parent.width * 0.4
            height: parent.height * 0.2
        }
    }
    \endqml
*/

Application_p {
    anchors.fill: parent

    /*!
        Outer color for the flat mesh.
     */
    property alias outerColor: fm.outerColor
    /*!
        Inner color for the flat mesh.
     */
    property alias centerColor: fm.centerColor

    function animIndicators() {
        rightIndicator.animate();
        leftIndicator.animate();
        topIndicator.animate();
        bottomIndicator.animate();
    }

    FlatMesh {
        id: fm
        anchors.fill: parent
    }

    /*!
        Is the right indicator visible?
     */
    property alias rightIndicVisible:  rightIndicator.visible
    /*!
        Is the left indicator visible?
     */
    property alias leftIndicVisible:   leftIndicator.visible
    /*!
        Is the top indicator visible?
     */
    property alias topIndicVisible:    topIndicator.visible
    /*!
        Is the bottom indicator visible?
     */
    property alias bottomIndicVisible: bottomIndicator.visible

    Indicator {
        id: rightIndicator
        edge: Qt.RightEdge
        visible: false
        z: 10
        anchors.verticalCenterOffset: DeviceSpecs.flatTireHeight/2
    }

    Indicator {
        id: leftIndicator
        edge: Qt.LeftEdge
        visible: true
        z: 10
        anchors.verticalCenterOffset: DeviceSpecs.flatTireHeight/2
    }

    Indicator {
        id: topIndicator
        edge: Qt.TopEdge
        visible: true
        z: 10
    }

    Indicator {
        id: bottomIndicator
        edge: Qt.BottomEdge
        visible: false
        z: 10
    }
}
