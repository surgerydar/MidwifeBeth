import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.5

import SodaControls 1.0
import "colours.js" as Colours
import "controls" as MWB

ApplicationWindow {
    id: applicationWindow
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
        roles: [ '_id', 'page_id', 'type', 'title', 'content', 'width', 'height' ]
        sort: { "index": 1 }
    }
    DatabaseList {
        id: tags
        collection: 'tags'
        roles: [ 'tag', 'count' ]
        function addTag( tag ) {
            var existing = findOne({tag:tag});
            if ( existing ) {
                existing.count += 1
                update( {_id:existing._id},{count:(existing.count+1)});
            } else {
                add( { tag: tag, count: 1 } );
            }
        }
    }
    DatabaseList {
        id: babies
        collection: 'babies'
        roles: [ '_id', 'firstName', 'middleNames', 'lastName', 'dob', 'tob', 'birthweight', 'gender', 'profilePhoto', 'photos', 'notes', 'data' ]
        sort: { "name": 1 }
    }
    DatabaseList {
        id: bookmarks
        collection: "bookmarks"
        roles: [ '_id', 'title', 'link' ]
        sort: { 'title': 1 }
    }
    //
    //
    //
    StackView {
        id: stack
        anchors.top: title.bottom
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.right: parent.right
    }
    //
    //
    //
    Rectangle {
        id: title
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: stack.depth <= 1 ? 64 : 0
        color: Colours.lightGreen
        clip: true
        //
        //
        //
        Behavior on height {
            NumberAnimation {
                duration: 500
                easing.type: Easing.InCubic
            }
        }
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
        id: home
        width: 64
        height: 64
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 4
        radius: 32
        color: "transparent"
        opacity: .4
        //visible: stack.depth > 1
        Image {
            anchors.fill: parent
            anchors.margins: 8
            fillMode: Image.PreserveAspectFit
            source:  'icons/main_menu.png'
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                stack.pop(null);
            }
        }
        state: stack.depth > 1 ? "visible" : "hidden"
        states: [
            State {
                name: "visible"
                AnchorChanges {
                    target: home
                    anchors.bottom: undefined
                    anchors.top: home.parent.top
                }
            },
            State {
                name: "hidden"
                AnchorChanges {
                    target: home
                    anchors.bottom: home.parent.top
                    anchors.top: undefined
                }
            }
        ]
        transitions: Transition {
            AnchorAnimation {
                duration: 500
                easing.type: Easing.InCubic
            }
        }
        onStateChanged: {
            console.log( "home.state= " + state );
        }
    }

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
    /*
    //
    //
    //
    Rectangle {
        id: search
        width: 64
        height: 64
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 4
        radius: 32
        color: Colours.darkOrange
        opacity: .8
        visible: stack.depth === 1
        Image {
            anchors.fill: parent
            anchors.margins: 8
            fillMode: Image.PreserveAspectFit
            source:  'icons/search.png'
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                stack.push("qrc:///Search.qml")
            }
        }
    }
    //
    //
    //
    Rectangle {
        id: refresh
        width: 64
        height: 64
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 4
        radius: 32
        color: Colours.darkOrange
        opacity: .8
        visible: stack.depth === 1
        Image {
            anchors.fill: parent
            anchors.margins: 8
            fillMode: Image.PreserveAspectFit
            source:  'icons/refresh.png'
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                refreshData();
            }
        }
    }
    */
    //
    //
    //
    Rectangle {
        id: fullscreenContainer
        anchors.fill: parent
        color: "black"
        visible: false
    }
    //
    //
    //
    MWB.ConfirmDialog {
        id: confirmDialog
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
                stack.clear();
                var mainMenu = pages.findOne({title:"Main Menu"});
                //var mainMenu = pages.findOne({title:"Test Page"});
                if ( mainMenu ) {
                    var param = {filter:{page_id:mainMenu._id},hideToolbar:true};
                    console.log( 'home screen = ' + JSON.stringify(param) ) ;
                    stack.push("qrc:///Page.qml", param);
                } else {
                    stack.push("qrc:///SectionsGrid.qml");
                }
                //stack.push("qrc:///SectionsGrid.qml");
                //stack.push("qrc:///MyBabies.qml");
                //stack.push("qrc:///MeasureFieldBuilder.qml");
            } else if( destination.indexOf( 'pages' ) >= 0 ) {
                pages.load();
                //
                // extract tags
                //
                tags.clear();
                for ( var i = 0; i < pages.count; ++i ) {
                    var page = pages.get(i);
                    //
                    // TODO: consider moving this serverside
                    //
                    //
                    // convert string into array
                    //
                    var newTags = pages.get(i).tags.split(',');
                    //
                    // remove trailing spaces and convert to lowercase
                    //
                    var sanitisedTags = [];
                    newTags.forEach( (tag)=>{
                                        var sanitisedTag = tag.trim().toLowerCase();
                                        if ( sanitisedTag.length > 0 ) {
                                            sanitisedTags.push(sanitisedTag);
                                        }
                                    });
                    //
                    // add tags to tag db
                    //
                    sanitisedTags.forEach( (tag)=>{
                                              console.log( 'adding tag : ' + tag );
                                              tags.addTag(tag);
                                          });
                    //
                    // replace page tags with array
                    //
                    pages.update({_id:page._id},{tags:sanitisedTags});
                }
                tags.save();
                pages.save();
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
        //
        //
        refreshData();
    }
    //
    //
    //
    function refreshData() {
        //
        // download latest from admin
        //
        Downloader.download('https://app.midwifebeth.com:8080/blocks?format=json',SystemUtils.documentPath('blocks.json'));
        Downloader.download('https://app.midwifebeth.com:8080/pages?format=json',SystemUtils.documentPath('pages.json'));
        Downloader.download('https://app.midwifebeth.com:8080/sections?format=json',SystemUtils.documentPath('sections.json'));
    }
    function processLink( url, title ) {
        console.log( 'link clicked : ' + url  );
        if ( url.startsWith('link://') ) {
            var components = url.substring('link://'.length).split('/');
            if ( components.length >= 1) {
                var category = components[ 0 ];
                var _id = components.length > 1 ? components[ 1 ] : undefined;
                switch( category ) {
                case 'sections' :
                    var section = sections.findOne({_id:_id});
                    if ( section ) {
                        stack.push("qrc:///Pages.qml", {title:title||section.title,filter:{section_id:_id}});
                    }
                    break;
                case 'pages' :
                    var page = pages.findOne({_id:_id});
                    if ( page ) {
                        stack.push("qrc:///Page.qml", {title:title||page.title,filter:{page_id:_id}});
                    }
                    break;
                case 'myfamily' :
                    stack.push("qrc:///MyFamily.qml");
                    break;
                case 'bookmarks' :
                    stack.push("qrc:///Bookmarks.qml");
                    break;
                }
            }
        } else if ( url.startsWith('http://') || url.startsWith('https://') ) {
            Qt.openUrlExternally(url);
        }
    }
}
