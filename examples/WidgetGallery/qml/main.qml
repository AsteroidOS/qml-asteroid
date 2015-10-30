import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import org.asteroid.controls 1.0

ApplicationWindow {
    visible: true

    height: 576
    width: 1024

    Flow {
        anchors.fill: parent
        spacing: 20

        ProgressCircle {
            width: 320
            height: 320

            value: 0.5

            Timer {
                interval: 250
                running: true
                repeat: true

                onTriggered: {
                    if (parent.value >= 1)
                        parent.value = 0
                    else
                        parent.value += 0.01
                }
            }
        }

        Item {
            height: 320
            width: 320

            ListView {
                id: listView

                anchors.centerIn: parent

                width: 280
                height: 280
                clip: true

                model: 100
                delegate: Label {
                    width: ListView.view.width
                    text: index
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            CircularScrollIndicator {
                id: listScrollBar

                anchors.centerIn: listView

                flickable: listView

                width: 320
                height: 320
            }
        }
    }
}
