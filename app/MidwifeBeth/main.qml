import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 1.4

import SodaControls 1.0
import "colours.js" as Colours
import "controls" as MWB

Window {
    visible: true
    width: 480
    height: 640
    title: qsTr("Midwife Beth")
    color: Colours.lightGreen
    //
    //
    //
    DatabaseList {
        id: sections
        collection: 'sections'
        roles: [ '_id', 'title', 'tags' ]
        sort: { "index": 1 }

    }
    DatabaseList {
        id: pages
        collection: 'pages'
        roles: [ '_id', 'section_id', 'title', 'tags' ]
        sort: { "index": 1 }
    }
    DatabaseList {
        id: blocks
        collection: 'blocks'
        roles: [ '_id', 'page_id', 'type', 'content' ]
    }
    //
    //
    //
    StackView {
        id: stack
        anchors.fill: parent
        anchors.topMargin: 64
    }
    //
    //
    //
    Rectangle {
        id: title
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 64
        color: Colours.lightGreen
        //
        //
        //
        Label {
            anchors.fill: parent
            anchors.margins: 4
            font.pixelSize: 64
            font.weight: Font.Bold
            fontSizeMode: Label.Fit
            horizontalAlignment: Label.AlignHCenter
            verticalAlignment: Label.AlignVCenter
            color: Colours.almostWhite
            text: "Midwife Beth"
        }
    }
    //
    //
    //
    /*
    Item {
        id: toolBar
        height: 64
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.right: parent.right

    }
    */
    Rectangle {
        id: back
        width: 64
        height: 64
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: 4
        radius: 32
        color: Colours.darkOrange
        opacity: .8
        visible: stack.depth > 1
        Image {
            anchors.fill: parent
            anchors.margins: 8
            fillMode: Image.PreserveAspectFit
            source:  'icons/left_arrow.png'
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                stack.pop();
            }
        }
    }
    //
    //
    //
    Connections {
        target: Downloader
        //
        //
        //
        onDone: {
            if ( destination.indexOf( 'sections' ) >= 0 ) {
                sections.load();
                /*
                var about = sections.findOne({title:"About"});
                if ( about ) {
                    pages.setFilter({section_id: about._id});
                    stack.push("qrc:///Pages.qml");
                } else {
                    console.log( 'unable to find About' );
                }
                */
                //stack.push("qrc:///Sections.qml");
                stack.push("qrc:///SectionsGrid.qml");
            } else if( destination.indexOf( 'pages' ) >= 0 ) {
                pages.load();
            } else if( destination.indexOf( 'blocks') >= 0 ) {
                blocks.load();
            }
        }
    }

    //
    //
    //
    Component.onCompleted: {
        //
        // download latest from admin
        //
        Downloader.download('https://aftertrauma.uk:8080/blocks?format=json',SystemUtils.documentPath('blocks.json'));
        Downloader.download('https://aftertrauma.uk:8080/pages?format=json',SystemUtils.documentPath('pages.json'));
        Downloader.download('https://aftertrauma.uk:8080/sections?format=json',SystemUtils.documentPath('sections.json'));
        //
        //
        //

    }
}
