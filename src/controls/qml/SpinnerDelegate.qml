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

/*!
    \qmltype SpinnerDelegate
    \inqmlmodule org.asteroid.controls

    \brief Provides a delegate for use with CircularSpinner.

    The SpinnerDelegate is primarily intended to be used with a \l CircularSpinner
    but may also be used with a plain \l ListView or \l PathView.  It is responsible 
    for displaying each value in the list model.  This example shows how a user can 
    select from list of 20 integers.  Here, a \l MouseArea is added to allow the user 
    to select a value.

    \qml
    import QtQuick 2.9
    import org.asteroid.controls 1.0

    ListView {
        id: rating
        anchors.centerIn: parent
        model: 20
        delegate: SpinnerDelegate{
            MouseArea {
                anchors.fill: parent
                onClicked: rating.currentIndex = index
            }
        }
        highlight: Rectangle { color: "green" }
        highlightFollowsCurrentItem: true
        focus: true
    }
    \endqml

    This somewhat more complex example shows a month and a year \l CircularSpinner 
    each with a \l SpinnerDelegate that overrides the \l SpinnerDelegate::text attribute.

    \qml
    import QtQuick 2.12
    import org.asteroid.controls 1.0

    Item {
        id: combinationSelector
        anchors.fill: parent 
        Row {
            anchors.fill: parent
            CircularSpinner {
                id: month
                height: parent.height
                width: parent.width/2
                model: 12
                showSeparator: true
                delegate: SpinnerDelegate{ text: Qt.locale().monthName(index, Locale.ShortFormat) }
            }
            CircularSpinner {
                id: year
                height: parent.height
                width: parent.width/2
                model: 100
                showSeparator: false
                delegate: SpinnerDelegate { text: index+2000 }
            }
        }
    }
    \endqml
    
    The effect on a round watch is shown below.
    \image SpinnerExample.jpg "Spinner example screenshot"
*/
Label {
    property bool isCircularSpinner: PathView.view !== null
    property bool isCurr: isCircularSpinner ? PathView.isCurrentItem : ListView.isCurrentItem

    width: isCircularSpinner ? PathView.view.width : ListView.view.width
    height: Dims.h(10)

    function zeroPadding(x) {
        if (x<10) return "0"+x;
        else      return x;
    }

    /*!
        Defaults to a zero-padded two-digit value.
     */
    text: zeroPadding(index)
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter

    opacity: isCurr ? 1.0 : 0.6
    scale: isCurr ? 1.4 : 0.8
    Behavior on scale   { NumberAnimation { duration: 200 } }
    Behavior on opacity { NumberAnimation { duration: 200 } }
}
