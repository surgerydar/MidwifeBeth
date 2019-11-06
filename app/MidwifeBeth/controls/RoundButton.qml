import QtQuick 2.13
import QtQuick.Controls 2.5

import "../colours.js" as Colours
import "../controls" as MWB

Button {
    id: control
    background: Rectangle {
        id: circle
        anchors.fill: control
        radius: height / 2
        color: Colours.lightGrey
        opacity: .5
    }
    contentItem: Image {
        id: image
        anchors.fill: control
        anchors.margins: 8
        fillMode: Image.PreserveAspectFit
    }
    property alias image: image.source
    property alias backgroundColour: circle.color
    property alias backgroundOpacity: circle.opacity
}
