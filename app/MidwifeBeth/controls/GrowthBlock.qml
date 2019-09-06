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
        Image {
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            source: "/icons/growth.png"
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
            action: function() {
                container.media.growth.splice(index,1);
                container.updateContent();
            }
        }
    }
    tools: [
        Rectangle {
            width: 32
            height: width
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 8
            radius: width / 2
            color: Colours.darkOrange
            Image {
                anchors.fill: parent
                anchors.margins: 4
                fillMode: Image.PreserveAspectFit
                source: "../icons/chart.png"
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    stack.push("qrc:///controls/DataChart.qml", {
                                   title: "Growth",
                                   dataSets: [ {key:"height",label:"Height", units: "cm", min: 44.0, max: 84.0 }, {key:"weight",label:"Weight", units: "kg", min: 0.5, max: 14.0 }, {key:"headDiameter",label:"Head Diameter", units: "cm", min: 31.0, max: 50.0 } ], // TODO: the min/max values derived from centiles for age range
                                   chartData: media.growth
                               });
                }
            }
        },
        Rectangle {
            width: 32
            height: width
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            radius: width / 2
            color: Colours.darkOrange
            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                source: "../icons/add.png"
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    add();
                }
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
