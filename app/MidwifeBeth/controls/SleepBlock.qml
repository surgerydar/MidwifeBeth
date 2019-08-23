import QtQuick 2.13
import QtQuick.Controls 2.5

import "../colours.js" as Colours
import "../controls" as MWB

MWB.HorizontalListView {
    id: container
    labelText: "Sleep"
    //
    //
    //
    model: ListModel {}
    delegate: Item {
        height: parent.height
        width: height
        Image {
            fillMode: Image.PreserveAspectCrop
            //source: // sleep icon
        }
    }
    onAdd: {
        // push sleep editor
    }

    //
    //
    //
    onMediaChanged: {
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
