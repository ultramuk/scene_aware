# Description:
# Configures a custom target for running the code formatter.
function(configure_formatter)
  # --- Function Start: configure_formatter
  find_program(CLANG_FORMAT_EXE clang-format)

  if(NOT ${PROJECT_NAME})
    return()
  endif()

  if(NOT TARGET ${PROJECT_NAME})
    return()
  endif()

  if(NOT CLANG_FORMAT_EXE)
    message(FATAL_ERROR "clang-format not found. Please install it or add it to your PATH.")
  endif()

  file(GLOB_RECURSE ALL_CXX_FILES
    LIST_DIRECTORIES false
    "${CMAKE_SOURCE_DIR}/include/*.hpp"
    "${CMAKE_SOURCE_DIR}/source/*.cpp"
    "${CMAKE_SOURCE_DIR}/tests/*.cpp"
    "${CMAKE_SOURCE_DIR}/executables/*.cpp"
  )

  if(EXISTS "${CMAKE_BINARY_DIR}")
    list(FILTER ALL_CXX_FILES EXCLUDE REGEX "${CMAKE_BINARY_DIR}/")
  endif()

  add_custom_target(format
    COMMAND chmod +x ${CMAKE_CURRENT_SOURCE_DIR}/scripts/executables/run_formatter.sh
    COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/scripts/executables/run_formatter.sh ${CLANG_FORMAT_EXE} ${ALL_CXX_FILES}
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    COMMENT "Formatting C++ code with clang-format"
    VERBATIM
  )

  add_dependencies(${PROJECT_NAME} format)

  message(STATUS "Added 'format' target for code formatting.")

  # --- Function End: configure_formatter
endfunction()
