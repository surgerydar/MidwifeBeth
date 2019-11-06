import QtQuick 2.13
import QtQuick.Controls 2.5
import QtQuick.Dialogs 1.3

import "colours.js" as Colours
import "controls" as MWB

Rectangle {
    id: container
    width: parent.width
    height: childrenRect.y + childrenRect.height
    color: Colours.midGreen
    //
    //
    //
    Column {
        id: content
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
            onStatusChanged: {
                if( status === Image.Error ) {
                    console.log('MyBabyInfo : unable to load ' + source );
                    source = '/icons/profile.png'
                }
            }

            MWB.RoundButton {
                width: 48
                height: width
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                image: "/icons/EDIT ICON 96 BOX.png"
                onClicked: {
                    stack.push("qrc:///controls/PhotoChooser.qml", {
                                   save: function ( source ) {
                                       profilePhotoDisplay.source = 'file://' + source;
                                       stack.pop();
                                   },
                                   cancel: function() {
                                       stack.pop();
                                   }
                               });
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
        MWB.TextField {
            id: birthDateTime
            width: parent.width
            placeholderText: "Date of birth"
            labelText: "Date of birth"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    stack.push("qrc:///controls/DateTimePicker.qml", { date: birthDateTime.value, cancel: ()=>{stack.pop();}, save: (date)=>{birthDateTime.value=date; stack.pop();} } );
                }
            }
            onValueChanged: {
                text = Qt.formatDateTime(value,'MMMM dd yyyy hh:mm ap')
            }
            property var value: null
        }
        MWB.WeightField {
            id: birthWeightField
            width: parent.width
            placeholderText: "Birth weight"
            labelText: "Birth weight"
        }
    }
    Rectangle {
        height: 4
        anchors.top: content.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: 4
        color: Colours.lightGreen
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
                container.profilePhotoChanged(fileUrl);
            }
        }

        property var save: null
    }
    //
    //
    //
    property alias profilePhoto: profilePhotoDisplay.source
    property alias firstName: firstNameField.text
    property alias middleNames: middleNamesField.text
    property alias surname: surnameField.text
    property alias birthDateTime: birthDateTime.value
    property alias birthWeight: birthWeightField.value
    property bool editable: true
}
