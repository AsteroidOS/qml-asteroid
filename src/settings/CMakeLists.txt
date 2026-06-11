set(SRC
	src/settings_plugin.cpp
	src/mceconfig.cpp
	src/displaysettings.cpp
	src/datetimesettings.cpp
	src/aboutsettings.cpp
	src/languagemodel.cpp
	src/profilecontrol.cpp)
set(HEADERS
	src/settings_plugin.h
	src/mceconfig.h
	src/displaysettings.h
	src/datetimesettings.h
	src/aboutsettings.h
	src/languagemodel.h
	src/profilecontrol.h)

add_library(asteroidsettingsplugin ${SRC} ${HEADERS})

target_link_libraries(asteroidsettingsplugin
	Qt::DBus
	Qt::Qml
	Qt::Quick)

install(TARGETS asteroidsettingsplugin
	DESTINATION ${KDE_INSTALL_QMLDIR}/org/asteroid/settings)
install(FILES qmldir
	DESTINATION ${KDE_INSTALL_QMLDIR}/org/asteroid/settings)
