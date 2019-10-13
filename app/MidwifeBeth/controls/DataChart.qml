import QtQuick 2.13
import QtQuick.Controls 2.5
import QtQuick.Shapes 1.13
import QtQuick.Layouts 1.13

import "../colours.js" as Colours
import "../controls" as MWB

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
            text: ""
        }
    }
    //
    //
    //
    RowLayout {
        id: chartContainer
        anchors.top: subtitleContainer.bottom
        anchors.left: parent.left
        anchors.bottom: toolbar.top
        anchors.right: parent.right

        RowLayout {
            id: axes
            Layout.fillHeight: true
            Behavior on width {
                NumberAnimation { duration: 1000; easing.type: Easing.OutQuad }
            }
        }

        Shape {
            id: chart
            clip: true
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }
    //
    //
    //
    Column {
        id: legend
        anchors.bottom: toolbar.top
        anchors.right: parent.right
        anchors.margins: 4
        spacing: 4
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
    }
    //
    //
    //
    Component {
        id: path
        ShapePath {
            fillColor: "transparent"
            strokeColor: Colours.almostBlack
            strokeWidth: 3
            capStyle: ShapePath.RoundCap
        }
    }
    Component {
        id: pathMove
        PathMove {}
    }
    Component {
        id: pathLine
        PathLine {}
    }
    Component {
        id: axis
        Item {
            id: container
            Layout.fillHeight: true
            ColumnLayout {
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                Repeater {
                    id: ticks
                    model: 10
                    Label {
                        Layout.fillHeight: true
                        Layout.alignment: Qt.AlignRight
                        leftPadding: 4
                        rightPadding: 4
                        horizontalAlignment: Label.AlignRight
                        verticalAlignment: Label.AlignVCenter
                        color: container.colour
                        text: Math.round( container.maxValue - ( ( ( ( index + 1 ) / container.tickCount ) * ( container.maxValue - container.minValue ) ) ) )+ container.units
                        Component.onCompleted: {
                            container.implicitWidth = Math.max(container.implicitWidth,contentWidth+8);
                        }
                    }
                }
            }
            Rectangle {
                width: 4
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                color: container.colour
            }
            property alias tickCount: ticks.model
            property real minValue: 0.
            property real maxValue: 100.
            property string units: ""
            property color colour: Colours.almostBlack
        }
    }

    Component {
        id: legendLabel
        MWB.TitleBox {
            id: container
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if ( path ) {
                        console.log( 'Chart.legendColour=' + path.strokeColor );
                        if ( path.strokeColor === Qt.rgba(0,0,0,0) ) {
                            path.strokeColor = container.color;
                            container.opacity = 1.
                            axis.visible = true;
                        } else {
                            path.strokeColor = Qt.rgba(0,0,0,0);
                            container.opacity = .75
                            axis.visible = false;
                        }
                    }
                }
            }
            property var path: null
            property var axis: null
        }
    }

    //
    //
    //
    function generateChart() {
        let i;
        for ( i = legend.children.length-1; i >= 0; i-- ) {
            console.log( 'destroying : ' + legend.children[i]);
            legend.children[i].destroy();
        }
        for ( i = axes.children.length-1; i >= 0; i-- ) {
            console.log( 'destroying : ' + axes.children[i]);
            axes.children[i].destroy();
        }
        chart.data = [];
        /*
        for ( let i = 0; i < chart.data.length; i++ ) {
            chart.data[i].destroy();
        }
        */
        //chart.data.clear();
        //
        //
        //
        if ( chartData.length > 0 ) {
            //
            // build chart for each key
            //
            let xstep = chart.width / ( chartData.length - 1 );
            let colours = ["red","green","blue"];
            let colourIndex = 0;
            dataSets.forEach(function(dataSet) {
                let x = 0;
                let y = 0;
                let chartPath = path.createObject(chart);
                chartPath.strokeColor = colours[colourIndex];
                let chartAxis = axis.createObject(axes,{tickCount: 10, minValue:dataSet.min, maxValue:dataSet.max, colour:chartPath.strokeColor, units: dataSet.units});
                legendLabel.createObject(legend,{text:dataSet.label,path:chartPath,axis:chartAxis,backgroundColour:chartPath.strokeColor});
                colourIndex++;
                for ( i = 0; i < chartData.length; i++ ) {
                    y = chart.height - ( ( ( chartData[i][dataSet.key] - dataSet.min ) / ( dataSet.max - dataSet.min ) ) * chart.height );
                    console.log( 'DataChart.generateChart : key=' + dataSet.key + ' index=' + i + ' x=' + x + ' y=' + y );
                    let element;
                    if ( i === 0 ) {
                        element = pathMove.createObject(chartPath,{"x":x,"y":y});
                    } else {
                        element = pathLine.createObject(chartPath,{"x":x,"y":y});
                    }
                    chartPath.pathElements.push(element);
                    chart.data.push(chartPath);
                    x += xstep;
                }
            });
        }
    }
    //
    //
    //
    onChartDataChanged: {
        generateChart();
    }
    Component.onCompleted: {
        generateChart();
    }
    //
    //
    //
    property var dataSets: []
    property var chartData: []
    property alias title: subtitle.text
}
