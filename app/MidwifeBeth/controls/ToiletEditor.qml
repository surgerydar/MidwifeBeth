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
            text: "Toilet"
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
        id: toiletTime
        height: 128
        anchors.top: subtitleContainer.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        dateModel: toiletTimeModel
    }
    //
    //
    //
    Row {
        id: toiletType
        height: 64
        anchors.top: toiletTime.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        padding: 8
        spacing: 4
        //
        //
        //
        RadioButton {
            id: nappieOption
            anchors.verticalCenter: parent.verticalCenter
            text: "nappy"
            checked: !toilet.type || toilet.type === 'nappy';
            onCheckedChanged: {
                if ( checked ) {
                    toilet.type = 'nappy';
                    options.currentIndex = 0;
                }
            }
        }
        RadioButton {
            id: pottyOption
            anchors.verticalCenter: parent.verticalCenter
            text: "potty"
            checked: toilet.type && toilet.type === 'potty';
            onCheckedChanged: {
                if ( checked ) {
                    toilet.type = 'potty';
                    options.currentIndex = 1;
                }
            }
        }
        RadioButton {
            id: toiletOption
            anchors.verticalCenter: parent.verticalCenter
            text: "toilet"
            checked: toilet.type && toilet.type === 'toilet';
            onCheckedChanged: {
                if ( checked ) {
                    toilet.type = 'toilet';
                    options.currentIndex = 2;
                }
            }
        }
    }

    //
    //
    //
    SwipeView {
        id: options
        anchors.top: toiletType.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: toolbar.top
        interactive: false
        Item {
            id: nappyOptions
            Column {
                anchors.fill: parent
                padding: 8
                spacing: 4
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    RadioButton {
                        id: wet
                        text: "wet"
                        checked: toilet.options ? toilet.options.wet || false : false
                        onCheckedChanged: {
                            toilet.options.wet = checked;
                        }
                    }
                    RadioButton {
                        id: dry
                        text: "dry"
                        checked: toilet.options ? toilet.options.dry || false : false
                        onCheckedChanged: {
                            toilet.options.dry = checked;
                        }
                    }
                    RadioButton {
                        id: soiled
                        text: "soiled"
                        checked: toilet.options ? toilet.options.soiled || false : false
                        onCheckedChanged: {
                            toilet.options.soiled = checked;
                        }
                    }
                }
                MWB.TextArea {
                    id: nappyNotes
                    anchors.left: parent.left
                    anchors.right: parent.right
                    labelText: "Notes"
                    text: toilet.options && toilet.options.description ? toilet.options.description : ""
                    onTextChanged: {
                        toilet.options.description = text;
                    }
                }
            }
        }
        Item {
            id: pottyOptions
            MWB.TextArea {
                id: pottyNotes
                anchors.fill: parent
                labelText: "Notes"
                text: toilet.options && toilet.options.description ? toilet.options.description : ""
                onTextChanged: {
                    toilet.options.description = text;
                }
            }
        }
        Item {
            id: toiletOptions
            MWB.TextArea {
                id: toiletNotes
                anchors.fill: parent
                labelText: "Notes"
                text: toilet.options && toilet.options.description ? toilet.options.description : ""
                onTextChanged: {
                    toilet.options.description = text;
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
            anchors.rightMargin: 8
            font.pointSize: 24
            color: Colours.almostWhite
            text: "save"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if ( save ) {
                        save( toilet );
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
    onToiletChanged: {
        console.log( "toilet=" + toilet );
        if ( !toilet.type ) {
            toilet.type = 'nappy';
            toilet.options = { dry: true };
        }
        toiletTimeModel.date = toilet.time ? new Date( toilet.time ) : new Date();
        switch( toilet.type ) {
        case 'nappy' :
            options.currentIndex = 0;
            break;
        case 'potty' :
            options.currentIndex = 1;
            break;
        case 'toilet' :
            options.currentIndex = 2;
            break;
        }
    }
    //
    //
    //
    DateModel {
        id: toiletTimeModel
        onDateChanged: {
            toilet.time = toiletTimeModel.date.getTime();
        }
    }
    //
    //
    //
    property var save: null
    property var cancel: null
    property var toilet: ({})
}
