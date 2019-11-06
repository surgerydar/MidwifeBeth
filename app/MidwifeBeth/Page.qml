import QtQuick 2.13
import QtQuick.Controls 2.1

import "colours.js" as Colours
import "controls" as MWB

Item {
    id: container
    //
    //
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
            text: ""
            visible: text.length > 0
        }
    }
    //
    //
    //
    ListView {
        id: content
        anchors.top: subtitle.visible ? subtitleContainer.bottom : parent.top
        anchors.left: parent.left
        anchors.bottom: hideToolbar ? parent.bottom : toolbar.top
        anchors.right: toolbar.right
        anchors.topMargin: 4
        spacing: 4
        clip: true
        model: blocks
        bottomMargin: 4
        delegate: MWB.Block {
            anchors.left: parent.left
            anchors.right: parent.right
            type: model.type
            media: model.content
            title: model.title || ""
            contentWidth: model.width || ( model.type === 'video' ) ? 1080 : 0
            contentHeight: model.height || ( model.type === 'video' ) ? 1920 : 0
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
        visible: !hideToolbar
        MWB.RoundButton {
            id: bookmarkButton
            width: 64
            height: width
            anchors.centerIn: parent
            image: "/icons/BOOKMARK ICON 96 BOX.png"
            onClicked: {
                let bookmark = {
                    title: container.title,
                    link: 'link://pages/' + filter.page_id
                };
                bookmarks.add(bookmark);
                bookmarks.save();
                addBookmark.visible = false;
            }
        }
    }
    //
    //
    //
    StackView.onActivating: {
        console.log( 'Page : filter= ' + JSON.stringify(filter) + ' title= ' + title + ' hideToolbar= ' + hideToolbar );
        console.log( 'subtitle.text= ' + subtitle.text + ' subtitle.visible= ' +  subtitle.visible + ' subtitleContainer.bottom= ' + ( subtitleContainer.y + subtitleContainer.height ) );
        blocks.setFilter(filter);
        let link = 'link://pages/' + filter.page_id;
        bookmarkButton.visible = bookmarks.findOne({link:link}) === undefined;
    }
    //
    //
    //
    property alias title: subtitle.text
    property var filter: ({})
    property bool hideToolbar: false
}
