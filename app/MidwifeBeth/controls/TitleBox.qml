import QtQuick 2.6
import QtQuick.Controls 2.1

import "../colours.js" as Colours

Rectangle {
    id: background
    width: label.contentWidth + radius
    height: label.contentHeight + 4
    radius: height / 2
    visible: label.text.length > 0
    color: Colours.almostBlack
    Label {
        id: label
        anchors.centerIn: parent
        color: Colours.almostWhite
        font.pointSize: 14
    }
    property alias text: label.text
    property alias font: label.font
}
