set(SRC
	src/controls_plugin.cpp
	src/application_p.cpp
	src/icon.cpp)
set(HEADERS
	src/controls_plugin.h
	src/application_p.h
	src/icon.h)

if(${QT_VERSION_MAJOR} EQUAL 6)
        set(SRC ${SRC}
                src/flatmesh_qt6.cpp
                src/flatmeshnode.cpp)
        set(HEADERS ${HEADERS}
                src/flatmesh_qt6.h
                src/flatmeshnode.h)
else()
        set(SRC ${SRC}
                src/flatmesh.cpp)
        set(HEADERS ${HEADERS}
                src/flatmesh.h
                src/flatmeshgeometry.h)
endif()

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
)
if (${QT_VERSION_MAJOR} EQUAL 6)
        set(controls ${controls} ValueMeter_qt6)
        foreach(control ${controls})
                list(APPEND controls-qml "qml/${control}.qml")
        endforeach()

        add_library(asteroidcontrolsplugin ${SRC} ${HEADERS})
        qt_add_resources(
                asteroidcontrolsplugin "asteroidcontrolsplugin_qrc"
                PREFIX "/org/asteroid/controls/"
                FILES "${controls-qml}"
        )
else()
        set(controls ${controls} ValueMeter)
        add_library(asteroidcontrolsplugin ${SRC} ${HEADERS} resources.qrc)
endif()


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
