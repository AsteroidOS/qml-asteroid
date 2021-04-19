# Try to find mce
# Once done this will define
# MCE_FOUND - System has mce
# MCE_INCLUDE_DIRS - The mce include directories
# MCE_LIBRARIES - The libraries needed to use mce
# MCE_DEFINITIONS - Compiler switches required for using mce

find_package(PkgConfig REQUIRED)
pkg_check_modules(PC_Mce QUIET mce)
set(Mce_DEFINITIONS ${PC_Mce_CFLAGS_OTHER})

find_path(Mce_INCLUDE_DIRS
	NAMES mode-names.h
	PATH_SUFFIXES mce
	PATHS ${PC_Mce_INCLUDEDIR} ${PC_Mce_INCLUDE_DIRS})

set(Mce_VERSION ${PC_Mce_VERSION})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Mce
	FOUND_VAR
		Mce_FOUND
	REQUIRED_VARS
		Mce_INCLUDE_DIRS
	VERSION_VAR
		Mce_VERSION)

mark_as_advanced(Mce_LIBRARY Mce_VERSION)

if(Mce_FOUND AND NOT TARGET Mce::Mce)
	add_library(Mce::Mce UNKNOWN IMPORTED)
	set_target_properties(Mce::Mce PROPERTIES
		INTERFACE_INCLUDE_DIRECTORIES "${Mce5_INCLUDE_DIRS}")	
endif()
