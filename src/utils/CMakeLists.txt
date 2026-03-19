set(SRC
	src/utils_plugin.cpp
	src/devicespecs.cpp
	src/fileinfo.cpp
	src/bluetoothstatus.cpp)
set(HEADERS
	src/utils_plugin.h
	src/devicespecs.h
	src/fileinfo.h
	src/bluetoothstatus.h)

add_library(asteroidutilsplugin ${SRC} ${HEADERS})

target_link_libraries(asteroidutilsplugin
	Qt::DBus
	Qt::Qml
	Qt::Quick)

install(TARGETS asteroidutilsplugin
	DESTINATION ${INSTALL_QML_IMPORT_DIR}/org/asteroid/utils)
install(FILES qmldir
	DESTINATION ${INSTALL_QML_IMPORT_DIR}/org/asteroid/utils)
