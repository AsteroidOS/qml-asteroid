# Try to find mpris
# Once done this will define
# QTMPRIS_FOUND - System has mpris
# QTMPRIS_INCLUDE_DIRS - The mpris include directories
# QTMPRIS_LIBRARIES - The libraries needed to use mpris
# QTMPRIS_DEFINITIONS - Compiler switches required for using mpris

find_package(PkgConfig REQUIRED)
pkg_check_modules(PC_QtMpris QUIET mpris-qt5)
set(QtMpris_DEFINITIONS ${PC_QtMpris_CFLAGS_OTHER})

find_path(QtMpris_INCLUDE_DIRS
	NAMES mpris.h
	PATH_SUFFIXES mpris
	PATHS ${PC_QtMpris_INCLUDEDIR} ${PC_QtMpris_INCLUDE_DIRS})

find_library(QtMpris_LIBRARIES
	NAMES mpris-qt5
	PATHS ${PC_QtMpris_LIBDIR} ${PC_QtMpris_LIBRARY_DIRS})

set(QtMpris_VERSION ${PC_QtMpris_VERSION})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(QtMpris
	FOUND_VAR
		QtMpris_FOUND
	REQUIRED_VARS
		QtMpris_LIBRARIES
		QtMpris_INCLUDE_DIRS
	VERSION_VAR
		QtMpris_VERSION)

mark_as_advanced(QtMpris_INCLUDE_DIR QtMpris_LIBRARY QtMpris_VERSION)

if(QtMpris_FOUND AND NOT TARGET QtMpris::QtMpris)
	add_library(QtMpris::QtMpris UNKNOWN IMPORTED)
	set_target_properties(QtMpris::QtMpris PROPERTIES
		IMPORTED_LOCATION "${QtMpris_LIBRARIES}"
		INTERFACE_INCLUDE_DIRECTORIES "${QtMpris_INCLUDE_DIRS}")
endif()
