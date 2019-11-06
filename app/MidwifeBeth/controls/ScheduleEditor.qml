import QtQuick 2.13
import QtQuick.Controls 2.5

import "../colours.js" as Colours
import "../utils.js" as Utils
import "../controls" as MWB

Item {
    id: container
    //
    //
    //
    Rectangle {
        id: background
        anchors.fill: parent
        anchors.topMargin: label.visible ? label.height / 2 : 0
        radius: 4
        color: Colours.almostWhite
        border.color: "transparent"
    }
    //
    //
    //
    ListView {
        id: divisions
        anchors.fill: background
        anchors.topMargin: ( label.height / 2 + 4 )
        anchors.bottomMargin: ( mode.height + 2 )
        anchors.leftMargin: 2
        anchors.rightMargin: 2
        orientation: ListView.Horizontal
        spacing: 4

        model: 24
        delegate: Rectangle {
            height: divisions.height
            width: Math.max( divisions.width / divisions.model, divisionLabel.contentWidth + 8 )
            color: selected ? Colours.almostBlack : Colours.almostWhite
            border.color: selected ? Colours.almostWhite : Colours.almostBlack
            Label {
                id: divisionLabel
                anchors.centerIn: parent
                color: parent.selected ? Colours.almostWhite : Colours.almostBlack
                text: `${divisions.model === 24 ?  ( index < 9 ? '0' : '' ) + ( index + 1 ).toString() + ':00' : ( divisions.model === 7 ? 'Day ' + index : 'Week ' + index ) }`
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    parent.selected = !parent.selected;
                    pattern[index] = parent.selected;
                    container.patternElementChanged();
                }
            }
            property bool selected: pattern[index] === true
        }
    }
    //
    //
    //
    Row {
        id: mode
        height: 32
        anchors.top: options.top
        anchors.left: parent.left
        anchors.right: options.left
        anchors.bottom: parent.bottom
        padding: 4
        spacing: 4
        Repeater {
            model: [ "Day", "Week", "Month" ]
            delegate: TitleBox {
                opacity: index === mode.selected ? 1. : .5
                text: modelData
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        savePattern(mode.selected.toString());
                        mode.selected = index;
                    }
                }
            }
        }
        onSelectedChanged: {
            let count = divisions.model;
            switch(selected) {
            case 0 : // Day
                count = 24;
                break;
            case 1 : // Week
                count = 7;
                break;
            case 2 : // Month
                count = 4;
                break;
            }
            restorePattern(selected.toString());
            if ( pattern.length !== count ) pattern = new Array(count);
            divisions.model = count;
        }
        // TODO: make this property of container so it is exposed
        property int selected: 0
    }
    //
    //
    //
    Row {
        id: options
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        CheckBox {
            id: repeatButton
            text: "repeat"
        }
        CheckBox {
            id: notifyButton
            text: "notify"
        }
    }
    //
    //
    //
    TitleBox {
        id: label
        anchors.top: parent.top
        anchors.left: parent.left
    }
    //
    //
    //
    signal patternElementChanged()
    //
    //
    //
    function savePattern( key ) {
        patternStore[key] = [...pattern];
    }
    function restorePattern( key ) {
        if ( patternStore[key] ) {
            pattern = [...patternStore[key]];
        }
    }
    //
    //
    //
    onPatternChanged: {
        switch( pattern.length ) {
        case 24 :
            mode.selected = 0;
            break;
        case 7 :
            mode.selected = 1;
            break;
        case 4 :
            mode.selected = 2;
            break;
        }
    }

    property alias backgroundColour: background.color
    property alias labelText: label.text
    property var pattern: new Array(24)
    property alias repeat: repeatButton.checked
    property alias notify: notifyButton.checked
    property var patternStore: ({})
}
