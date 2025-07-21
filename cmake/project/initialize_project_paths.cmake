# Description:
# Initializes standard project directory path variables using a given prefix.
# The prefix is typically the uppercase project name (e.g., MY_PROJECT).
#
# Arguments:
# project_name_prefix (string): The project name prefix (conventionally uppercase with underscores)
# for path variables (e.g., MY_PROJECT_ROOT_PATH).
function(initialize_project_paths project_name_prefix)
  # --- Function Start: initialize_project_paths
  if(NOT project_name_prefix)
    message(FATAL_ERROR "initialize_project_paths: project_name_prefix argument is required.")
    return()
  endif()

  set(${project_name_prefix}_ROOT_PATH "${CMAKE_SOURCE_DIR}" PARENT_SCOPE)
  set(${project_name_prefix}_SOURCE_PATH "${CMAKE_SOURCE_DIR}/source" PARENT_SCOPE)
  set(${project_name_prefix}_INCLUDE_PATH "${CMAKE_SOURCE_DIR}/include" PARENT_SCOPE)
  set(${project_name_prefix}_BUILD_PATH "${CMAKE_BINARY_DIR}/${CMAKE_BUILD_TYPE}" PARENT_SCOPE)
  set(${project_name_prefix}_INTERNALS_PATH "${CMAKE_SOURCE_DIR}/dependencies/internals" PARENT_SCOPE)
  set(${project_name_prefix}_EXECUTABLES_PATH "${CMAKE_SOURCE_DIR}/executables" PARENT_SCOPE)
  set(${project_name_prefix}_EXTERNALS_PATH "${CMAKE_SOURCE_DIR}/dependencies/externals" PARENT_SCOPE)
  set(${project_name_prefix}_CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake" PARENT_SCOPE)

  message(STATUS "Project paths initialized with prefix: ${project_name_prefix}")

  # --- Function End: initialize_project_paths
endfunction()
