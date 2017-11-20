TEMPLATE = lib
TARGET = asteroidcontrolsplugin
QT += qml quick svg
CONFIG += qt plugin qtquickcompiler

TARGET = $$qtLibraryTarget($$TARGET)
uri = org.asteroid.controls

SOURCES += \
    src/controls_plugin.cpp \
    src/application_p.cpp \
    src/flatmesh.cpp \
    src/flatmeshnode.cpp \
    src/icon.cpp

HEADERS += \
    src/controls_plugin.h \
    src/application_p.h \
    src/flatmesh.h \
    src/flatmeshnode.h \
    src/icon.h

OTHER_FILES = \
    qmldir \
    qml/Application.qml \
    qml/BorderGestureArea.qml \
    qml/CircularSpinner.qml \
    qml/Dims.qml \
    qml/IconButton.qml \
    qml/Indicator.qml \
    qml/LayerStack.qml \
    qml/Label.qml \
    qml/Marquee.qml \
    qml/PageDot.qml \
    qml/Spinner.qml \
    qml/SpinnerDelegate.qml \
    qml/StatusPage.qml \
    qml/Switch.qml \
    qml/TextField.qml \
    qml/TextBase.qml \
    qml/TextArea.qml \
    qml/HandWritingKeyboard.qml

RESOURCES += resources.qrc

qmldir.files = qmldir

qmlfiles.path = $$[QT_INSTALL_QML]/$$replace(uri, \\., /)

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
