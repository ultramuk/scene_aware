# Description:
# Configures and creates the custom Doxygen build target.
function(create_doxygen_target)
  # --- Function Start: create_doxygen_target
  configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/assets/doxyfile.in"
    "${DOXYGEN_CONFIG_FILE}"
    @ONLY
  )

  message(STATUS "Doxygen: Configuring target '${DOXYGEN_CONFIG_FILE}'")

  add_custom_target(create_documentations ALL
    COMMENT "Executing documentation generation"
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    DEPENDS ${DOXYGEN_CONFIG_FILE}
  )

  add_custom_command(
    TARGET create_documentations
    POST_BUILD
    COMMAND ${DOXYGEN_EXECUTABLE} ${DOXYGEN_CONFIG_FILE}
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    COMMENT "Generating API documentation with Doxygen..."
    VERBATIM
  )

  # --- Function End: create_doxygen_target
endfunction()
