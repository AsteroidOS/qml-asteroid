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

Label {
    property bool isCircularSpinner: PathView.view !== null
    property bool isCurr: isCircularSpinner ? PathView.isCurrentItem : ListView.isCurrentItem

    width: isCircularSpinner ? PathView.view.width : ListView.view.width
    height: Dims.h(10)

    text: zeroPadding(index)
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter

    opacity: isCurr ? 1.0 : 0.6
    scale: isCurr ? 1.5 : 0.6
    Behavior on scale   { NumberAnimation { duration: 200 } }
    Behavior on opacity { NumberAnimation { duration: 200 } }
}
