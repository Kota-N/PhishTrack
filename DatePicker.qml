import QtQuick 2.0
import QtQuick.Controls 1.4
import QtGraphicalEffects 1.0

Rectangle {
    id: datePicker
    width: parent.width /2
    height: parent.height
    color: "#748779"

    Rectangle {
        anchors {
            left: parent.left
            right: parent.right
        }
        height: 40
        color: "#323B34"

        Text {
            id: dateDisplay
            anchors.centerIn: parent
            color: "white"
            text: ""
        }
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
            database.setSelectedDate(dateDisplay.text)
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
