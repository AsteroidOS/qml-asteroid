set(SRC asteroidapp.cpp)
set(HEADERS asteroidapp.h)

add_library(asteroidapp ${SRC} ${HEADERS})

target_link_libraries(asteroidapp
	PUBLIC
		Qt5::Qml
		Qt5::Quick
	PRIVATE
		Mlite5::Mlite5
		Mapplauncherd_qt5::Mapplauncherd_qt5)

set_target_properties(asteroidapp PROPERTIES
	EXPORT_NAME AsteroidApp
	SOVERSION ${PROJECT_VERSION_MAJOR}
	VERSION ${PROJECT_VERSION})

target_include_directories(asteroidapp PUBLIC
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
	$<INSTALL_INTERFACE:include/asteroidapp>)

# Install the library
install(TARGETS asteroidapp
	EXPORT AsteroidAppTargets
	LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})

# Install headers
install(FILES ${HEADERS}
	DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/asteroidapp
	COMPONENT Devel)

install(FILES asteroidapp.prf
	DESTINATION ${CMAKE_INSTALL_LIBDIR}/mkspecs/features
	COMPONENT Devel)

ecm_generate_pkgconfig_file(
	BASE_NAME asteroidapp
	DEPS qdeclarative5-boostable
	FILENAME_VAR asteroidapp
	DESCRIPTION ${PROJECT_DESCRIPTION}
	INSTALL)

# Configure and install the CMake Config file
include(CMakePackageConfigHelpers)
set(CMAKECONFIG_INSTALL_DIR ${CMAKE_INSTALL_LIBDIR}/cmake/asteroidapp)

configure_package_config_file(
	"AsteroidAppConfig.cmake.in"
	"${CMAKE_CURRENT_BINARY_DIR}/AsteroidAppConfig.cmake"
	INSTALL_DESTINATION ${CMAKECONFIG_INSTALL_DIR}
	PATH_VARS
		CMAKE_INSTALL_PREFIX
		CMAKE_INSTALL_INCLUDEDIR
		CMAKE_INSTALL_LIBDIR
		ASTEROID_MODULES_INSTALL_DIR
	NO_CHECK_REQUIRED_COMPONENTS_MACRO)
write_basic_package_version_File(${CMAKE_CURRENT_BINARY_DIR}/AsteroidAppConfigVersion.cmake
	VERSION ${asteroidapp_VERSION}
	COMPATIBILITY SameMajorVersion)

install(EXPORT AsteroidAppTargets
	DESTINATION ${CMAKECONFIG_INSTALL_DIR}
	COMPONENT Devel)

install(FILES
	"${CMAKE_CURRENT_BINARY_DIR}/AsteroidAppConfig.cmake"
	"${CMAKE_CURRENT_BINARY_DIR}/AsteroidAppConfigVersion.cmake"
	DESTINATION ${CMAKECONFIG_INSTALL_DIR}
	COMPONENT Devel)
