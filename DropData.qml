import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0

Page {
    background: Rectangle {
        color: "#ABC7B2"
    }

    Row {
        id: btnContainer
        anchors.horizontalCenter: parent.horizontalCenter
        topPadding: 20
        spacing: 10
        z: 5

        Rectangle {
            id: insertBtn
            width: 200
            height: 50
            color: "#323B34"
            Text {
                text: qsTr("Insert")
                anchors.centerIn: parent
                color: "white"
            }

            MouseArea {
                anchors.fill: parent
                onPressed: {
                    insertBtn.opacity = 0.7
                    insertBtn.scale = 0.98
                }
                onReleased: {
                    insertBtn.opacity = 1.0
                    insertBtn.scale = 1.0
                    database.cleanDroppedData(dataInput.text)
                    dataInput.text = ""
                }
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: 100
                }
            }
            Behavior on scale {
                NumberAnimation {
                    duration: 100
                }
            }
        }
    }

    Rectangle {
        id: inputContainer
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 50
        width: parent.width /1.1
        height: parent.height /1.3
        color: "#748779"

        TextArea {
            id: dataInput
            color: "#323B34"
            width: parent.width /2
            height: parent.height
            placeholderText: qsTr("Drop data here...")
            anchors.right: parent.right
            background: Rectangle {
                color: "#ABC7B2"
            }
        }

        DatePicker {}
    }

    DropShadow {
        anchors.fill: btnContainer
        horizontalOffset: 5
        verticalOffset: 5
        radius: 7
        samples: 10
        color: "#748779"
        source: btnContainer
    }

    DropShadow {
        anchors.fill: inputContainer
        horizontalOffset: 2
        verticalOffset: 2
        radius: 15
        samples: 50
        color: "#748779"
        source: inputContainer
    }
}
