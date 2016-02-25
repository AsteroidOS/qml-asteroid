TEMPLATE = lib
TARGET = asteroidcontrolsplugin
QT += qml quick
CONFIG += qt plugin

TARGET = $$qtLibraryTarget($$TARGET)
uri = org.asteroid.controls

SOURCES += \
    src/controls_plugin.cpp \
    src/asteroidimageprovider.cpp \
    src/themedaemonclient.cpp \
    src/deviceinfo.cpp \
    src/application_p.cpp

HEADERS += \
    src/controls_plugin.h \
    src/asteroidimageprovider.h \
    src/themedaemonclient.h \
    src/deviceinfo.h \
    src/application_p.h

OTHER_FILES = \
    qmldir \
    qml/Application.qml \
    qml/BorderGestureArea.qml \
    qml/CircularScrollIndicator.qml \
    qml/IconButton.qml \
    qml/LayerStack.qml \
    qml/ProgressCircle.qml \
    qml/TimePicker.qml \
    qml/Units.qml

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
