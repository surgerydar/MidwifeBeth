import QtQuick 2.13
import QtQuick.Controls 2.5

import "../colours.js" as Colours
import "../utils.js" as Utils
import "../controls" as MWB

MWB.HorizontalListView {
    id: container
    labelText: "Nappy"
    //
    //
    //
    model: ListModel {}
    delegate: Item {
        height: parent.height
        width: height
        Rectangle {
            anchors.fill: parent
            color: Colours.almostWhite
        }
        Image {
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            opacity: .25
            source: "/icons/TOILET ICON 96 BOX.png";
        }
        MWB.TitleBox {
            id: time
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: 4
            text: formatTime(model.time)
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                container.editContent(index);
            }
        }
        //
        //
        //
        MWB.BlockDeleteButton {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 4
            deleteAction: function() {
                container.media.nappy.splice(index,1);
                container.updateContent();
            }
        }
    }
    //
    //
    //
    section.property: "date"
    section.delegate: MWB.DateSectionDelegate {}
    //
    //
    //
    onAdd: {
        editContent();
    }
    //
    //
    //
    function editContent(index) {
        stack.push("qrc:///controls/NappyEditor.qml", {
                       nappy: index !== undefined ? media.nappy[index] : {},
                       save: function ( nappy ) {
                           let date = new Date(nappy.time);
                           nappy.date = Qt.formatDate(date,'yyyy-MMM-dd');
                           if ( index !== undefined ) {
                               model.set(index,nappy);
                               media.nappy[index] = nappy;
                           } else {
                               model.append(nappy);
                               media.nappy.push(nappy);
                           }
                           container.updateContent();
                           if ( index !== undefined ) {
                               listView.positionViewAtIndex(index, ListView.Contain);
                           } else {
                               listView.positionViewAtEnd();
                           }
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
            if ( media.nappy ) {
                media.nappy.forEach((nappy)=>{model.append(nappy)});
            } else {
                media.nappy = [];
            }
        } catch ( error ) {
            console.log( 'NappyBlock.onMediaChanged : error : ' + error + ' : media=' + JSON.stringify(media));
        }
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
    function formatTime(time) {
        return Qt.formatTime(new Date(time),'hh:mm ap');
    }
    //
    //
    //
    property var media: ({})
    property string title: ""
    property int contentWidth: 0
    property int contentHeight: 0
}
