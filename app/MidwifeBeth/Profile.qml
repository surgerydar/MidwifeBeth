import QtQuick 2.0
import QtQuick.Controls 1.4

import "colours.js" as Colours
import "controls" as MWB

Item {
    id: container
    //
    //
    //
    Rectangle {
        id: subtitleContainer
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 64
        color: Colours.midGreen
        //
        //
        //
        Label {
            id: subtitle
            anchors.fill: parent
            anchors.margins: 4
            font.pixelSize: 48
            font.weight: Font.Bold
            fontSizeMode: Label.Fit
            horizontalAlignment: Label.AlignHCenter
            verticalAlignment: Label.AlignVCenter
            color: Colours.almostWhite
            text: "My Baby"
            visible: text.length > 0
        }
    }
    //
    //
    //
    ListView {
        id: content
        anchors.fill: parent
        anchors.topMargin: subtitle.visible ? subtitleContainer.height + 4 : 4
        spacing: 4
        clip: true
        model: babies
        bottomMargin: 72
        delegate: Rectangle {
            width: content.width
            height: 64
            color: Colours.midGreen
            Label {
                anchors.fill: parent
                anchors.margins: 4
                font.pixelSize: 64
                fontSizeMode: Label.Fit
                horizontalAlignment: Label.AlignLeft
                verticalAlignment: Label.AlignVCenter
                color: Colours.almostWhite
                text: model.name
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    //stack.push("qrc:///Pages.qml", {title: model.title},{section_id:model._id});
                }
            }
        }
        footer: Rectangle {
            width: content.width
            height: 72
            color: Colours.midGreen
            //
            //
            //
            Rectangle {
                id: addButton
                width: 64
                height: 64
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                radius: 32
                color: Colours.darkOrange
                opacity: .8
                visible: stack.depth === 1
                Image {
                    anchors.fill: parent
                    anchors.margins: 8
                    fillMode: Image.PreserveAspectFit
                    source:  'icons/add.png'
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                    }
                }
            }
        }
    }
}
