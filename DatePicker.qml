import QtQuick 2.0
import QtQuick.Controls 1.4
import QtGraphicalEffects 1.0

Rectangle {
    width: parent.width /2
    height: parent.height
    color: "#748779"

    Text {
        id: dateDisplay
        anchors.horizontalCenter: parent.horizontalCenter
        color: "white"
        text: ""
    }


    Calendar {
        id: calendar
        minimumDate: new Date(2017, 0, 1)
        locale: Qt.locale("en_US")
        width: parent.width /1.4
        height: parent.height /1.4
        anchors.centerIn: parent
        onSelectedDateChanged: {
                              const day = selectedDate.getDate();
                              const month = selectedDate.getMonth() + 1;
                              const year = selectedDate.getFullYear();
                            dateDisplay.text = year + "-" + month + "-" + day
                          }
    }

    DropShadow {
        anchors.fill: calendar
        horizontalOffset: 0
        verticalOffset: 0
        radius: 30
        samples: 50
        color: "#323B34"
        source: calendar
    }
}
