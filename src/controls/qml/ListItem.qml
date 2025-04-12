/*
 * Copyright (C) 2023 - Timo Könnecke <github.com/eLtMosen>
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
import org.asteroid.utils 1.0

/*!
    \qmltype ListItem
    \inqmlmodule AsteroidControls

    \brief A delegate to display a icon and text combo.

    An example is shown below which display three icons
    with their associated text and allows the user to select
    one.  Note that both highlighting and processing of the
    \l ListItem::clicked signal should typically be explicitly
    set.

    \qml
    import QtQuick 2.9
    import org.asteroid.controls 1.0

    Item {

        ListModel {
            id: powerModel
            ListElement { text: "off"; icon: "ios-power-outline" }
            ListElement { text: "reboot"; icon: "ios-sync" }
            ListElement { text: "fire"; icon: "ios-bonfire-outline" }
        }

        ListView {
            id: powerItems
            model: powerModel
            anchors {
                top: parent.top
                topMargin: parent.height * 0.20
            }
            height: parent.height
            width: parent.width
            delegate: ListItem {
                title: text
                iconName: icon
                highlight: powerItems.currentIndex == index ? 0.2 : 0
                onClicked: powerItems.currentIndex = index
            }
        }
    }
    \endqml
*/
Item {
    /*! alias to recieve string label.text */
    property alias title: label.text
    /*! alias to recieve string icon.name */
    property alias iconName: icon.name
    /*! alias to recieve boolean highlight.forceOn */
    property alias highlight: highlight.forceOn
    /*! size of the icon/s */
    property int iconSize: height - Dims.h(6)
    /*! size of the label text */
    property int labelFontSize: Dims.l(9)
    /*! forward the clicked() signal to parent */
    signal clicked()

    width: parent.width
    height: Dims.h(21)

    HighlightBar {
        id: highlight

        onClicked: parent.clicked()
    }

    Icon {
        id: icon

        width: iconSize
        height: width

        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: DeviceSpecs.hasRoundScreen ? Dims.w(18) : Dims.w(12)
        }
    }

    Label {
        id: label

        anchors {
            leftMargin: DeviceSpecs.hasRoundScreen ? Dims.w(6) : Dims.w(10)
            left: icon.right
            verticalCenter: parent.verticalCenter
        }
        font {
            pixelSize: labelFontSize
            styleName: "SemiCondensed Light"
        }
    }
}
