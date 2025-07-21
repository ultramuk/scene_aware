# Description:
# Configures default compiler flags (COMPILER_FLAGS) if the variable is not already defined.
# It selects flags based on the CMAKE_CXX_COMPILER_ID (MSVC or GCC/Clang).
function(configure_default_compiler_flags)
  # --- Function Start: configure_default_compiler_flags
  set(_DEFAULT_COMPILER_FLAGS)

  # macOS: locate correct SDK and add -isysroot flag so compiler uses it
  if(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
    execute_process(COMMAND xcrun --sdk macosx --show-sdk-path
      OUTPUT_VARIABLE MACOS_SDK_PATH
      OUTPUT_STRIP_TRAILING_WHITESPACE)
    set(CMAKE_OSX_SYSROOT "${MACOS_SDK_PATH}")
    message(STATUS "Set macOS SDK path: ${MACOS_SDK_PATH}")

    # Prepend isysroot flag for Clang so it appears in compile_commands.json
    list(PREPEND _DEFAULT_COMPILER_FLAGS "-isysroot" "${CMAKE_OSX_SYSROOT}")
  endif()

  if(NOT DEFINED COMPILER_FLAGS)
    if(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
      set(local_compiler_flags ${COMPILER_FLAGS_FOR_MSVC})
    else()
      set(local_compiler_flags ${COMPILER_FLAGS_FOR_GCC})
    endif()

    list(APPEND local_compiler_flags ${_DEFAULT_COMPILER_FLAGS})
    set(COMPILER_FLAGS ${local_compiler_flags} PARENT_SCOPE)
    message(STATUS "Default compiler flags configured: ${COMPILER_FLAGS}")
  else()
    list(APPEND COMPILER_FLAGS ${_DEFAULT_COMPILER_FLAGS})
    set(COMPILER_FLAGS ${COMPILER_FLAGS} PARENT_SCOPE)
    message(STATUS "Appended default flags to existing COMPILER_FLAGS.")
  endif()

  # --- Function End: configure_default_compiler_flags
endfunction()
