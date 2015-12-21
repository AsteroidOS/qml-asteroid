/*
 * Qt Quick Controls Asteroid - User interface components for AsteroidOS
 *
 * Copyright (C) 2015 - Florent Revest <revestflo@gmail.com>
 *               2012 - Vasiliy Sorokin <sorokin.vasiliy@gmail.com>
 *                      Aleksey Mikhailichenko <a.v.mich@gmail.com>
 *                      Arto Jalkanen <ajalkane@gmail.com>
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

import QtQuick 2.1
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.0
import QtQuick.Controls.Nemo 1.0
import org.nemomobile.systemsettings 1.0

Rectangle {
    id: timePicker

    property int hours: 00
    property int minutes: 00

    property int minuteGradDelta: 6
    property int hourGradDelta: 30

    signal startInteraction
    signal stopInteraction

    onHoursChanged: {
        if (hours == 24)
            hours = 0
    }

    onMinutesChanged: {
        if (minutes == 60)
            minutes = 0
    }

    // White circle
    Rectangle {
        anchors.fill: parent
        border.color: "#BBB"
        border.width: 0.5
        color: "#FFF"
        radius: width*0.5
    }

    // 00, 15, 30 and 45 text indicators
    Text {
        property int minuteRadius: parent.width * 0.055
        property int minuteTrackRadius: parent.width * 0.38

        x: parent.centerX - minuteRadius
        y: parent.centerY - minuteRadius - minuteTrackRadius

        font.pixelSize: timePicker.width * 0.1
        color: "#BBB"
        text: "00"
    }

    Text {
        property int minuteRadius: parent.width * 0.055
        property int minuteTrackRadius: parent.width * 0.38

        x: parent.centerX - minuteRadius + minuteTrackRadius
        y: parent.centerY - minuteRadius

        font.pixelSize: timePicker.width * 0.1
        color: "#BBB"
        text: "15"
    }

    Text {
        property int minuteRadius: parent.width * 0.055
        property int minuteTrackRadius: parent.width * 0.38

        x: parent.centerX - minuteRadius
        y: parent.centerY - minuteRadius + minuteTrackRadius

        font.pixelSize: timePicker.width * 0.1
        color: "#BBB"
        text: "30"
    }

    Text {
        property int minuteRadius: parent.width * 0.055
        property int minuteTrackRadius: parent.width * 0.38

        x: parent.centerX - minuteRadius - minuteTrackRadius
        y: parent.centerY - minuteRadius

        font.pixelSize: timePicker.width * 0.1
        color: "#BBB"
        text: "45"
    }

    // Selected hour line
    Canvas {
        anchors.fill: parent
        rotation: timePicker.hours * 30
        smooth: true
        onPaint: {
            var ctx = getContext("2d")
            ctx.lineWidth = 1
            ctx.strokeStyle = "#A6CAEB"
            ctx.beginPath()
            ctx.moveTo(timePicker.width/2, timePicker.height/2)
            ctx.lineTo(width/2,height*0.3)
            ctx.closePath()
            ctx.stroke()
        }
    }

    // Selected minute line
    Canvas {
        anchors.fill: parent
        rotation: timePicker.minutes * 6
        smooth: true
        onPaint: {
            var ctx = getContext("2d")
            ctx.lineWidth = 1
            ctx.strokeStyle = "#A6CAEB"
            ctx.beginPath()
            ctx.moveTo(timePicker.width/2, timePicker.height/2)
            ctx.lineTo(width/2,height*0.1)
            ctx.closePath()
            ctx.stroke()
        }
    }

    // Center dot
    Rectangle {
        width: timePicker.width*0.02
        height: width
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        color: "#008ED9"
        radius: width*0.5
    }

    // Selected hour
    Item {
        property int hourRadius: parent.width * 0.055
        property int hourTrackRadius: parent.width * 0.16

        x: (parent.centerX - hourRadius) + hourTrackRadius
           * Math.cos(timePicker.hours * timePicker.hourGradDelta * (Math.PI / 180) - (Math.PI / 2));
        y: (parent.centerY - hourRadius) + hourTrackRadius
           * Math.sin(timePicker.hours * timePicker.hourGradDelta * (Math.PI / 180) - (Math.PI / 2));
        width: parent.width*0.17
        height: width

        // Selected minute circle background
        Rectangle {
            width: parent.width
            height: width
            x: -width*0.14
            y: -height*0.14
            color: "#B6E5F5"
            radius: width*0.5
        }

        // Selected minute number
        Text {
            id: hourText
            anchors.fill: parent
            font.pixelSize: timePicker.width * 0.1
            color: "#444"
            text: (timePicker.hours < 10 ? "0" : "") + timePicker.hours
        }
    }

    // Selected minute
    Item {
        property int minuteRadius: parent.width * 0.055
        property int minuteTrackRadius: parent.width * 0.38

        x: parent.centerX - minuteRadius + minuteTrackRadius
            * Math.cos(timePicker.minutes * timePicker.minuteGradDelta * (Math.PI / 180) - (Math.PI / 2));
        y: parent.centerY - minuteRadius + minuteTrackRadius
            * Math.sin(timePicker.minutes * timePicker.minuteGradDelta * (Math.PI / 180) - (Math.PI / 2));
        width: parent.width*0.17
        height: width

        // Selected minute circle background
        Rectangle {
            width: parent.width
            height: width
            x: -width*0.14
            y: -height*0.14
            color: "#B6E5F5"
            radius: width*0.5
        }

        // Selected minute number
        Text {
            id: minuteText
            anchors.fill: parent
            font.pixelSize: timePicker.width * 0.1
            color: "#444"
            text: (timePicker.minutes < 10 ? "0" : "") + timePicker.minutes
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent

        property int currentHandler : -1 // 0 - hours, 1 - minutes
        property real previousAlpha: -1

        onPressed: {
            startInteraction()
            currentHandler = chooseHandler(mouseX, mouseY)
            previousAlpha = findAlpha(mouseX, mouseY)
        }

        onReleased: {
            stopInteraction()
            currentHandler = -1
            previousAlpha = -1
        }

        onPositionChanged: {
            var newAlpha = 0;
            if (currentHandler < 0)
                return

            newAlpha = findAlpha(mouseX, mouseY)

            if (currentHandler > 0) {
                var newMins = getNewTime(timePicker.minutes, newAlpha, timePicker.minuteGradDelta, 1)
                if (newMins !== timePicker.minutes) {
                    timePicker.minutes = newMins
                }
            } else {
                var newHours = getNewTime(timePicker.hours, newAlpha, timePicker.hourGradDelta, 2)
                if (newHours !== timePicker.hours) {
                    timePicker.hours = newHours
                }
            }
        }

        function sign(number) {
            return  number >= 0 ? 1 : -1;
        }

        function getNewTime(source, alpha, resolution, boundFactor) {
            var delta = alpha - previousAlpha

            if (Math.abs(delta) < resolution)
                return source

            if (Math.abs(delta) > 180) {
                delta = delta - sign(delta) * 360
            }

            var result = source * resolution

            var resdel = Math.round(result + delta)
            if (Math.round(result + delta) > 359 * boundFactor)
                result += delta - 360 * (source * resolution > 359 ? boundFactor : 1)
            else if (Math.round(result + delta) < 0 * boundFactor)
                result += delta + 360 * (source * resolution > 359 ? boundFactor : boundFactor)
            else
                result += delta

            previousAlpha = alpha
            return result / resolution
        }

        function findAlpha(x, y) {

            var alpha = (Math.atan((y - bg.centerY)/(x - bg.centerX)) * 180) / 3.14 + 90
            if (x < bg.centerX)
                alpha += 180

            return alpha
        }

        function chooseHandler(mouseX, mouseY) {
            var radius = Math.sqrt(Math.pow(bg.centerX - mouseX, 2) + Math.pow(bg.centerY - mouseY, 2));
            if (radius <= bg.width * 0.25)
                return 0
            else if(radius < bg.width * 0.5)
                return 1
            return -1
        }
    }
}
