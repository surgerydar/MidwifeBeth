import QtQuick 2.13
import QtQuick.Controls 2.5

import "../colours.js" as Colours
import "../controls" as MWB

MWB.TextField {
    id: field
    readOnly: true
    clip: true
    //
    //
    //
    MWB.MeasurementField {
        id: editor
        height: field.height - field.topPadding;
        anchors.top: field.bottom
        anchors.left: field.left
        anchors.right: confirmButton.left
        anchors.topMargin: field.topPadding
        //
        //
        //
        transitions: Transition {
            AnchorAnimation { duration: 1000 }
        }
        units: [
            {
                label: 'cm',
                template: '[{"inputMask":"09","maximumLength" : 2}].[{"inputMask":"99","maximumLength" : 2}]cm',
                fromDisplay: function() { return parseFloat(fields[0].text)+(parseFloat(fields[1].text)/Math.pow(10.,fields[1].text.length)); },
                toDisplay: function(b) { fields[0].text = Math.floor(b); fields[1].text = Math.round((b-Math.floor(b)) * 10); }
            },
            {
                label: 'inches',
                template: '[{"inputMask":"09","maximumLength" : 2}].[{"inputMask":"09","maximumLength" : 2}]"',
                fromDisplay: function() {  return (parseFloat(fields[0].text)+(parseFloat(fields[1].text)/Math.pow(10.,fields[1].text.length))) * 2.54; },
                toDisplay: function(b) { let inches = b / 2.54; fields[0].text = Math.floor(inches); fields[1].text = Math.round((inches-Math.floor(inches)) * 10); }
            }
        ]
        function open(show) {
            editing = show;
            if ( show ) {
                editor.anchors.top = field.top;
            } else {
                editor.anchors.top = field.bottom;
            }
        }
        property bool editing: false
    }
    RoundButton {
        id: confirmButton
        anchors.right: parent.right
        anchors.verticalCenter: editor.verticalCenter
        visible: editor.editing
        text: "\u2713" // Unicode Character 'CHECK MARK'
        onClicked: editor.open(false);
    }
    //
    //
    //
    onPressed: editor.open(true);
    //
    //
    //
    onValueChanged: {
        switch( editor.currentUnit ) {
        case 0:
            text = value.toFixed( 2 ) + 'cm';
            break;
        case 1:
            text = ( value / 2.54 ).toFixed( 2 ) + '"';
            break;
        }
    }
    //
    //
    //
    property alias value: editor.value
    //
    //
    //
    /*
    function convertValue() {
        let majorValue = parseFloat(major.text);
        if ( !isNaN(majorValue) ) {
            switch( field.displayUnits ) {
            case 'inches' :
                field.value = majorValue / 2.54;
                break;
            case 'cm' :
                field.value = majorValue;
                break;
            }
        }
        visible = false;
    }
    function formatDisplay() {
        if ( value > 0. ) {
            switch ( displayUnits ) {
            case 'inches' :
                let inches = value * 2.54;
                text = inches.toFixed(2) + '"';
                break;
            case 'cm' :
                text = value.toFixed(2) + 'cm'
                break;
            }
        } else {
            text = "";
        }
    }
    */
}