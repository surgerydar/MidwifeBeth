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
            text: "feed"
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
        id: feedTime
        height: 128
        anchors.top: subtitleContainer.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        dateModel: feedTimeModel
    }
    //
    //
    //
    Row {
        id: feedType
        height: 64
        anchors.top: feedTime.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        padding: 8
        spacing: 4
        //
        //
        //
        RadioButton {
            id: breast
            anchors.verticalCenter: parent.verticalCenter
            text: "breast"
            checked: !feed.type || feed.type === 'breast';
            onCheckedChanged: {
                if ( checked ) {
                    feed.type = 'breast';
                    feedOptions.currentIndex = 0;
                }
            }
        }
        RadioButton {
            id: bottle
            anchors.verticalCenter: parent.verticalCenter
            text: "bottle"
            checked: feed.type && feed.type === 'bottle';
            onCheckedChanged: {
                if ( checked ) {
                    feed.type = 'bottle';
                    feedOptions.currentIndex = 1;
                }
            }
        }
        RadioButton {
            id: solids
            anchors.verticalCenter: parent.verticalCenter
            text: "solids"
            checked: feed.type && feed.type === 'solids';
            onCheckedChanged: {
                if ( checked ) {
                    feed.type = 'solids';
                    feedOptions.currentIndex = 2;
                }
            }
        }
    }

    //
    //
    //
    SwipeView {
        id: feedOptions
        anchors.top: feedType.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: toolbar.top
        interactive: false
        Item {
            id: breastOptions
            Column {
                anchors.fill: parent
                //padding: 8
                spacing: 4
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    CheckBox {
                        id: left
                        text: "left"
                        checked: feed.options ? feed.options.left || false : false
                        onCheckedChanged: {
                            feed.options.left = checked;
                        }
                    }
                    CheckBox {
                        id: right
                        text: "right"
                        checked: feed.options ? feed.options.right || false : false
                        onCheckedChanged: {
                            feed.options.right = checked;
                        }
                    }
                }
                MWB.TextField {
                    id: leftDuration
                    width: parent.width
                    labelText: "Left duration"
                    visible: left.checked
                    placeholderText: "minutes"
                    text: feed.options && feed.options.leftDuration ? feed.options.leftDuration : ""
                    onTextChanged: {
                        feed.options.leftDuration = text;
                    }
                }
                MWB.TextField {
                    id: rightDuration
                    width: parent.width
                    labelText: "Right duration"
                    visible: right.checked
                    placeholderText: "minutes"
                    text: feed.options && feed.options.rightDuration ? feed.options.rightDuration : ""
                    onTextChanged: {
                        feed.options.rightDuration = text;
                    }
                }
                MWB.TextArea {
                    id: breastNotes
                    width: parent.width
                    labelText: "Notes"
                    text: feed.options && feed.options.description ? feed.options.description : ""
                }
            }
        }
        Item {
            id: bottleOptions
            Column {
                anchors.fill: parent
                MWB.TextField {
                    id: bottleQuantity
                    width: parent.width
                    labelText: "Quantity"
                    placeholderText: "quantity"
                    onTextChanged: {
                        feed.options.quantity = text;
                    }
                }
                MWB.TextArea {
                    id: bottleNotes
                    width: parent.width
                    labelText: "Notes"
                    text: feed.options && feed.options.description ? feed.options.description : ""
                }
            }
        }
        Item {
            id: solidsOptions
            MWB.TextArea {
                anchors.fill: parent
                labelText: "Notes"
                text: feed.options && feed.options.description ? feed.options.description : ""
                onTextChanged: {
                    feed.options.description = text;
                }
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
                        save( feed );
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
    onFeedChanged: {
        if ( !feed.type ) {
            feed.type = 'breast';
            feed.options = {};
        }
        feedTimeModel.date = feed.time ? new Date( feed.time ) : new Date();
        switch( feed.type ) {
        case 'breast' :
            feedOptions.currentIndex = 0;
            break;
        case 'bottle' :
            feedOptions.currentIndex = 1;
            break;
        case 'solids' :
            feedOptions.currentIndex = 2;
            break;
        }
    }
    //
    //
    //
    DateModel {
        id: feedTimeModel
        onDateChanged: {
            feed.time = feedTimeModel.date.getTime();
        }
    }
    //
    //
    //
    property var save: null
    property var cancel: null
    property var feed: ({})
}
