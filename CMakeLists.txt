cmake_minimum_required(VERSION 3.27.0)

project(qml-asteroid
	VERSION 2.0.0
	DESCRIPTION "QML components, styles and demos for AsteroidOS")

find_package(ECM REQUIRED NO_MODULE)

option(BUILD_WITH_QT6 "Build a Qt6 version (WIP)" OFF)
if (BUILD_WITH_QT6)
    set(QT_VERSION_MAJOR 6)
else()
    set(QT_VERSION_MAJOR 5)
endif()

set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${CMAKE_SOURCE_DIR}/cmake)

option(WITH_ASTEROIDAPP "Build the AsteroidApp class" ON)
option(WITH_CMAKE_MODULES "Install AsteroidOS CMake modules" ON)

include(FeatureSummary)
include(GNUInstallDirs)
include(ECMFindQmlModule)
include(ECMGeneratePkgConfigFile)
include(AsteroidCMakeSettings)

set(ASTEROID_MODULES_INSTALL_DIR ${CMAKE_INSTALL_DATADIR}/asteroidapp/cmake)

if (${QT_VERSION_MAJOR} EQUAL 6)
    set(QT_MIN_VERSION "6.10.0")
    find_package(Qt6 ${QT_MIN_VERSION} CONFIG REQUIRED DBus Qml Quick Svg)
    ecm_find_qmlmodule(Qt5Compat.GraphicalEffects 1.0 REQUIRED)
    if (WITH_ASTEROIDAPP)
        find_package(Mapplauncherd_qt6 MODULE REQUIRED)
    endif()

    add_compile_definitions(QT6)
else()
    find_package(Qt5 5.15 CONFIG REQUIRED DBus Qml Quick Svg)
    if (WITH_ASTEROIDAPP)
        find_package(Mapplauncherd_qt5 MODULE REQUIRED)
    endif()
endif()

ecm_find_qmlmodule(QtQuick.VirtualKeyboard 2.1 REQUIRED)

if (WITH_CMAKE_MODULES)
# Install CMake modules
    file(GLOB installAsteroidModuleFiles LIST_DIRECTORIES FALSE ${CMAKE_SOURCE_DIR}/cmake/*[^~])
    install(FILES ${installAsteroidModuleFiles} DESTINATION ${ASTEROID_MODULES_INSTALL_DIR})
else()
    get_target_property(REAL_QMAKE_EXECUTABLE Qt::qmake IMPORTED_LOCATION)

    if (NOT QT_INSTALL_QML)
        execute_process(COMMAND "${REAL_QMAKE_EXECUTABLE}" -query QT_INSTALL_QML
                        OUTPUT_VARIABLE QT_INSTALL_QML
                        ERROR_QUIET OUTPUT_STRIP_TRAILING_WHITESPACE)
    endif()
    set(INSTALL_QML_IMPORT_DIR ${QT_INSTALL_QML})
endif()

add_subdirectory(src)

if (WITH_ASTEROIDAPP)
    install(PROGRAMS generate-desktop.sh
            DESTINATION ${CMAKE_INSTALL_BINDIR}
            RENAME asteroid-generate-desktop)
endif() 

feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)
