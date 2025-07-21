include(${CMAKE_SOURCE_DIR}/cmake/common/configure_subdirectory.cmake)

# Description:
# Adds all direct subdirectories of a given directory to the build.
#
# Arguments:
# DIRECTORY_PATH: The path to the parent directory.
function(add_subdirectories DIRECTORY_PATH)
  # --- Function Start: add_subdirectories
  if(NOT DIRECTORY_PATH)
    message(FATAL_ERROR "add_subdirectories() requires the 'DIRECTORY_PATH' argument.")
  endif()

  if(NOT IS_DIRECTORY "${DIRECTORY_PATH}")
    message(FATAL_ERROR "Argument '${DIRECTORY_PATH}' is not a valid directory.")
  endif()

  file(GLOB sub_directories
    CONFIGURE_DEPENDS
    RELATIVE "${DIRECTORY_PATH}"
    "${DIRECTORY_PATH}/*"
  )

  foreach(sub_directory ${sub_directories})
    if(IS_DIRECTORY "${DIRECTORY_PATH}/${sub_directory}")
      configure_subdirectory("${DIRECTORY_PATH}/${sub_directory}")
    endif()
  endforeach()

  # --- Function End: add_subdirectories
endfunction()
