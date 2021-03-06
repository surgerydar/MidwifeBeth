import QtQuick 2.13
import QtQuick.Controls 2.1
import QtQml.Models 2.1

import "../colours.js" as Colours
import "../controls" as MWB

Item {
    height: 128
    //
    //
    //
    Rectangle {
        id: background
        anchors.fill: parent
        anchors.topMargin: label.visible ? label.height / 2 : 0
        color: Colours.midGreen
    }
    //
    //
    //
    ListView {
        id: content
        anchors.fill: background
        orientation: ListView.Horizontal
        spacing: 4
        rightMargin: toolbar.width
    }
    //
    //
    //
    Item {
        id: toolbar
        width: 40
        anchors.top: background.top
        anchors.bottom: background.bottom
        anchors.right: background.right
        MWB.RoundButton {
            width: 32
            height: width
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            image: "/icons/PLUS ICON 96 BOX.png"
            onClicked: {
                add();
            }
        }
    }
    //
    //
    //
    MWB.TitleBox {
        id: label
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: radius / 2
    }
    //
    //
    //
    signal add();
    //
    //
    //
    property alias backgroundColour: background.color
    property alias labelText: label.text
    property alias model: content.model
    property alias delegate: content.delegate
    property alias section: content.section
    property alias listView: content
    property alias tools: toolbar.children
}
