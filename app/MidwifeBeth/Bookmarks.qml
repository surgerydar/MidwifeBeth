import QtQuick 2.13
import QtQuick.Controls 2.5

import "colours.js" as Colours
import "controls" as MWB

Item {
    id: container
    //
    // TODO: generic subtitle
    //
    Rectangle {
        id: subtitleContainer
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 64
        color: Colours.midGreen
        //
        //
        //
        Label {
            id: subtitle
            anchors.fill: parent
            anchors.margins: 4
            font.pixelSize: 48
            font.weight: Font.Bold
            fontSizeMode: Label.Fit
            horizontalAlignment: Label.AlignHCenter
            verticalAlignment: Label.AlignVCenter
            color: Colours.almostWhite
            text: "Bookmarks"
        }
    }
    //
    //
    //
    Rectangle {
        anchors.top: subtitleContainer.bottom
        anchors.left: parent.left
        anchors.bottom: toolbar.top
        anchors.right: parent.right
        color: Colours.lightGreen
    }
    //
    //
    //
    MWB.EditableList {
        id: bookmarksList
        anchors.top: subtitleContainer.bottom
        anchors.left: parent.left
        anchors.bottom: toolbar.top
        anchors.right: parent.right
        //
        //
        //
        spacing: 4
        topMargin: 4
        bottomMargin: 4
        clip: true
        model: bookmarks
        //
        //
        //
        delegate: MWB.EditableListItem {
            id: delegateContainer
            width: bookmarksList.width
            swipeEnabled: editing
            contentEditable: false
            contentItem: Rectangle {
                id: bookmarkContainer
                width: parent.width
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                color: Colours.midGreen
                Label {
                    anchors.fill: parent
                    anchors.margins: 4
                    fontSizeMode: Label.Fit
                    font.pointSize: 48
                    color: Colours.almostWhite
                    verticalAlignment: Label.AlignVCenter
                    text: model.title
                }
                MouseArea {
                    anchors.fill: parent
                    enabled: !editing
                    onClicked: {
                        processLink( model.link, model.title );
                    }
                }
            }
            onRemove: {
                Qt.callLater( removeBookmark, model._id );
            }
        }
    }
    //
    //
    //
    Rectangle {
        id: toolbar
        height: 72
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        color: Colours.midGreen
        Label {
            id: addBookmark
            anchors.centerIn: parent
            font.pointSize: 18
            color: Colours.almostWhite
            text: editing ? "done" : "edit"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    editing = !editing;
                }
            }
        }
    }
    //
    //
    //
    function removeBookmark( bookmark_id ) {
        bookmarks.remove( {_id: bookmark_id} );
        bookmarks.save();
    }
    //
    //
    //
    property bool editing: false
}
