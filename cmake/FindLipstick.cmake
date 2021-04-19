# Try to find lipstick-qt5
# Once done this will define
# LIPSTICK_FOUND - System has lipstick
# LIPSTICK_INCLUDE_DIRS - The lipstick include directories
# LIPSTICK_LIBRARIES - The libraries needed to use lipstick
# LIPSTICK_DEFINITIONS - Compiler switches required for using lipstick

find_package(PkgConfig REQUIRED)
pkg_check_modules(PC_Lipstick QUIET lipstick-qt5)
set(Lipstick_DEFINITIONS ${PC_Lipstick_CFLAGS_OTHER})

find_path(Lipstick_INCLUDE_DIRS
	NAMES lipstickcompositor.h
	PATH_SUFFIXES lipstick-qt5
	PATHS ${PC_Lipstick_INCLUDEDIR} ${PC_Lipstick_INCLUDE_DIRS})

find_library(Lipstick_LIBRARIES
	NAMES lipstick-qt5
	PATHS ${PC_Lipstick_LIBDIR} ${PC_Lipstick_LIBRARY_DIRS})

set(Lipstick_VERSION ${PC_Lipstick_VERSION})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Lipstick
	FOUND_VAR
		Lipstick_FOUND
	REQUIRED_VARS
		Lipstick_LIBRARIES
		Lipstick_INCLUDE_DIRS
	VERSION_VAR
		Lipstick_VERSION)

mark_as_advanced(Lipstick_INCLUDE_DIR Lipstick_LIBRARY Lipstick_VERSION)

if(Lipstick_FOUND AND NOT TARGET Lipstick::Lipstick)
	add_library(Lipstick::Lipstick UNKNOWN IMPORTED)
	set_target_properties(Lipstick::Lipstick PROPERTIES
		IMPORTED_LOCATION "${Lipstick_LIBRARIES}"
		INTERFACE_INCLUDE_DIRECTORIES "${Lipstick_INCLUDE_DIRS}")
endif()
