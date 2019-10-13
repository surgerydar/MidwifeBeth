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
            try {
                item.mediaReady.connect(mediaReady);
                item.updateContent.connect(function(){ container.media = item.media; container.updateContent(); });
                item.media = container.media;
                item.title = container.title;
                item.contentWidth = container.contentWidth;
                item.contentHeight = container.contentHeight;
            } catch( error ) {
                console.log( 'Block : error initialising block : ' + error + ' : block=' + item + ' type=' + container.type + ' title=' + container.title + ' media=' + JSON.stringify(container.media) );
            }
        }
    }
    //
    //
    //
    Component.onCompleted: {
        blockLoader.source = blockSource();
    }
    //
    //
    //
    onTypeChanged: {
        blockLoader.source = blockSource();
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
    function blockSource() {
        return ( type.charAt(0).toUpperCase() + type.slice(1) ) + 'Block.qml';
    }

    function calculateHeight() {
        if ( contentHeight && contentWidth ) {
            return width * ( contentHeight / contentWidth ) + 16;
        }
        return blockLoader.item ? Math.max(64,blockLoader.item.height) : 64
    }
    function editContent() {
        if ( blockLoader.status === Loader.Ready && blockLoader.item.editContent ) {
            blockLoader.item.editContent();
            return true;
        }
        return false;
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
    property string type: "text" // "text" | "image" | "video" | "links"
    property var media: null
    property string title: ""
    property alias content: blockLoader.item
    property int contentWidth: 0
    property int contentHeight: 0
}
