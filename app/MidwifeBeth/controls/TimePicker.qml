import QtQuick 2.13
import QtQuick.Controls 2.5
import "../colours.js" as Colours
import "../controls" as MWB
Item {
    id: container
    Rectangle {
        width: Math.min( container.width, container.height )
        height: width
        anchors.centerIn: parent
        radius: width / 2
        color: Colours.almostBlack
        PathView {
            id: picker
            anchors.fill: parent
            anchors.margins: 12
            interactive: false
            model: 12
            delegate: Rectangle {
                width: 24
                height: 24
                radius: 12
                color: PathView.isCurrentItem ? Colours.almostWhite : "transparent"
                Label {
                    anchors.centerIn: parent
                    font.pointSize: 18
                    color: parent.PathView.isCurrentItem ? Colours.almostBlack : Colours.almostWhite
                    text: model.index
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        picker.currentIndex = model.index
                    }
                }
            }
            path: Path {
                startX: picker.width / 2
                startY: 0
                PathArc {
                    x: picker.width / 2
                    y: picker.height
                    radiusX: picker.width / 2
                    radiusY: picker.height / 2
                    useLargeArc: true
                }
                PathArc {
                    x: picker.width / 2
                    y: 0
                    radiusX: picker.width / 2
                    radiusY: picker.height / 2
                    useLargeArc: true
                }
            }
        }
    }
}
