import QtQuick 2.13
import QtQuick.Controls 2.5

import "../colours.js" as Colours
import "../controls" as MWB

MWB.HorizontalListView {
    id: container
    labelText: "Growth"
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
            source: "/icons/GRAPH ICON 96 BOX.png";
        }
        Column {
            anchors.fill: parent
            anchors.margins: 4
            Label {
                id: day
                width: parent.width / 2
                height: contentHeight
                font.pointSize: 48
                fontSizeMode: Label.HorizontalFit
                lineHeight: .8
                color: Colours.almostBlack
                text: model.date.split('-')[2]
            }
            Label {
                id: month
                width: parent.width / 2
                height: contentHeight
                font.pointSize: 48
                fontSizeMode: Label.HorizontalFit
                lineHeight: .9
                color: Colours.almostBlack
                text: model.date.split('-')[1]
            }
            Label {
                id: year
                width: parent.width / 2
                height: contentHeight
                font.pointSize: 48
                fontSizeMode: Label.HorizontalFit
                lineHeight: .9
                color: Colours.almostBlack
                text: model.date.split('-')[0]
            }
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
                container.media.growth.splice(index,1);
                container.updateContent();
            }
        }
    }
    tools: [
        MWB.RoundButton {
            width: 32
            height: width
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 8
            image: "/icons/GRAPH ICON 96 BOX.png"
            onClicked: {
                stack.push("qrc:///controls/DataChart.qml", {
                               title: "Growth",
                               dataSets: [ {key:"length",label:"Length", units: "cm", min: 44.0, max: 84.0 }, {key:"weight",label:"Weight", units: "kg", min: 0.5, max: 14.0 }, {key:"headCircumference",label:"Head Circumference", units: "cm", min: 31.0, max: 50.0 } ], // TODO: the min/max values derived from centiles for age range
                               chartData: media.growth
                           });
            }
        }
    ]
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
        stack.push("qrc:///controls/GrowthEditor.qml", {
                       growth: index !== undefined ? media.growth[index] : {},
                       save: function ( growth ) {
                           if ( index !== undefined ) {
                               model.set(index,growth);
                               media.growth[index] = growth;
                           } else {
                               let date = new Date();
                               growth.time = date.getTime();
                               growth.date = Qt.formatDate(date,'yyyy-MMM-dd');
                               model.append(growth);
                               media.growth.push(growth);
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
            if ( media.growth ) {
                media.growth.forEach((growth)=>{model.append(growth)});
            } else {
                media.growth = [];
            }
        } catch ( error ) {
            console.log( 'growthBlock.onMediaChanged : error : ' + error + ' : media=' + JSON.stringify(media));
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
    property var media: ({})
    property string title: ""
    property int contentWidth: 0
    property int contentHeight: 0
}
