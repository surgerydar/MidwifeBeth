import QtQuick 2.13
import QtQuick.Controls 2.5

import "../colours.js" as Colours
import "../controls" as MWB

MWB.HorizontalListView {
    id: container
    labelText: "feed"
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
            source: feedIcon(model.type);
        }
        Label {
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            padding: 4
            color: Colours.almostBlack
            font.pointSize: 18
            font.bold: true
            horizontalAlignment: Label.AlignRight
            text: formatTime(model.time);
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                container.editContent(index);
            }
        }
    }
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
