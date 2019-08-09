import QtQuick 2.13
import QtQuick.Controls 1.4
import QtQuick.Controls 2.1
import "../colours.js" as Colours

Rectangle {
    id: container
    color: Colours.almostWhite
    //
    //
    //
    Rectangle {
        id: header
        height: ( container.height - footer.height ) / 3
    }
    //
    //
    //
    SwipeView {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: footer.top
        anchors.right: parent.right
        //
        //
        //
        Calendar {
            id: datePicker
            anchors.fill: parent
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
        //
        //
        //
        Label {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.margins: 8
            visible: editable
            font.pointSize: 18
            color: Colours.almostWhite
            text: "cancel"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    cancel();
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
            visible: editable
            font.pointSize: 18
            color: Colours.almostWhite
            text: "save"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    save();
                }
            }
        }
    }
    //
    //
    //
    signal cancel();
    signal save();
    //
    //
    //
    function getDate() {
        var date = new Date();

        return date;
    }
}
