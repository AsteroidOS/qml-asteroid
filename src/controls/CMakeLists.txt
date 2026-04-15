set(SRC
    src/controls_plugin.cpp
    src/application_p.cpp
    src/icon.cpp
    src/flatmesh.cpp
    src/flatmeshnode.cpp
)
set(HEADERS
    src/controls_plugin.h
    src/application_p.h
    src/icon.h
    src/flatmesh.h
    src/flatmeshnode.h
)

add_library(asteroidcontrolsplugin ${SRC} ${HEADERS})

set(controls 
    Application
    BorderGestureArea
    CircularSpinner
    Dims
    HandWritingKeyboard
    HighlightBar
    IconButton
    Indicator
    IntSelector
    Label
    LabeledActionButton
    LabeledSwitch
    LayerStack
    ListItem
    ListRow
    Marquee
    OptionCycler
    PageDot
    PageHeader
    Particle
    RemorseTimer
    RowSeparator
    SegmentedArc
    Spinner
    SpinnerDelegate
    StatusPage
    Switch
    TextArea
    TextBase
    TextField
    ValueMeter
)

foreach(control ${controls})
    list(APPEND controls-qml "qml/${control}.qml")
endforeach()

qt_add_resources(
    asteroidcontrolsplugin "asteroidcontrolsplugin_qrc"
    PREFIX "/org/asteroid/controls/"
    FILES "${controls-qml}"
)

set(controls-docs "$<LIST:TRANSFORM,$<LIST:TRANSFORM,$<LOWER_CASE:${controls}>,PREPEND,qml->,APPEND,.html>")
set(doc-dir "${CMAKE_BINARY_DIR}/doc/html")
set(full-controls-docs "$<LIST:TRANSFORM,${controls-docs},PREPEND,${doc-dir}>")

add_custom_target(
    doc
    DEPENDS "${full-controls-docs}"
)

add_custom_command(
    OUTPUT  "${full-controls-docs}"
    COMMAND "qdoc" "-indexdir" "/usr/share/doc/qt5" "-outputdir" "${doc-dir}" "${CMAKE_CURRENT_SOURCE_DIR}/master.qdocconf" "-single-exec"
    COMMENT "Generating HTML format Reference documentation..." VERBATIM
)

target_link_libraries(
    asteroidcontrolsplugin
    Qt::Qml
    Qt::Quick
    Qt::Svg
)

install(
    TARGETS asteroidcontrolsplugin
    DESTINATION ${INSTALL_QML_IMPORT_DIR}/org/asteroid/controls
)
install(
    FILES qmldir
    DESTINATION ${INSTALL_QML_IMPORT_DIR}/org/asteroid/controls
)
