import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import Qt.labs.qmlmodels 1.0

ApplicationWindow {
    id: window
    width: 1100
    height: 650
    visible: true
    title: qsTr("PhishTrack")



    header: TabBar {
        id: tabBar


        TabButton {
            text: qsTr("<font color='white'>EXPORT</font>")
            checked: swipeView.currentIndex === 0 ? true : false
            background: Rectangle {
                      color: tabBar.currentIndex === 0 ? "#697A6D" :  "#323B34"
                  }
            onClicked: swipeView.setCurrentIndex(0)

        }
        TabButton {
            text: qsTr("<font color='white'>INSERT DATA</font>")
            checked: swipeView.currentIndex === 1 ? true : false
            background: Rectangle {
                color: tabBar.currentIndex === 1 ? "#697A6D" :  "#323B34"
            }
            onClicked: swipeView.setCurrentIndex(1)
        }
        TabButton {
            text: qsTr("<font color='white'>DATABASE</font>")
            checked: swipeView.currentIndex === 2 ? true : false
            background: Rectangle {
                color: tabBar.currentIndex === 2 ? "#697A6D" :  "#323B34"
            }
            onClicked: swipeView.setCurrentIndex(2)
        }

        background: Rectangle {
            color: "#323B34"
        }
    }
    SwipeView {
        id: swipeView
        anchors.fill: parent
        Home {}
        DropData {}
        Tables {}
        Component.onCompleted: contentItem.interactive = false
    }

}
