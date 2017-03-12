TEMPLATE = lib
QT += qml quick
CONFIG += qt plugin

OTHER_FILES = svg/*.svg

icons.path = /usr/share/icons/asteroid/
icons.files += $$files(svg/*.svg)

unix {
    INSTALLS += icons
}
