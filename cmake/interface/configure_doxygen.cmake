# Description:
# Configures Doxygen for documentation generation.

include(${CMAKE_SOURCE_DIR}/cmake/doxygen/find_target_directories.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/doxygen/create_doxygen_target.cmake)

function(configure_doxygen)
  # --- Function Start: configure_doxygen
  find_package(Doxygen REQUIRED)

  set(DOXYGEN_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/documents)
  set(DOXYGEN_CONFIG_FILE ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile)

  find_target_directories("include" "source" "executables" "tests")
  string(REPLACE ";" " " DOXYGEN_INPUT "${TARGET_DIRS}")
  create_doxygen_target()

  message(STATUS "Doxygen module loaded. Documentation will be generated after building.")

  # --- Function End: configure_doxygen
endfunction()
