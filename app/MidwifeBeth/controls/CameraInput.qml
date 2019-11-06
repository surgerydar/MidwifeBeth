import QtQuick 2.13
import QtMultimedia 5.13
import QtQuick.Window 2.2

import "../colours.js" as Colours
import "../controls" as MWB

Item {
    id: container
    //
    //
    //
    Camera {
        id: camera
        /*
        imageProcessing.whiteBalanceMode: CameraImageProcessing.WhiteBalanceFlash

        exposure {
            exposureCompensation: -1.0
            exposureMode: Camera.ExposurePortrait
        }
        */
        imageCapture {
            onImageSaved: {
                console.log('Camera.imageCapture.onImageSaved : ' + path );
                //photoPreview.source = 'file://' + path  // Show the saved file in an Image
                if ( save ) {
                    //
                    // ensure image is in documents directory
                    //
                    let documentPath = SystemUtils.documentPath(path.substring(path.lastIndexOf('/')+1));
                    if ( documentPath !== path ) { // not in documents
                        let extension = path.substring(path.lastIndexOf('.'));
                        let targetFile = Date.now() + extension;
                        documentPath = SystemUtils.documentPath(targetFile);
                        SystemUtils.copyFile(path,documentPath);
                    }
                    //
                    // correct orientation ( possibly iOS only )
                    //
                    let rotation = 360 - ( camera.position === Camera.BackFace ? viewfinder.orientation : viewfinder.orientation + 180 );
                    if ( rotation > 0 && rotation < 360 ) {
                        if ( SystemUtils.rotateImage(documentPath,rotation) ) {
                            console.log( 'Camera.onImageSaved : image rotated' );
                        } else {
                            console.log( 'Camera.onImageSaved : unable to rotate image' );
                        }
                    }
                    let url = 'file://' + documentPath;
                    save(url);
                }
            }
        }
        onOrientationChanged: {
            console.log( 'Camera.orientation: ' + orientation );
            orient.text = 'input: ' + camera.orientation + ' output: ' + viewfinder.orientation + ' screen: ' + Screen.orientation;
        }
    }

    VideoOutput {
        id: viewfinder
        source: camera
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: toolbar.top
        anchors.right: parent.right
        //autoOrientation: true
        orientation: Screen.orientation === 1 ? ( camera.position === Camera.BackFace ? 270 : 90 ) : ( Screen.orientation === 2 ? ( camera.position === Camera.BackFace ? 0 : 180 ) :  ( camera.position === Camera.BackFace ? 180 : 0 ) )
        onOrientationChanged: {
            console.log( 'VideoOutput.orientation: ' + orientation );
            orient.text = 'input: ' + camera.orientation + ' output: ' + viewfinder.orientation  + ' screen: ' + Screen.orientation;
        }
    }
    Label {
        id: orient
        visible: false
        anchors.top: viewfinder.top
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Label.AlignHCenter
        text: 'input: ' + camera.orientation + ' output: ' + viewfinder.orientation + ' screen: ' + Screen.orientation
    }

    MWB.RoundButton {
        id: cameraSelector
        width: 64
        height: width
        anchors.bottom: viewfinder.bottom
        anchors.right: viewfinder.right
        anchors.margins: 8
        visible: ( Qt.platform.os === 'ios' || Qt.platform.os === 'android' ) && camera.position !== Camera.UnspecifiedPosition
        image: "/icons/CAMERA SWITCH ICON 96 BOX.png"
        onClicked: {
            if ( camera.position === Camera.FrontFace ) {
                camera.position = Camera.BackFace;
            } else if ( camera.position === Camera.BackFace ) {
                camera.position = Camera.FrontFace;
            }
        }
    }

    Column {
        id: flashMode
        anchors.top: viewfinder.top
        anchors.right: viewfinder.right
        anchors.margins: 8
        spacing: 4
        //visible: camera.flash.supportedModes.length > 1
        Repeater {
            model: ListModel {
                ListElement {
                    mode: Camera.FlashOn
                    icon: "/icons/FLASH ON ICON 96 BOX.png"
                }
                ListElement {
                    mode: Camera.FlashAuto
                    icon: "/icons/FLASH AUTO ICON 96 BOX.png"
                }
                ListElement {
                    mode: Camera.FlashOff
                    icon: "/icons/FLASH OFF ICON 96 BOX.png"
                }
            }
            delegate: MWB.RoundButton {
                width: 32
                height: width
                anchors.horizontalCenter: parent.horizontalCenter
                opacity: camera.flash.mode === model.mode ? 1.0 : 0.5
                image: model.icon
                //visible: camera.flash.supportedModes.indexOf( model.mode )
                onClicked : {
                    camera.flash.mode = model.mode
                }
            }
        }
    }

    Rectangle {
        id: toolbar
        height: 72
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        color: Colours.midGreen
        //
        //
        //
        MWB.RoundButton {
            id: capture
            width: 64
            height: width
            anchors.centerIn: parent
            image: "/icons/CAMERA SHOOT ICON 96 BOX.png"
            onClicked: {
                camera.imageCapture.capture()
            }
        }
    }
    property var save: null
    property var cancel: null
}

