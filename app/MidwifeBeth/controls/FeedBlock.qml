import QtQuick 2.13
import QtQuick.Controls 2.5

import "../colours.js" as Colours
import "../controls" as MWB

MWB.HorizontalListView {
    id: container
    labelText: "Feed"
    //
    //
    //
    model: ListModel {}
    delegate: Item {
        height: parent.height
        width: height
        Image {
            fillMode: Image.PreserveAspectCrop
            //source: // feed icon bottle, breast solid
        }
    }
    onAdd: {
        // push feed editor
    }

    //
    //
    //
    onMediaChanged: {
        /*
          {
            time: time,
            type: breast|bottle|solids
            info: feed specific info
            note: extra note
          }
          info:
            breast: duration,left|right|both
            bottle: quantity
          */
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
