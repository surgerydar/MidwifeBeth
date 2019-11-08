import QtQuick 2.13
import QtQuick.Controls 2.5

import "../colours.js" as Colours
import "../controls" as MWB

MWB.HorizontalListView {
    id: container
    labelText: "Feed"
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
            source: "/icons/FEED ICON 96 BOX.png";
        }
        MWB.TitleBox {
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: 4
            text: formatTime(model.time);
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
                container.media.feeds.splice(index,1);
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
        stack.push("qrc:///controls/FeedEditor.qml", {
                       feed: index !== undefined ? media.feeds[index] : {},
                       save: function ( feed ) {
                           let date = new Date(feed.time);
                           feed.date = Qt.formatDate(date,'yyyy-MMM-dd');
                           if ( index !== undefined ) {
                               model.set(index,feed);
                               media.feeds[index] = feed;
                           } else {
                               model.append(feed);
                               media.feeds.push(feed);
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
            if ( media.feeds ) {
                media.feeds.forEach((feed)=>{model.append(feed)});
            } else {
                media.feeds = [];
            }
        } catch ( error ) {
            console.log( 'feedBlock.onMediaChanged : error : ' + error + ' : media=' + JSON.stringify(media));
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
    function feedIcon(type) {
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
