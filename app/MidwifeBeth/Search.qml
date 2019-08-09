import QtQuick 2.7
import QtQuick.Controls 2.1

import "controls" as MWB
import "colours.js" as Colours

Item {
    id: container
    //
    //
    //
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
            text: "Search"
        }
    }
    //
    //
    //
    ListView {
        id: results
        anchors.top: subtitleContainer.bottom
        anchors.left: parent.left
        anchors.bottom: searchBar.top
        anchors.right: parent.right
        anchors.margins: 8
        //
        //
        //
        clip: true
        spacing: 4
        //
        //
        //
        model: ListModel {}
        //
        //
        //
        delegate: SearchItem {
            anchors.left: parent.left
            anchors.right: parent.right
            title: model.title
            summary: model.summary
            //
            //
            //
            onClicked: {
                var param = {title: model.title, filter:{page_id:model.page}};
                stack.push("qrc:///Page.qml", param);
            }
        }
        /*
        add: Transition {
            NumberAnimation { properties: "y"; from: results.height; duration: 250 }
        }
        */
    }
    Item {
        id: searchBar
        height: 64
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.bottomMargin: 64
        //
        //
        //
        MWB.TokenisedTextField {
            id: searchField
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: searchButton.left
            anchors.margins: 8
            //font.family: fonts.light
            font.pointSize: 32
        }
        //
        //
        //
        MWB.Button {
            id: searchButton
            anchors.verticalCenter: searchField.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 8
            image: "icons/search.png"
            backgroundColour: "transparent"
            //
            //
            //
            onClicked: {
                search();
            }
        }
    }
    //
    //
    //
    StackView.onActivated: {
        pages.filter = {};
    }
    StackView.onRemoved: {
    }
    //
    //
    //
    function search() {
        //
        //
        //
        results.model.clear();
        var searchTags = searchField.tokenised;
        if ( searchTags.length > 0 ) {
            for ( var t = 0; t < searchTags.length; t++ ) {
                searchTags[ t ] = searchTags[ t ].trim().toLowerCase();
            }
            var searchResults = pages.find( { tags: { $and: searchTags } } );
            console.log( 'search results : ' + JSON.stringify(searchResults) );
            searchResults.forEach( (page)=>{
                                      //
                                      // find summary
                                      //
                                      var summary = page.title;
                                      var pageBlocks = blocks.find({page_id:page._id});
                                      for ( var i = 0; i < pageBlocks.length; i++ ) {
                                          if ( pageBlocks[ i ].type === 'text' && pageBlocks[ i ].content.length > 0 ) {
                                              summary = pageBlocks[ i ].content;
                                              break;
                                          }
                                      }
                                      results.model.append( {
                                                               page: page._id,
                                                               title: page.title,
                                                               summary: summary
                                                           });
                                  });
        }
    }
}
