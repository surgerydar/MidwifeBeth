import QtQuick 2.13
import QtQuick.Controls 2.5
import QtQuick.Dialogs 1.3
import SodaControls 1.0

import "../colours.js" as Colours
import "../controls" as MWB

Item {
    id: container
    //
    // TODO: generic subtitle
    //
    Rectangle {
        id: subtitleContainer
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 64
        color: Colours.midGreen
        //
        //
        //
        Label {
            id: subtitle
            anchors.fill: parent
            anchors.margins: 4
            font.pixelSize: 48
            font.weight: Font.Bold
            fontSizeMode: Label.Fit
            horizontalAlignment: Label.AlignHCenter
            verticalAlignment: Label.AlignVCenter
            color: Colours.almostWhite
            text: "Nappy"
        }
    }
    //
    //
    //
    Rectangle {
        anchors.top: subtitleContainer.bottom
        anchors.left: parent.left
        anchors.bottom: toolbar.top
        anchors.right: parent.right
        color: Colours.lightGreen
    }
    //
    //
    //
    MWB.TimePicker {
        id: nappyTime
        height: 128
        anchors.top: subtitleContainer.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        dateModel: nappyTimeModel
    }
    //
    //
    //
    Row {
        id: nappyContent
        height: 64
        anchors.top: nappyTime.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        padding: 8
        spacing: 4
        //
        //
        //
        CheckBox {
            id: wet
            text: "wet"
            onCheckedChanged: {
                nappy.wet = checked;
            }
        }
        CheckBox {
            id: poo
            text: "poo"
            onCheckedChanged: {
                nappy.poo = checked;
            }
        }
    }
    MWB.TextArea {
        id: description
        anchors.top: nappyContent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: toolbar.top
        labelText: "Notes"
        onTextChanged: {
            nappy.description = text;
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
            anchors.rightMargin: 8
            font.pointSize: 24
            color: Colours.almostWhite
            text: "save"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if ( save ) {
                        save( nappy );
                    } else {
                        stack.pop();
                    }
                }
            }
        }
    }
    //
    //
    //
    onNappyChanged: {
        console.log( "nappy=" + nappy );
        wet.checked = nappy.wet || false;
        poo.checked = nappy.poo || false;
        description.text = nappy.description || "";
        nappyTimeModel.date = nappy.time ? new Date( nappy.time ) : new Date();
    }
    //
    //
    //
    DateModel {
        id: nappyTimeModel
        onDateChanged: {
            nappy.time = nappyTimeModel.date.getTime();
        }
    }
    //
    //
    //
    property var save: null
    property var cancel: null
    property var nappy: ({})
}
