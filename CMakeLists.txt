cmake_minimum_required(VERSION 3.6.0)

project(qml-asteroid
	VERSION 1.0.0
	DESCRIPTION "QML components, styles and demos for AsteroidOS")

find_package(ECM REQUIRED NO_MODULE)

set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${CMAKE_SOURCE_DIR}/cmake)

option(WITH_ASTEROIDAPP "Build the AsteroidApp class" ON)
option(WITH_CMAKE_MODULES "Install AsteroidOS CMake modules" ON)

include(FeatureSummary)
include(GNUInstallDirs)
include(ECMFindQmlModule)
include(ECMGeneratePkgConfigFile)
include(AsteroidCMakeSettings)

set(ASTEROID_MODULES_INSTALL_DIR ${CMAKE_INSTALL_DATADIR}/asteroidapp/cmake)

find_package(Qt5 ${QT_MIN_VERSION} COMPONENTS DBus Qml Quick Svg REQUIRED)
if (WITH_ASTEROIDAPP)
    find_package(Mlite5 MODULE REQUIRED)
    find_package(Mapplauncherd_qt5 MODULE REQUIRED)
endif()

ecm_find_qmlmodule(QtQuick.VirtualKeyboard 2.1)

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

add_custom_target(
    doc
    DEPENDS "${CMAKE_BINARY_DIR}/doc/html/qml-dims.html"
)
add_custom_command(
    OUTPUT  "${CMAKE_BINARY_DIR}/doc/html/qml-dims.html"
    COMMAND "qdoc" "-indexdir" "/usr/share/doc/qt5" "-outputdir" "${CMAKE_BINARY_DIR}/doc/html" "${CMAKE_CURRENT_SOURCE_DIR}/src/controls/doc/asteroid_controls.qdocconf"
    COMMENT "Generating HTML format Reference documentation..." VERBATIM
)

if (WITH_ASTEROIDAPP)
    install(PROGRAMS generate-desktop.sh
            DESTINATION ${CMAKE_INSTALL_BINDIR}
            RENAME asteroid-generate-desktop)
endif() 

feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)
