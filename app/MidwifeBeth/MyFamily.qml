import QtQuick 2.6
import QtQuick.Controls 2.1

import "colours.js" as Colours
import "controls" as MWB

Item {
    id: container
    //
    //
    //
    Rectangle {
        id: subtitleContainer
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 64
        color: Colours.midGreen
        //
        //
        //
        Label {
            id: subtitle
            anchors.fill: parent
            anchors.margins: 4
            font.pixelSize: 48
            font.weight: Font.Bold
            fontSizeMode: Label.Fit
            horizontalAlignment: Label.AlignHCenter
            verticalAlignment: Label.AlignVCenter
            color: Colours.almostWhite
            text: "My Family"
        }
    }
    //
    //
    //
    MWB.EditableList {
        id: content
        anchors.fill: parent
        anchors.topMargin: subtitle.visible ? subtitleContainer.height + 4 : 4
        spacing: 4
        clip: true
        model: babies
        delegate: MWB.EditableListItem {
            id: delegateContainer
            width: parent.width
            swipeEnabled: false
            contentItem: Rectangle {
                width: parent.width
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                color: Colours.midGreen
                Image {
                    id: icon
                    width: height
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    anchors.margins: 4
                    source: model.profilePhoto ? model.profilePhoto : "/icons/profile.png"
                    onStatusChanged: {
                        if ( status === Image.Error ) source = "/icons/profile.png";
                    }
                }
                Label {
                    anchors.left: icon.right
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.margins: 16
                    font.pointSize: 24
                    color: Colours.almostWhite
                    text: model.firstName ? model.firstName : ""
                }
                MouseArea {
                    anchors.fill: parent
                    enabled: !delegateContainer.swipeEnabled
                    onClicked: {
                        delegateContainer.select();
                    }
                }
            }
            onEdit: {
                select();
            }
            onRemove: {
                babies.remove( {_id: model._id} );
            }
            function select() {
                var baby = babies.findOne({_id: model._id});
                if ( baby ) {
                    stack.push("qrc:///MyBaby.qml",{baby:baby});
                } else {
                    console.log( 'MyFamily : unable to find child : ' + model._id );
                }
            }

        }
        //
        //
        //
        onAddItem: {
            var newBaby = {};
            newBaby["_id"] = babies.add(newBaby);
            babies.save();
            stack.push("qrc:///MyBaby.qml",{baby:newBaby});
        }
    }
}
