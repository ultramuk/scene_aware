# Description:
# Consolidates the core project setup by calling various configuration
# functions. This function initializes paths, configures compiler flags,
# and prints a project summary. It is intended to be called once from the
# root CMakeLists.txt.
#
# Arguments:
# project_name_arg (string): The name of the project, typically ${PROJECT_NAME}.
function(configure_project project_name_arg)
  # --- Function Start: configure_project
  # --- Include Dependent Core Function Modules
  include(${CMAKE_SOURCE_DIR}/cmake/common/convert_to_uppercase_with_underscores.cmake)
  include(${CMAKE_SOURCE_DIR}/cmake/project/configure_default_compiler_flags.cmake)
  include(${CMAKE_SOURCE_DIR}/cmake/project/configure_makefile_verbosity.cmake)
  include(${CMAKE_SOURCE_DIR}/cmake/project/initialize_project_paths.cmake)
  include(${CMAKE_SOURCE_DIR}/cmake/project/print_project_summary.cmake)
  include(${CMAKE_SOURCE_DIR}/cmake/common/add_subdirectories.cmake)

  # --- Configure Project Settings
  configure_default_compiler_flags()
  configure_makefile_verbosity()

  # --- Prepare Project Variables
  convert_to_uppercase_with_underscores(${project_name_arg} local_uppercase_project_name)
  set(UPPERCASE_PROJECT_NAME ${local_uppercase_project_name} PARENT_SCOPE)
  initialize_project_paths(${local_uppercase_project_name})
  set(COMPILER_FLAGS ${COMPILER_FLAGS} PARENT_SCOPE)

  # --- Print Configuration Summary
  print_project_summary(${local_uppercase_project_name})

  # --- Configure Subdirectories
  add_subdirectories(${${local_uppercase_project_name}_EXTERNALS_PATH})
  add_subdirectories(${${local_uppercase_project_name}_INTERNALS_PATH})
  add_subdirectories(${${local_uppercase_project_name}_EXECUTABLES_PATH})

  # --- Function End: configure_project
endfunction()
