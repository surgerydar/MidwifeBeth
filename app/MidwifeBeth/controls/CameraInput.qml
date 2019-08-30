import QtQuick 2.13
import QtMultimedia 5.13

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
            /*
            onImageCaptured: {
                console.log('Camera.imageCapture.onImageCaptured : ' + preview );
                photoPreview.source = preview  // Show the preview in an Image
            }
            */
            onImageSaved: {
                console.log('Camera.imageCapture.onImageSaved : ' + path );
                photoPreview.source = 'file://' + path  // Show the saved file in an Image
            }
        }
        onOrientationChanged: {
            console.log( 'Camera.orientation: ' + orientation );
        }
    }

    VideoOutput {
        id: viewfinder
        source: camera
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: toolbar.top
        anchors.right: parent.right
        autoOrientation: true
        onOrientationChanged: {
            console.log( 'VideoOutput.orientation: ' + orientation );
        }
    }

    Image {
        id: cameraSelector
        visible: ( Qt.platform.os === 'ios' || Qt.platform.os === 'android' ) && camera.position !== Camera.UnspecifiedPosition
        source: camera.position === Camera.FrontFace ? "../icons/camera_front.png" : camera.position === Camera.BackFace ? "../icons/camera_rear.png" : ""
        anchors.bottom: viewfinder.bottom
        anchors.right: viewfinder.right
        anchors.margins: 8
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if ( camera.position === Camera.FrontFace ) {
                    camera.position = Camera.BackFace;
                } else if ( camera.position === Camera.BackFace ) {
                    camera.position = Camera.FrontFace;
                }
            }
        }
    }

    Column {
        id: flashMode
        anchors.top: viewfinder.top
        anchors.right: viewfinder.right
        //visible: camera.flash.supportedModes.length > 1
        Repeater {
            model: ListModel {
                ListElement {
                    mode: Camera.FlashOn
                    icon: "../icons/flash_on.png"
                }
                ListElement {
                    mode: Camera.FlashAuto
                    icon: "../icons/flash_auto.png"
                }
                ListElement {
                    mode: Camera.FlashOff
                    icon: "../icons/flash_off.png"
                }
            }
            delegate: Image {
                source: model.icon
                //visible: camera.flash.supportedModes.indexOf( model.mode )
                anchors.horizontalCenter: parent.horizontalCenter
                opacity: camera.flash.mode === model.mode ? 1.0 : 0.5
                MouseArea {
                    anchors.fill: parent
                    onClicked : {
                        camera.flash.mode = model.mode
                    }
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
        Label {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.margins: 8
            font.pointSize: 18
            color: Colours.almostWhite
            text: "cancel"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if ( cancel ) {
                        cancel();
                    }
                }
            }
        }
        //
        //
        //
        Rectangle {
            id: capture
            width: 64
            height: width
            radius: width / 2
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            color: Colours.darkOrange

            Rectangle {
                anchors.fill: parent
                anchors.margins: 8
                radius: width / 2
                color: Colours.almostWhite
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    camera.imageCapture.capture()
                }
            }
        }
        //
        //
        //
        Image {
            id: photoPreview
            width: height
            anchors.top: parent.top
            anchors.left: capture.right
            anchors.bottom: parent.bottom
            anchors.margins: 4
            fillMode: Image.PreserveAspectFit
        }
        //
        //
        //
        Label {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.margins: 8
            visible: photoPreview.source
            font.pointSize: 18
            color: Colours.almostWhite
            text: "save"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if ( save ) {
                        save(photoPreview.source)
                    }
                }
            }
        }
    }
    property var save: null
    property var cancel: null
}

