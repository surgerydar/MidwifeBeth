import QtQuick 2.7
import QtQuick.Controls 2.1

import SodaControls 1.0

import "../colours.js" as Colours
import "../utils.js" as Utils

Item {
    id: container
    //
    //
    //
    Rectangle {
        anchors.fill: parent
        color: Colours.midGreen
    }
    //
    //
    //
    Row {
        spacing: 4
        anchors.fill: parent
        //
        //
        //
        Tumbler {
            id: day
            width: ( parent.width - 8 ) / 3
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            //
            //
            //
            model: dateModel.daysInMonth
            //
            //
            //
            background: Rectangle {
                anchors.fill: parent
                color: Colours.almostWhite
            }
            //
            //
            //
            delegate: Label {
                height: 64
                width: parent.width
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                opacity: 0.4 + Math.max(0, 1 - Math.abs(Tumbler.displacement)) * 0.6
                color: Colours.almostBlack
                font.pointSize: 18
                text: index + 1
            }
            //
            //
            //
            onCurrentIndexChanged: {
                if ( !moving ) return;
                if ( currentIndex > -1 ) {
                    dateModel.day = currentIndex + 1;
                }
            }
            //
            //
            //
            function currentValue() {
                return currentIndex;
            }
        }
        Tumbler {
            id: month
            width: ( parent.width - 8 ) / 3
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            //
            //
            //
            model: 12
            //
            //
            //
            background: Rectangle {
                anchors.fill: parent
                color: Colours.almostWhite
            }
            //
            //
            //
            delegate: Label {
                height: 64
                width: parent.width
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                opacity: 0.4 + Math.max(0, 1 - Math.abs(Tumbler.displacement)) * 0.6
                color: Colours.almostBlack
                //font.family: fonts.light
                font.pointSize: 18
                text: textMonth ? Utils.longMonth(index) : index + 1
            }
            //
            //
            //
            onCurrentIndexChanged: {
                if ( !moving ) return;
                if ( currentIndex > -1 ) {
                    dateModel.month = currentIndex + 1;
                }
            }
        }
        Tumbler {
            id: year
            width: ( parent.width - 8 ) / 3
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            //
            //
            //
            model: RangeModel {
                from: minimumDate.getFullYear()
                to: maximumDate.getFullYear()
            }
            //
            //
            //
            background: Rectangle {
                anchors.fill: parent
                color: Colours.almostWhite
            }
            //
            //
            //
            delegate: Label {
                height: 64
                width: parent.width
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                opacity: 0.4 + Math.max(0, 1 - Math.abs(Tumbler.displacement)) * 0.6
                color: Colours.almostBlack
                font.pointSize: 18
                text: model.value
            }
            //
            //
            //
            onCurrentIndexChanged: {
                if ( !moving ) return;
                if ( currentIndex > -1 ) {
                    dateModel.year = model.get(currentIndex);
                }
            }
        }
    }
    function resetDisplay() {
        year.currentIndex = dateModel.year - minimumDate.getFullYear();
        month.currentIndex = dateModel.month - 1;
        day.currentIndex = dateModel.day - 1;
    }
    Component.onCompleted: {
        resetDisplay();
    }
    onDateModelChanged: {
        resetDisplay();
    }
    //
    //
    //
    //
    property bool blockUpdate: false
    property bool textMonth: true
    property date currentDate: new Date()
    property date minimumDate: new Date(0,0)
    property date maximumDate: new Date()
    property DateModel dateModel: DateModel {}
}
