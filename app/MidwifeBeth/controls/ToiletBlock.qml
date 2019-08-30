import QtQuick 2.13
import QtQuick.Controls 2.5

import "../colours.js" as Colours
import "../utils.js" as Utils
import "../controls" as MWB

MWB.HorizontalListView {
    id: container
    labelText: "Toilet"
    //
    //
    //
    model: ListModel {}
    delegate: Item {
        height: parent.height
        width: height
        Image {
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            source: toiletIcon(model.type);
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
            action: function() {
                container.media.toilet.splice(index,1);
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
        stack.push("qrc:///controls/ToiletEditor.qml", {
                       toilet: index !== undefined ? media.toilet[index] : {},
                       save: function ( toilet ) {
                           let date = new Date(toilet.time);
                           toilet.date = Qt.formatDate(date,'yyyy-MMM-dd');
                           if ( index !== undefined ) {
                               model.set(index,toilet);
                               media.toilet[index] = toilet;
                           } else {
                               model.append(toilet);
                               media.toilet.push(toilet);
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
            if ( media.toilet ) {
                media.toilet.forEach((toilet)=>{model.append(toilet)});
            } else {
                media.toilet = [];
            }
        } catch ( error ) {
            console.log( 'toiletBlock.onMediaChanged : error : ' + error + ' : media=' + JSON.stringify(media));
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
    //
    //
    //
    function toiletIcon(type) {
        return '/icons/' + type + '.png';
    }
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
