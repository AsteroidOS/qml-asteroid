TEMPLATE = lib
TARGET = asteroidapp

QT += quick qml

DEFINES += ASTEROIDAPP_LIBRARY

SOURCES += \
    asteroidapp.cpp

HEADERS += \
    asteroidapp.h

CONFIG += link_pkgconfig
PKGCONFIG += mlite5

LIBS += -rdynamic -lmdeclarativecache5
QMAKE_CXXFLAGS += -fPIC -fvisibility=hidden -fvisibility-inlines-hidden

header.path = /usr/include/asteroidapp
header.files += asteroidapp.h

feature.path = /usr/lib/mkspecs/features/
feature.files = asteroidapp.prf

CONFIG += create_pc create_prl no_install_prl
QMAKE_PKGCONFIG_NAME = asteroidapp
QMAKE_PKGCONFIG_DESCRIPTION = Asteroid Application Library
QMAKE_PKGCONFIG_REQUIRES += qdeclarative5-boostable
QMAKE_PKGCONFIG_LIBDIR = $$target.path
QMAKE_PKGCONFIG_INCDIR = /usr/include/asteroidapp
QMAKE_PKGCONFIG_DESTDIR = pkgconfig

target.path = /usr/lib/
INSTALLS += target header feature
