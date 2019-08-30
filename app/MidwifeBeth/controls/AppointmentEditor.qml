import QtQuick 2.13
import QtQuick.Controls 2.5

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
            text: "Appointment"
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
    Column {
        anchors.top: subtitleContainer.bottom
        anchors.left: parent.left
        anchors.bottom: toolbar.top
        anchors.right: parent.right
        spacing: 4
        topPadding: 4
        bottomPadding: 4
        //
        //
        //
        MWB.TextField {
            id: time
            width: parent.width
            placeholderText: "Date of birth"
            labelText: "Date"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    stack.push("qrc:///controls/DateTimePicker.qml", { date: time.value, cancel: ()=>{stack.pop();}, save: (date)=>{time.value=date; stack.pop();} } );
                }
            }
            onValueChanged: {
                text = Qt.formatDateTime(value,'MMMM dd yyyy hh:mm ap')
                appointment.time = value.getTime();
            }
            property var value: null
        }
        MWB.TextField {
            id: location
            width: parent.width
            placeholderText: "Appointment location"
            labelText: "Location"
            onTextChanged: {
                appointment.location = text;
            }
        }
        MWB.TextArea {
            id: description
            width: parent.width
            height: 256
            labelText: "Description"
            onTextChanged: {
                appointment.description = text;
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
            color: Colours.almostWhite
            text: "save"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if ( save ) {
                        save( appointment );
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
    onAppointmentChanged: {
        description.text = appointment.description || "";
        location.text = appointment.location || "";
        time.value = appointment.time ? new Date(appointment.time) : new Date();
    }
    //
    //
    //
    property var save: null
    property var cancel: null
    property var appointment: ({})
}
