cmake_minimum_required(VERSION 3.6.0)

project(qml-asteroid
	VERSION 1.0.0
	DESCRIPTION "QML components, styles and demos for AsteroidOS")

find_package(ECM REQUIRED NO_MODULE)

set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${CMAKE_SOURCE_DIR}/cmake)

include(FeatureSummary)
include(GNUInstallDirs)
include(ECMQMLModules)
include(ECMGeneratePkgConfigFile)
include(AsteroidCMakeSettings)

set(ASTEROID_MODULES_INSTALL_DIR ${CMAKE_INSTALL_DATADIR}/asteroidapp/cmake)

find_package(Qt5 ${QT_MIN_VERSION} COMPONENTS DBus Qml Quick Svg REQUIRED)
find_package(Mlite5 MODULE REQUIRED)
find_package(Mapplauncherd_qt5 MODULE REQUIRED)

ecm_find_qmlmodule(QtQuick.VirtualKeyboard 2.1)

add_subdirectory(src)

# Install CMake modules
file(GLOB installAsteroidModuleFiles LIST_DIRECTORIES FALSE ${CMAKE_SOURCE_DIR}/cmake/*[^~])
install(FILES ${installAsteroidModuleFiles} DESTINATION ${ASTEROID_MODULES_INSTALL_DIR})

install(PROGRAMS generate-desktop.sh
	DESTINATION ${CMAKE_INSTALL_BINDIR}
	RENAME asteroid-generate-desktop)

feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)
