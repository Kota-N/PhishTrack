import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0

Page {
    background: Rectangle {
        color: "#ABC7B2"
    }

    property variant currentTable: "users"

    // ------------------
    // Buttons
    // ------------------

    Row {
        id: btnContainer
        anchors.horizontalCenter: parent.horizontalCenter
        topPadding: 20
        spacing: 10
        z: 5

        // ------------------
        // userBtn
        // ------------------

        Rectangle {
            id: usersBtn
            width: 200
            height: 50
            color: "#323B34"
            Text {
                text: qsTr("users")
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

        // ------------------
        // campaignsBtn
        // ------------------

        Rectangle {
            id: campaignsBtn
            width: 200
            height: 50
            color: "#323B34"
            Text {
                text: qsTr("campaigns")
                anchors.centerIn: parent
                color: "white"
            }

            MouseArea {
                anchors.fill: parent
                onPressed: {
                    campaignsBtn.opacity = 0.7
                    campaignsBtn.scale = 0.98
                }
                onReleased: {
                    campaignsBtn.opacity = 1.0
                    campaignsBtn.scale = 1.0
                    currentTable = "campaigns"
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

        // ------------------
        // userCampaignBtn
        // ------------------

        Rectangle {
            id: userCampaignBtn
            width: 200
            height: 50
            color: "#323B34"
            Text {
                text: qsTr("user_campaign")
                anchors.centerIn: parent
                color: "white"
            }

            MouseArea {
                anchors.fill: parent
                onPressed: {
                    userCampaignBtn.opacity = 0.7
                    userCampaignBtn.scale = 0.98
                }
                onReleased: {
                    userCampaignBtn.opacity = 1.0
                    userCampaignBtn.scale = 1.0
                    currentTable = "user_campaign"
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
    }


    // ------------------
    // ListView
    // ------------------

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
            onCurrentIndexChanged: console.log(currentItem.currentModelData.id)

            header: currentTable === "users" ? usersHeader : currentTable === "campaigns" ? campaignsHeader : userCampaignHeader

            model: currentTable === "users" ? usersModel : currentTable === "campaigns" ? campaignsModel : userCampaignModel

            delegate: currentTable === "users" ? usersDelegate : currentTable === "campaigns" ? campaignsDelegate : userCampaignDelegate
        }

        // ----------------------
        // Headers
        // ----------------------

        Component {
            id: usersHeader

            Rectangle {
                width: ListView.view.width /1.5
                height: 25
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#536156"

                Row {
                    leftPadding: 20
                    spacing: 70
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        text: "id"
                        color: "white"
                    }
                    Text {
                        text: "medctr_id"
                        color: "white"
                    }
                }
            }
        }

        Component {
            id: campaignsHeader

            Rectangle {
                width: ListView.view.width /1.5
                height: 25
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#536156"

                Row {
                    leftPadding: 20
                    spacing: 70
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        text: "id"
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
            id: userCampaignHeader

            Rectangle {
                width: ListView.view.width /1.5
                height: 25
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#536156"

                Row {
                    leftPadding: 20
                    spacing: 70
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        text: "id"
                        color: "white"
                    }
                    Text {
                        text: "user_id"
                        color: "white"
                    }
                    Text {
                        text: "campaign_id"
                        color: "white"
                    }
                }
            }
        }

        // ----------------------
        // models
        // ----------------------

        ListModel {
            id: usersModel

            Component.onCompleted: {
                const usersIds = database.getUsersIds();
                const usersMedctrIds = database.getUsersMedctrIds();
                for (let i = 0; i < usersIds.length; i++) {
                    append({id: usersIds[i]["id"], medctr_id: usersMedctrIds[i]["medctr_id"]});
                }

            }
        }
        ListModel {
            id: campaignsModel

            Component.onCompleted: {
                const campaignsIds = database.getCampaignsIds();
                const campaignsDates = database.getCampaignsDates();
                for (let i = 0; i < campaignsIds.length; i++) {
                    append({id: campaignsIds[i]["id"], date: campaignsDates[i]["date"]});
                }
            }
        }
        ListModel {
            id: userCampaignModel

            Component.onCompleted: {
                const userCampaignIds = database.getUserCampaignIds();
                const userCampaignUserIds = database.getUserCampaignUserIds();
                const userCampaignCampaignIds = database.getUserCampaignCampaignIds();
                for (let i = 0; i < campaignsIds.length; i++) {
                    append({id: userCampaignIds[i]["id"], user_id: userCampaignUserIds[i]["user_id"], campaign_id: userCampaignCampaignIds[i]["campaign_id"]});
                }
            }
        }

        // ------------------------
        // Delegates
        // ------------------------

        Component {
            id: usersDelegate

            Rectangle {
                width: ListView.view.width /1.5
                anchors.horizontalCenter: parent.horizontalCenter
                height: 25
                color: listView.currentIndex === index ? "#323B34" : "#748779"

                property variant currentUsersModelData: model

                Row {
                    leftPadding: 20
                    spacing: 70
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        text: id
                        color: "white"
                    }
                    Text {
                        text: medctr_id
                        color: "white"
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: listView.currentIndex = index
                }

            }
        }

        Component {
            id: campaignsDelegate

            Rectangle {
                width: ListView.view.width /1.5
                anchors.horizontalCenter: parent.horizontalCenter
                height: 25
                color: listView.currentIndex === index ?"#323B34" : "#748779"

                property variant currentCampaignsModelData: model

                Row {
                    leftPadding: 20
                    spacing: 70
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        text: id
                        color: "white"
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

        Component {
            id: userCampaignDelegate

            Rectangle {
                width: ListView.view.width /1.5
                anchors.horizontalCenter: parent.horizontalCenter
                height: 25
                color: listView.currentIndex === index ?"#323B34" : "#748779"

                property variant currentCampaignsModelData: model

                Row {
                    leftPadding: 20
                    spacing: 70
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        text: id
                        color: "white"
                    }
                    Text {
                        text: user_id
                        color: "white"
                    }
                    Text {
                        text: campaign_id
                        color: "white"
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: listView.currentIndex = index
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

    DropShadow {
        anchors.fill: listViewContainer
        horizontalOffset: 2
        verticalOffset: 2
        radius: 15
        samples: 50
        color: "#748779"
        source: listViewContainer
    }

}
