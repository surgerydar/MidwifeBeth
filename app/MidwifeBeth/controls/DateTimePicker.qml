import QtQuick 2.13
import QtQuick.Controls 1.4
import QtQuick.Controls 2.1
import SodaControls 1.0
import "../colours.js" as Colours

Rectangle {
    id: container
    color: Colours.almostWhite
    //
    //
    //
    DateDisplay {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: ( container.height - footer.height ) / 3
        dateModel: dateModel
        displayType: container.displayType
        onSelectedChanged: {
            switch( selected ) {
            case DateDisplay.Field.Date:
                editorSelect.currentIndex = 0;
                break;
            case DateDisplay.Field.Time:
                editorSelect.currentIndex = 1;
                break;
            }
        }
    }
    TabBar {
        id: editorSelect
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        topPadding: 2
        bottomPadding: 2
        //
        //
        //
        TabButton {
            contentItem: Label {
                anchors.centerIn: parent
                text: "Date"
                horizontalAlignment: Label.AlignHCenter
                verticalAlignment: Label.AlignVCenter
            }

            background: Rectangle {
                anchors.fill: parent
                color: parent.checked ? Colours.midGreen : Colours.almostWhite
            }
        }
        TabButton {
            contentItem: Label {
                anchors.centerIn: parent
                text: "Time"
                horizontalAlignment: Label.AlignHCenter
                verticalAlignment: Label.AlignVCenter
            }
            background: Rectangle {
                anchors.fill: parent
                color: parent.checked ? Colours.midGreen : Colours.almostWhite
            }
        }
        onCurrentIndexChanged: {
            header.selected = currentIndex === 0 ? DateDisplay.Field.Date : DateDisplay.Field.Time
        }
    }
    //
    //
    //
    SwipeView {
        id: editor
        anchors.top: editorSelect.bottom
        anchors.left: parent.left
        anchors.bottom: footer.top
        anchors.right: parent.right
        //
        //
        //
        currentIndex: editorSelect.currentIndex
        //
        //
        //
        Page {
            DatePicker {
                id: datePicker
                anchors.fill: parent
                dateModel: dateModel
            }
        }
        Page {
            TimePicker {
                id: timePicker
                anchors.fill: parent
                dateModel: dateModel
                displayType: container.displayType
            }
        }
    }
    //
    // TODO: this could be generic for all Popup editors
    //
    Rectangle {
        id: footer
        height: 64
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        color: Colours.midGreen
        //
        //
        //
        Label {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.margins: 8
            font.pointSize: 18
            color: Colours.almostWhite
            text: "cancel"
            visible: cancel !== null
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if ( cancel ) cancel();
                }
            }
        }
        //
        //
        //
        Label {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.margins: 8
            font.pointSize: 18
            color: Colours.almostWhite
            text: "save"
            visible: save !== null
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if ( save ) save(date);
                }
            }
        }
    }
    //
    //
    //
    Component.onCompleted: {
        timePicker.resetDisplay();
        datePicker.resetDisplay();
    }
    //
    //
    //
    DateModel {
        id: dateModel
    }
    //
    //
    //
    enum ActivePicker {
        Date,
        Time
    }
    //
    //
    //
    property alias date: dateModel.date
    property var save: null
    property var cancel: null
    property int displayType: TimePicker.DisplayType.TwentyFourHour
    property alias activePicker: editorSelect.currentIndex
}
