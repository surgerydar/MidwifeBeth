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
    MouseArea {
        anchors.fill: parent
        onClicked: editor.open(true);
    }
    //
    //
    //
    MWB.MeasurementField {
        id: editor
        height: field.height - field.topPadding;
        anchors.top: field.bottom
        anchors.left: field.left
        anchors.right: field.right
        anchors.topMargin: field.topPadding
        //
        //
        //
        transitions: Transition {
            AnchorAnimation { duration: 1000 }
        }
        units: [
            {
                label: 'kg',
                template: '[{"inputMask":"09","maximumLength" : 2}].[{"inputMask":"99","maximumLength" : 2}]kg',
                fromDisplay: function() { return parseFloat(fields[0].text)+(parseFloat(fields[1].text)/Math.pow(10.,fields[1].text.length)); },
                toDisplay: function(b) { fields[0].text = Math.floor(b); fields[1].text = Math.round((b-Math.floor(b)) * 10); }
            },
            {
                label: 'lb',
                template: '[{"inputMask":"09","maximumLength" : 2}]lb [{"inputMask":"09","maximumLength" : 2}]oz',
                fromDisplay: function() {  let lb = parseFloat(fields[0].text) + ( parseFloat(fields[1].text) / 16. ); return lb / 2.2046; },
                toDisplay: function(b) { let lb = b * 2.2046; fields[0].text = Math.floor(lb); fields[ 1 ].text = Math.round(16.0 * (lb-Math.floor(lb))); }
            }
        ]
        onFieldFocusChanged: function(hasFocus) {
            if ( !hasFocus ) open(false);
        }
        function open(show) {
            editing = show;
            if ( show ) {
                editor.anchors.top = field.top;
                Qt.callLater(()=>{editor.grabFocus();})
            } else {
                editor.anchors.top = field.bottom;
            }
        }
        property bool editing: false
    }
    //
    //
    //
    onValueChanged: {
        switch( editor.currentUnit ) {
        case 0:
            text = value.toFixed( 2 ) + 'kg';
            break;
        case 1:
            let lb = value * 2.2046;
            text = Math.floor(lb) + 'lb ' + Math.round( ( lb - Math.floor(lb) ) * 16. ) + 'oz';
            break;
        }
    }
    //
    //
    //
    property alias value: editor.value
}
