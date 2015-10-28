import QtQuick 2.4

/*!
    \qmltype ProgressCircle
    \inqmlmodule org.asteroid.controls
    \inherits Canvas
    \brief Progress indicator shapped as a circle.

    You can customize the color, background and the line width.

    Example:
    \qml
    ProgressCircle {
        anchors.centerIn: parent

        height: 500
        width: 500

        color: "#3498db"
        backgroundColor: "#e5e6e8"
    }
    \endqml
*/

Canvas {
    id: root

    /*! This defines the color for the percentage of the circle. */
    property color color: "#3aadd9"

    /*! This defines the color for the background of the circle. */
    property color backgroundColor: "#e5e6e8"

    /*! This defines the percentage from 0 to 1. */
    property double value: 0

    /*! This defineds the background line width. */
    property real backgroundLineWidth: _radius / 14

    /*! This defines the progress line width. */
    property real progressLineWidth: _radius / 13

    /*! \internal */
    property point _center: Qt.point(width / 2, height / 2)

    /*! \internal */
    property real _radius: Math.min(width / 2, height / 2.15)

    antialiasing: true

    height: 200
    width: 200

    onValueChanged: requestPaint()
    onColorChanged: requestPaint()
    onBackgroundColorChanged: requestPaint()

    onPaint: {
        var start_angle = 0
        var end_angle = Math.PI * 2
        var ctx = getContext('2d')

        ctx.reset()
        ctx.clearRect(0, 0, width, height)

        ctx.strokeStyle = backgroundColor
        ctx.lineWidth = backgroundLineWidth

        ctx.beginPath()
        ctx.arc(_center.x, _center.y, _radius, start_angle, end_angle)
        ctx.stroke()

        start_angle = 0
        end_angle = Math.PI * value * 2

        ctx.strokeStyle = color
        ctx.lineWidth = progressLineWidth

        ctx.beginPath()
        ctx.arc(_center.x, _center.y, _radius, start_angle, end_angle)
        ctx.stroke()
    }

    Behavior on value { NumberAnimation { } }
}
