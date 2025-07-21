# Description:
# Configures a subdirectory by adding it to the build if it contains a CMakeLists.txt file.
#
# Arguments:
# DIRECTORY_PATH: The path to the subdirectory to configure.
function(configure_subdirectory DIRECTORY_PATH)
  # --- Function Start: configure_subdirectory
  if(NOT DIRECTORY_PATH)
    message(FATAL_ERROR "configure_subdirectory() requires the 'DIRECTORY_PATH' argument.")
  endif()

  get_filename_component(subdirectory_name "${DIRECTORY_PATH}" NAME)

  message(STATUS "-- Configuring subdirectory: ${subdirectory_name} (${DIRECTORY_PATH})")

  if(EXISTS "${DIRECTORY_PATH}/CMakeLists.txt")
    add_subdirectory("${DIRECTORY_PATH}")
    message(STATUS "-- Finished configuring subdirectory: ${subdirectory_name}")
  else()
    message(STATUS "-- No CMakeLists.txt found in ${subdirectory_name}, skipping configuration.")
  endif()

  # --- Function End: configure_subdirectory
endfunction()
