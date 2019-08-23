import QtQuick 2.6
import QtQuick.Controls 2.1

import "../colours.js" as Colours

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
    Image {
        id: content
        //
        //
        //
        height: Math.min(width * ( sourceSize.height / sourceSize.width ), sourceSize.height)
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 8
        //
        //
        //
        fillMode: Image.PreserveAspectFit
        //
        //
        //
        onStatusChanged: {
            if ( status === Image.Error ) {

                /*
                var currentSource = JSON.stringify(source);
                if ( currentSource.indexOf(SystemUtils.documentDirectory()) < 0 ) {
                    var mediaPath = 'file://' + SystemUtils.documentDirectory() + '/media' + currentSource.substring(currentSource.lastIndexOf('/'));
                    console.log( 'redirecting image block from ' + currentSource + ' to : ' + mediaPath );
                    source = mediaPath;
                } else {
                    console.log('ImageBlock : error loading image : ' + source );
                    mediaError( 'unable to load : ' + source );
                }
                */

            } else if ( status === Image.Ready ){
                /*
                //container.height = Math.max(64,content.paintedHeight + 16);
                console.log( 'ImageBlock sourceSize: [' + sourceSize.width + ',' + sourceSize.height + ']');
                console.log( 'ImageBlock size: [' + width + ',' + height + ']');
                console.log( 'ImageBlock container.size: [' + container.width + ',' + container.height + ']');
                height = Math.min(width * ( sourceSize.height / sourceSize.width ),sourceSize.height);
                container.height = Math.max(64, Math.min(width * ( sourceSize.height / sourceSize.width ),sourceSize.height) + 16);
                console.log( 'resizing ImageBlock to ' + container.height );
                */
                //console.log('ImageBlock : loaded image : ' + source );
                updateContentDimensions();
                mediaReady();
            }
        }
        //
        //
        //
    }
    //
    //
    //
    onMediaChanged: {
        content.source = "image://cached/" + 'https://app.midwifebeth.com:8080' + media;
        console.log( 'ImageBlock : loading media : ' + content.source );
    }
    //
    //
    //
    function updateContentDimensions() {
        if ( contentWidth && contentHeight ) {
            content.height = content.width * ( contentHeight / contentWidth );
        } else {
            content.height = Math.min(width * ( content.sourceSize.height / content.sourceSize.width ), content.sourceSize.height)
        }
    }

    onContentWidthChanged: {
        updateContentDimensions();
    }
    onContentHeightChanged: {
        updateContentDimensions();
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
    property bool redirected: false
    property var media: ""
    property string title: ""
    property int contentWidth: 0
    property int contentHeight: 0
}
