import QtQuick 2.13
import QtQuick.Controls 2.5

import "../colours.js" as Colours
import "../controls" as MWB

MWB.HorizontalListView {
    id: container
    labelText: "Photos"
    //
    //
    //
    model: ListModel {}
    delegate: Item {
        id: photoDelegate
        height: parent.height
        width: height
        Image {
            id: image
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
            source: 'file://' + SystemUtils.documentPath(model.image)
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if ( image.parent === photoDelegate ) {
                        fullscreenContainer.visible = true;
                        image.fillMode = Image.PreserveAspectFit;
                        image.parent = fullscreenContainer;
                    } else {
                        fullscreenContainer.visible = false;
                        image.fillMode = Image.PreserveAspectCrop;
                        image.parent = photoDelegate;
                    }
                }
            }
        }
        //
        //
        //
        MWB.BlockDeleteButton {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 4
            action: function() {
                SystemUtils.removeFile(SystemUtils.documentPath(model.image));
                container.media.photos.splice(index,1);
                container.updateContent();
            }
        }
    }
    onAdd: {
        editContent();
    }
    //
    //
    //
    section.property: "date"
    section.delegate: MWB.DateSectionDelegate {}
    //
    //
    //
    function editContent() {
        stack.push("qrc:///controls/PhotoChooser.qml", {
                       save: function ( source ) {
                           /*
                           console.log( 'adding photo : ' + source );
                           let sourceFile = source.toString().substring('file://'.length);
                           let targetFile = SystemUtils.documentDirectory() + '/' + Date.now() + sourceFile.substring(sourceFile.lastIndexOf('.'));
                           console.log('PhotoBlock : moving photo from : ' + sourceFile + ' to : ' + targetFile );
                           SystemUtils.copyFile(sourceFile,targetFile);
                           */
                           let date = new Date();
                           let image = {image:source.substring(source.lastIndexOf('/')+1),caption:"", date: Qt.formatDate(date,'yyyy-MMM-dd'), time: date.getTime()};
                           model.append(image);
                           media.photos.push(image);
                           console.log( 'PhotoBlock.media=' + JSON.stringify(media));
                           container.updateContent();
                           listView.positionViewAtEnd();
                           stack.pop();
                       },
                       cancel: function() {
                           stack.pop();
                       }
                   });
    }
    //
    //
    //
    onMediaChanged: {
        try {
            model.clear();
            if ( media.photos ) {
                media.photos.forEach((photo)=>{model.append(photo)});
            } else {
                media.photos = [];
            }
        } catch ( error ) {
            console.log( 'PhotoBlock.onMediaChanged : error : ' + error + ' : media=' + JSON.stringify(media));
        }
    }
    Component.onDestruction: {
        console.log( 'PhotoBlock.onDestroyed' );
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
    property var media: ({})
    property string title: ""
    property int contentWidth: 0
    property int contentHeight: 0
}
