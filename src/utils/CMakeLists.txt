set(SRC
	src/utils_plugin.cpp
	src/deviceinfo.cpp
	src/bluetoothstatus.cpp)
set(HEADERS
	src/utils_plugin.h
	src/deviceinfo.h
	src/bluetoothstatus.h)

add_library(asteroidutilsplugin ${SRC} ${HEADERS})

target_link_libraries(asteroidutilsplugin
	Qt5::DBus
	Qt5::Qml
	Qt5::Quick)

install(TARGETS asteroidutilsplugin
	DESTINATION ${INSTALL_QML_IMPORT_DIR}/org/asteroid/utils)
install(FILES qmldir
	DESTINATION ${INSTALL_QML_IMPORT_DIR}/org/asteroid/utils)
