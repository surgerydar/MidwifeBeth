import QtQuick 2.13
import QtQuick.Controls 2.5

import "../colours.js" as Colours
import "../utils.js" as Utils
import "../controls" as MWB

MWB.HorizontalListView {
    id: container
    labelText: "Milestone"
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
            opacity: .25
            fillMode: Image.PreserveAspectFit
            source: "/icons/MILESTONE ICON 96 BOX.png"
        }
        Text {
            anchors.fill: parent
            padding: 4
            wrapMode: Text.WordWrap
            elide: Text.ElideRight
            fontSizeMode: Label.Fit
            minimumPointSize: 18
            font.pointSize: 48
            text: model.description
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
                container.media.milestone.splice(index,1);
                container.updateContent();
            }
        }
    }
    section.property: "date"
    section.delegate: MWB.DateSectionDelegate {}

    onAdd: {
        editContent();
    }
    //
    //
    //
    function editContent(index) {
        stack.push("qrc:///controls/MilestoneEditor.qml", {
                       milestone: index !== undefined ? media.milestone[index] : {},
                       save: function ( milestone ) {
                           if ( index !== undefined ) {
                               model.set(index,milestone);
                               media.milestone[index] = milestone;
                           } else {
                               let date = new Date();
                               milestone.time = date.getTime();
                               milestone.date = Qt.formatDate(date,'yyyy-MMM-dd');
                               model.append(milestone);
                               media.milestone.push(milestone);
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
            if ( media.milestone ) {
                media.milestone.forEach((milestone)=>{model.append(milestone)});
            } else {
                media.milestone = [];
            }
        } catch ( error ) {
            console.log( 'milestoneBlock.onMediaChanged : error : ' + error + ' : media=' + JSON.stringify(media));
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
