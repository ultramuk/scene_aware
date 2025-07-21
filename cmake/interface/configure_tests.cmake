# Description:
# Configures the test environment, discovers tests, and sets up CTest.
#
# Arguments:
# TEST_DIR: Directory containing test source files.
# ENABLE_COVERAGE: Flag to enable code coverage.
# FUNCTION_COVERAGE: Minimum required function coverage percentage.
# LINE_COVERAGE: Minimum required line coverage percentage.

include(cmake/test/check_code_coverage.cmake)
include(cmake/test/register_test_case.cmake)

function(configure_tests)
  # --- Function Start: configure_tests
  set(options)
  set(oneValueArgs TEST_DIR ENABLE_COVERAGE FUNCTION_COVERAGE LINE_COVERAGE)
  set(multiValueArgs)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  # 소스 코드에는 존재하지만 강의에는 없음
  # if(NOT ${PROJECT_NAME})
  #   return()
  # endif()

  # if(NOT TARGET ${PROJECT_NAME})
  #   return()
  # endif()

  if(NOT ARG_TEST_DIR)
    message(FATAL_ERROR "configure_tests() requires the 'TEST_DIR' argument.")
  endif()

  include(CTest)

  file(GLOB_RECURSE test_sources
    CONFIGURE_DEPENDS "${ARG_TEST_DIR}/*.cpp"
  )

  add_executable(run_all_tests ${test_sources})

  set_target_compile_properties(run_all_tests)

  add_target_dependencies(run_all_tests
    DEPENDENCIES
    ${PROJECT_NAME}
    Catch2::Catch2WithMain
  )

  add_test(NAME all-tests COMMAND run_all_tests)

  foreach(test_source ${test_sources})
    register_test_case(${test_source})
  endforeach()

  add_custom_command(
    TARGET run_all_tests
    POST_BUILD
    COMMAND ${CMAKE_CTEST_COMMAND} --output-on-failure
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    COMMENT "Running all tests automatically after build..."
    VERBATIM
  )

  check_code_coverage()

  # --- Function End: configure_tests
endfunction()
