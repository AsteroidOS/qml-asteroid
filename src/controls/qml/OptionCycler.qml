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
        property var config: ({ design: "diamonds" })
        property var designOptions: ["diamonds", "bubbles", "logos", "flashes"]

        OptionCycler {
            anchors.centerIn: parent
            width: Dims.l(80)
            height: Dims.l(20)
            title: "Tap to cycle designs"
            valueArray: designOptions
            currentValue: config.design
            onValueChanged: {
                config.design = value
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

    /*! Left and right margin for the label content */
    property int labelMargin: Dims.w(15)

    /*! Size of the label text */
    property int labelFontSize: Dims.l(6)

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

    Label {
        id: titleLabel
        anchors {
            top: parent.top
            left: parent.left
            leftMargin: labelMargin
        }
        font.pixelSize: labelFontSize
        verticalAlignment: Text.AlignTop
        horizontalAlignment: Text.AlignLeft
        wrapMode: Text.Wrap
        height: parent.height / 2
    }

    Label {
        id: valueLabel
        anchors {
            top: titleLabel.bottom
            horizontalCenter: parent.horizontalCenter
        }
        text: currentValue
        font.pixelSize: labelFontSize
        verticalAlignment: Text.AlignTop
        horizontalAlignment: Text.AlignRight
        wrapMode: Text.Wrap
        height: parent.height / 2
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
