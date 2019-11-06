import QtQuick 2.13
import QtQuick.Controls 2.5

import "../colours.js" as Colours
import "../utils.js" as Utils
import "../controls" as MWB

MWB.HorizontalListView {
    id: container
    labelText: "Appointments"
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
            source: "/icons/APPOINTMENT ICON 96 BOX.png";
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
        MWB.TitleBox {
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
        stack.push("qrc:///controls/AppointmentEditor.qml", {
                       appointment: index !== undefined ? media.appointment[index] : {},
                       save: function ( appointment ) {
                           let date = new Date(appointment.time);
                           appointment.date = Qt.formatDate(date,'yyyy-MMM-dd');
                           if ( index !== undefined ) {
                               model.set(index,appointment);
                               media.appointment[index] = appointment;
                           } else {
                               model.append(appointment);
                               media.appointment.push(appointment);
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
            if ( media.appointment ) {
                media.appointment.forEach((appointment)=>{model.append(appointment)});
            } else {
                media.appointment = [];
            }
        } catch ( error ) {
            console.log( 'appointmentBlock.onMediaChanged : error : ' + error + ' : media=' + JSON.stringify(media));
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
