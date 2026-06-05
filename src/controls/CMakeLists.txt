set(SRC
	src/controls_plugin.cpp
	src/application_p.cpp
	src/gesturesextension.cpp
	src/flatmesh.cpp
	src/flatmeshnode.cpp
	src/icon.cpp
)
set(HEADERS
	src/controls_plugin.h
	src/application_p.h
	src/gesturesextension.h
	src/flatmesh.h
	src/flatmeshnode.h
	src/flatmeshgeometry.h
	src/icon.h
)

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

set_source_files_properties(qml/Dims.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

qt6_add_qml_module(asteroidcontrolsplugin
    URI org.asteroid.controls
    VERSION 1.0
    PLUGIN_TARGET asteroidcontrolsplugin
    CLASS_NAME ControlsPlugin
    NO_GENERATE_PLUGIN_SOURCE
    SOURCES ${SRC} ${HEADERS}
    QML_FILES ${controls-qml}
)

target_include_directories(asteroidcontrolsplugin PRIVATE src)

qt_add_shaders(
    asteroidcontrolsplugin "asteroidcontrolsplugin_shaders"
    PREFIX "/org/asteroid/controls"
    FILES "qml/spinnerfade.frag"
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

qt6_generate_wayland_protocol_client_sources(asteroidcontrolsplugin
    FILES "${CMAKE_SOURCE_DIR}/wayland-protocols/asteroid-gestures-unstable-v1.xml"
)

target_link_libraries(
    asteroidcontrolsplugin
    PRIVATE
        Qt::Qml
        Qt::Quick
        Qt::Svg
        Qt::WaylandClient
        Qt::GuiPrivate
)

install(
    TARGETS asteroidcontrolsplugin
    DESTINATION ${KDE_INSTALL_QMLDIR}/org/asteroid/controls
)
install(
    FILES "${CMAKE_CURRENT_BINARY_DIR}/qmldir"
    DESTINATION ${KDE_INSTALL_QMLDIR}/org/asteroid/controls
)
