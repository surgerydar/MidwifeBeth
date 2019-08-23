import QtQuick 2.13
import QtQuick.Controls 2.5

import "../colours.js" as Colours
import "../controls" as MWB

Item {
    id: container
    //
    //
    //
    height: content.childrenRect.y + content.childrenRect.height + 32
    //
    //
    //
    Rectangle {
        id: background
        anchors.fill: parent
        anchors.topMargin: labelBackground.visible ? labelBackground.height / 2 : 0
        radius: 4
        color: Colours.midGreen
    }
    //
    //
    //
    Column {
        id: content
        anchors.top: labelBackground.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        padding: 8
        spacing: 4
        MWB.LengthField {
            id: height
            width: parent.width - 16
            labelText: "Height"
            placeholderText: "Height"
            onValueChanged: {
                media.height = value;
                container.updateContent();
            }
        }
        MWB.WeightField {
            id: weight
            width: parent.width - 16
            labelText: "Weight"
            placeholderText: "Weight"
            onValueChanged: {
                media.weight = value;
                container.updateContent();
            }
        }
        MWB.LengthField {
            id: head
            width: parent.width - 16
            labelText: "Head Diameter"
            placeholderText: "Diameter"
            onValueChanged: {
                media.headDiameter = value;
                container.updateContent();
            }
        }
    }
    //
    //
    //
    Rectangle {
        id: labelBackground
        height: label.contentHeight + 4
        width: label.contentWidth + radius
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: background.radius
        radius: ( label.contentHeight + 4 ) / 2 // JONS: setting this to height / 2 fails ( subtle binding loop I think )
        visible: label.text.length > 0
        color: Colours.almostBlack
        Label {
            id: label
            anchors.centerIn: parent
            color: Colours.almostWhite
            font.pointSize: 14
            text: "Growth"
        }
    }
    //
    //
    //
    onMediaChanged: {
        height.value    = media.height || 0.;
        weight.value    = media.weight || 0.;
        head.value      = media.headDiameter || 0.;
    }

    //
    //
    //
    signal mediaReady();
    signal mediaError( string error );
    signal updateContent();
    //
    //
    //
    property var media: ({})
    property string title: ""
    property int contentWidth: 0
    property int contentHeight: 0
}
