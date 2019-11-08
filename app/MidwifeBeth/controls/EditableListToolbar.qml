import QtQuick 2.6
import QtQuick.Controls 2.1
import "../controls" as MWB
import "../colours.js" as Colours

Rectangle {
    id: container
    height: 72
    width: parent.width
    color: Colours.midGreen
    //
    //
    //
    MWB.RoundButton {
        id: addButton
        width: 64
        height: width
        anchors.centerIn: parent
        image: "../icons/PLUS ICON 96 BOX.png"
        onClicked: {
            add();
        }
    }
    //
    //
    //
    Label {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: addButton.right
        anchors.margins: 16
        visible: editable
        font.pointSize: 24
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
