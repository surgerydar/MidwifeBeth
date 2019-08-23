import QtQuick 2.13
import QtQuick.Controls 2.5

Popup {
    id: container
    width: contentScroller.width + 8
    height: contentScroller.height + 8
    x: offsetX()
    y: offsetY()
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    //
    //
    //
    background: Rectangle {
        anchors.fill: parent
        color: "transparent"
    }
    //
    //
    //
    Flickable {
        id: contentScroller
        width: Math.min( content.childrenRect.width, applicationWindow.width - 8 )
        height: Math.min( content.childrenRect.height, applicationWindow.height - 64 )
        contentWidth: content.childrenRect.width
        contentHeight: content.childrenRect.height
        Column {
            id: content
            spacing: 4
            Repeater {
                id: contentRepeater
            }
        }
    }
    //
    //
    //
    function offsetX() {
        switch( pinEdge ) {
        case PinnedPopup.PinEdge.Top :
        case PinnedPopup.PinEdge.Bottom :
            return Math.max( 8, Math.min( applicationWindow.width - ( width + 8 ), pin.x - width / 2 ) )
        case PinnedPopup.PinEdge.Left :
            return pin.x;
        case PinnedPopup.PinEdge.Right :
            return pin.x - width;
        }
        return 8;
    }
    function offsetY() {
        switch( pinEdge ) {
        case PinnedPopup.PinEdge.Left :
        case PinnedPopup.PinEdge.Right :
            return Math.max( 8, Math.min( applicationWindow.height - ( height + 8 ), pin.y - height / 2 ) )
        case PinnedPopup.PinEdge.Top :
            return pin.y;
        case PinnedPopup.PinEdge.Bottom :
            return pin.y - height;
        }
        return 8;
    }
    //
    //
    //
    onWidthChanged: {
        x = offsetX();
    }
    onHeightChanged: {
        y = offsetY();
    }
    onPinChanged: {
        x = offsetX();
        y = offsetY();
    }
    onPinEdgeChanged: {
        x = offsetX();
        y = offsetY();
    }
    onAboutToShow: {
        x = offsetX();
        y = offsetY();
    }
    onModelChanged: {

    }
    //
    //
    //
    function openPinned( point, edge ) {
        pin = point;
        pinEdge = edge;
        open();
    }
    //
    //
    //
    enum PinEdge {
        Top,
        Left,
        Bottom,
        Right
    }
    //
    //
    //
    property alias model: contentRepeater.model
    property alias delegate: contentRepeater.delegate
    property point pin: Qt.point(8,8)
    property int pinEdge: container.Bottom
}
