# =============================================================================
# Project Configuration
# =============================================================================
# --- CMake Version
cmake_minimum_required(VERSION 3.15)

# --- Project Definition
project(
  template
  VERSION 0.0.0
  DESCRIPTION "A C++ project template with a focus on readable code."
  HOMEPAGE_URL "https://github.com/movingChurch/readable-code-cpp-project-template"
)

# --- Project Options
option(ENABLE_TESTING "Enable testing" ON)

# =============================================================================
# Compiler and Linker Settings
# =============================================================================
# --- Compiler Features
set(COMPILER_FEATURES cxx_std_20)

# --- Compiler Flags
set(COMPILER_FLAGS_FOR_MSVC
  /W4
  /WX
  /permissive-
)
set(COMPILER_FLAGS_FOR_GCC
  -Wall
  -Wpedantic
  -Wextra
  -Werror
)

# --- Linker Flags
set(LINKER_FLAGS "")

# =============================================================================
# Module and Project Setup
# =============================================================================
# --- Include Custom Modules
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")

set(interface_modules
  configure_project
  configure_library
  configure_executable
  configure_doxygen
  configure_formatter
  configure_static_analysis
  configure_tests
)

foreach(module IN LISTS interface_modules)
  include(interface/${module})
endforeach()

# --- Configure Project
# Sets up essential project-wide configurations.
configure_project(${PROJECT_NAME})

# =============================================================================
# Target Definitions
# =============================================================================
# --- Add Library
set(source_files
  source/example/math/add.cpp
  source/example/math/subtract.cpp
)

set(library_dependencies "")

configure_library(
  TYPE STATIC
  SOURCES ${source_files}
  DEPENDENCIES ${library_dependencies}
)

# --- Add Executable
configure_executable(
  SOURCE executables/print_math_result.cpp
  DEPENDENCIES spdlog
)

# =============================================================================
# Testing and Tools
# =============================================================================
# --- Configure Testing
if(ENABLE_TESTING)
  enable_testing()

  configure_tests(
    TEST_DIR "${CMAKE_CURRENT_SOURCE_DIR}/tests"
    ENABLE_COVERAGE ON
    FUNCTION_COVERAGE 100
    LINE_COVERAGE 90
  )
endif()

# --- Configure Tools
configure_doxygen()
configure_formatter()
configure_static_analysis(SOURCES ${source_files})
