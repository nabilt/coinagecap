var db;

function initDb() {
    db = LocalStorage.openDatabaseSync("CoinTrackerDB", "", "Database tracking coins and settings", 1000000);
    function initTable(tx) {
        tx.executeSql('CREATE TABLE IF NOT EXISTS app_settings(id INTEGER PRIMARY KEY, key TEXT UNIQUE, value TEXT)');
        tx.executeSql('CREATE TABLE IF NOT EXISTS user_coins(id INTEGER PRIMARY KEY, coin_id TEXT UNIQUE, properties TEXT)');
    }
    db.transaction(initTable);
}

function deleteSetting(key) {
    function _deleteSetting(tx) {
        var result = tx.executeSql('DELETE FROM app_settings WHERE key = ?', [key]);
    }
    db.transaction(_deleteSetting);
}

function saveSetting(key, value) {
    function _saveSetting(tx) {
        var result = tx.executeSql("INSERT INTO app_settings VALUES (?,?,?)",
                                   [null, key, JSON.stringify(value)]);
    }
    // Always overwrite previous key/value pair
    deleteSetting(key);
    db.transaction(_saveSetting);
}

function getSetting(key) {
    var result = "{}";

    function _getSetting(tx) {
        var results = tx.executeSql("SELECT value FROM app_settings WHERE key = ?", [key]);
        if (results.rows.length == 1) {
            result = results.rows.item(0).value;
        }
    }

    db.readTransaction(_getSetting);
    return JSON.parse(result);
}

function saveUserCoins(coins) {
    function _saveUserCoins(tx) {
        for (var key in coins) {
            var result = tx.executeSql("REPLACE INTO user_coins VALUES (?, ?, ?)",
                                       [null, key, JSON.stringify(coins[key])]);
        }
    }

    db.transaction(_saveUserCoins);
}

function getUserCoins() {
    var coins = {};

    function _getUserCoins(tx) {
        var results = tx.executeSql("SELECT coin_id, properties FROM user_coins");
        for (var i = 0; i < results.rows.length; i++) {
            coins[results.rows.item(i).coin_id] = JSON.parse(results.rows.item(i).properties);
        }
    }

    db.readTransaction(_getUserCoins);
    return coins;
}

function restoreSettings() {
    var appState = Storage.getSetting('app_state');
    if (appState.hasOwnProperty('filterRole')) {
        sortedTickerModel.filterRole = tickerModel.roleValue(appState.filterRole);
    } else {
        sortedTickerModel.filterRole = tickerModel.roleValue('name');
    }

    if (appState.hasOwnProperty('sortRole')) {
        sortedTickerModel.sortRole = tickerModel.roleValue(appState.sortRole);
    } else {
        sortedTickerModel.sortRole = tickerModel.roleValue('market_cap_usd');
    }

    if (appState.hasOwnProperty('sortDirection')) {
        sortToolBar.sortDirection = appState.sortDirection;
    } else {
        sortToolBar.sortDirection = 1;
    }
    return appState;
}
