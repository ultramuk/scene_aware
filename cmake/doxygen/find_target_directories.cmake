# Description:
# Auto-detects input directories for Doxygen if not specified.
#
# Arguments:
# ARGN (list): A list of directories to search for. If empty, defaults are used.
function(find_target_directories)
  # --- Function Start: find_target_directories
  if(NOT ARGN)
    set(local_target_dirs "include" "source" "executables" "tests")
  else()
    set(local_target_dirs ${ARGN})
  endif()

  set(parent_source_dir ${CMAKE_SOURCE_DIR})
  set(detected_input_dirs "")

  foreach(current_dir ${local_target_dirs})
    if(EXISTS "${parent_source_dir}/${current_dir}")
      list(APPEND detected_input_dirs "${parent_source_dir}/${current_dir}")
    endif()
  endforeach()

  if(detected_input_dirs)
    set(TARGET_DIRS ${detected_input_dirs} PARENT_SCOPE)
    message(STATUS "Doxygen: Auto-detected input directories: ${TARGET_DIRS}")
  else()
    set(TARGET_DIRS ${parent_source_dir} PARENT_SCOPE)
    message(WARNING "Doxygen: Could not auto-detect directories. Defaulting to project root.")
  endif()

  message(STATUS "Doxygen: Final input directories: ${TARGET_DIRS}")

  # --- Function End: find_target_directories
endfunction()
