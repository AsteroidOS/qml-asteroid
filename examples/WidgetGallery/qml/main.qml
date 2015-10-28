import QtQuick 2.5
import QtQuick.Controls 1.4
import org.asteroid.controls 1.0

ApplicationWindow {
    visible: true

    height: 576
    width: 1024

    ProgressCircle {
        anchors.centerIn: parent
        value: 0.5
    }
}
