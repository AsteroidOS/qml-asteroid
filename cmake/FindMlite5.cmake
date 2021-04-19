# Try to find mlite5
# Once done this will define
# MLITE5_FOUND - System has mlite5
# MLITE5_INCLUDE_DIRS - The mlite5 include directories
# MLITE5_LIBRARIES - The libraries needed to use mlite5
# MLITE5_DEFINITIONS - Compiler switches required for using mlite5

find_package(PkgConfig REQUIRED)
pkg_check_modules(PC_Mlite5 QUIET mlite5)
set(Mlite5_DEFINITIONS ${PC_Mlite5_CFLAGS_OTHER})

find_path(Mlite5_INCLUDE_DIRS
	NAMES mlite-global.h
	PATH_SUFFIXES mlite5
	PATHS ${PC_Mlite5_INCLUDEDIR} ${PC_Mlite5_INCLUDE_DIRS})

find_library(Mlite5_LIBRARIES
	NAMES mlite5
	PATHS ${PC_Mlite5_LIBDIR} ${PC_Mlite5_LIBRARY_DIRS})

set(Mlite5_VERSION ${PC_Mlite5_VERSION})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Mlite5
	FOUND_VAR
		Mlite5_FOUND
	REQUIRED_VARS
		Mlite5_LIBRARIES
		Mlite5_INCLUDE_DIRS
	VERSION_VAR
		Mlite5_VERSION)

mark_as_advanced(Mlite5_INCLUDE_DIR Mlite5_LIBRARY Mlite5_VERSION)

if(Mlite5_FOUND AND NOT TARGET Mlite5::Mlite5)
	add_library(Mlite5::Mlite5 UNKNOWN IMPORTED)
	set_target_properties(Mlite5::Mlite5 PROPERTIES
		IMPORTED_LOCATION "${Mlite5_LIBRARIES}"
		INTERFACE_INCLUDE_DIRECTORIES "${Mlite5_INCLUDE_DIRS}")
endif()
