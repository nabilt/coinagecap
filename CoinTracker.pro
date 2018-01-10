QT += quick quickcontrols2
CONFIG += c++11
QTPLUGIN += qsqlite

TARGET = CoinageCap

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += main.cpp \
    dynamicrolemodel.cpp \
    sortfilterproxymodel.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    dynamicrolemodel.h \
    sortfilterproxymodel.h

DISTFILES += \
    icons/CoinTracker/index.theme \
    icons/CoinTracker/24x24/arrow_back.png \
    icons/CoinTracker/24x24/arrow_downward.png \
    icons/CoinTracker/24x24/arrow_left.png \
    icons/CoinTracker/24x24/arrow_upward.png \
    icons/CoinTracker/24x24/close.png \
    icons/CoinTracker/24x24/menu.png \
    icons/CoinTracker/24x24/more_vert.png \
    icons/CoinTracker/24x24/search.png \
    icons/CoinTracker/24x24/settings.png \
    icons/CoinTracker/24x24/star_border \
    icons/CoinTracker/24x24@2/arrow_back.png \
    icons/CoinTracker/24x24@2/arrow_downward.png \
    icons/CoinTracker/24x24@2/arrow_left.png \
    icons/CoinTracker/24x24@2/arrow_upward.png \
    icons/CoinTracker/24x24@2/close.png \
    icons/CoinTracker/24x24@2/menu.png \
    icons/CoinTracker/24x24@2/more_vert.png \
    icons/CoinTracker/24x24@2/search.png \
    icons/CoinTracker/24x24@2/settings.png \
    icons/CoinTracker/24x24@3/arrow_back.png \
    icons/CoinTracker/24x24@3/arrow_downward.png \
    icons/CoinTracker/24x24@3/arrow_left.png \
    icons/CoinTracker/24x24@3/arrow_upward.png \
    icons/CoinTracker/24x24@3/close.png \
    icons/CoinTracker/24x24@3/menu.png \
    icons/CoinTracker/24x24@3/more_vert.png \
    icons/CoinTracker/24x24@3/search.png \
    icons/CoinTracker/24x24@3/settings.png \
    icons/CoinTracker/24x24@3/star_border \
    icons/CoinTracker/24x24@4/arrow_back.png \
    icons/CoinTracker/24x24@4/arrow_downward.png \
    icons/CoinTracker/24x24@4/arrow_left.png \
    icons/CoinTracker/24x24@4/arrow_upward.png \
    icons/CoinTracker/24x24@4/close.png \
    icons/CoinTracker/24x24@4/menu.png \
    icons/CoinTracker/24x24@4/more_vert.png \
    icons/CoinTracker/24x24@4/search.png \
    icons/CoinTracker/24x24@4/settings.png \
    icons/CoinTracker/24x24@4/star_border \
    icons/CoinTracker/index.theme \
    icons/CoinTracker/24x24/arrow_back.png \
    icons/CoinTracker/24x24/arrow_downward.png \
    icons/CoinTracker/24x24/arrow_left.png \
    icons/CoinTracker/24x24/arrow_upward.png \
    icons/CoinTracker/24x24/close.png \
    icons/CoinTracker/24x24/menu.png \
    icons/CoinTracker/24x24/more_vert.png \
    icons/CoinTracker/24x24/search.png \
    icons/CoinTracker/24x24/settings.png \
    icons/CoinTracker/24x24/star_border \
    icons/CoinTracker/24x24@2/arrow_back.png \
    icons/CoinTracker/24x24@2/arrow_downward.png \
    icons/CoinTracker/24x24@2/arrow_left.png \
    icons/CoinTracker/24x24@2/arrow_upward.png \
    icons/CoinTracker/24x24@2/close.png \
    icons/CoinTracker/24x24@2/menu.png \
    icons/CoinTracker/24x24@2/more_vert.png \
    icons/CoinTracker/24x24@2/search.png \
    icons/CoinTracker/24x24@2/settings.png \
    icons/CoinTracker/24x24@3/arrow_back.png \
    icons/CoinTracker/24x24@3/arrow_downward.png \
    icons/CoinTracker/24x24@3/arrow_left.png \
    icons/CoinTracker/24x24@3/arrow_upward.png \
    icons/CoinTracker/24x24@3/close.png \
    icons/CoinTracker/24x24@3/menu.png \
    icons/CoinTracker/24x24@3/more_vert.png \
    icons/CoinTracker/24x24@3/search.png \
    icons/CoinTracker/24x24@3/settings.png \
    icons/CoinTracker/24x24@3/star_border \
    icons/CoinTracker/24x24@4/arrow_back.png \
    icons/CoinTracker/24x24@4/arrow_downward.png \
    icons/CoinTracker/24x24@4/arrow_left.png \
    icons/CoinTracker/24x24@4/arrow_upward.png \
    icons/CoinTracker/24x24@4/close.png \
    icons/CoinTracker/24x24@4/menu.png \
    icons/CoinTracker/24x24@4/more_vert.png \
    icons/CoinTracker/24x24@4/search.png \
    icons/CoinTracker/24x24@4/settings.png \
    icons/CoinTracker/24x24@4/star_border \
    .gitignore \
    README.md
