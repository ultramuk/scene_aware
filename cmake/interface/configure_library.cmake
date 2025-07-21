include(${CMAKE_SOURCE_DIR}/cmake/library/set_target_compile_properties.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/library/add_target_dependencies.cmake)

# Description:
# Configures a library target (STATIC, SHARED, or INTERFACE).
#
# Arguments:
# TYPE (string, optional): Library type. Defaults to STATIC.
# SOURCES (list, optional): Source files. Not required for INTERFACE.
# DEPENDENCIES (list, optional): Library dependencies.
function(configure_library)
  # --- Function Start: configure_library
  set(options)
  set(oneValueArgs TYPE)
  set(multiValueArgs SOURCES DEPENDENCIES)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT ARG_TYPE)
    set(ARG_TYPE STATIC)
  endif()

  string(TOUPPER "${ARG_TYPE}" ARG_TYPE_UPPER)

  set(VALID_LIBRARY_TYPES STATIC SHARED INTERFACE)
  if(NOT ARG_TYPE_UPPER IN_LIST VALID_LIBRARY_TYPES)
    message(FATAL_ERROR "Invalid library TYPE '${ARG_TYPE}'. Must be one of STATIC, SHARED, or INTERFACE.")
  endif()

  if(ARG_SOURCES)
    add_library(${PROJECT_NAME} ${ARG_TYPE} ${ARG_SOURCES})
  else()
    if(ARG_TYPE_UPPER STREQUAL "INTERFACE")
      add_library(${PROJECT_NAME} INTERFACE)
    else()
      message(FATAL_ERROR "Library type '${ARG_TYPE}' requires SOURCES, but none were provided.")
    endif()
  endif()

  set_target_compile_properties(${PROJECT_NAME})

  add_target_dependencies(${PROJECT_NAME}
    DEPENDENCIES
    ${ARG_DEPENDENCIES}
  )

  # --- Function End: configure_library
endfunction()
