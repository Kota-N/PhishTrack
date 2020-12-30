import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.2
import QtGraphicalEffects 1.0


Page {
    background: Rectangle {
        color: "#ABC7B2"
    }

    function createModel(parent) {
        var newModel = modelComponent.createObject(parent);
        return newModel;
    }

    FileDialog {
        id: exportPath
        title: "Please choose a folder"
        folder: shortcuts.home
        selectFolder: true
        onAccepted: {
            let path = exportPath.fileUrl.toString();
            // remove prefixed "file:///"
            path = path.replace(/^(file:\/{3})/,"");
            // unescape html codes like '%23' for '#'
            let cleanPath = decodeURIComponent(path);
            console.log(cleanPath);
            database.exportCSV(qsTr(cleanPath));
        }
        onRejected: {
        }
        Component.onCompleted: visible = false
    }


    Row {
        id: btnContainer
        anchors.horizontalCenter: parent.horizontalCenter
        topPadding: 20
        spacing: 10
        z: 5

        Rectangle {
            id: refreshBtn
            width: 200
            height: 50
            color: "#323B34"
            Text {
                text: qsTr("Refresh")
                anchors.centerIn: parent
                color: "white"
            }

            MouseArea {
                anchors.fill: parent
                onPressed: {
                    refreshBtn.opacity = 0.7
                    refreshBtn.scale = 0.98
                }
                onReleased: {
                    refreshBtn.opacity = 1.0
                    refreshBtn.scale = 1.0
                    listView.model = createModel(ListView)
                    listView.delegate = delegate
                    listView.currentIndex = -1
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

        Rectangle {
            id: exportBtn
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
                    exportBtn.opacity = 0.7
                    exportBtn.scale = 0.98
                }
                onReleased: {
                    exportBtn.opacity = 1.0
                    exportBtn.scale = 1.0
                    exportPath.visible = true
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
        id: listViewContainer
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 50
        width: parent.width /1.1
        height: parent.height /1.3
        color: "#748779"

        ListView {
            id: listView
            anchors.fill: parent
            focus: true
            clip: true
            spacing: 1
            currentIndex: -1

            header: header


        }

    }

    Component {
        id: header

        Rectangle {
            width: ListView.view.width /1.5
            height: 25
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#536156"

            Row {
                leftPadding: 20
                spacing: 90
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    text: "medctr_id"
                    color: "white"
                }
                Text {
                    text: "count"
                    color: "white"
                }
                Text {
                    text: "date"
                    color: "white"
                }
            }
        }
    }

    Component {
        id: modelComponent

        ListModel {
            id: model

            Component.onCompleted: {
                const medctrIdColumn = database.getDataForMainPage()[0];
                const countColumn = database.getDataForMainPage()[1];
                const dateColumn = database.getDataForMainPage()[2];
                for (let i = 0; i < medctrIdColumn.length; i++) {
                    append({medctr_id: medctrIdColumn[i]["medctr_id"], count: countColumn[i]["count"], date: dateColumn[i]["date"]});
                }
            }
        }
    }

    Component {
        id: delegate

        Rectangle {
            width: ListView.view.width /1.5
            anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
            height: 25
            color: listView.currentIndex === index ? "#323B34" : "#748779"

            property variant currentCampaignsModelData: model

            Row {
                leftPadding: 20
                spacing: 0
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    text: medctr_id
                    color: "white"
                    width: 160
                }
                Text {
                    text: count
                    color: "white"
                    width: 80
                }
                Text {
                    text: date
                    color: "white"
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: listView.currentIndex = index
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
