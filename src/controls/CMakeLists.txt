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

add_library(asteroidcontrolsplugin ${SRC} ${HEADERS} resources.qrc)

add_custom_target(
    doc
    DEPENDS "${CMAKE_BINARY_DIR}/doc/html/qml-dims.html"
)

add_custom_command(
    OUTPUT  "${CMAKE_BINARY_DIR}/doc/html/qml-dims.html"
    COMMAND "qdoc" "-indexdir" "/usr/share/doc/qt5" "-outputdir" "${CMAKE_BINARY_DIR}/doc/html" "${CMAKE_CURRENT_SOURCE_DIR}/doc/asteroid_controls.qdocconf" 
    COMMENT "Generating HTML format Reference documentation..." VERBATIM
)

target_link_libraries(asteroidcontrolsplugin
	Qt5::Qml
	Qt5::Quick
	Qt5::Svg)

install(TARGETS asteroidcontrolsplugin
	DESTINATION ${INSTALL_QML_IMPORT_DIR}/org/asteroid/controls)
install(FILES qmldir
	DESTINATION ${INSTALL_QML_IMPORT_DIR}/org/asteroid/controls)
