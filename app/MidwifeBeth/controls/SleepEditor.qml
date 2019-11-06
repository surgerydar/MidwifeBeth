import QtQuick 2.13
import QtQuick.Controls 2.5
import QtQuick.Dialogs 1.3
import SodaControls 1.0

import "../colours.js" as Colours
import "../utils.js" as Utils
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
            text: "Sleep"
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
        anchors.margins: 8
        spacing: 4
        //
        //
        //
        MWB.TextField {
            id: startTime
            anchors.left: parent.left
            anchors.right: parent.right
            labelText: "From"
            placeholderText: "Tap to set"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    stack.push("qrc:///controls/DateTimePicker.qml", { date: startTime.value, activePicker: DateTimePicker.ActivePicker.Time, cancel: ()=>{stack.pop();}, save: (date)=>{startTime.value=date; stack.pop();} } );
                }
            }
            onValueChanged: {
                sleep.startTime = value.getTime();
                refreshDisplay();
            }
            property var value: new Date()
        }
        MWB.TextField {
            id: endTime
            anchors.left: parent.left
            anchors.right: parent.right
            labelText: "To"
            placeholderText: "Tap to set"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    stack.push("qrc:///controls/DateTimePicker.qml", { date: endTime.value, activePicker: DateTimePicker.ActivePicker.Time, cancel: ()=>{stack.pop();}, save: (date)=>{endTime.value=date; stack.pop();} } );
                }
            }
            onValueChanged: {
                sleep.endTime = value.getTime();
                refreshDisplay();
            }
            property var value: null
        }
        MWB.TextField {
            id: duration
            anchors.left: parent.left
            anchors.right: parent.right
            labelText: "Duration"
            visible: startTime.value && endTime.value && startTime.value < endTime.value
            text: Utils.formatDuration( startTime.value, endTime.value )
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
        //
        //
        //
        Label {
            anchors.centerIn: parent
            font.pointSize: 18
            color: Colours.almostWhite
            text: "save"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if ( save ) {
                        save( sleep );
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
    function refreshDisplay() {
        startTime.text = Qt.formatDateTime(startTime.value,'MMMM dd yyyy hh:mm ap');
        endTime.text = endTime.value && startTime.value && endTime.value > startTime.value ? Qt.formatDateTime(endTime.value,'MMMM dd yyyy hh:mm ap') : "";
        duration.text = Utils.formatDuration(startTime.value,endTime.value);
    }

    function resetDisplay() {
        let defaultDate = new Date();
        startTime.value = sleep.startTime ? new Date( sleep.startTime ) : defaultDate;
        endTime.value = sleep.endTime ? new Date( sleep.endTime ) : defaultDate;
    }

    //
    //
    //
    onSleepChanged: {
        resetDisplay();
    }
    Component.onCompleted: {
        resetDisplay();
    }
    //
    //
    //
    property var save: null
    property var cancel: null
    property var sleep: ({})
}
