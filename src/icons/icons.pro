TEMPLATE = lib
QT += qml quick
CONFIG += qt plugin

uri = org.asteroid.icons

OTHER_FILES = svg/*.svg

icons.path = $$[QT_INSTALL_QML]/$$replace(uri, \\., /)
icons.files += $$files(svg/*.svg)

unix {
    INSTALLS += icons
}
