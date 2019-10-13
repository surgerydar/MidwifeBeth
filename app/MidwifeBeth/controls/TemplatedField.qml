import QtQuick 2.13
import QtQuick.Controls 2.5
import "../colours.js" as Colours

Item {
    id: container
    height: 60
    //
    //
    //
    Rectangle {
        anchors.fill: parent
        color: Colours.almostWhite
    }
    //
    //
    //
    Component {
        id: label
        Label {
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    Component {
        id: field
        TextField {
            anchors.verticalCenter: parent.verticalCenter
            background: Rectangle {
                anchors.fill: parent
                anchors.bottomMargin: 4
                radius: 2
                color: Colours.lightGreen
            }
        }
    }
    //
    //
    //
    Row {
        id: layout
        anchors.verticalCenter: parent.verticalCenter
        padding: 8
        spacing: 4
    }
    //
    //
    //
    onTemplateChanged: {
        parseTemplate();
    }
    Component.onCompleted: {
        parseTemplate()
    }
    //
    //
    //
    signal textChanged(int fieldIndex, string text);
    //
    //
    //
    function parseTemplate() {
        clear();
        let index = 0;
        let current = template;
        let count = 0;
        while (current.length>0) {
            let start = current.indexOf('[');
            if ( start === 0 ) {
                //
                // input field
                //
                let end = current.indexOf(']',start);
                if ( end > start ) {
                    let properties = {};
                    if ( end - start > 1 ) {
                        let json = current.substring(start+1,(end - start));
                        try {
                            console.log('TemplatedField.parseTemplate : setting properties to : ' + json );
                            properties = JSON.parse(json);
                        } catch( error ) {
                            console.log( 'TemplatedField.parseTemplate : error parsing : "' + json + '" : ' + error );
                        }
                    }
                    let newField = field.createObject(layout,properties);
                    let fieldIndex = fields.length;
                    newField.onTextChanged.connect(function(fieldText) {
                        //console.log( 'TemplatedField.textChanged(' + fieldIndex + ',' + newField.text );
                        container.textChanged(fieldIndex,newField.text);
                    });
                    newField.onFocusChanged.connect(function() {
                        let hasFocus = false;
                        for ( let i = 0; i < fields.length; i++ ) {
                            if ( fields[i].activeFocus ) {
                                hasFocus = true;
                                break;
                            }
                        }
                        fieldFocusChanged(hasFocus);
                    });
                    fields.push(newField);
                    start = end;
                }
                current = current.substring( start + 1 );
            } else {
                let separator = "";
                if ( start > 0 ) {
                    separator = current.substring(0,start);
                } else {
                    separator = current;
                    start = separator.length;
                }
                label.createObject(layout,{text:separator});
                current = current.substring( start );
            }
        }
    }
    //
    //
    //
    signal fieldFocusChanged(bool focus)
    //
    //
    //
    function clear() {
        //
        // clear ui
        //
        fields = [];
        for( let i = 0; i  < layout.children.length; i++ ) {
            layout.children[ i ].destroy();
        }
    }
    function grabFocus() {
        if ( fields.length > 0 ) fields[0].forceActiveFocus();
    }
    property var fields: []
    property string template: ""
}
