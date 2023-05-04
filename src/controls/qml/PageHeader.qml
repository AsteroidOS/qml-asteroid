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
import org.asteroid.utils 1.0

/*!
    \qmltype PageHeader
    \inqmlmodule org.controls.asteroid 1.0

    \brief Provides a title on a page.

    This is intended to be used as a title for a settings page.  Note that there should only
    be a single instance on a page; otherwise the titles will all be placed in the same location
    and make it impossible to read either title.

    Here is a short example:

    \qml
    import QtQuick 2.9
    import org.asteroid.controls 1.0

    Item {
        anchors.centerIn: parent
        anchors.fill: parent
        PageHeader { text: "Example Page" }
        Rectangle {
            anchors.centerIn: parent
            width: 100
            height: 100
            radius: 50
            color: "blue"
        }
    }
    \endqml
*/

Label {
    height: Dims.h(20)
    font.pixelSize: Dims.l(6)
    font.capitalization: Font.SmallCaps
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
    leftPadding: DeviceInfo.hasRoundScreen ? Dims.w(25) : 0
    rightPadding: DeviceInfo.hasRoundScreen ? Dims.w(25) : 0
    wrapMode: Text.WordWrap
    maximumLineCount: 2
}

