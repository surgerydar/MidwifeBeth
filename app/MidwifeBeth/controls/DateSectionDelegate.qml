import QtQuick 2.6
import QtQuick.Controls 2.1

import "../colours.js" as Colours

Rectangle {
    height: parent.height
    width: height / 2
    color: Colours.midGreen
    Column {
        anchors.fill: parent
        anchors.margins: 4
        Label {
            id: day
            width: parent.width
            height: contentHeight
            font.pointSize: 48
            fontSizeMode: Label.HorizontalFit
            lineHeight: .8
            color: Colours.almostWhite
            text: section.split('-')[2]
        }
        Label {
            id: month
            width: parent.width
            height: contentHeight
            font.pointSize: 48
            fontSizeMode: Label.HorizontalFit
            color: Colours.almostWhite
            text: section.split('-')[1]
        }
        Label {
            id: year
            width: parent.width
            height: contentHeight
            font.pointSize: 48
            fontSizeMode: Label.HorizontalFit
            color: Colours.almostWhite
            text: section.split('-')[0]
        }
    }
}
