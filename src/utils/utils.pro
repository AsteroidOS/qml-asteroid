TEMPLATE = lib
TARGET = asteroidutilsplugin
QT += qml quick dbus
CONFIG += qt plugin

TARGET = $$qtLibraryTarget($$TARGET)
uri = org.asteroid.utils

SOURCES += \
    src/utils_plugin.cpp \
    src/bluetoothstatus.cpp

HEADERS += \
    src/utils_plugin.h \
    src/bluetoothstatus.h

OTHER_FILES = \
    qmldir

qmldir.files = qmldir

qmlfiles.path = $$[QT_INSTALL_QML]/$$replace(uri, \\., /)
qmlfiles.files += $$files(qml/*)

!equals(_PRO_FILE_PWD_, $$OUT_PWD) {
    copy_qmldir.target = $$OUT_PWD/qmldir
    copy_qmldir.depends = $$_PRO_FILE_PWD_/qmldir
    copy_qmldir.commands = $(COPY_FILE) \"$$replace(copy_qmldir.depends, /, $$QMAKE_DIR_SEP)\" \"$$replace(copy_qmldir.target, /, $$QMAKE_DIR_SEP)\"
    QMAKE_EXTRA_TARGETS += copy_qmldir
    PRE_TARGETDEPS += $$copy_qmldir.target
}

unix {
    installPath = $$[QT_INSTALL_QML]/$$replace(uri, \\., /)
    qmldir.path = $$installPath
    target.path = $$installPath
    INSTALLS += target qmldir qmlfiles
}
