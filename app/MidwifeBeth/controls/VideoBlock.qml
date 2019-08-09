import QtQuick 2.6
import QtQuick.Controls 2.1
//import QtMultimedia 5.12
import QtMultimedia 5.13
import SodaControls 1.0

import "../colours.js" as Colours

Item {
    id: container
    //
    //
    //
    height: Math.max( 64, output.contentRect.height + 16 )
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
    CachedMediaSource {
        id: mediaSource
        player: content
    }
    //
    //
    //
    MediaPlayer {
        id: content
        autoLoad: true
        //
        //
        //
        onStatusChanged: {
            console.log('MediaPlayer status:' + status);
            switch( status ) {
            case MediaPlayer.NoMedia :
                console.log( "no media has been set" );
                break;
            case MediaPlayer.Loading :
                console.log( "the media is currently being loaded");
                break;
            case MediaPlayer.Loaded :
                console.log( "the media has been loaded");
                //seek(0);
                //
                // play then immediately pause to display first frame, there must be a better way of achieving this
                mediaSource.play();
                mediaSource.pause();
                updateContentDimensions();
                mediaReady();
                break;
            case MediaPlayer.Buffering :
                console.log( "the media is buffering data");
                break;
            case MediaPlayer.Stalled :
                console.log( "playback has been interrupted while the media is buffering data");
                break;
            case MediaPlayer.Buffered :
                console.log( "the media has buffered data");
                break;
            case MediaPlayer.EndOfMedia :
                console.log( "the media has played to the end");
                seek(0);
                mediaReady();
                break;
            case MediaPlayer.InvalidMedia :
                console.log( "the media cannot be played");
                break;
            case MediaPlayer.UnknownStatus :
                console.log( "the status of the media is unknown");
                break;
            }
        }
        //
        //
        //

        onPlaybackStateChanged: {
            //updateContentDimensions();
            //console.log( 'media playback state changed to ' + playbackState );
            if ( playbackState === MediaPlayer.PlayingState ) {
                playButton.visible = false;
            } else {
                playButton.visible = true;
            }
        }

        onError: {
            console.log( 'error playing media : ' + error + ' : ' + errorString );
            console.log( source );
            mediaError(error);
        }
    }
    //
    //
    //
    VideoOutput {
        id: output
        //
        //
        //
        //height: width * ( 9. / 16. )//Math.min(width * ( sourceRect.height / sourceRect.width ),sourceRect.height)
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 8
        fillMode: VideoOutput.PreserveAspectFit
        flushMode: VideoOutput.FirstFrame
        source: content
        orientation: ( contentWidth > contentHeight ? 0 : 270 )
        Rectangle {
            id: playButton
            anchors.fill: parent
            opacity: .5
            color: Colours.almostBlack
            visible: ( content.status === MediaPlayer.Loaded || content.status === MediaPlayer.EndOfMedia ) && content.playbackState !== MediaPlayer.PlayingState
            Image {
                anchors.centerIn: parent
                source: "../icons/right_arrow.png"
            }
            MouseArea {
                id: play
                anchors.fill: parent
                onClicked: {
                    //
                    // go fullscreen
                    //
                    if ( output.parent !== fullscreenContainer ) {
                        //
                        // reparent to fullscreen container
                        //
                        output.parent = fullscreenContainer;
                        output.anchors.verticalCenter = undefined;
                        output.anchors.top = fullscreenContainer.top;
                        output.anchors.bottom = fullscreenContainer.bottom;
                        output.anchors.left = fullscreenContainer.left;
                        output.anchors.right = fullscreenContainer.right;
                        output.anchors.margins = 0;
                        fullscreenContainer.visible = true;
                    }

                    if ( content.playbackState !== MediaPlayer.PlayingState ) {
                        console.log( 'play' );
                        //content.play();
                        mediaSource.play();
                    } else {
                        console.log( 'pause' );
                        //content.pause();
                        mediaSource.pause();
                    }
                }
            }
        }
        Rectangle {
            id: close
            width: 64
            height: 64
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.margins: 4
            radius: 32
            color: Colours.darkOrange
            opacity: .8
            visible: output.parent === fullscreenContainer
            Image {
                anchors.fill: parent
                anchors.margins: 8
                fillMode: Image.PreserveAspectFit
                source:  '../icons/left_arrow.png'
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    //
                    // pause video and reparent to container
                    //
                    mediaSource.pause();
                    output.parent = container;
                    output.anchors.top = undefined;
                    output.anchors.bottom = undefined;
                    output.anchors.verticalCenter = container.verticalCenter;
                    output.anchors.left = container.left;
                    output.anchors.right = container.right;
                    output.anchors.margins = 8;
                    updateContentDimensions();
                    fullscreenContainer.visible = false;
                }
            }
        }
    }
    //
    //
    //
    BusyIndicator {
        anchors.centerIn: parent
        running: content.status === MediaPlayer.Loading
    }
    //
    // TODO: ErrorIndicator and controls
    //

    //
    //
    //
    signal mediaReady();
    signal mediaError( string error );
    //
    //
    //
    //property alias media: mediaSource.url
    onMediaChanged: {
        mediaSource.url = 'https://app.midwifebeth.com:8080' + media;
        console.log('VideoBlock : loading media : ' + mediaSource.url );
    }
    //
    //
    //
    function updateContentDimensions() {
        if ( output.parent === fullscreenContainer ) return;
        //console.log( 'updating dimension, using content width/height=' + ( container.contentWidth && container.contentHeight ));
        console.log( 'updateContentDimensions : parent = ' + output.parent );
        if ( container.contentWidth && container.contentHeight ) {
            output.height = output.width * ( container.contentHeight / container.contentWidth );
        } else {
            output.height = output.width * ( 9. / 16. )
        }
        output.implicitHeight = output.height;
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
    property string media: ""
    property string title: ""
    property int contentWidth: 0
    property int contentHeight: 0
}
