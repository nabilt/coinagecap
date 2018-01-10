import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQml.Models 2.2
import QtQuick.Controls.Material 2.1
import Qt.labs.settings 1.0
import QtQuick.LocalStorage 2.0
import "helper.js" as Helper
import "storage.js" as Storage

ApplicationWindow {
    id: app
    visible: true
    width: 400
    height: 680
    minimumWidth: 400
    minimumHeight: 300

    property bool debug : false

    title: qsTr("Coinage Cap")

    property var roleLabel: ["Price ($)", "Price (XBT)",
        "Market Cap", "24 Hour Volume",
        "% Change (1 Hour)", "% Change (24 Hour)",
        "% Change (7 day)", "Name",
        "Available Supply", "Total Supply",
        "Max Supply"]
    property var roleLabelKey: ["price_usd", "price_btc",
        "market_cap_usd", "day_volume_usd",
        "percent_change_1h", "percent_change_24h",
        "percent_change_7d", "name",
        "available_supply", "total_supply",
        "max_supply"]

    property var userCoins: ({})

    function updateTicker(removeOldItems) {
        //appBusyIndicator.running = true;
        Helper.request('https://api.coinmarketcap.com/v1/ticker/', function (o) {
            try {
                var jsonTicker = JSON.parse(o.responseText);
                var updatedItems = Helper.addTickerToModel(jsonTicker, tickerModel, removeOldItems);
                sortedTickerModel.sort(0, sortToolBar.sortDirection);

                if (jsonTicker.length > 0) {
                    Storage.saveSetting('coins', jsonTicker.slice(0,100));
                }
            } catch(err) {
            }
            appBusyIndicator.running = false;
        }, function(myxhr) {
            //console.log(myxhr.readyState);
            //appBusyIndicator.running = false;
        });
    }

    function saveAppState() {
        var app_state = {
            'sortRole': tickerModel.roleNames[sortedTickerModel.sortRole],
            'filterRole': tickerModel.roleNames[sortedTickerModel.filterRole],
            'sortDirection': sortToolBar.sortDirection
        }

        Storage.saveSetting('app_state', app_state);
        Storage.saveUserCoins(userCoins);
    }

    Timer {
        id: httpTimer
        interval: 30000
        running: false
        repeat: true
        onTriggered: {
            updateTicker(true);
        }
    }

    onClosing: {
        httpTimer.running = false;
        saveAppState();
    }

    Component.onCompleted: {
        app.header = appHeader

        tickerModel.addRole('stared', 10);
        roleChangeConnection.enabled = true;

        sortedTickerModel.sourceModel = tickerModel;

        Storage.initDb();

        // Restore last known coin values
        var coins = Storage.getSetting('coins')
        if (coins.length > 0) {
            Helper.addTickerToModel(coins, tickerModel);
        }

        userCoins = Storage.getUserCoins();
        console.log(JSON.stringify(userCoins));
        updateTicker(true);

        httpTimer.running = true;
    }

    // Restore app settings from previous session and sort model after the model
    // has been initialized
    Connections {
        id: roleChangeConnection
        enabled: false
        target: tickerModel
        onRoleNameChanged: {
            var appState = Storage.restoreSettings();
            sortedTickerModel.sort(0, sortToolBar.sortDirection);
            enabled = false;
        }
    }

    // Update UI with current sort role label
    Connections {
        target: sortedTickerModel
        onSortRoleChanged: {
            for (var i = 0; i < app.roleLabelKey.length; i++) {
                if (tickerModel.roleNames[sortedTickerModel.sortRole] == app.roleLabelKey[i]) {
                    sortToolBar.curSortLabelIndex = i;
                }
            }
        }
    }

    Shortcut {
        sequence: "Menu"
        onActivated: optionsMenu.open()
    }

    ToolBar {
        id: searchHeader
        visible: app.header == searchHeader
        Component.onCompleted: {
            // Extend the height to support sortToolBar sub-header
            height += sortToolBar.height
            sortToolBar.anchors.bottom = appHeader.bottom
        }
        onVisibleChanged: {
            searchTextField.clear()
            if (visible)
                searchTextField.forceActiveFocus();
        }

        // This ColumnLayout is needed for some reason if you want a sub-header
        ColumnLayout{
            anchors.fill: parent
            RowLayout {
                spacing: 20
                anchors.fill: parent

                ToolButton {
                    icon.name: "arrow_back"
                    onClicked: {
                        app.header = appHeader
                    }
                }
                TextField {
                    id: searchTextField
                    Layout.fillWidth: true
                    placeholderText: qsTr("Search Coins")
                    onTextChanged: {
                        sortedTickerModel.setFilterFixedString(text)
                    }
                }
                ToolButton {
                    icon.name: "close"
                    onClicked: {
                        searchTextField.clear()
                        searchTextField.focus = true
                    }
                }
            }
        }
    }

    /* QML does not support dual headers, but we can work around this
       by extending the appHeader and drawing a second header, sortToolBar,
       over the extended space. */
     ToolBar {
        id: sortToolBar
        z: 2
        height: 40
        width: appHeader.width
        Material.background: Material.Grey

        property int sortDirection: 1
        property int curSortLabelIndex: 0

        RowLayout {
            anchors.fill: parent
            spacing: 0
            anchors.rightMargin: 12
            // Need to switch to light theme to get dark highlight.
            // Also need to set background manually to match the dark theme
            // used outside of this element
            Material.theme: Material.Light
            Material.background: "#EEEEEE"
            Material.foreground: "black"

            Item { Layout.fillWidth: true }
            ToolButton {
                implicitWidth: 36
                anchors.margins: 0
                anchors.verticalCenter: parent.verticalCenter
                icon.name: sortToolBar.sortDirection ? "arrow_downward" : "arrow_upward"
                icon.color: Qt.darker(Material.color(Material.Grey), 1.5)
                onClicked: {
                    sortToolBar.sortDirection ^= 1;
                    sortedTickerModel.sort(0, sortToolBar.sortDirection);
                    tickerListView.contentY = 0;
                }
            }
            Label {
                anchors.verticalCenter: parent.verticalCenter
                font.weight: Font.DemiBold
                color: Qt.darker(Material.color(Material.Grey), 1.5)
                text: app.roleLabel[sortToolBar.curSortLabelIndex]
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        sortByMenu.open()
                    }
                }
                Menu {
                    id: sortByMenu
                    title: "Sort by"
                    Repeater {
                        model: app.roleLabel
                        MenuItem {
                            text: modelData
                            onTriggered: {
                                var sortRoleName = app.roleLabelKey[index];
                                sortedTickerModel.sortRole = tickerModel.roleValue(sortRoleName);
                                sortedTickerModel.sort(0, sortToolBar.sortDirection);
                                sortToolBar.curSortLabelIndex = index;
                                tickerListView.contentY = 0;
                            }
                        }
                    }
                }
            }
            ToolButton {
                id: starButtonHeader
                anchors.margins: 0
                Material.foreground: Material.Gray
                anchors.verticalCenter: parent.verticalCenter
                icon.name: "star_border"
                highlighted: false
                onClicked: {
                    highlighted = !highlighted;
                    sortedTickerModel.onlyShowChecked = highlighted;
                    sortedTickerModel.sort(0, sortToolBar.sortDirection);
                }
            }
        }
    }
    ToolBar {
        id: appHeader
        visible: app.header == appHeader
        Component.onCompleted: {
            // Extend the height to support sortToolBar sub-header
            height += sortToolBar.height
            sortToolBar.anchors.bottom = appHeader.bottom
        }

        // This ColumnLayout is needed for some reason if you want a sub-header
        ColumnLayout{
            anchors.fill: parent
            anchors.rightMargin: 5
            RowLayout {
                anchors.fill: parent
                ToolButton {
                    icon.name: stackView.depth > 1 ? "arrow_left" : ""
                    onClicked: {
                        if (stackView.depth > 1) {
                            stackView.pop()
                            coinDetailsPageLoader.setSource("")
                        } else {

                        }
                    }
                }

                // Spacing
                Item {
                    Layout.fillWidth: true
                }

                ToolButton {
                    icon.name: "search"
                    implicitWidth: 36
                    onClicked: {
                        app.header = searchHeader
                    }
                }

                ToolButton {
                    icon.name: "more_vert"
                    implicitWidth: 36
                    onClicked: optionsMenu.open()
                    visible: app.debug
                    Menu {
                        id: optionsMenu
                        x: parent.width - width
                        transformOrigin: Menu.TopRight

                        MenuItem {
                            text: "Update"
                            onTriggered: app.updateTicker(true)
                        }
                    }
                }
            }
        }
    }

    /*
    Dialog {
        id: sortDialog
        x: Math.round((app.width - width) / 2)
        y: Math.round(app.height / 6)
        width: Math.round(Math.min(app.width, app.height) / 3 * 2)
        //height: app.height - y
        //contentHeight: bla.implicitHeight
        modal: true
        focus: true
        title: "Sort By"
        property int sortType: tickerDelegateModel.sortType

        standardButtons: Dialog.Ok | Dialog.Cancel
        onAccepted: {
            tickerDelegateModel.sortType = sortDialog.sortType
            sortDialog.close()
        }
        onRejected: {
            sortDialog.close()
        }

        contentItem: ColumnLayout {
            id: settingsColumn
            spacing: 20
            RowLayout {
                spacing: 10

                ComboBox {
                    id: styleBox
                    model: tickerDelegateModel.sortTypeNames
                    onCurrentIndexChanged: {
                        sortDialog.sortType = currentIndex
                    }
                    Layout.fillWidth: true
                }
            }
        }
    }*/

    Loader {
        id: coinDetailsPageLoader
    }

    Component {
        id: tickerDelegate

        Pane {
            width: tickerListView.width
            contentWidth: tickerViewRow.implicitWidth
            contentHeight: 35
            Material.foreground: Material.White
            // Striped rows
            //Material.background: model.index % 2 == 0 ? Material.Background : "#424242"
            MouseArea {
                width: tickerViewRow.width - starButton.width
                height: tickerViewRow.height
                z:1
                onClicked: {
                    // This is available in all editors.
                    tickerListView.currentIndex = index
                    coinDetailsPageLoader.setSource("qrc:/CoinDetails.qml")
                    var coinDetailsPage = coinDetailsPageLoader.item
                    coinDetailsPage.coinName = name
                    coinDetailsPage.symbol = symbol
                    coinDetailsPage.rank = rank
                    coinDetailsPage.priceUsd = price_usd
                    coinDetailsPage.priceBtc = price_btc
                    coinDetailsPage.dayVolumeUsd = model.day_volume_usd
                    coinDetailsPage.marketCapUsd = market_cap_usd
                    coinDetailsPage.availableSupply = available_supply
                    coinDetailsPage.totalSupply = total_supply
                    coinDetailsPage.maxSupply = max_supply
                    coinDetailsPage.percentChange1H = percent_change_1h
                    coinDetailsPage.percentChange24H = percent_change_24h
                    coinDetailsPage.percentChange7H = percent_change_7d
                    coinDetailsPage.lastUpdated = last_updated
                    stackView.push(coinDetailsPage)
                }
            }

            RowLayout {
                id: tickerViewRow
                anchors.fill: parent
                anchors.margins: 0
                spacing: 0

                Label {
                    text: rank
                    font.pixelSize: 16
                    Layout.rightMargin: 16
                }
                Image {
                    source: "qrc:/img/" + symbol.toLowerCase() + "@2x.png"
                    anchors.verticalCenter: parent.verticalCenter
                    Layout.preferredWidth: 32
                    Layout.preferredHeight: 32
                    Layout.rightMargin: 16
                    onStatusChanged: {
                        if (status == Image.Error) {
                            source = "qrc:/img/unknown.png";
                        }
                    }
                }
                Column {
                    Layout.fillWidth: true
                    anchors.verticalCenter: parent.verticalCenter
                    Label {
                        text: name
                        font.pixelSize: 16
                    }
                    Label {
                        text: symbol
                        font.pixelSize:  8
                    }
                }
                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    Label {
                        id: priceUsdLabel
                        property color negFlashColor: Material.color(Material.Red)
                        property color posFlashColor: Material.color(Material.Green)
                        property color endFlashColor: Material.color(Material.Green)
                        property double prevPriceUsd: 0
                        property var priceUsd: price_usd
                        text: '$' + Helper.formatCurrency(price_usd)
                        font.pixelSize: 18
                        font.weight: Font.DemiBold
                        anchors.right: parent.right

                        // Set price color based on increasing or decreasing value
                        // This doesn't work with QSortFilterProxyModel because it doesn't call
                        // begineMoveRows() & endMoveRows(). Need to reimplement.
                        onPriceUsdChanged: {
                            var newColor;
                            if (price_usd < priceUsdLabel.prevPriceUsd)
                                newColor = priceUsdLabel.negFlashColor;
                            else
                                newColor = priceUsdLabel.posFlashColor;

                            //console.log('price change', index, price_usd, priceUsdLabel.prevPriceUsd);
                            priceUsdLabel.endFlashColor = newColor;
                            priceUsdLabel.color = newColor;
                            priceUsdLabel.color = "white";

                            priceUsdLabel.prevPriceUsd = price_usd;
                        }
                        Behavior on color {
                            SequentialAnimation {
                                ColorAnimation { from: "white"; to: priceUsdLabel.endFlashColor; duration: 650;
                                    easing.type: Easing.Linear;}
                                ColorAnimation { from: priceUsdLabel.endFlashColor; to: "white"; duration: 650;
                                    easing.type: Easing.Linear;}
                            }
                        }
                    }
                    Row {
                        anchors.right: parent.right
                        spacing: 10
                        Label {
                            text: percent_change_24h + '%'
                            font.pixelSize:  12
                            //anchors.right: parent.right
                            background: Rectangle {
                                width: parent.width + 4
                                x: -2
                                height: parent.height + 2
                                y: -1
                                color: percent_change_24h >= 0 ? Material.color(Material.Green) : Material.color(Material.Red)
                            }
                        }
                    }
                }
                ToolButton {
                    id: starButton
                    Material.foreground: Material.Gray
                    anchors.verticalCenter: parent.verticalCenter
                    icon.name: "star_border"
                    highlighted: Helper.getCoinParameter(userCoins, id, 'stared')
                    onHighlightedChanged: {
                        // Sync highlighted state with model data
                        // This is what gets used for filtering
                        stared = highlighted;
                    }
                    onClicked: {
                        highlighted = !highlighted

                        if (typeof(userCoins[id]) == "undefined") {
                            userCoins[id] = {};
                        }
                        userCoins[id]['stared'] = highlighted;
                        Storage.saveUserCoins(userCoins);

                        stared = highlighted;
                    }
                }
            }
        }
    }


    ListView {
        id: tickerListView
        width: parent.width
        model: sortedTickerModel
        delegate: tickerDelegate
        boundsBehavior: Flickable.StopAtBounds

        BusyIndicator {
            id: appBusyIndicator
            z: 3
            anchors.centerIn: parent
            running: false
            onRunningChanged: {
                fadedBackground.visible = running
            }
        }

        // Disable momentum scroll
        MouseArea {
            z: -1
            anchors.fill: parent
            onWheel: {
                // trackpad
                tickerListView.contentY -= wheel.pixelDelta.y;
                // mouse wheel
                tickerListView.contentY -= wheel.angleDelta.y;
                tickerListView.returnToBounds();
            }
        }

        Component.onCompleted: {
            // Customize scroll properties on different platforms
            if (Qt.platform.os == "linux" || Qt.platform.os == "osx" ||
                Qt.platform.os == "unix" || Qt.platform.os == "windows") {
                var scrollBar = Qt.createQmlObject('import QtQuick.Controls 2.3; ScrollBar{}',
                                                   tickerListView,
                                                   "dynamicSnippet1");
                scrollBar.policy = ScrollBar.AlwaysOn;
                ScrollBar.vertical = scrollBar;
            }
        }

        cacheBuffer: 50
    }


    // Fade out app while loading
    Rectangle {
        id: fadedBackground
        z: 2
        visible: false
        anchors.fill: parent
        color: Material.color(Material.Grey, Material.Shade900)
        opacity: 0.7
        // Prevent mouse clicks to children
        MouseArea {
            anchors.fill: parent
        }
    }


    StackView {
        id: stackView
        anchors.fill: parent
        anchors.margins: 0
        initialItem: tickerListView
    }


}
