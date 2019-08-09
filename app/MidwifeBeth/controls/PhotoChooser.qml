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
    }
    //
    //
    //
    Row {
        anchors.bottom: preview.bottom
        anchors.horizontalCenter: preview.horizontalCenter
        anchors.margins: 4
        spacing: 4
        Button {
            text: "Gallery"
            onClicked: {
                imageChooser.open();
            }
        }
        Button {
            text: "Camera"
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
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 8
            font.pointSize: 18
            color: Colours.almostWhite
            text: "cancel"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if ( cancel ) {
                        cancel();
                    } else {
                        stack.pop();
                    }
                }
            }
        }
        Label {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 8
            font.pointSize: 18
            visible: preview.status === Image.Ready
            color: Colours.almostWhite
            text: "save"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if ( save ) {
                        save( preview.source );
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
            preview.source = fileUrl;
        }
    }
    property var save: null
    property var cancel: null
}
