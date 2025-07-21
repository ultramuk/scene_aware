# Description:
# Converts a string to uppercase, replacing hyphens and spaces with underscores.
#
# Arguments:
# INPUT_STRING: The string to convert.
# OUTPUT_VARIABLE_NAME: The variable to store the result in the parent scope.
function(convert_to_uppercase_with_underscores INPUT_STRING OUTPUT_VARIABLE_NAME)
  # --- Function Start: convert_to_uppercase_with_underscores
  if(NOT INPUT_STRING)
    message(FATAL_ERROR "convert_to_uppercase_with_underscores() requires 'INPUT_STRING'.")
  endif()

  if(NOT OUTPUT_VARIABLE_NAME)
    message(FATAL_ERROR "convert_to_uppercase_with_underscores() requires 'OUTPUT_VARIABLE_NAME'.")
  endif()

  string(REPLACE "-" "_" converted_string "${INPUT_STRING}")
  string(REPLACE " " "_" converted_string "${converted_string}")
  string(TOUPPER "${converted_string}" converted_string)
  set(${OUTPUT_VARIABLE_NAME} ${converted_string} PARENT_SCOPE)

  # --- Function End: convert_to_uppercase_with_underscores
endfunction()
