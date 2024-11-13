set(SRC
	src/controls_plugin.cpp
	src/application_p.cpp
	src/flatmesh.cpp
	src/flatmeshnode.cpp
	src/icon.cpp)
set(HEADERS
	src/controls_plugin.h
	src/application_p.h
	src/flatmesh.h
	src/flatmeshnode.h
	src/icon.h)

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
        Marquee
        PageDot
        PageHeader
        SegmentedArc
        Spinner
        SpinnerDelegate
        StatusPage
        Switch
        TextArea
        TextBase
        TextField
)
foreach(control ${controls})
    list(APPEND controls-qml "qml/${control}.qml")
endforeach()

add_library(asteroidcontrolsplugin ${SRC} ${HEADERS})

qt_add_resources(asteroidcontrolsplugin "asteroidcontrolsplugin_qrc"
    PREFIX "/org/asteroid/controls/"
    FILES "${controls-qml}")

qt6_add_shaders(asteroidcontrolsplugin "asteroidcontrolsplugin_shaders"
    PREFIX "/org/asteroid/controls/"
    FILES "qml/Spinner.frag"
    BATCHABLE
    PRECOMPILE
    OPTIMIZED)

set(controls-docs "$<LIST:TRANSFORM,$<LIST:TRANSFORM,$<LOWER_CASE:${controls}>,PREPEND,qml->,APPEND,.html>")
set(doc-dir "${CMAKE_BINARY_DIR}/doc/html")
set(full-controls-docs "$<LIST:TRANSFORM,${controls-docs},PREPEND,${doc-dir}>")

add_custom_target(
    doc
    DEPENDS "${full-controls-docs}"
)

add_custom_command(
    OUTPUT  "${full-controls-docs}"
    COMMAND "qdoc" "-indexdir" "/usr/share/doc/qt5" "-outputdir" "${doc-dir}" "${CMAKE_CURRENT_SOURCE_DIR}/doc/asteroid_controls.qdocconf" 
    COMMENT "Generating HTML format Reference documentation..." VERBATIM
)

target_link_libraries(asteroidcontrolsplugin
	Qt::Qml
	Qt::Quick
	Qt::Svg)

install(TARGETS asteroidcontrolsplugin
	DESTINATION ${INSTALL_QML_IMPORT_DIR}/org/asteroid/controls)
install(FILES qmldir
	DESTINATION ${INSTALL_QML_IMPORT_DIR}/org/asteroid/controls)
