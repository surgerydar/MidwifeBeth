import QtQuick 2.13
import QtQuick.Controls 2.5
import QtQuick.Dialogs 1.3

import "colours.js" as Colours
import "controls" as MWB

Rectangle {
    width: parent.width
    height: childrenRect.height + 16
    color: Colours.midGreen
    //
    //
    //
    Column {
        x: 8
        y: 8
        width: parent.width - 16
        spacing: 4
        Image {
            id: profilePhotoDisplay
            width: parent.width / 3
            height: width
            anchors.horizontalCenter: parent.horizontalCenter
            fillMode: Image.PreserveAspectFit
            Row {
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 4
                Button {
                    text: "Gallery"
                    onClicked: {
                        imageChooser.selectImage( function ( source ) {
                            profilePhotoDisplay.source = source;
                        });
                    }
                }
                Button {
                    text: "Camera"
                    onClicked: {
                        stack.push("qrc:///controls/CameraInput.qml", {
                                       save: function ( source ) {
                                           profilePhotoDisplay.source = source;
                                           stack.pop();
                                       },
                                       cancel: function() {
                                           stack.pop();
                                       }
                                   });
                    }
                }
            }
        }
        MWB.TextField {
            id: firstNameField
            width: parent.width
            placeholderText: "First name"
            labelText: "First name"
        }
        MWB.TextField {
            id: middleNamesField
            width: parent.width
            placeholderText: "Middle names"
            labelText: "Middle names"
        }
        MWB.TextField {
            id: surnameField
            width: parent.width
            placeholderText: "Surname"
            labelText: "Surname"
        }
        MWB.DatePicker {
            id: birthDateTime
            width: parent.width
            height: 128
        }
        MWB.TextField {
            id: birthWeightField
            width: parent.width
            placeholderText: "Birth weight"
            labelText: "Birth weight"
            inputMask: unit.units[unit.currentUnit].template
            //
            //
            //
            Label {
                id: unit
                anchors.right:  parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 8
                text: units[currentUnit].label
                color: Colours.almostBlack
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        var newUnit = unit.currentUnit+1;
                        if ( newUnit >= unit.units.length ) {
                            unit.currentUnit = 0;
                        } else {
                            unit.currentUnit = newUnit;
                        }
                    }
                }
                property int currentUnit: 0
                property var units: [{label:'lb',template:'09 l\b 09 oz;0'},{label:'oz',template:'0099 oz;0'},{label:'kg',template:'09.99 kg;0'},{label:'g',template:'0099 g;0'}]
            }
        }
    }
    FileDialog {
        id: imageChooser
        folder: shortcuts.pictures
        nameFilters: [ "Image files (*.jpg *.png)" ]
        function selectImage( save ) {
            imageChooser.save = save;
            open();
        }
        onAccepted: {
            if ( save ) {
                save( fileUrl );
                save = null;
            }
        }

        property var save: null
    }
    property alias profilePhoto: profilePhotoDisplay.source
    property alias firstName: firstNameField.text
    property alias middleNames: middleNamesField.text
    property alias surname: surnameField.text
    property alias birthDate: birthDateTime.currentDate
    property alias birthWeight: birthWeightField.text
    property bool editable: true
}
