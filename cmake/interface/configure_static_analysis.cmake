# Description:
# Configures a custom target for running static analysis with clang-tidy.
#
# Arguments:
# SOURCES: A list of source files to analyze.
function(configure_static_analysis)
  # --- Function Start: configure_static_analysis
  set(options)
  set(oneValueArgs)
  set(multiValueArgs SOURCES)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT ARG_SOURCES)
    return()
  endif()

  find_program(CLANG_TIDY_EXE clang-tidy)

  if(NOT CLANG_TIDY_EXE)
    message(FATAL_ERROR "clang-tidy not found. Please install it or add it to your PATH.")
  endif()

  # Define the custom target for running clang-tidy.
  add_custom_target(static_analysis
    COMMAND chmod +x ${CMAKE_CURRENT_SOURCE_DIR}/scripts/executables/run_static_analysis.sh
    COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/scripts/executables/run_static_analysis.sh
    ${CLANG_TIDY_EXE} ${CMAKE_BINARY_DIR} ${ARG_SOURCES}
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    COMMENT "Running static analysis with clang-tidy..."
    VERBATIM
  )

  add_dependencies(${PROJECT_NAME} static_analysis)

  message(STATUS "Added 'static_analysis' target for static analysis.")

  # --- Function End: configure_static_analysis
endfunction()
