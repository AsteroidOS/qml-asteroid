add_compile_definitions(QT_DISABLE_DEPRECATED_UP_TO=0x050F00)

if (WITH_ASTEROIDAPP)
    add_subdirectory(app)
endif()
add_subdirectory(controls)
add_subdirectory(utils)
