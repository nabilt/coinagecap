import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1
import "helper.js" as Helper

Item {
    property string coinName: ""
    property string symbol: ""
    property int rank: 0
    property double priceUsd: 0.0
    property double priceBtc: 0.0
    property double dayVolumeUsd: 0.0
    property double marketCapUsd: 0.
    property double availableSupply: 0.0
    property double totalSupply: 0.0
    property double maxSupply: 0.0
    property double percentChange1H: 0.0
    property double percentChange24H: 0.0
    property double percentChange7H: 0.0
    property int lastUpdated: 0

    onSymbolChanged: {
        coinIcon.source = "qrc:/img/" + symbol.toLowerCase() + "@2x.png"
    }

    GridLayout {
        columns: 3
        anchors.fill: parent
        anchors.margins: 10
        columnSpacing: 20
        rowSpacing: 20
        Rectangle {
            Layout.alignment: Qt.AlignCenter
            Layout.preferredHeight: 40
            Layout.columnSpan: 3

            Row {
                spacing: 12
                anchors.centerIn: parent
                Image {
                    id: coinIcon
                    anchors.verticalCenter: parent.verticalCenter
                    onStatusChanged: {
                        if (status == Image.Error) {
                            source = "qrc:/img/unknown.png";
                        }
                    }
                }
                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    text: coinName
                    font.pixelSize: 24

                }
            }
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            Label {
                text: '$' + Helper.millify(priceUsd)
                font.pixelSize: 18
                font.weight: Font.DemiBold
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Label {
                text: "Price"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            Label {
                text: '$' + Helper.millify(marketCapUsd)
                font.pixelSize: 18
                font.weight: Font.DemiBold
                //anchors.horizontalCenter: parent.horizontalCenter
            }
            Label {
                text: "Market Cap"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            Label {
                text: '$' + Helper.millify(dayVolumeUsd)
                font.pixelSize: 18
                font.weight: Font.DemiBold
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Label {
                text: "24h Volume"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            Label {
                text: percentChange1H + '%'
                color: percentChange1H >= 0 ? Material.color(Material.Green) : Material.color(Material.Red)
                font.pixelSize: 18
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Label {
                text: "1 Hour"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            Label {
                text: percentChange24H + '%'
                color: percentChange24H >= 0 ? Material.color(Material.Green) : Material.color(Material.Red)
                font.pixelSize: 18
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Label {
                text: "24 Hour"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            Label {
                text: percentChange7H + '%'
                color: percentChange7H >= 0 ? Material.color(Material.Green) : Material.color(Material.Red)
                font.pixelSize: 18
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Label {
                text: "7 Day"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            Label {
                text: Helper.millify(availableSupply) + " " + symbol
                font.pixelSize: 18
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Label {
                text: "Available Supply"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            Label {
                text: Helper.millify(totalSupply) + " " + symbol
                font.pixelSize: 18
                //anchors.horizontalCenter: parent.horizontalCenter
            }
            Label {
                text: "Total Supply"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            Label {
                text: Helper.millify(maxSupply) + " " + symbol
                font.pixelSize: 18
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Label {
                text: "Max Supply"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

    }
}
