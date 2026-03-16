/*
 * Copyright (C) 2026 Timo Könnecke <github.com/moWerk>
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
    \qmltype ListRow
    \inqmlmodule org.asteroid.controls 1.0

    \brief A layout base for list rows with a left content area and a right action widget.

    ListRow provides the shared geometry tokens and layout skeleton used by list row
    components such as \l LabeledSwitch, \l LabeledActionButton, and \l OptionCycler.
    It owns the left/right margins, icon size, font size, and opacity behavior so that
    all row components remain visually consistent without duplicating these values.

    The left content area is filled via normal child declaration (default property).
    The right action widget is injected as a \l Component via the \l actionComponent
    property and instantiated in a \l Loader that owns the right-side anchor geometry.

    The Loader always resizes its instantiated root item to the Loader dimensions, so
    action components must wrap their content in an Item and size the inner widget
    explicitly using \l iconSize captured from the consumer's scope.

    This example shows a simple row with a label on the left and a custom icon on the right:

    \qml
    import QtQuick 2.9
    import org.asteroid.controls 1.0

    ListRow {
        width: parent.width
        height: Dims.l(15)

        Label {
            anchors {
                left: parent.left
                leftMargin: rowMargin
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
            text: "Example"
            font.pixelSize: labelFontSize
        }

        actionComponent: Item {
            Icon {
                anchors.centerIn: parent
                name: "ios-checkmark-circle-outline"
                width: iconSize
                height: iconSize
            }
        }
    }
    \endqml
*/
Item {
    /*!
        \qmlproperty Component ListRow::actionComponent
        The component to instantiate in the right-side action area.
        The Loader is \l iconSize + 2 * \l actionSlotPadding wide and \l iconSize tall,
        providing \l actionSlotPadding on each side around centered content. The Loader
        resizes its instantiated root item to fill itself, so action components must wrap
        their widget in an Item and size it explicitly using \l iconSize.
    */
    property Component actionComponent: null

    /*!
        \qmlproperty Item ListRow::actionArea
        Read-only reference to the Loader occupying the right action slot.
        Left-side content anchors its right edge to \c actionArea.left automatically
        via the internal \c labelContainer.
    */
    readonly property alias actionArea: actionLoader

    /*!
        \qmlproperty bool ListRow::highlightBarEnabled*
        Set to false to disable the HighlightBar, allowing child items to receive
        taps directly. Defaults to true. Set to false for components such as
        \l IntSelector that manage multiple independent tap targets.
    */
    property bool highlightBarEnabled: true

    /*!
     \qmlproperty string ListRow::text   *
     The descriptive label text displayed on the left side of the row.
     Leave unset and add child items via the default property for custom left-side content.
    */
    property alias text: labelContainer.text

    /*! Padding on each side of the action icon within the action slot, too enable placement of items wider than \l iconSize */
    property int actionSlotPadding: Dims.l(6)

    /*! Left and right margin for the row content */
    property int rowMargin: Dims.w(15)

    /*! Size of the right-side action widget */
    property int iconSize: Dims.l(20)

    /*! Base font size for label text */
    property int labelFontSize: Dims.l(6)

    /*! Default width is parent width */
    width: parent.width

    /*! Default height is parent height */
    height: parent.height

    /*! Left content area — filled by child declarations */
    default property alias content: labelContainer.data

    signal clicked()

    Behavior on opacity {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutQuad
        }
    }

    Label {
        id: labelContainer
        anchors {
            left: parent.left
            leftMargin: rowMargin
            right: actionLoader.left
            top: parent.top
            bottom: parent.bottom
        }
        font.pixelSize: labelFontSize
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        wrapMode: Text.Wrap
    }

    Loader {
        id: actionLoader
        anchors {
            right: parent.right
            rightMargin: actionComponent ? rowMargin - actionSlotPadding : 0
            verticalCenter: parent.verticalCenter
        }
        width: actionComponent ? iconSize + 2 * actionSlotPadding : 0
        height: iconSize
        sourceComponent: actionComponent
    }

    HighlightBar {
        enabled: highlightBarEnabled
        onClicked: parent.clicked()
    }
}
