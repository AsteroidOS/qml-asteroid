/*
 * Copyright (C) 2023 - Timo Könnecke <github.com/eLtMosen>
 * Copyright (C) 2022 - Ed Beroset <github.com/beroset>
 * Copyright (C) 2020 - Darrel Griët <idanlcontact@gmail.com>
 * Copyright (C) 2015 - Florent Revest <revestflo@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
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
    \qmltype HighlightBar
    \inqmlmodule AsteroidControls

    \brief A combined Rectangle and MouseArea.

    The \l HighlightBar can be used as part of a delegate for a \l ListView
    or other similar collection or by itself as a convenience.  It 
    combines a \l Rectangle and \l MouseArea and by default is 
    transparent.  When it is clicked it turns slightly translucent
    and also emits a \l MouseArea::clicked signal.

    Note that because HighlightBar fills
    the parent, creating a smaller HighlightBar requires defining a
    parent with a set width and height.

    The simplest example is this:
    \qml
    import QtQuick 2.9
    import org.asteroid.controls 1.0

    HighlightBar { }
    \endqml

    That example fills the screen and shows the background color 
    (if any) and briefly turns on opacity when the screen is clicked.

    A slightly more complex example is shown below.  It starts with
    a transparent background and then cycles between a centered green 
    or blue \l Rectangle with each mouse click.  

    \qml
    import QtQuick 2.9
    import org.asteroid.controls 1.0

    Item {
        Item {
            width: parent.width * 0.5
            height: parent.height * 0.5
            anchors.centerIn: parent
            HighlightBar {
                property int colorIndex: 0
                onClicked: {
                    colorIndex = 1 - colorIndex
                    color = ["blue", "green"][colorIndex]
                }
            }
        }
    }
    \endqml
*/
Rectangle {
    /*! forward the clicked() signal to parent */
    signal clicked()
    /*! alias to receive boolean forceOn to act like a controlled radio button */
    property bool forceOn: false

    anchors.fill: parent
    /*! the default color may be overridden */
    color: rowClick.containsPress || forceOn ? "#33ffffff" : "#00ffffff"

    Behavior on color {
        ColorAnimation {
            duration: 150;
            easing.type: Easing.OutQuad
        }
    }

    MouseArea {
        id: rowClick

        anchors.fill: parent
        hoverEnabled: true
        onClicked: parent.clicked()
    }
}
