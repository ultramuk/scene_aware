include(${CMAKE_SOURCE_DIR}/cmake/library/set_target_compile_properties.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/library/add_target_dependencies.cmake)

# Description:
# Configures an executable target with its properties and dependencies.
#
# Arguments:
# SOURCE (string, required): The main source file for the executable.
# DEPENDENCIES (list, optional): A list of targets this executable depends on.
function(configure_executable)
  # --- Function Start: configure_executable
  set(options)
  set(oneValueArgs SOURCE)
  set(multiValueArgs DEPENDENCIES)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT ARG_SOURCE)
    message(FATAL_ERROR "configure_executable() requires the 'SOURCE' argument.")
  endif()

  get_filename_component(source_basename "${ARG_SOURCE}" NAME_WE)

  if(NOT source_basename)
    message(FATAL_ERROR "Could not extract basename from SOURCE '${ARG_SOURCE}'.")
  endif()

  set(executable_target_name "${CMAKE_PROJECT_NAME}__${source_basename}")

  message(STATUS "-- Defining executable: ${executable_target_name} from ${ARG_SOURCE}")

  add_executable(${executable_target_name} ${ARG_SOURCE})

  set_target_compile_properties(${executable_target_name})

  add_target_dependencies(${executable_target_name}
    DEPENDENCIES
    ${CMAKE_PROJECT_NAME}
    ${ARG_DEPENDENCIES}
  )

  # --- Function End: configure_executable
endfunction()
