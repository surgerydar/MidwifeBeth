import QtQuick 2.13
import QtQuick.Controls 2.5
import "../controls" as MWB
import "../colours.js" as Colours

MWB.TemplatedField {
    id: container
    //
    //
    //
    Label {
        id: unitSelector
        anchors.right: container.right
        anchors.rightMargin: 4
        anchors.verticalCenter: container.verticalCenter
        padding: 2
        color: Colours.almostWhite
        text: units.length > 0 && currentUnit >= 0 && currentUnit < units.length ? units[ currentUnit ].label : "unit"
        background: Rectangle {
            anchors.fill: parent
            radius: 2
            color: Colours.almostBlack
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                let nextUnit = currentUnit + 1;
                if ( nextUnit >= units.length ) {
                    currentUnit = 0;
                } else {
                    currentUnit = nextUnit;
                }
                grabFocus();
            }
        }
    }
    //
    //
    //
    function initialiseUnitDisplay() {
        if ( units.length > 0 && currentUnit >= 0 && currentUnit < units.length ) {
            template = units[currentUnit].template;
            units[currentUnit].toDisplay(value);
        } else {
            template = "";
        }
    }
    //
    //
    //
    onCurrentUnitChanged: {
        initialiseUnitDisplay();
    }
    onTextChanged: {
        if ( units.length > 0 && currentUnit >= 0 && currentUnit < units.length && units[currentUnit].fromDisplay ) {
            for ( let i = 0; i < fields.length; i++ ) {
                if ( isNaN(parseInt(fields[ i ].text)) ) return;
            }
            value = units[currentUnit].fromDisplay();
        }
    }
    onValueChanged: {
        if ( fields && fields.length > 0 && units.length > 0 && currentUnit >= 0 && currentUnit < units.length && units[currentUnit].toDisplay ) {
            units[currentUnit].toDisplay(value);
        }
    }
    onUnitsChanged: {
        if ( currentUnit >= units.length ) currentUnit = 0;
        initialiseUnitDisplay();
    }
    //
    //
    //
    Component.onCompleted: {
        initialiseUnitDisplay();
    }
    //
    //
    //
    property var units: []
    property int currentUnit: 0
    property real value: 0.
}
