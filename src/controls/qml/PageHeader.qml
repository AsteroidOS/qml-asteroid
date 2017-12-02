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

