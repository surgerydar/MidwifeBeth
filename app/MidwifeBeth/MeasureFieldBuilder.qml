import QtQuick 2.13
import QtQuick.Controls 2.5
import "colours.js" as Colours
import "controls" as MWB
Item {
    id: container
    //
    //
    //
    MWB.MeasurementField {
        id: field
        anchors.left: parent.left
        anchors.right: parent.right
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
        onValueChanged: {
            console.log( 'value=' + value );
        }
    }
    //
    //
    //
    TextField {
        id: input
        anchors.top: field.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        onTextChanged: {
            field.template = text;
        }
    }
}
