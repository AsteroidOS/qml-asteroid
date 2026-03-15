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
    \qmltype OptionCycler
    \inqmlmodule org.asteroid.controls 1.0

    \brief A component that displays and cycles through a list of configuration values.

    This component displays a title label and a value label showing the current value
    from a provided array of configuration options. Clicking the component cycles to
    the next value in the array, looping back to the first value when the end is reached.

    \qml
    import QtQuick 2.9
    import org.asteroid.controls 1.0

    Item {
        anchors.fill: parent
        property var designOptions: ["diamonds", "bubbles", "logos", "flashes"]

        OptionCycler {
            width: parent.width
            height: Dims.l(20)
            title: "Tap to cycle designs"
            valueArray: designOptions
            currentValue: designOptions[0]
            onValueChanged: currentValue = value
        }
    }
    \endqml
*/
ListRow {
    /*!
        \qmlproperty string OptionCycler::title
        The title text to display on the left side.
    */
    property alias title: titleLabel.text

    /*!
        \qmlproperty var OptionCycler::valueArray
        The array of values to cycle through.
    */
    property var valueArray

    /*!
        \qmlproperty string OptionCycler::currentValue
        The currently selected value.
    */
    property string currentValue

    /*!
        \qmlsignal OptionCycler::valueChanged(string value)
        Emitted when the selected value changes, passing the new \a value.
    */
    signal valueChanged(string value)

    /*!
        \qmlproperty int OptionCycler::valueFontSize
        Size of the value label text. One step larger than \l labelFontSize to
        distinguish the operator value from the informational description.
    */
    property int valueFontSize: Dims.l(7)

    onClicked: {
        var currentIndex = valueArray.indexOf(currentValue)
        var nextIndex = (currentIndex + 1) % valueArray.length
        valueChanged(valueArray[nextIndex])
    }

    Label {
        id: titleLabel
        anchors {
            left: parent.left
            leftMargin: rowMargin
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
        font.pixelSize: labelFontSize
        horizontalAlignment: Text.AlignLeft
        wrapMode: Text.Wrap
    }

    Connections {
        target: actionArea
        onStatusChanged: {
            if (actionArea.status === Loader.Ready)
                actionArea.item.text = Qt.binding(function() { return currentValue })
        }
    }

    actionComponent: Item {
        property alias text: valueLabel.text

        Label {
            id: valueLabel
            anchors.centerIn: parent
            width: parent.width
            font {
                pixelSize: valueFontSize
                family: "Noto Sans SemiCondensed"
                bold: true
            }
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.Wrap
        }
    }
}
