import QtQuick 2.13
import QtQuick.Controls 2.1

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
            text: ""
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
        model: blocks
        bottomMargin: 72
        delegate: MWB.Block {
            anchors.left: parent.left
            anchors.right: parent.right
            type: model.type
            media: model.content
            title: model.title || ""
            contentWidth: model.width || ( model.type === 'video' ) ? 1080 : 0
            contentHeight: model.height || ( model.type === 'video' ) ? 1920 : 0
        }
    }
    //
    //
    //
    StackView.onActivating: {
        console.log( 'Page : filter= ' + JSON.stringify(filter));
        blocks.setFilter(filter);
    }
    //
    //
    //
    property alias title: subtitle.text
    property var filter: ({})
}
