import QtQuick 2.6
import QtQuick.Controls 2.1

import "colours.js" as Colours
import "controls" as MWB
import "utils.js" as Utils

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
        toolbar: true
        delegate: MWB.EditableListItem {
            id: delegateContainer
            width: parent.width
            height: content.model.count === 1 ? content.height - 80 : 64
            swipeEnabled: content.editing
            contentItem: Rectangle {
                width: delegateContainer.width
                height: delegateContainer.height
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                color: Colours.midGreen
                Image {
                    id: icon
                    /*
                    width: content.model.count === 1 ? Math.min( ( sourceSize.width / sourceSize.height ) * ( delegateContainer.availableHeight - 72 ), delegateContainer.availableWidth - 16 ) : height
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.left: content.model.count === 1 ? undefined : parent.left
                    anchors.horizontalCenter: content.model.count === 1 ? parent.horizontalCenter : undefined
                    //anchors.margins: 8
                    fillMode: content.model.count === 1 ? Image.PreserveAspectFit : Image.PreserveAspectCrop
                    */
                    width: content.model.count === 1 ? parent.width : height
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    fillMode: Image.PreserveAspectCrop
                    source: model.profilePhoto ? 'file://' + SystemUtils.documentPath(model.profilePhoto) : "/icons/profile.png"
                    onStatusChanged: {
                        if ( status === Image.Error ) {
                            console.log( 'document path= ' + SystemUtils.documentDirectory());
                            source = "/icons/profile.png";
                        }
                    }
                }
                Column {
                    anchors.bottom: icon.bottom
                    anchors.right: icon.right
                    anchors.margins: 8
                    visible: content.model.count === 1
                    spacing: 4
                    MWB.TitleBox {
                        font.pointSize: 24
                        text: model.firstName ? model.firstName : ""
                    }
                    MWB.TitleBox {
                        font.pointSize: 18
                        text: Utils.formatDateSpan(new Date(model.birthDate),new Date())
                    }
                }
                Column {
                    visible: content.model.count > 1
                    anchors.left: icon.right
                    anchors.top: icon.top
                    anchors.leftMargin: 8
                    spacing: 4
                    Label {
                        id: name
                        font.pointSize: 24
                        verticalAlignment: Label.AlignTop
                        color: Colours.almostWhite
                        text: model.firstName ? model.firstName : ""
                    }
                    Label {
                        id: age
                        font.pointSize: 18
                        verticalAlignment: Label.AlignTop
                        color: Colours.almostWhite
                        text: Utils.formatDateSpan(new Date(model.birthDate),new Date())
                    }
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
                console.log('removing baby : ' + model._id );
                Qt.callLater(babies.save);
                babies.remove({_id:model._id});
                //Qt.callLater(removeBaby,model._id);
            }
            //
            //
            //
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
