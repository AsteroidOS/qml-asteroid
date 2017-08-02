/*
 * Qt Quick Controls Asteroid - User interface components for AsteroidOS
 *
 * Copyright (C) 2016 Florent Revest <revestflo@gmail.com>
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

Canvas {
    property color borderColor
    property color color
    onColorChanged: requestPaint()

    onPaint: {
        var ctx = getContext('2d');
        ctx.fillStyle = color;
        ctx.strokeStyle = borderColor
        ctx.lineWidth = 1
        var shift = height*0.28

        ctx.beginPath();
        ctx.moveTo(shift, 0);
        ctx.lineTo(width, 0);
        ctx.lineTo(width-shift, height);
        ctx.lineTo(0, height);
        ctx.lineTo(shift, 0);

        ctx.fill();
        ctx.stroke();
    }
}
