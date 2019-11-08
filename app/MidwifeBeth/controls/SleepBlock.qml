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
        Rectangle {
            anchors.fill: parent
            color: Colours.almostWhite
        }

        Image {
            anchors.fill: parent
            opacity: .25
            fillMode: Image.PreserveAspectFit
            source: "/icons/SLEEP ICON 96 BOX.png"
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                container.editContent(index);
            }
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
            MWB.RoundButton {
                width: 32
                height: width
                visible: !( model.startTime && model.endTime && model.startTime < model.endTime )
                image: "/icons/TIMER ICON 96 BOX.png"
                onClicked: {
                    media.sleep[ index ].endTime = Date.now();
                    container.model.set(index,media.sleep[ index ]);
                    container.updateContent();
                }
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
                container.media.sleep.splice(index,1);
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
        stack.push("qrc:///controls/SleepEditor.qml", {
                       sleep: index !== undefined ? media.sleep[index] : {},
                       save: function ( sleep ) {
                           let date = new Date(sleep.startTime);
                           sleep.date = Qt.formatDate(date,'yyyy-MMM-dd');
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
