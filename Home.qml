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
            id: usersBtn
            width: 200
            height: 50
            color: "#323B34"
            Text {
                text: qsTr("Export CSV")
                anchors.centerIn: parent
                color: "white"
            }

            MouseArea {
                anchors.fill: parent
                onPressed: {
                    usersBtn.opacity = 0.7
                    usersBtn.scale = 0.98
                }
                onReleased: {
                    usersBtn.opacity = 1.0
                    usersBtn.scale = 1.0
                    currentTable = "users"
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

    DropShadow {
        anchors.fill: btnContainer
        horizontalOffset: 5
        verticalOffset: 5
        radius: 7
        samples: 10
        color: "#748779"
        source: btnContainer
    }
}
