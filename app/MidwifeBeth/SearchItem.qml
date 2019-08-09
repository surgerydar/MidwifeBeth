import QtQuick 2.6
import QtQuick.Controls 2.1

import "controls" as MWB
import "colours.js" as Colours

Item {
    id: container
    //
    //
    //
    height: 64
    //
    //
    //
    Rectangle {
        id: background
        anchors.fill: parent
        color: Colours.midGreen
    }
    //
    //
    //
    Label {
        id: titleText
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 8
        //
        //
        //
        elide: Text.ElideRight
        font.pixelSize: Math.round(( container.height - 8 ) * .4)
        fontSizeMode: Label.Fit
        color: Colours.almostWhite
        //
        //
        //
        horizontalAlignment: Text.AlignLeft
    }
    Label {
        id: summaryText
        anchors.top: titleText.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 8
        //
        //
        //
        //font.weight: Font.Light
        //font.family: fonts.light
        font.pixelSize: Math.round(titleText.font.pixelSize * .5)
        fontSizeMode: Label.Fit
        wrapMode: Text.WordWrap
        elide: Text.ElideRight
        color: Colours.almostWhite
        //
        //
        //
        horizontalAlignment: Text.AlignLeft
    }
    //
    //
    //
    MouseArea {
        anchors.fill: parent
        onClicked: {
            parent.clicked();
        }
    }
    //
    //
    //
    signal clicked();
    //
    //
    //
    property alias title: titleText.text
    property alias summary: summaryText.text
}
