# Try to find systemsettings
# Once done this will define
# SYSTEMSETTINGS_FOUND - System has systemsettings
# SYSTEMSETTINGS_INCLUDE_DIRS - The systemsettings include directories
# SYSTEMSETTINGS_LIBRARIES - The libraries needed to use systemsettings
# SYSTEMSETTINGS_DEFINITIONS - Compiler switches required for using systemsettings

find_package(PkgConfig REQUIRED)
pkg_check_modules(PC_SystemSettings QUIET systemsettings)
set(SystemSettings_DEFINITIONS ${PC_SystemSettings_CFLAGS_OTHER})

find_path(SystemSettings_INCLUDE_DIRS
	NAMES aboutsettings.h
	PATH_SUFFIXES systemsettings
	PATHS ${PC_SystemSettings_INCLUDEDIR} ${PC_SystemSettings_INCLUDE_DIRS})

find_library(SystemSettings_LIBRARIES
	NAMES systemsettings
	PATHS ${PC_SystemSettings_LIBDIR} ${PC_SystemSettings_LIBRARY_DIRS})

set(SystemSettings_VERSION ${PC_SystemSettings_VERSION})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(SystemSettings
	FOUND_VAR
		SystemSettings_FOUND
	REQUIRED_VARS
		SystemSettings_LIBRARIES
		SystemSettings_INCLUDE_DIRS
	VERSION_VAR
		SystemSettings_VERSION)

mark_as_advanced(SystemSettings_INCLUDE_DIR SystemSettings_LIBRARY SystemSettings_VERSION)

if(SystemSettings_FOUND AND NOT TARGET SystemSettings::SystemSettings)
	add_library(SystemSettings::SystemSettings UNKNOWN IMPORTED)
	set_target_properties(SystemSettings::SystemSettings PROPERTIES
		IMPORTED_LOCATION "${SystemSettings_LIBRARIES}"
		INTERFACE_INCLUDE_DIRECTORIES "${SystemSettings_INCLUDE_DIRS}")
endif()
