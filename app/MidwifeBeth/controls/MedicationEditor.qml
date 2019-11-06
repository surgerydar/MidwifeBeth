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
            text: "Medication"
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
            id: name
            width: parent.width
            placeholderText: "Name of medicine"
            labelText: "Name"
            onTextChanged: {
                medication.name = text;
            }
        }
        MWB.TextField {
            id: time
            width: parent.width
            placeholderText: "Date / time"
            labelText: "Start date"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    stack.push("qrc:///controls/DateTimePicker.qml", { date: time.value, cancel: ()=>{stack.pop();}, save: (date)=>{time.value=date; stack.pop();} } );
                }
            }
            onValueChanged: {
                text = Qt.formatDateTime(value,'MMMM dd yyyy hh:mm ap')
                medication.time = value.getTime();
            }
            property var value: null
        }
        MWB.TextField {
            id: dose
            width: parent.width
            placeholderText: "Dosage e.g. 20mg, 20ml, 2 tablets"
            onTextChanged: {
                medication.dose = text;
            }
        }
        MWB.ScheduleEditor {
            id: schedule
            width: parent.width
            height: 96
            labelText: "Schedule"
            onPatternElementChanged: {
                medication.schedule = pattern;
            }
            onRepeatChanged: {
                medication.repeat = repeat;
            }
            onNotifyChanged: {
                medication.notify = notify;
            }
        }
        MWB.TextArea {
            id: notes
            width: parent.width
            height: 256
            labelText: "Notes"
            onTextChanged: {
                medication.notes = text;
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
            color: Colours.almostWhite
            text: "save"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if ( save ) {
                        save( medication );
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
    onMedicationChanged: {
        notes.text = medication.notes || "";
        if ( medication.schedule ) {
            schedule.pattern = medication.schedule;
        } else {
            medication.schedule = schedule.pattern;
        }
        dose.text = medication.dose || "";
        name.text = medication.name || "";
        time.value = medication.time ? new Date(medication.time) : new Date();
        schedule.repeat = medication.repeat || false;
        schedule.notify = medication.notify || false;
    }
    //
    //
    //
    property var save: null
    property var cancel: null
    property var medication: ({})
}
