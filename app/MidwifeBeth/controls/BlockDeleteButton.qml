import QtQuick 2.13
import QtQuick.Controls 2.5

import "../colours.js" as Colours
import "../controls" as MWB
MWB.RoundButton {
    id: container
    width: 32
    height: width
    image: "/icons/DELETE ICON 96 BOX.png"
    onClicked: {
        confirmDialog.show('Are you sure?',[{
                                                 label:"Yes",
                                                 action: container.deleteAction || function() {}
                                             },{
                                                 label:"No",
                                                 action: function() {}
                                             }
                           ]);
    }
    property var deleteAction: null
}

/*
MWB.TitleBox {
    id: container
    text: "X"
    z: 2
    MouseArea {
        anchors.fill: parent
        onClicked: {
            confirmDialog.show('Are you sure?',[{
                                                     label:"Yes",
                                                     action: container.action || function() {}
                                                 },{
                                                     label:"No",
                                                     action: function() {}
                                                 }
                               ]);
        }
    }
    property var action: null
}
*/
