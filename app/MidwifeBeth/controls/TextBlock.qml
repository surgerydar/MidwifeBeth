import QtQuick 2.6
import QtQuick.Controls 2.1

import "../colours.js" as Colours
import "../styles.js" as Styles

Item {
    id: container
    //
    //
    //
    height: Math.max(64,content.height + 16)
    //
    //
    //
    Background {
        anchors.fill: parent
        fill: Colours.almostWhite
        radius: [ 0 ]
    }
    //
    //
    //
    Text {
        id: content
        //
        //
        //
        height: contentHeight
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 8
        //
        //
        //
        wrapMode: Text.WordWrap
        textFormat: Text.RichText
        //
        //
        //
        color: Colours.almostBlack
        //
        //
        //
        font.weight: Font.Light
        //font.family: fonts.light
        font.pointSize: 18
        //
        //
        //
        onLinkActivated: {
            processLink(link);
        }
        onTextChanged: {
            content.text = Styles.style(text,"global");
        }
    }
    //
    //
    //
    signal mediaReady();
    signal mediaError( string error );
    //
    //
    //
    Component.onCompleted: {
        mediaReady();
    }
    //
    //
    //
    property alias media: content.text
    property string title: ""
    property int contentWidth: 0
    property int contentHeight: 0
}
