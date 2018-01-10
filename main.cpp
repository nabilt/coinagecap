#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QIcon>
#include <QFont>
#include <QFontDatabase>
#include <QQuickStyle>
#include <QQmlContext>
#include <QDir>
#include <QDebug>
#include <QSortFilterProxyModel>
#include "sortfilterproxymodel.h"
#include "dynamicrolemodel.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    QIcon::setThemeName("CoinTracker");

    QFontDatabase::addApplicationFont(":/fonts/Roboto-Bold.ttf");
    QFontDatabase::addApplicationFont(":/fonts/Roboto-Regular.ttf");
    QGuiApplication::setFont(QFont("Roboto"));

    DynamicRoleModel dynamicRoleModel;
    SortFilterProxyModel proxyModel;
    proxyModel.setFilterCaseSensitivity(Qt::CaseInsensitive);

    QQmlApplicationEngine engine;
    engine.setOfflineStoragePath(QDir::currentPath());

    QQmlContext *ctxt = engine.rootContext();
    ctxt->setContextProperty("sortedTickerModel", &proxyModel);
    ctxt->setContextProperty("tickerModel", &dynamicRoleModel);

    engine.load(QUrl(QLatin1String("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
