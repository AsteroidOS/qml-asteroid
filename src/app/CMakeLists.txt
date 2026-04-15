set(TARGET asteroidapp6)
set(NAME AsteroidApp6)

add_library(${TARGET} asteroidapp.cpp)

target_link_libraries(
	${TARGET}
	PUBLIC
		Qt::Qml
		Qt::Quick
	PRIVATE
		Qt::Core
)

target_link_libraries(
	${TARGET}
	PRIVATE
		Mapplauncherd_qt6::Mapplauncherd_qt6
)

target_include_directories(
	${TARGET} PUBLIC
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
	$<INSTALL_INTERFACE:include/${TARGET}>
)

# Install headers
set(ASTEROID_INCLUDEDIR "${CMAKE_INSTALL_INCLUDEDIR}/${TARGET}")
install(
	FILES asteroidapp.h
	DESTINATION ${ASTEROID_INCLUDEDIR}
	COMPONENT Devel
)

ecm_generate_pkgconfig_file(
	BASE_NAME ${TARGET}
	DEPS qdeclarative${QT_VERSION_MAJOR}-boostable
	FILENAME_VAR ${TARGET}
	DESCRIPTION ${PROJECT_DESCRIPTION}
	INSTALL)

# Configure and install the CMake Config file
include(CMakePackageConfigHelpers)

set(CMAKECONFIG_INSTALL_DIR ${CMAKE_INSTALL_LIBDIR}/cmake/${TARGET})

write_basic_package_version_file(
	${CMAKE_CURRENT_BINARY_DIR}/${NAME}ConfigVersion.cmake
	VERSION ${asteroidapp6_VERSION}
	COMPATIBILITY SameMajorVersion
)

set_target_properties(
	${TARGET} PROPERTIES
	EXPORT_NAME ${NAME}
	NAMESPACE Asteroid::
	SOVERSION ${PROJECT_VERSION_MAJOR}
	VERSION ${PROJECT_VERSION}
)

install(
	TARGETS ${TARGET}
	EXPORT ${NAME}Targets
	LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
	INCLUDES DESTINATION ${ASTEROID_INCLUDEDIR}
)

configure_package_config_file(
	"${NAME}Config.cmake.in"
	"${CMAKE_CURRENT_BINARY_DIR}/${NAME}Config.cmake"
	INSTALL_DESTINATION ${CMAKECONFIG_INSTALL_DIR}
	PATH_VARS
		ASTEROID_MODULES_INSTALL_DIR
)

install(
	EXPORT ${NAME}Targets
	NAMESPACE Asteroid::
	FILE ${NAME}Targets.cmake
	DESTINATION ${CMAKECONFIG_INSTALL_DIR}
)

install(
	FILES
	"${CMAKE_CURRENT_BINARY_DIR}/${NAME}Config.cmake"
	"${CMAKE_CURRENT_BINARY_DIR}/${NAME}ConfigVersion.cmake"
	DESTINATION ${CMAKECONFIG_INSTALL_DIR}
	COMPONENT Devel
)

