import QtQuick 2.13
import QtQuick.Controls 2.5

import "../colours.js" as Colours
import "../controls" as MWB

MWB.HorizontalListView {
    id: container
    labelText: "Photos"
    //
    //
    //
    model: ListModel {}
    delegate: Item {
        height: parent.height
        width: height
        Image {
            fillMode: Image.PreserveAspectCrop
            source: model.image
        }
    }
    onAdd: {
        editContent();
    }
    //
    //
    //
    function editContent() {
        stack.push("qrc:///controls/PhotoChooser.qml", {
                       save: function ( source ) {
                           console.log( 'adding photo : ' + source );
                           let image = {image:source.toString(),caption:""};
                           model.append(image);
                           if ( !Array.isArray(media) ) media = [];
                           media.push(image);
                           console.log( 'PhotoBlock.media=' + JSON.stringify(media));
                           container.updateContent();
                           listView.positionViewAtEnd();
                           stack.pop();
                       },
                       cancel: function() {
                           stack.pop();
                       }
                   });
    }
    //
    //
    //
    onMediaChanged: {
        try {
            model.clear();
            if ( Array.isArray(media) ) {
                media.forEach( function(image) {
                    model.append(image);
                });
            } else {
                media = [];
            }
        } catch ( error ) {
            console.log( 'PhotoBlock.onMediaChanged : error : ' + error + ' : media=' + JSON.stringify(media));
        }
    }
    Component.onDestruction: {
        console.log( 'PhotoBlock.onDestroyed' );
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
    property var media: []
    property string title: ""
    property int contentWidth: 0
    property int contentHeight: 0
}