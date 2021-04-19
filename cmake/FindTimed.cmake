# Try to find timed-qt5
# Once done this will define
# TIMED_FOUND - System has timed
# TIMED_INCLUDE_DIRS - The timed include directories
# TIMED_LIBRARIES - The libraries needed to use timed

find_package(PkgConfig REQUIRED)
pkg_check_modules(PC_Timed QUIET timed-qt5)

find_library(Timed_LIBRARIES
	NAMES timed-qt5
	PATHS ${PC_Timed_LIBDIR} ${PC_Timed_LIBRARY_DIRS})

set(Timed_VERSION ${PC_Timed_VERSION})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Timed
	FOUND_VAR
		Timed_FOUND
	REQUIRED_VARS
		Timed_LIBRARIES
	VERSION_VAR
		Timed_VERSION)

mark_as_advanced(Timed_LIBRARIES Timed_VERSION)

if(Timed_FOUND AND NOT TARGET Timed::Timed)
	add_library(Timed::Timed UNKNOWN IMPORTED)
	set_target_properties(Timed::Timed PROPERTIES
		IMPORTED_LOCATION "${Timed_LIBRARIES}")
endif()
