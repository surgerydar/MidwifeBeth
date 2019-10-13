import QtQuick 2.6
import QtQuick.Controls 2.1

import "../colours.js" as Colours
import "../styles.js" as Styles

Item {
    id: container
    //
    //
    //
    height: Math.max(64,content.height + 16) + ( more.visible ? more.height + 8 : 0 )
    //
    //
    //
    Background {
        anchors.fill: parent
        fill: Colours.almostWhite
        radius: [ 0 ]
    }
    //
    //
    //
    Text {
        id: content
        //
        //
        //
        height: !foldable || expanded ? contentHeight : summary.height
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 8
        clip: true
        visible: expanded
        //
        //
        //
        wrapMode: Text.WordWrap
        textFormat: Text.RichText
        elide: !foldable || expanded ? Text.ElideNone : Text.ElideRight
        //
        //
        //
        color: Colours.almostBlack
        //
        //
        //
        font.weight: Font.Light
        font.pointSize: 18
        //
        //
        //
        onLinkActivated: {
            processLink(link);
        }
    }
    Text {
        id: summary
        //
        //
        //
        height: contentHeight
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 8
        clip: true
        visible: foldable && !expanded
        //
        //
        //
        wrapMode: Text.WordWrap
        textFormat: Text.RichText
        elide: Text.ElideRight
        //
        //
        //
        color: Colours.almostBlack
        //
        //
        //
        font.weight: Font.Light
        font.pointSize: 18
        //
        //
        //
        onLinkActivated: {
            processLink(link);
        }
    }

    //
    //
    //
    Label {
        id: more
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 4
        visible: foldable && content.text.length > 0
        font.pointSize: 12
        font.italic: true
        text: expanded ? "...less" : "more..."
        MouseArea {
            anchors.fill: parent
            onClicked: {
                expanded = !expanded;
            }
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
    Component.onCompleted: {
        mediaReady();
    }
    onMediaChanged: {
        //
        // apply style
        //
        let text = Styles.style(media,"global");
        //
        // recalculate folded height
        //
        let summaryStart = text.indexOf('<summary>');
        let summaryEnd = text.indexOf('</summary>');
        if ( summaryStart >= 0 && summaryEnd >= 0 ) {
            summaryText = text.substring(summaryStart+'<summary>'.length,summaryEnd);
            foldable = true;
            expanded = false;
        } else {
            summaryText = "";
            foldable = false;
            expanded = true;
        }
        contentText = text;//text.replace('<summary>','').replace('</summary>');
        console.log( 'TextBlock : summaryText= ' + summaryText );
        console.log( 'TextBlock : contentText= ' + contentText );
    }
    //
    //
    //
    property string media: ""
    property string title: ""
    property int contentWidth: 0
    property int contentHeight: 0
    property bool expanded: false
    property bool foldable: false
    property alias contentText: content.text
    property alias summaryText: summary.text
}
