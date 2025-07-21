# Description:
# Prints a comprehensive summary of the project configuration.
#
# Arguments:
# project_name_prefix (string): The project name prefix used for path variables.
function(print_project_summary project_name_prefix)
  # --- Function Start: print_project_summary
  if(NOT project_name_prefix)
    message(FATAL_ERROR "print_project_summary: project_name_prefix argument is required.")
    return()
  endif()

  message(STATUS "-----------------------------------------------------------------------------")
  message(STATUS "Configuration summary for ${PROJECT_NAME}")

  message(STATUS "\nSystem Configurations")
  message(STATUS "  Architecture: ${CMAKE_SYSTEM_PROCESSOR}")
  message(STATUS "  Name:         ${CMAKE_SYSTEM_NAME}")
  message(STATUS "  Version:      ${CMAKE_SYSTEM_VERSION}")

  message(STATUS "\nProject Configurations")
  message(STATUS "  Name:         ${PROJECT_NAME}")
  message(STATUS "  Version:      ${PROJECT_VERSION}")
  message(STATUS "  Description:  ${PROJECT_DESCRIPTION}")
  message(STATUS "  Homepage URL: ${PROJECT_HOMEPAGE_URL}")

  message(STATUS "\nC++ Compiler Configurations")
  message(STATUS "  C++ Compiler ID:        ${CMAKE_CXX_COMPILER_ID}")
  message(STATUS "  C++ Compiler Version:   ${CMAKE_CXX_COMPILER_VERSION}")
  message(STATUS "  C++ Compiler Path:      ${CMAKE_CXX_COMPILER}")
  message(STATUS "  C++ Build Type:         ${CMAKE_BUILD_TYPE}")
  message(STATUS "  C++ Compiler Features:  ${COMPILER_FEATURES}")
  message(STATUS "  C++ Compiler Flags:     ${COMPILER_FLAGS}")

  message(STATUS "\nProject Paths (Prefix: ${project_name_prefix})")
  message(STATUS "  Root:          ${${project_name_prefix}_ROOT_PATH}")
  message(STATUS "  Source:        ${${project_name_prefix}_SOURCE_PATH}")
  message(STATUS "  Include:       ${${project_name_prefix}_INCLUDE_PATH}")
  message(STATUS "  Build:         ${${project_name_prefix}_BUILD_PATH}")
  message(STATUS "  Internals:     ${${project_name_prefix}_INTERNALS_PATH}")
  message(STATUS "  Externals:     ${${project_name_prefix}_EXTERNALS_PATH}")
  message(STATUS "  Executables:   ${${project_name_prefix}_EXECUTABLES_PATH}")
  message(STATUS "  CMake Modules: ${${project_name_prefix}_CMAKE_MODULE_PATH}")

  message(STATUS "\n-----------------------------------------------------------------------------")

  # --- Function End: print_project_summary
endfunction()
