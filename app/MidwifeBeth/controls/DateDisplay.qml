import QtQuick 2.13
import QtQuick.Controls 1.4
import QtQuick.Controls 2.1
import SodaControls 1.0

import "../colours.js" as Colours

Item {
    id: container
    Rectangle {
        anchors.fill: parent
        color: Colours.almostWhite
    }
    Label {
        id: day
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.verticalCenter
        anchors.right: parent.horizontalCenter
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        color: Colours.almostBlack
        opacity: selected === DateDisplay.Field.Date ? 1. : .5
        horizontalAlignment: Label.AlignRight
        verticalAlignment: Label.AlignBottom
        fontSizeMode: Label.Fit
        font.pixelSize: container.height / 2.
        text: Qt.formatDate(dateModel.date,'MMM dd');
        MouseArea {
            anchors.fill: parent
            onClicked: {
                selected = DateDisplay.Field.Date
            }
        }
    }
    Label {
        id: year
        anchors.top: parent.verticalCenter
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.right: parent.horizontalCenter
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        color: Colours.almostBlack
        opacity: selected === DateDisplay.Field.Date ? 1. : .5
        horizontalAlignment: Label.AlignRight
        verticalAlignment: Label.AlignTop
        font.pixelSize: container.height / 2.
        fontSizeMode: Label.Fit
        text: Qt.formatDate(dateModel.date,'yyyy');
        MouseArea {
            anchors.fill: parent
            onClicked: {
                selected = DateDisplay.Field.Date
            }
        }
    }
    Label {
        id: time
        anchors.top: parent.top
        anchors.left: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        color: Colours.almostBlack
        opacity: selected === DateDisplay.Field.Time ? 1. : .5
        font.pixelSize: container.height / 2.
        fontSizeMode: Label.Fit
        verticalAlignment: Label.AlignVCenter
        horizontalAlignment: Label.AlignLeft
        text: Qt.formatTime(dateModel.date,'hh:mm ap');
        MouseArea {
            anchors.fill: parent
            onClicked: {
                selected = DateDisplay.Field.Time
            }
        }
    }
    //
    //
    //
    enum Field {
        Date,
        Time
    }
    property int selected: DateDisplay.Field.Date
    property DateModel dateModel: DateModel {}
}
