# Description:
# Sets common compile and link-related properties for a given target.
#
# Arguments:
# target_name (string): The name of the target for which to set properties.
function(set_target_compile_properties target_name)
  # --- Function Start: set_target_compile_properties
  if(NOT target_name)
    message(FATAL_ERROR "set_target_compile_properties: target_name argument is required.")
    return()
  endif()

  # Add include directory if a local 'include' folder exists.
  if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/include")
    message(STATUS "[${target_name}] Adding include directory: ${CMAKE_CURRENT_SOURCE_DIR}/include")
    target_include_directories(${target_name}
      PUBLIC
      "${CMAKE_CURRENT_SOURCE_DIR}/include"
    )
  endif()

  # Set required compiler features (e.g., C++ standard).
  if(COMPILER_FEATURES)
    message(STATUS "[${target_name}] Setting compiler features: ${COMPILER_FEATURES}")
    target_compile_features(${target_name}
      PRIVATE
      ${COMPILER_FEATURES}
    )
  else()
    message(WARNING "[${target_name}] COMPILER_FEATURES is not set. Skipping.")
  endif()

  # Set testing flags if enabled.
  if(ENABLE_TESTING)
    set(TEST_FLAGS "--coverage")
  endif()

  # Set compiler options.
  message(STATUS "[${target_name}] Setting compiler options: ${COMPILER_FLAGS} ${TEST_FLAGS}")
  target_compile_options(${target_name}
    PRIVATE
    ${COMPILER_FLAGS}
    ${TEST_FLAGS}
  )

  # Set linker options.
  message(STATUS "[${target_name}] Setting linker options: ${LINKER_FLAGS} ${TEST_FLAGS}")
  target_link_options(${target_name}
    PRIVATE
    ${LINKER_FLAGS}
    ${TEST_FLAGS}
  )

  # --- Function End: set_target_compile_properties
endfunction()
