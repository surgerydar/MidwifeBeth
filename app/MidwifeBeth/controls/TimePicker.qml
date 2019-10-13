import QtQuick 2.13
import QtQuick.Controls 2.5
import SodaControls 1.0
import "../colours.js" as Colours

Item {
    id: container
    //
    //
    //
    Rectangle {
        anchors.fill: parent
        color: Colours.midGreen
    }

    Component {
        id: numberDelegate
        Label {
            text: modelData.toString().length < 2 ? "0" + modelData : modelData
            opacity: 1.0 - Math.abs(Tumbler.displacement) / (Tumbler.tumbler.visibleItemCount / 2)
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pointSize: 24
            color: Colours.almostBlack
        }
    }

    Row {
        anchors.fill: parent
        spacing: 4
        Tumbler {
            id: hourPicker
            width: displayType === TimePicker.DisplayType.TwelveHour ? ( parent.width - 8 ) / 3 : ( parent.width - 4 ) / 2
            height: parent.height
            model: displayType === TimePicker.DisplayType.TwelveHour ? [12,1,2,3,4,5,6,7,8,9,10,11] : 24
            //
            //
            //
            background: Rectangle {
                anchors.fill: parent
                color: Colours.almostWhite
            }
            delegate: numberDelegate
            onCurrentIndexChanged: {
                if ( !moving ) return;
                switch ( displayType ) {
                case TimePicker.DisplayType.TwelveHour:
                    dateModel.hour = currentIndex + ( ampmPicker.currentIndex === 1 ? 12 : 0 );
                    break;
                case TimePicker.DisplayType.TwentyFourHour:
                    dateModel.hour = currentIndex;
                    break;
                }
            }
        }
        Tumbler {
            id: minutePicker
            width: displayType === TimePicker.DisplayType.TwelveHour ? ( parent.width - 8 ) / 3 : ( parent.width - 4 ) / 2
            height: parent.height
            model: 60
            //
            //
            //
            background: Rectangle {
                anchors.fill: parent
                color: Colours.almostWhite
            }
            delegate: numberDelegate
            onCurrentIndexChanged: {
                if ( !moving ) return;
                dateModel.minute = currentIndex;
            }
        }
        Tumbler {
            id: ampmPicker
            width: ( parent.width - 8 ) / 3
            height: parent.height
            model: ["AM","PM"]
            visible: displayType === TimePicker.DisplayType.TwelveHour
            //
            //
            //
            background: Rectangle {
                anchors.fill: parent
                color: Colours.almostWhite
            }
            delegate: numberDelegate
            onCurrentIndexChanged: {
                if ( !moving ) return;
                if ( currentIndex === 1  ) {
                    if ( dateModel.hour < 11 ) {
                        dateModel.hour = dateModel.hour + 12;
                    }
                } else {
                    if ( dateModel.hour > 11 ){
                        dateModel.hour = dateModel.hour - 12;
                    }
                }
            }
        }
    }
    //
    //
    //
    function resetDisplay() {
        switch ( displayType ) {
        case TimePicker.DisplayType.TwelveHour:
            hourPicker.currentIndex = dateModel.hour >= 11 ? dateModel.hour - 12 : dateModel.hour;
            minutePicker.currentIndex = dateModel.minute;
            ampmPicker.currentIndex = dateModel.hour >= 11 ? 1 : 0
            break;
        case TimePicker.DisplayType.TwentyFourHour:
            hourPicker.currentIndex = dateModel.hour;
            minutePicker.currentIndex = dateModel.minute;
            break;
        }

    }
    //
    //
    //
    onDateModelChanged: {
        resetDisplay();
    }
    Component.onCompleted: {
        resetDisplay();
    }
    //
    //
    //
    enum DisplayType {
        TwelveHour,
        TwentyFourHour
    }
    //
    //
    //
    property bool blockUpdate: false
    property DateModel dateModel: DateModel {}
    property int displayType: TimePicker.DisplayType.TwentyFourHour
}
