# Description:
# Adds specified dependencies to a given target using target_link_libraries.
# This function simplifies linking multiple libraries or targets as private
# dependencies.
#
# Arguments:
# target_name (string, required): The name of the target to which dependencies will be added.
# DEPENDENCIES (list, optional): A list of dependencies to link against the target.
function(add_target_dependencies target_name)
  # --- Function Start: add_target_dependencies
  set(options "")
  set(one_value_args "")
  set(multi_value_args "DEPENDENCIES")

  cmake_parse_arguments(ARGUMENTS
    "${options}"
    "${one_value_args}"
    "${multi_value_args}"
    ${ARGN})

  if(ARGUMENTS_DEPENDENCIES)
    message(STATUS "[${target_name}] Adding dependencies: ${ARGUMENTS_DEPENDENCIES}")
    target_link_libraries(${target_name} PRIVATE ${ARGUMENTS_DEPENDENCIES})
  else()
    message(STATUS "[${target_name}] No dependencies provided to add_target_dependencies.")
  endif()

  # --- Function End: add_target_dependencies
endfunction()
