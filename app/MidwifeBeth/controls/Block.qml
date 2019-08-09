import QtQuick 2.6
import QtQuick.Controls 2.1

import "../colours.js" as Colours

Item {
    id: container
    //
    //
    //
    height: calculateHeight()
    implicitHeight: calculateHeight()
    //
    //
    //
    Component {
        id: text
        TextBlock {
            anchors.left: parent.left
            anchors.right: parent.right
        }
    }
    Component {
        id: image
        ImageBlock {
            anchors.left: parent.left
            anchors.right: parent.right
        }
    }
    Component {
        id: video
        VideoBlock {
            anchors.left: parent.left
            anchors.right: parent.right
        }
    }
    Component {
        id: links
        LinksBlock {
            anchors.left: parent.left
            anchors.right: parent.right
        }
    }
    Loader {
        id: blockLoader
        //anchors.fill: parent
        anchors.left: parent.left
        anchors.right: parent.right
        onLoaded: {
            item.mediaReady.connect(mediaReady);
            item.media = container.media;
            item.title = container.title;
            item.contentWidth = container.contentWidth;
            item.contentHeight = container.contentHeight;
        }
    }
    //
    //
    //
    Component.onCompleted: {
        blockLoader.sourceComponent = type === "video" ? video : type === "image" ? image : type === "links" ? links : text;
    }
    //
    //
    //
    onTypeChanged: {
        blockLoader.sourceComponent = type === "video" ? video : type === "image" ? image : type === "links" ? links : text;
    }
    onMediaChanged: {
        if ( blockLoader.status === Loader.Ready ) {
            blockLoader.item.media = media;
        }
    }
    onContentWidthChanged: {
        if ( blockLoader.status === Loader.Ready ) {
            blockLoader.item.contentWidth = contentWidth;
        }
    }
    onContentHeightChanged: {
        if ( blockLoader.status === Loader.Ready ) {
            blockLoader.item.contentHeight = contentHeight;
        }
    }
    //
    //
    //
    function calculateHeight() {
        //console.log( 'Block : calculating height using width/height=' + ( contentHeight && contentWidth ) );
        if ( contentHeight && contentWidth ) {
            return width * ( contentHeight / contentWidth ) + 16;
        }
        return blockLoader.item ? Math.max(64,blockLoader.item.height) : 64
    }
    //
    //
    //
    signal mediaReady();
    signal mediaError( string error );
    //
    //
    //
    property string type: "text" // "text" | "image" | "video" | "links"
    property string media: ""
    property string title: ""
    property alias content: blockLoader.item
    property int contentWidth: 0
    property int contentHeight: 0
}
