# Description:
# Adds an external package using FetchContent. This function simplifies the
# process by declaring the dependency, making its targets available, and
# applying any specified compile options or definitions.
#
# Arguments:
# REPOSITORY_URL (string, required): Git repository URL for the package.
# REPOSITORY_TAG (string, required): Git tag, branch, or commit hash.
# LIBRARIES (list, optional): List of target names created by the package.
# COMPILE_OPTIONS (list, optional): List of compile options to apply to the targets.
# COMPILE_DEFINITIONS (list, optional): List of compile definitions to apply.
function(add_external_package)
  # --- Function Start: add_external_package
  get_filename_component(package_name ${CMAKE_CURRENT_LIST_DIR} NAME)
  message(STATUS "[${package_name}] Configuring external package...")

  set(one_value_args REPOSITORY_URL REPOSITORY_TAG)
  set(multi_value_args LIBRARIES COMPILE_OPTIONS COMPILE_DEFINITIONS)
  cmake_parse_arguments(PACKAGE "" "${one_value_args}" "${multi_value_args}" ${ARGN})

  if(NOT PACKAGE_REPOSITORY_URL OR NOT PACKAGE_REPOSITORY_TAG)
    message(FATAL_ERROR "[${package_name}] REPOSITORY_URL and REPOSITORY_TAG must be provided.")
    return()
  endif()

  include(FetchContent)

  FetchContent_Declare(
    ${package_name}
    GIT_REPOSITORY ${PACKAGE_REPOSITORY_URL}
    GIT_TAG ${PACKAGE_REPOSITORY_TAG}
    GIT_SHALLOW TRUE
  )

  FetchContent_MakeAvailable(${package_name})

  if(PACKAGE_LIBRARIES)
    if(PACKAGE_COMPILE_OPTIONS OR PACKAGE_COMPILE_DEFINITIONS)
      message(STATUS "[${package_name}] Applying custom compile settings to targets: ${PACKAGE_LIBRARIES}")

      foreach(target_name IN LISTS PACKAGE_LIBRARIES)
        if(NOT TARGET ${target_name})
          message(
            WARNING "[${package_name}] Target '${target_name}' not found. Cannot apply compile settings."
          )
          continue()
        endif()

        get_target_property(aliased_target ${target_name} ALIASED_TARGET)

        if(aliased_target)
          set(actual_target ${aliased_target})
        else()
          set(actual_target ${target_name})
        endif()

        if(PACKAGE_COMPILE_OPTIONS)
          target_compile_options(${actual_target} PRIVATE ${PACKAGE_COMPILE_OPTIONS} --coverage)
        endif()

        if(PACKAGE_COMPILE_DEFINITIONS)
          target_compile_definitions(${actual_target} PRIVATE ${PACKAGE_COMPILE_DEFINITIONS})
        endif()
      endforeach()
    endif()
  elseif(PACKAGE_COMPILE_OPTIONS OR PACKAGE_COMPILE_DEFINITIONS)
    message(
      WARNING
      "[${package_name}] COMPILE_OPTIONS or COMPILE_DEFINITIONS were provided, but no LIBRARIES were specified to apply them to."
    )
  endif()

  message(STATUS "[${package_name}] Configuration complete. Targets from ${package_name} are now available.")

  # --- Function End: add_external_package
endfunction()
