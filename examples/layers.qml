import QtQuick 2.4
import QtQuick.Controls 1.0
import QtGraphicalEffects 1.0
import org.asteroid.controls 1.0


Application {
    id: app
    title: "My App"

    LayerStack {
        id: watchLayerStack

        Layer {
            id: myWatchLayer
            Rectangle {
                anchors.fill: parent
                color: "green"

                Button {
                    anchors.centerIn: parent
                    text: "Sub"
                    onClicked: {
                        mySubWL.show();
                    }
                }

            }
        }

        Layer {
            z:5
            id: mySubWL
            Rectangle {
                anchors.fill: parent
            }
        }
    }

    Button {
        anchors.bottom: parent.bottom
        text: "Action"
        onClicked: {
            myWatchLayer.show();
        }
    }
}
