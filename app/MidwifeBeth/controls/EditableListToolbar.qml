import QtQuick 2.6
import QtQuick.Controls 2.1
import "../colours.js" as Colours

Rectangle {
    id: container
    height: 72
    width: parent.width
    color: Colours.midGreen
    //
    //
    //
    Rectangle {
        width: 64
        height: 64
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        radius: 32
        color: Colours.darkOrange
        opacity: .8
        Image {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "../icons/add.png"
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                add();
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
        text: editing ? "done" : "edit"
        MouseArea {
            anchors.fill: parent
            onClicked: {
                editing = !editing
            }
        }
    }
    //
    //
    //
    signal add();
    //
    //
    //
    property bool editable: false
    property bool editing: false
}
