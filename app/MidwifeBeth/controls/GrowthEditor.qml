import QtQuick 2.13
import QtQuick.Controls 2.5

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
            text: "Growth"
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
    Column {
        id: content
        anchors.top: subtitleContainer.bottom
        anchors.left: parent.left
        anchors.bottom: toolbar.top
        anchors.right: parent.right
        padding: 8
        spacing: 4
        MWB.LengthField {
            id: length
            width: parent.width - 16
            labelText: "Length"
            placeholderText: "Length"
            onValueChanged: {
                growth.length = value;
            }
        }
        MWB.WeightField {
            id: weight
            width: parent.width - 16
            labelText: "Weight"
            placeholderText: "Weight"
            onValueChanged: {
                growth.weight = value;
            }
        }
        MWB.LengthField {
            id: headCircumference
            width: parent.width - 16
            labelText: "Head Circumference"
            placeholderText: "Circumference"
            onValueChanged: {
                growth.headCircumference = value;
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
            font.pointSize: 18
            color: Colours.almostWhite
            text: "save"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if ( save ) {
                        save( growth );
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
    onGrowthChanged: {
        if ( growth.length ) length.value = growth.length;
        if ( growth.weight ) weight.value = growth.weight;
        if ( growth.headCircumference ) headCircumference.value = growth.headCircumference;
    }
    //
    //
    //
    property var save: null
    property var cancel: null
    property var growth: ({})
}
