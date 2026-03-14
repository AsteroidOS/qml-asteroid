/*
 * Copyright (C) 2025 Timo Könnecke <github.com/eLtMosen>
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

    This component displays a title label and a value label showing the current value from a provided array of configuration options.
    Clicking the component cycles to the next value in the array, looping back to the first value when the end is reached.
    It is designed to work with configuration settings, updating a specified configuration object when the value changes.

    This example shows a centered \l OptionCycler that cycles through a list of design options, updating a configuration object.

    \qml
    import QtQuick 2.9
    import org.asteroid.controls 1.0

    Item {
        anchors.fill: parent
        property var designOptions: ["diamonds", "bubbles", "logos", "flashes"]

        OptionCycler {
            anchors.centerIn: parent
            width: Dims.l(80)
            height: Dims.l(20)
            title: "Tap to cycle designs"
            valueArray: designOptions
            currentValue: designOptions[0]
            onValueChanged: {
                currentValue = value
            }
        }
    }
    \endqml
*/

Item {
    /*!
        \qmlproperty string OptionCycler::title
        The title text to display above the current value.
    */
    property alias title: titleLabel.text

    /*!
        \qmlproperty array OptionCycler::valueArray
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

    /*! Left and right margin for the row content — matches LabeledSwitch rowMargin */
    property int rowMargin: Dims.w(15)

    /*! Size of the phantom switch placeholder — matches LabeledSwitch iconSize */
    property int iconSize: Dims.l(20)

    /*! Size of the title label text */
    property int labelFontSize: Dims.l(6)

    /*! Size of the value label text — one step larger to distinguish from title */
    property int valueFontSize: Dims.l(7)

    /*! Default width is parent width */
    width: parent.width

    /*! Default height is parent height */
    height: parent.height

    Behavior on opacity {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutQuad
        }
    }

    Item {
        id: phantomSwitch
        anchors {
            right: parent.right
            rightMargin: rowMargin
            verticalCenter: parent.verticalCenter
        }
        width: iconSize
        height: iconSize
    }

    Label {
        id: titleLabel
        anchors {
            left: parent.left
            leftMargin: rowMargin
            right: phantomSwitch.left
            rightMargin: Dims.h(6)
            verticalCenter: parent.verticalCenter
        }
        font.pixelSize: labelFontSize
        horizontalAlignment: Text.AlignLeft
        wrapMode: Text.Wrap
    }

    Label {
        id: valueLabel
        anchors {
            horizontalCenter: phantomSwitch.horizontalCenter
            verticalCenter: phantomSwitch.verticalCenter
        }
        text: currentValue
        font {
            pixelSize: valueFontSize
            family: "Noto Sans SemiCondensed"
            bold: true
        }
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.Wrap
    }

    HighlightBar {
        onClicked: {
            var currentIndex = valueArray.indexOf(currentValue)
            var nextIndex = (currentIndex + 1) % valueArray.length
            var newValue = valueArray[nextIndex]
            valueChanged(newValue)
        }
    }
}
