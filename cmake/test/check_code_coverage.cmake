# Description:
# Configures code coverage generation using gcovr. This function is called
# by `configure_tests` and relies on arguments parsed in that scope.
#
# Relies on parent scope variables:
# ARG_ENABLE_COVERAGE: If TRUE, enables coverage.
# ARG_FUNCTION_COVERAGE: Minimum function coverage threshold.
# ARG_LINE_COVERAGE: Minimum line coverage threshold.
function(check_code_coverage)
  # --- Function Start: check_code_coverage
  if(NOT ARG_ENABLE_COVERAGE)
    return()
  endif()

  message(STATUS "-- Code coverage is enabled. Configuring gcovr...")

  # Validate that coverage thresholds are provided
  if(NOT ARG_FUNCTION_COVERAGE)
    message(FATAL_ERROR "ENABLE_COVERAGE is ON but 'FUNCTION_COVERAGE' is not set.")
  endif()

  if(NOT ARG_LINE_COVERAGE)
    message(FATAL_ERROR "ENABLE_COVERAGE is ON but 'LINE_COVERAGE' is not set.")
  endif()

  # Find gcovr executable
  find_program(GCOVR_EXECUTABLE gcovr)

  if(NOT GCOVR_EXECUTABLE)
    message(FATAL_ERROR "gcovr is not found. Please install it via brew or pip.")
  endif()

  # Add a custom command to generate the coverage report after tests run.
  add_custom_command(
    TARGET run_all_tests
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory "${CMAKE_BINARY_DIR}/coverage"
    COMMAND
    ${GCOVR_EXECUTABLE}
    --fail-under-function ${ARG_FUNCTION_COVERAGE}
    --fail-under-line ${ARG_LINE_COVERAGE}
    -r "${CMAKE_SOURCE_DIR}"
    --filter "${CMAKE_SOURCE_DIR}/source/.*"
    --filter "${CMAKE_SOURCE_DIR}/include/.*"
    --html-details "${CMAKE_BINARY_DIR}/coverage/index.html"
    "${CMAKE_BINARY_DIR}"
    COMMENT "Generating coverage report and checking thresholds..."
    VERBATIM
  )

  message(STATUS "-- Coverage setup complete. Report will be generated after tests run.")

  # --- Function End: check_code_coverage
endfunction()
