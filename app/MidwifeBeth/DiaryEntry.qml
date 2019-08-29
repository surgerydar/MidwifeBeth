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
            text: ( baby.firstName ? baby.firstName : "My Baby" ) + ' / ' + Qt.formatDate(date,"MMM dd")
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
        bottomMargin: 4
        clip: true
        model: ListModel { // List of blocks
        }
        delegate: MWB.Block {
            anchors.left: parent.left
            anchors.right: parent.right
            type: model.type
            media: model.content || null
            title: model.title || ""
            onUpdateContent: {
                console.log( 'DiaryEntry : updating content : ' + JSON.stringify(media) );
                contentView.model.set( index, { content: media });
            }
        }
        footerPositioning: ListView.OverlayFooter
        footer: Rectangle {
            width: contentView.width
            height: 72
            z: 2
            color: Colours.midGreen

            //
            //
            //
            Rectangle {
                id: addButton
                width: 64
                height: 64
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                radius: 32
                color: Colours.darkOrange
                opacity: .8
                Image {
                    anchors.fill: parent
                    anchors.margins: 8
                    fillMode: Image.PreserveAspectFit
                    source:  'icons/add.png'
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        addPopup.openPinned(Qt.point(container.width/2,container.height-80),MWB.PinnedPopup.PinEdge.Bottom);
                    }
                }
            }
        }
    }
    //
    //
    //
    MWB.PinnedPopup {
        id: addPopup
        pinEdge: MWB.PinnedPopup.PinEdge.Bottom
        model: ["Growth","Feed","Sleep","Toilet","Medication","Appointments","Note","Photo"]
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
        /*
        Component.onCompleted: {
            pin = Qt.point(container.width/2,container.height-80)
        }
        */
    }
    //
    //
    //
    StackView.onActivating: {
        if ( entry ) {
            console.log( 'DiaryEntry.StackView.onActivating : skipping initialisation' );
            return;
        }
        //
        // find diary entry for date
        //
        entry = null;
        if ( baby.diary ) {
            for ( let i = 0; i < baby.diary.length; i++ ) {
                let currentDate = new Date(baby.diary[ i ].date)
                if ( date.getFullYear() === currentDate.getFullYear() && date.getMonth() === currentDate.getMonth() && date.getDate() === currentDate.getDate() ) {
                    entry = baby.diary[ i ];
                    break;
                }
            }
        } else {
            baby.diary = [];
        }
        //
        // no entry, create new
        //
        if ( entry === null ) {
            entry = { date: date.getTime(), blocks:[] }
            baby.diary.push( entry );
        }
        console.log( 'loading diary entry: ' + JSON.stringify(entry) );
        //
        // populate list
        //
        contentView.model.clear();
        if ( entry.blocks ) {
            entry.blocks.forEach(function(block) {
                contentView.model.append( block );
            });
        }

    }
    StackView.onDeactivating: {
        //
        // update content
        //
        entry.blocks = [];
        for ( let i = 0; i < contentView.model.count; i++ ) {
            let block = contentView.model.get(i);
            console.log( 'block : ' + i + ' : ' + JSON.stringify(block));
            entry.blocks.push({
                                  type: block.type,
                                  title: block.title,
                                  content: block.content
                              });
        }
        //
        // sort diary entries by date
        //
        baby.diary.sort((a,b)=>{ return a.date - b.date; });
        //
        // save
        //
        babies.update({_id:baby._id},baby);
        babies.save();
    }
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
                console.log( 'found block: ' + contentView.itemAtIndex(i) );
                if ( !contentView.itemAtIndex(i).editContent() ) {
                    contentView.positionViewAtIndex(i,ListView.Beginning);
                }

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
    }
    //
    //
    //
    property var entry: null
    property var baby: ({})
    property var date: new Date()
}
