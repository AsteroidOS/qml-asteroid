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

Repeater {
    id: segmentedArc

    property real inputValue: 0
    property int segmentAmount: 12
    property int start: 0
    property int gap: 6
    property int endFromStart: 360
    property bool clockwise: true
    property real arcStrokeWidth: .011
    property real scalefactor: .374 - (arcStrokeWidth / 2)

    model: segmentAmount

    Shape {
        id: segment

        ShapePath {
            fillColor: "transparent"
            strokeColor: index / segmentedArc.segmentAmount < segmentedArc.inputValue / 100 ? "#26C485" : "black"
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
