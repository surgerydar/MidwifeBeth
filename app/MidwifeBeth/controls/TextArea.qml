import QtQuick 2.6
import QtQuick.Controls 2.1

import "../colours.js" as Colours

TextArea {
    id: container
    height: Math.max(48,contentHeight+(labelBackground.visible ? labelBackground.height + 4:0))
    color: Colours.almostBlack
    padding: 8
    topPadding: labelBackground.visible ? labelBackground.height + 4 : 0
    font.pointSize: 24
    //
    //
    //
    background: Rectangle {
        id: background
        anchors.fill: parent
        anchors.topMargin: labelBackground.visible ? labelBackground.height / 2 : 0
        radius: 4
        color: Colours.almostWhite
        border.color: "transparent"
    }
    Rectangle {
        id: labelBackground
        width: label.contentWidth + radius
        height: label.contentHeight + 4
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: background.radius
        radius: height / 2
        visible: label.text.length > 0
        color: Colours.almostBlack
        Label {
            id: label
            anchors.centerIn: parent
            color: background.color
            font.pointSize: 14
        }
    }
    property alias backgroundColour: background.color
    property alias labelText: label.text
}
