import QtQuick 2.0
import QtQuick.Controls 1.4

import SodaControls 1.0
import "../colours.js" as Colours
import "../controls" as MWB

Item {
    id: container
    //
    //
    //
    Repeater {
        id: items
        Rectangle {
            width: ( container.width / 2 ) - 8
            height: 64
            color: Colours.almostWhite
            Label {
                anchors.fill: parent
                anchors.margins: 4
                font.pixelSize: 64
                fontSizeMode: Label.Fit
                horizontalAlignment: Label.AlignHCenter
                verticalAlignment: Label.AlignVCenter
                wrapMode: Label.WordWrap
                color: Colours.almostBlack
                text: model.title
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    container.clicked(model._id);
                }
            }
        }
    }
    //
    //
    //
    function layout() {
        var x = spacing;
        var y = spacing;
        var itemWidth = ( container.width - ( spacing * 3 ) ) / 2;
        var rowCount = 0;
        var colCount = 0;
        for ( var i = 0; i < container.children.length - 1; i++ ) {
            container.children[ i ].x = x;
            container.children[ i ].y = y;
            container.children[ i ].width = itemWidth;
            container.children[ i ].height = itemHeight;
            colCount++;
            x += itemWidth + spacing;
            if ( x + itemWidth > container.width - spacing ) {
                x = spacing;
                y += itemHeight + spacing;
                colCount = 0;
                rowCount++;
            }
        }
        if ( colCount == 1 ) {
            container.children[ container.children.length - 2 ].width = ( container.width - 8 );
        }
        container.implicitHeight = container.height = ( ( itemHeight + spacing ) * rowCount ) + ( spacing * 2 );
    }
    //
    //
    //
    signal clicked( string item_id );
    //
    //
    //
    onWidthChanged: {
        layout()
    }
    onHeightChanged: {
        layout()
    }
    Component.onCompleted: {
        layout();
    }
    //
    //
    //
    property alias model: items.model
    property int spacing: 4
    property int itemHeight: 64
}
