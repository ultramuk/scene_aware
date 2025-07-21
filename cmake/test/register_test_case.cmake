# Description:
# Registers a single test case with CTest, creating a unique test name and
# assigning labels based on its directory structure.
#
# Arguments:
# TEST_SOURCE_FILE: The full path to the test source file.
#
# Relies on parent scope variables:
# ARG_TEST_DIR: The root directory where all tests are located.
function(register_test_case TEST_SOURCE_FILE)
  # --- Function Start: register_test_case
  if(NOT TEST_SOURCE_FILE)
    message(FATAL_ERROR "register_test_case() requires 'TEST_SOURCE_FILE'.")
  endif()

  if(NOT ARG_TEST_DIR)
    message(FATAL_ERROR "register_test_case() requires 'ARG_TEST_DIR' to be set in the parent scope.")
  endif()

  # Generate a test name from the file path relative to the tests directory.
  file(RELATIVE_PATH relative_path "${ARG_TEST_DIR}" "${TEST_SOURCE_FILE}")
  get_filename_component(directory_path "${relative_path}" DIRECTORY)
  get_filename_component(test_basename "${relative_path}" NAME_WE)
  string(REPLACE "/" "." test_name_path "${directory_path}")

  if(test_name_path)
    set(full_test_name "${test_name_path}.${test_basename}")
  else()
    set(full_test_name "${test_basename}")
  endif()

  # The Catch2 tag corresponds to the test's basename.
  set(catch_tag "[${test_basename}]")

  add_test(NAME "${full_test_name}" COMMAND run_all_tests ${catch_tag})

  # Use the top-level directory within the tests folder as a label.
  string(REGEX MATCH "^[^/]+" test_label "${directory_path}")

  if(test_label)
    set_tests_properties("${full_test_name}" PROPERTIES LABELS "${test_label}")
  endif()

  # --- Function End: register_test_case
endfunction()
