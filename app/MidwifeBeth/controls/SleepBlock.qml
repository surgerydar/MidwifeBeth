import QtQuick 2.13
import QtQuick.Controls 2.5

import "../colours.js" as Colours
import "../utils.js" as Utils
import "../controls" as MWB

MWB.HorizontalListView {
    id: container
    labelText: "Sleep"
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
            source: "/icons/sleep.png"
        }
        Column {
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: 4
            spacing: 4
            MWB.TitleBox {
                id: startTime
                anchors.right: parent.right
                text: formatTime(model.startTime)
            }
            MWB.TitleBox {
                id: duration
                color: Colours.almostBlack
                text: Utils.formatDuration(model.startTime,model.endTime)
            }
            Image {
                anchors.right: parent.right
                source: "/icons/timer.png"
                visible: !( model.startTime && model.endTime && model.startTime < model.endTime )
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        media.sleep[ index ].endTime = new Date();
                        container.model.set(index,media.sleep[ index ]);
                    }
                }
            }
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
        stack.push("qrc:///controls/SleepEditor.qml", {
                       sleep: index !== undefined ? media.sleep[index] : {},
                       save: function ( sleep ) {
                           if ( index !== undefined ) {
                               model.set(index,sleep);
                               media.sleep[index] = sleep;
                           } else {
                               model.append(sleep);
                               media.sleep.push(sleep);
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
            if ( media.sleep ) {
                media.sleep.forEach((sleep)=>{model.append(sleep)});
            } else {
                media.sleep = [];
            }
        } catch ( error ) {
            console.log( 'SleepBlock.onMediaChanged : error : ' + error + ' : media=' + JSON.stringify(media));
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
