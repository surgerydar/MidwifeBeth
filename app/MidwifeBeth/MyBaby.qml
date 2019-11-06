import QtQuick 2.13
import QtQuick.Controls 2.1
import QtQml.Models 2.1

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
            text: baby.firstName || "My Baby"
        }
    }
    //
    //
    //
    ListView {
        id: contentView
        anchors.fill: parent
        anchors.topMargin: subtitle.visible ? subtitleContainer.height + 4 : 4
        spacing: 4
        topMargin: 4
        bottomMargin: 4
        clip: true
        //
        //
        //
        model: ListModel {}
        delegate: MWB.Block {
            anchors.left: parent.left
            anchors.right: parent.right
            type: model.type
            media: model.content || null
            title: model.title || ""
            onUpdateContent: {
                console.log( 'DiaryEntry : updating content : ' + JSON.stringify(media) );
                contentView.model.set( index, { content: media });
                container.save();
            }
            ListView.onAdd: {
                console.log('MyBaby.contentView.delegate.ListView.onAdd : ' + JSON.stringify({type:model.type,title: model.title,content: model.content}));
                if ( Object.keys(model.content).length === 0 ) {
                    if ( editContent() ) {
                        contentView.positionViewAtIndex(index,ListView.Beginning);
                    }
                }
            }
        }
        //
        //
        //
        header: MyBabyInfo {
            profilePhoto: baby.profilePhoto ? 'file://' + SystemUtils.documentPath(baby.profilePhoto) : "/icons/profile.png"
            firstName: baby.firstName ? baby.firstName : ""
            middleNames: baby.middleNames ? baby.middleNames : ""
            surname: baby.surname ? baby.surname : ""
            birthDateTime: baby.birthDate ? new Date(baby.birthDate) : new Date()
            birthWeight: baby.birthWeight ? baby.birthWeight : 0.
            onProfilePhotoChanged: {
                let newProfilePhoto    = profilePhoto.toString();
                if ( newProfilePhoto.length > 0 ) {
                    newProfilePhoto = newProfilePhoto.substring(newProfilePhoto.lastIndexOf('/')+1);
                    if ( newProfilePhoto !== baby.profilePhoto ) {
                        baby.profilePhoto   = newProfilePhoto.substring(newProfilePhoto.lastIndexOf('/')+1);
                        container.save();
                    }
                }
            }
        }
        //
        //
        //
        footerPositioning: ListView.OverlayFooter
        footer: Rectangle {
            width: contentView.width
            height: 72
            z: 2
            color: Colours.midGreen
            //
            //
            //
            MWB.RoundButton {
                id: addButton
                width: 64
                height: 64
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                image: "../icons/PLUS ICON 96 BOX.png"
                onClicked: {
                    addPopup.openPinned(Qt.point(container.width/2,container.height-80),MWB.PinnedPopup.PinEdge.Bottom);
                }
            }
        }
    }
    //
    //
    //
    //
    //
    //
    MWB.PinnedPopup {
        id: addPopup
        pinEdge: MWB.PinnedPopup.PinEdge.Bottom
        model: ["Growth","Feed","Sleep","Nappy","Medication","Appointment","Milestone","Photo"]
        delegate: Rectangle {
            height: 64
            width: container.width / 3
            color: Colours.almostBlack
            Label {
                anchors.centerIn: parent
                color: Colours.almostWhite
                font.pointSize: 18
                verticalAlignment: Label.AlignVCenter
                horizontalAlignment: Label.AlignHCenter
                text: modelData
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log( 'selected:' + model.index );
                        addBlock( ( modelData.charAt(0).toLowerCase() + modelData.slice(1) ) );
                        addPopup.close();
                    }
                }
            }
        }
    }
    //
    //
    //
    StackView.onActivating: {
        if ( dataLoaded ) return; // prevent reload
        if ( !baby.diary ) {
            baby.diary = [];
            return;
        }
        //
        // populate diary list
        //
        contentView.model.clear();
        baby.diary.forEach(function(block) {
            contentView.model.append( block );
        });
        //
        //
        //
        dataLoaded = true;
    }
    StackView.onDeactivating: {
        save();
    }
    //
    //
    //
    //
    //
    //
    function addBlock( type ) {
        //
        // find existing block
        //
        for ( let i = 0; i < contentView.model.count; i++ ) {
            if ( contentView.model.get(i).type === type ) {
                // add entry
                //contentView.itemAtIndex(i).editContent();
                contentView.positionViewAtIndex(i,ListView.Beginning);
                Qt.callLater(()=>{contentView.itemAtIndex(i).editContent();});
                return;
            }
        }
        //
        //
        //
        contentView.model.append({
                                     type: type,
                                     title: "",
                                     content: {}
                             });
        contentView.positionViewAtIndex(contentView.model.count,ListView.Beginning);
    }
    function save() {
        //
        // save birth info
        //
        if ( info ) {
            let profilePhoto    = info.profilePhoto.toString();
            baby.profilePhoto   = profilePhoto.substring(profilePhoto.lastIndexOf('/')+1);
            baby.firstName      = info.firstName;
            baby.middleNames    = info.middleNames;
            baby.surname        = info.surname;
            baby.birthDate      = info.birthDateTime.getTime();
            baby.birthWeight    = info.birthWeight;
        }
        //
        // save diary
        //
        baby.diary = [];
        for ( let i = 0; i < contentView.model.count; i++ ) {
            let block = contentView.model.get(i);
            baby.diary.push({
                                type: block.type,
                                title: block.title,
                                content: block.content
                            });
        }
        //
        //
        //
        console.log( "MyBaby.StackView.onDeactivating : saving : " + JSON.stringify(baby) );
        babies.update({_id:baby._id},baby);
        babies.save();
    }

    property alias info: contentView.headerItem
    property var baby: ({})
    property bool dataLoaded: false
}
