import QtQuick 2.0
import QtQuick.Controls 1.4
//import QtQuick.Layouts 1.12

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
    Flickable {
        anchors.fill: parent
        anchors.topMargin: subtitleContainer.height + 4
        contentHeight: content.height
        clip: true
        bottomMargin: 72
        MWB.GridLayout {
            id: content
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            model: sections
            onClicked: {
                stack.push("qrc:///Pages.qml", {title:item.title,filter:{section_id:item._id}});
            }
        }
    }
}
