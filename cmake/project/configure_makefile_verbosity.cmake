# Description:
# Configures the CMAKE_VERBOSE_MAKEFILE option based on the CMAKE_BUILD_TYPE.
# Sets verbosity ON for non-Release builds and OFF for Release builds.
function(configure_makefile_verbosity)
  # --- Function Start: configure_makefile_verbosity
  if(CMAKE_BUILD_TYPE STREQUAL "Release")
    set(CMAKE_VERBOSE_MAKEFILE OFF PARENT_SCOPE)
    message(STATUS "Makefile verbosity: OFF (Release build)")
  else()
    set(CMAKE_VERBOSE_MAKEFILE ON PARENT_SCOPE)
    message(STATUS "Makefile verbosity: ON (Debug or other build type)")
  endif()

  # --- Function End: configure_makefile_verbosity
endfunction()
