/*
 * Copyright (C) 2026 - Timo Könnecke  <github.com/moWerk>
 *               2022 - Ed Beroset     <github.com/beroset>
 *               2020 - Darrel Griët   <idanlcontact@gmail.com>
 *               2015 - Florent Revest <revestflo@gmail.com>
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
    \qmltype LabeledSwitch
    \inqmlmodule org.asteroid.controls 1.0

    \brief This combines \l Label and \l Switch in a convenient package.

    This example shows a centered blue square and a \l LabeledSwitch centered below it.
    The square turns green when the toggle is checked, and red when it is unchecked.

    \qml
    import QtQuick 2.9
    import org.asteroid.controls 1.0

    Item {
        anchors.fill: parent
        Rectangle {
            id: square
            anchors.centerIn: parent
            width: 100
            height: 100
            color: "blue"
        }
        LabeledSwitch {
            anchors.top: square.bottom
            anchors.horizontalCenter: square.horizontalCenter
            width: Dims.l(80)
            height: Dims.l(20)
            text: "Enable"
            checked: false
            onCheckedChanged: {
                if (checked) {
                    square.color = "green"
                } else {
                    square.color = "red"
                }
            }
        }
    }
    \endqml
*/
ListRow {
    /*!
        \qmlproperty string LabeledSwitch::text
        The descriptive label text displayed on the left side of the row.
    */
    property alias text: label.text

    /*!
        \qmlproperty bool LabeledSwitch::checked
        The toggle state of the switch. Toggled by tapping anywhere in the row.
    */
    property bool checked: false

    onClicked: checked = !checked

    Connections {
        target: actionArea
        onStatusChanged: {
            if (actionArea.status === Loader.Ready)
                actionArea.item.checked = Qt.binding(function() { return checked })
        }
    }

    actionComponent: Item {
        property alias checked: toggle.checked

        Switch {
            id: toggle
            anchors.centerIn: parent
            width: iconSize
            height: iconSize
        }
    }

    Label {
        id: label
        anchors {
            left: parent.left
            leftMargin: rowMargin
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
        font.pixelSize: labelFontSize
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.Wrap
        height: parent.height
    }
}
