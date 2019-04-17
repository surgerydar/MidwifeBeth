import QtQuick 2.0
import QtQuick.Controls 1.4

import "colours.js" as Colours
import "controls" as MWB

Item {
    id: container
    //anchors.fill: parent
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
            anchors.fill: parent
            anchors.margins: 4
            font.pixelSize: 64
            font.weight: Font.Bold
            fontSizeMode: Label.Fit
            horizontalAlignment: Label.AlignHCenter
            verticalAlignment: Label.AlignVCenter
            color: Colours.almostWhite
            text: "Sections"
        }
    }
    //
    //
    //
    ListView {
        id: content
        anchors.fill: parent
        anchors.topMargin: subtitleContainer.height + 4
        spacing: 4
        clip: true
        model: sections
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
                text: model.title
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    pages.setFilter( {section_id:model._id} );
                    stack.push("qrc:///Pages.qml", {title: model.title});
                }
            }
        }
    }
}
