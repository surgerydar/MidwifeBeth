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
        anchors.topMargin: labelBackground.visible ? labelBackground.height / 2 : 0
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
        Rectangle {
            width: 32
            height: width
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            radius: width / 2
            color: Colours.darkOrange
            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                source: "../icons/add.png"
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    add();
                }
            }
        }
    }
    //
    //
    //
    Rectangle {
        id: labelBackground
        width: label.contentWidth + radius
        height: label.contentHeight + 4
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: background.radius
        radius: height / 2
        visible: label.text.length > 0
        color: Colours.almostBlack
        Label {
            id: label
            anchors.centerIn: parent
            color: Colours.almostWhite
            font.pointSize: 14
        }
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
}
