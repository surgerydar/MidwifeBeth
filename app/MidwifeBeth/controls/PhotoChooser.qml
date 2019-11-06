import QtQuick 2.13
import QtQuick.Controls 2.5
import QtQuick.Dialogs 1.3

import "../colours.js" as Colours
import "../controls" as MWB

Item {
    id: container
    //
    //
    //
    Image {
        id: preview
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: toolbar.top
        anchors.right: parent.right
        fillMode: Image.PreserveAspectFit
        //autoTransform: true
    }
    //
    //
    //
    Row {
        anchors.bottom: preview.bottom
        anchors.horizontalCenter: preview.horizontalCenter
        anchors.margins: 4
        spacing: 4
        MWB.RoundButton {
            width: 64
            height: width
            image: "/icons/GALLERY ICON 96 BOX.png"
            onClicked: {
                console.log('PhotosLocation : ' + imageChooser.shortcuts.pictures );
                imageChooser.open();
            }
        }
        MWB.RoundButton {
            width: 64
            height: width
            image: "/icons/CAMERA ICON 96 BOX.png"
            onClicked: {
                stack.push("qrc:///controls/CameraInput.qml", {
                               save: function ( source ) {
                                   preview.source = source;
                                   stack.pop();
                               },
                               cancel: function() {
                                   stack.pop();
                               }
                           });
            }
        }
    }
    //
    //
    //
    Rectangle {
        id: toolbar
        height: 72
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        color: Colours.midGreen
        Label {
            anchors.centerIn: parent
            font.pointSize: 18
            visible: preview.status === Image.Ready
            color: Colours.almostWhite
            text: "save"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if ( save ) {
                        console.log( 'saving image : ' + preview.source.toString() );
                        console.log( 'fileName=' + SystemUtils.urlFilename(preview.source));
                        console.log( 'protocol=' + SystemUtils.urlProtocol(preview.source));
                        let sourcePath = preview.source.toString();
                        if ( sourcePath.startsWith('file:assets-library:') ) {
                            //
                            // process iOS asset
                            //
                            sourcePath = SystemUtils.copyImageFromGallery(sourcePath.substring('file:'.length));
                        } else if ( sourcePath.startsWith('file://') ) {
                            sourcePath = sourcePath.substring('file://'.length);
                        }
                        let documentPath = SystemUtils.documentPath(sourcePath.substring(sourcePath.lastIndexOf('/')+1));
                        if ( documentPath !== sourcePath ) {
                            // iOS asset library path - file:assets-library://asset/asset.JPG%3Fid=6A96935E-6344-40FA-BEEA-266BAEF448F2&ext=JPG
                            let extension = documentPath.substring(documentPath.lastIndexOf('.'));
                            let targetFile = Date.now() + extension;
                            documentPath = SystemUtils.documentPath(targetFile);
                            SystemUtils.copyFile(sourcePath,documentPath);
                        }
                        //
                        // verify image has copied into documents
                        //
                        if ( SystemUtils.fileExists(documentPath) ) {
                            save( documentPath );
                        } else {
                            errorDialog.show( "Unable to save image",[{label:"Ok", action: function() {} }]);
                        }
                    } else {
                        stack.pop();
                    }
                }
            }
        }
    }
    FileDialog {
        id: imageChooser
        folder: shortcuts.pictures
        nameFilters: [ "Image files (*.jpg *.png)" ]
        onAccepted: {
            console.log( 'imageChooser.onAccepted : ' + fileUrl);
            preview.source = fileUrl;
        }
    }
    property var save: null
    property var cancel: null
}
