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
        fill: Colours.midGreen
        radius: [ 0 ]
    }
    //
    //
    //
    GridLayout {
        id: content
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 8
        model: ListModel {}
        onClicked: {
            processLink(item.url);
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
    property string media: ""
}
