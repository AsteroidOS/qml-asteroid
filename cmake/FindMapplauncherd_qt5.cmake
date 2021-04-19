# Try to find qdeclarative5-boostable
# Once done this will define
# MAPPLAUNCHERD_QT5_FOUND - System has qdeclarative
# MAPPLAUNCHERD_QT5_INCLUDE_DIRS - The qdeclarative include directories
# MAPPLAUNCHERD_QT5_LIBRARIES - The libraries needed to use qdeclarative
# MAPPLAUNCHERD_QT5_DEFINITIONS - Compiler switches required for using qdeclarative

find_package(PkgConfig REQUIRED)
pkg_check_modules(PC_Mapplauncherd_qt5 QUIET qdeclarative5-boostable)
set(Mapplauncherd_qt5_DEFINITIONS ${PC_Mapplauncherd_qt5_CFLAGS_OTHER})

find_path(Mapplauncherd_qt5_INCLUDE_DIRS
	NAMES mdeclarativecache.h
	PATH_SUFFIXES mdeclarativecache5
	PATHS ${PC_Mapplauncherd_qt5_INCLUDEDIR} ${PC_Mapplauncherd_qt5_INCLUDE_DIRS})

find_library(Mapplauncherd_qt5_LIBRARIES
	NAMES mdeclarativecache5
	PATHS ${PC_Mapplauncherd_qt5_LIBDIR} ${PC_Mapplauncherd_qt5_LIBRARY_DIRS})

set(Mapplauncherd_qt5_VERSION ${PC_Mapplauncherd_qt5_VERSION})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Mapplauncherd_qt5
	FOUND_VAR
		Mapplauncherd_qt5_FOUND
	REQUIRED_VARS
		Mapplauncherd_qt5_LIBRARIES
		Mapplauncherd_qt5_INCLUDE_DIRS
	VERSION_VAR
		Mapplauncherd_qt5_VERSION)

mark_as_advanced(Mapplauncherd_qt5_INCLUDE_DIR Mapplauncherd_qt5_LIBRARY Mapplauncherd_qt5_VERSION)

if(Mapplauncherd_qt5_FOUND AND NOT TARGET Mapplauncherd_qt5::Mapplauncherd_qt5)
	add_library(Mapplauncherd_qt5::Mapplauncherd_qt5 UNKNOWN IMPORTED)
	set_target_properties(Mapplauncherd_qt5::Mapplauncherd_qt5 PROPERTIES
		IMPORTED_LOCATION "${Mapplauncherd_qt5_LIBRARIES}"
		INTERFACE_INCLUDE_DIRECTORIES "${Mapplauncherd_qt5_INCLUDE_DIRS}")
endif()
