import QtQuick 2.6
import QtQuick.Controls 2.1

import "../colours.js" as Colours
import "../styles.js" as Styles

Item {
    id: container
    //
    //
    //
    height: Math.max(64,contentContainer.height + 16)
    //
    //
    //
    Background {
        anchors.fill: parent
        fill: Colours.midGreen
        radius: [ 0 ]
    }
    //
    //
    //
    Item {
        id: contentContainer
        height: ( titleLabel.visible ? titleLabel.height + 8: 0 ) + content.height
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        Label {
            id: titleLabel
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 8
            font.pixelSize: 32
            fontSizeMode: Label.Fit
            horizontalAlignment: Label.AlignHCenter
            wrapMode: Label.WordWrap
            color: Colours.almostWhite
            visible: text.length > 0
        }
        //
        //
        //
        GridLayout {
            id: content
            anchors.top: titleLabel.visible ? titleLabel.bottom : parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 8
            spacing: 8
            model: ListModel {}
            onClicked: {
                processLink(item.url,item.title);
            }
        }
    }
    //
    //
    //
    signal mediaReady();
    signal mediaError( string error );
    signal updateContent();
    //
    //
    //
    Component.onCompleted: {
        mediaReady();
    }
    //
    //
    //
    onMediaChanged: {
        var links = JSON.parse(media);
        content.model.clear();
        if ( links ) {
            for ( var i = 0; i < links.length; i++ ) {
                content.model.append(links[i]);
            }
            mediaReady();
        } else {
            mediaError( 'Invalid links data : ' + media );
        }
    }
    //
    //
    //
    property var media: ""
    property alias title: titleLabel.text
    property int contentWidth: 0
    property int contentHeight: 0
}
