import QtQuick 2.13
import QtQuick.Controls 2.5

import "../colours.js" as Colours
import "../controls" as MWB

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
