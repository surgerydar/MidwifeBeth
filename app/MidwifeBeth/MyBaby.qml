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
        id: content
        anchors.fill: parent
        anchors.topMargin: subtitle.visible ? subtitleContainer.height + 4 : 4
        spacing: 4
        bottomMargin: 4
        clip: true
        model: ObjectModel {
            MyBabyInfo {
                id: info
                profilePhoto: baby.profilePhoto ? baby.profilePhoto : "icons/profile.png"
                firstName: baby.firstName ? baby.firstName : ""
                middleNames: baby.middleNames ? baby.middleNames : ""
                surname: baby.surname ? baby.surname : ""
                birthDate: baby.birthDate ? new Date(baby.birthDate) : new Date()
                birthWeight: baby.birthWeight ? baby.birthWeight : ""
            }
            MWB.HorizontalListView {
                id: photoList
                width: content.width
                labelText: "photos"
                onAdd: {
                    stack.push("qrc:///controls/PhotoChooser.qml", {
                                   save: function ( source ) {
                                       console.log( 'adding photo : ' + source );
                                       model.append({image:source.toString(),caption:""});
                                       listView.positionViewAtEnd();
                                       stack.pop();
                                   },
                                   cancel: function() {
                                       stack.pop();
                                   }
                               });
                }
                model: ListModel {}
                delegate: Image {
                    height: parent.height
                    width: height
                    fillMode: Image.PreserveAspectCrop
                    source: model.image
                }
                Component.onCompleted: {
                    if ( baby.photos ) {
                        console.log('photos: ' + JSON.stringify(baby.photos) );
                        for ( var i = 0; i < baby.photos.length; i++ ) {
                            var p = baby.photos[ i ];
                            console.log( 'appending photo : ' + JSON.stringify(p) );
                            model.append(p);
                        }
                    }
                }
            }
            MWB.HorizontalListView {
                id: diaryList
                width: content.width
                labelText: "diary"
            }
        }
        footerPositioning: ListView.OverlayFooter
        footer: Rectangle {
            width: content.width
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
        model: ["Weight","Height","Feeding","Sleep","Vaccination"]
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

    }
    StackView.onDeactivating: {
        baby.profilePhoto = info.profilePhoto; // TODO: convert to document path ???
        baby.firstName = info.firstName;
        baby.middleNames = info.middleNames;
        baby.surname = info.surname;
        baby.birthDate = info.birthDate.getTime();
        baby.birthWeight = info.birthWeight;
        baby.photos = [];
        for ( var i = 0; i < photoList.model.count; i++ ) {
            var p = photoList.model.get(i);
            baby.photos.push({image:p.image,caption:p.caption});
        }

        console.log( "MyBaby.StackView.onDeactivating : saving : " + JSON.stringify(baby) );
        babies.update({_id:baby._id},baby);
        babies.save();
    }

    property var baby: ({})
}
