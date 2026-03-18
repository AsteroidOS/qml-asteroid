/*
 * Copyright (C) 2026 Timo Könnecke <github.com/moWerk>
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
import org.asteroid.utils 1.0
import org.asteroid.controls 1.0

/*!
 *   \qmltype RowSeparator
 *   \inqmlmodule org.asteroid.controls
 *
 *   \brief A thin horizontal rule for separating rows in a list.
 *
 *   The \l RowSeparator control draws a hairline rule that scales with
 *   screen resolution via \l Dims, rendering as approximately one
 *   physical pixel at 400px and scaling proportionally on larger
 *   displays.
 *
 *   The separator color defaults to a low-opacity white suitable for
 *   use on dark backgrounds. Both \l color and \l height can be
 *   overridden by the caller.
 *
 *   By default RowSeparator behaves as a plain horizontal rule sized to
 *   its parent width, suitable for use as a sibling in a \l Column or
 *   \l Flickable layout:
 *
 *   \qml
 *   import QtQuick 2.0
 *   import org.asteroid.controls 1.0
 *
 *   Column {
 *       width: parent.width
 *
 *       Label { text: "Section A" }
 *       RowSeparator {}
 *       Label { text: "Section B" }
 *       RowSeparator {}
 *       Label { text: "Section C" }
 *   }
 *   \endqml
 *
 *   When used inside a list delegate where the separator should hug the
 *   bottom edge of the row, set \l pinToBottom to \c true:
 *
 *   \qml
 *   import QtQuick 2.0
 *   import org.asteroid.controls 1.0
 *
 *   ListView {
 *       model: 5
 *       delegate: Item {
 *           width: ListView.view.width
 *           height: 60
 *
 *           Text {
 *               anchors.centerIn: parent
 *               text: "Row " + index
 *           }
 *
 *           RowSeparator { pinToBottom: true }
 *       }
 *   }
 *   \endqml
 */
Rectangle {
    /*! the color of the separator line, defaults to low-opacity white */
    color: "#40ffffff"
    /*! the thickness of the separator, defaults to Dims.l(0.25) */
    height: Math.max(1, Dims.l(0.25))
    /*! anchor the separator to the bottom edge of the parent, useful
     *       inside list delegates. Defaults to false for use in Column
     *       and Flickable layouts. */
    property bool pinToBottom: false

    anchors {
        bottom: pinToBottom ? parent.bottom : undefined
        left: parent.left
        right: parent.right
    }
}
