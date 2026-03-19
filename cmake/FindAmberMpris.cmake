# Try to find mpris
# Once done this will define
# AMBER_MPRIS_FOUND - System has mpris
# AMBER_MPRIS_INCLUDE_DIRS - The mpris include directories
# AMBER_MPRIS_LIBRARIES - The libraries needed to use mpris
# AMBER_MPRIS_DEFINITIONS - Compiler switches required for using mpris

find_package(PkgConfig REQUIRED)
pkg_check_modules(PC_AmberMpris QUIET ambermpris)
set(AmberMpris_DEFINITIONS ${PC_AmberMpris_CFLAGS_OTHER})

find_path(AmberMpris_INCLUDE_DIRS
	NAMES mpris.h
	PATH_SUFFIXES AmberMpris
	PATHS ${PC_AmberMpris_INCLUDEDIR} ${PC_AmberMpris_INCLUDE_DIRS})

find_library(AmberMpris_LIBRARIES
	NAMES ambermpris
	PATHS ${PC_AmberMpris_LIBDIR} ${PC_AmberMpris_LIBRARY_DIRS})

set(AmberMpris_VERSION ${PC_AmberMpris_VERSION})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(AmberMpris
	FOUND_VAR
		AmberMpris_FOUND
	REQUIRED_VARS
		AmberMpris_LIBRARIES
		AmberMpris_INCLUDE_DIRS
	VERSION_VAR
		AmberMpris_VERSION)

mark_as_advanced(AmberMpris_INCLUDE_DIR AmberMpris_LIBRARY AmberMpris_VERSION)

if(AmberMpris_FOUND AND NOT TARGET AmberMpris::AmberMpris)
	add_library(AmberMpris::AmberMpris UNKNOWN IMPORTED)
	set_target_properties(AmberMpris::AmberMpris PROPERTIES
		IMPORTED_LOCATION "${AmberMpris_LIBRARIES}"
		INTERFACE_INCLUDE_DIRECTORIES "${AmberMpris_INCLUDE_DIRS}")
endif()
