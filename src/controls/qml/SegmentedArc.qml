/*
 * Copyright (C) 2022 - Timo Könnecke <github.com/eLtMosen>
 *               2022 - Darrel Griët <dgriet@gmail.com>
 *               2022 - Ed Beroset <github.com/beroset>
 *               2016 - Sylvia van Os <iamsylvie@openmailbox.org>
 *               2015 - Florent Revest <revestflo@gmail.com>
 *               2012 - Vasiliy Sorokin <sorokin.vasiliy@gmail.com>
 *                      Aleksey Mikhailichenko <a.v.mich@gmail.com>
 *                      Arto Jalkanen <ajalkane@gmail.com>
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

import QtQuick 2.15
import QtQuick.Shapes 1.1

/*!
    \qmltype SegmentedArc
    \inqmlmodule AsteroidControls

    \brief A segmented arc that uses color to represent a value.

    This control allows the user to create an arc that is segmented
    int \l segmentAmount pieces from a start angle of \l start degrees
    through a swing of \l endFromStart degrees from there.  An
    \l inputValue (as a number from 0 to 100) is represented by some
    number of those segments set to color \l fgColor while the others
    are set to the color \l bgColor.

    This example shows a "speedometer" style gauge that goes from
    the lower left (-135 degrees) to the lower right (+135 degrees)
    which is a full range of 270 degrees.  The initial value is 25%
    but can be changed via the \l IntSelector control.

    \qml
    import QtQuick 2.15
    import org.asteroid.controls 1.0

    Item {
        IntSelector {
            id: number
            value: 25
            stepSize: 5
        }
        SegmentedArc {
            anchors.fill: parent
            segmentAmount: 10
            inputValue: number.value
            start: -135
            endFromStart: 270
            fgColor: "orange"
            bgColor: "darkblue"
        }
    }
    \endqml
*/
Repeater {
    id: segmentedArc

    /*! initial value of the control. Default is 0 */
    property real inputValue: 0
    /*! Number of segments to use */
    property int segmentAmount: 12
    /*! Starting angle in degrees for segmented arc.  Default is 0 which is top */
    property int start: 0
    /*! Gap angle in degrees for segmented arc.  Default is 6 */
    property int gap: 6
    /*! Angle span in degrees of the complete segmented arc.  Default is 360 */
    property int endFromStart: 360
    /*! Draw clockwise.  Default is true */
    property bool clockwise: true
    /*! Arc stroke width.  Default is 0.011 */
    property real arcStrokeWidth: .011
    /*! Draw clockwise.  Default is 0.3685 */
    property real scalefactor: .374 - (arcStrokeWidth / 2)
    /*! Color of segments that are on.  Default is #26C485 (green) */
    property color fgColor: "#26C485"
    /*! Color of segments that are off.  Default is black */
    property color bgColor: "black"

    model: segmentAmount

    Shape {
        id: segment

        ShapePath {
            fillColor: "transparent"
            strokeColor: index / segmentedArc.segmentAmount < segmentedArc.inputValue / 100 ? fgColor : bgColor
            strokeWidth: parent.height * segmentedArc.arcStrokeWidth
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.MiterJoin
            startX: parent.width / 2
            startY: parent.height * ( .5 - segmentedArc.scalefactor)

            PathAngleArc {
                centerX: parent.width / 2
                centerY: parent.height / 2
                radiusX: segmentedArc.scalefactor * parent.width
                radiusY: segmentedArc.scalefactor * parent.height
                startAngle: -90 + index * (sweepAngle + (segmentedArc.clockwise ? +segmentedArc.gap : -segmentedArc.gap)) + segmentedArc.start
                sweepAngle: segmentedArc.clockwise ? (segmentedArc.endFromStart / segmentedArc.segmentAmount) - segmentedArc.gap :
                                                        -(segmentedArc.endFromStart / segmentedArc.segmentAmount) + segmentedArc.gap
                moveToStart: true
            }
        }
    }
}
