import QtQuick 2.13
import QtQuick.Controls 2.5

import "../colours.js" as Colours
import "../utils.js" as Utils
import "../controls" as MWB

MWB.HorizontalListView {
    id: container
    labelText: "Medication"
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
        Text {
            anchors.fill: parent
            padding: 4
            wrapMode: Text.WordWrap
            elide: Text.ElideRight
            fontSizeMode: Label.Fit
            minimumPointSize: 18
            font.pointSize: 32
            text: model.name
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
                container.media.appointment.splice(index,1);
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
        stack.push("qrc:///controls/MedicationEditor.qml", {
                       medication: index !== undefined ? media.medication[index] : {},
                       save: function ( medication ) {
                           let date = new Date(medication.time);
                           medication.date = Qt.formatDate(date,'yyyy-MMM-dd');
                           if ( index !== undefined ) {
                               model.set(index,medication);
                               media.medication[index] = medication;
                           } else {
                               model.append(medication);
                               media.medication.push(medication);
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
            if ( media.medication ) {
                media.medication.forEach((medication)=>{model.append(medication)});
            } else {
                media.medication = [];
            }
        } catch ( error ) {
            console.log( 'medicationBlock.onMediaChanged : error : ' + error + ' : media=' + JSON.stringify(media));
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
