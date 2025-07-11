# Root CMakeLists.txt
# - Defines project metadata and global settings
# - Initializes compiler flags and build options
# - Declares global project paths
# - Includes shared CMake modules
# - Registers subdirectories (libraries, applications, externals, scripts)

# CMake minimum version setting
set(CMAKE_VERSION_MINIMUM 3.15)
cmake_minimum_required(VERSION ${CMAKE_VERSION_MINIMUM})

# Project Meta Information Variable Declaration
set(PROJECT_NAME scene_aware)
set(PROJECT_VERSION 1.0.0)
set(PROJECT_DESCRIPTION "real-time vehicle accident detection system built on deep learning and GPU-accelerated inference")
set(PROJECT_HOMEPAGE_URL "https://github.com/ultramuk/scene_aware")

# Reset the project
project(
    ${PROJECT_NAME}
    VERSION ${PROJECT_VERSION}
    DESCRIPTION ${PROJECT_DESCRIPTION}
    HOMEPAGE_URL ${PROJECT_HOMEPAGE_URL}
)

# Setting whether library sharing is shared (default: dynamic)
option(BUILD_SHARED_LIBS "Build shared libraries instead of static ones" ON)

# Build type confirmation & Output control setting
if(CMAKE_BUILD_TYPE STREQUAL "Release")
    set(CMAKE_VERBOSE_MAKEFILE OFF)
else()
    set(CMAKE_VERBOSE_MAKEFILE ON)
endif()

# Compiler flag definition
macro(use_compilation_warning_as_error)
    if(MSVC)
        # Only enabled in debug because some old versions of VS STL generate
        # warnings when compiled in release configuration.
        add_compile_options($<$<CONFIG:Debug>:/WX>)
    elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        add_compile_options(-Werror)
    endif()
endmacro()

if(MSVC)
    # Only enabled in debug because some old versions of VS STL generate
    # unreachable code warning when compiled in release configuration.
    add_compile_options($<$<CONFIG:Debug>:/W4>)
endif()

if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    # using regular Clang or AppleClang
    add_compile_options(-Wall -Wconversion -Wshadow -Werror=conversion -Werror=sign-compare)
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    add_compile_options(-Wall -Wconversion -Wshadow -Wextra)
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Intel")
    # using Intel compiler
    add_compile_options(-Wall -Wconversion -Wshadow -Wextra -Werror=conversion -fPIC -Wno-deprecated-gpu-targets)
endif()

# Compiler ID -based conditional processing
if(NOT COMPILER_FLAGS)
    if(CMAKE_CXX_COMPILER_ID STREQUAL MSVC)
        set(COMPILER_FLAGS ${COMPILER_FLAGS_FOR_MSVC})
    else()
        set(COMPILER_FLAGS ${COMPILER_FLAGS_FOR_GCC})
    endif()
endif()

# C standard setting variable definition
set(COMPILER_FEATURES cxx_std_17)

# Including a string utility function and producing prefixes
include(${CMAKE_SOURCE_DIR}/cmake/core/string/convert_to_uppercase_with_underscores.cmake)
convert_to_uppercase_with_underscores(${PROJECT_NAME} UPPERCASE_PROJECT_NAME)

# Global path variables
set(${UPPERCASE_PROJECT_NAME}_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})
set(${UPPERCASE_PROJECT_NAME}_SOURCE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/source)
set(${UPPERCASE_PROJECT_NAME}_INCLUDE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/include)
set(${UPPERCASE_PROJECT_NAME}_BUILD_PATH ${CMAKE_CURRENT_BINARY_DIR}/build)
set(${UPPERCASE_PROJECT_NAME}_INSTALL_PATH ${CMAKE_CURRENT_BINARY_DIR}/install)
set(${UPPERCASE_PROJECT_NAME}_LIBRARY_PATH ${CMAKE_CURRENT_SOURCE_DIR}/libraries)
set(${UPPERCASE_PROJECT_NAME}_APPLICATION_PATH ${CMAKE_CURRENT_SOURCE_DIR}/applications)
set(${UPPERCASE_PROJECT_NAME}_EXTERNAL_PATH ${CMAKE_CURRENT_SOURCE_DIR}/externals)
set(${UPPERCASE_PROJECT_NAME}_SCRIPT_PATH ${CMAKE_CURRENT_SOURCE_DIR}/scripts)

# Common function expression
include(${CMAKE_SOURCE_DIR}/cmake/core/directory/configure_subdirectory.cmake)

# Each major directory configuration connection
configure_subdirectory(${${UPPERCASE_PROJECT_NAME}_EXTERNAL_PATH} "External")
configure_subdirectory(${${UPPERCASE_PROJECT_NAME}_LIBRARY_PATH} "Library")
configure_subdirectory(${${UPPERCASE_PROJECT_NAME}_APPLICATION_PATH} "Application")
configure_subdirectory(${${UPPERCASE_PROJECT_NAME}_SCRIPT_PATH} "Script")

# IMPORTED target check
# target_link_libraries(${PROJECT_NAME} PRIVATE gtest gtest_main)

# Output start message
message(STATUS "-----------------------------------------------------------------------------")
message(STATUS "Started all process in ${PROJECT_NAME} CMakeLists.txt.")
message(STATUS)

# System information output
message(STATUS "System Configurations")
message(STATUS "Architecture: ${CMAKE_SYSTEM_PROCESSOR}")
message(STATUS "Name: ${CMAKE_SYSTEM_NAME}")
message(STATUS "Version: ${CMAKE_SYSTEM_VERSION}")
message(STATUS)

# Project meta information output
message(STATUS "Project Configurations")
message(STATUS "Name: ${PROJECT_NAME}")
message(STATUS "Version: ${PROJECT_VERSION}")
message(STATUS "Description: ${PROJECT_DESCRIPTION}")
message(STATUS "Homepage URL: ${PROJECT_HOMEPAGE_URL}")
message(STATUS)

# Compiler setting output
message(STATUS "C++ Compiler Configurations")
message(STATUS "C++ Compiler ID: ${CMAKE_CXX_COMPILER_ID}")
message(STATUS "C++ Compiler Version: ${CMAKE_CXX_COMPILER_VERSION}")
message(STATUS "C++ Compiler Path: ${CMAKE_CXX_COMPILER}")
message(STATUS "C++ Build Type: ${CMAKE_BUILD_TYPE}")
message(STATUS "C++ Compiler Features: ${COMPILER_FEATURES}")
message(STATUS "C++ Compiler Flags: ${COMPILER_FLAGS}")
message(STATUS "Build Shared Libraries: ${BUILD_SHARED_LIBS}")
message(STATUS)

# Global path constant output
message(STATUS "Project Paths")
message(STATUS "Root: ${${UPPERCASE_PROJECT_NAME}_ROOT_PATH}")
message(STATUS "Build: ${${UPPERCASE_PROJECT_NAME}_BUILD_PATH}")
message(STATUS "Install: ${${UPPERCASE_PROJECT_NAME}_INSTALL_PATH}")
message(STATUS "Application: ${${UPPERCASE_PROJECT_NAME}_APPLICATION_PATH}")
message(STATUS "Library: ${${UPPERCASE_PROJECT_NAME}_LIBRARY_PATH}")
message(STATUS "External: ${${UPPERCASE_PROJECT_NAME}_EXTERNAL_PATH}")
message(STATUS "Script: ${${UPPERCASE_PROJECT_NAME}_SCRIPT_PATH}")
message(STATUS)

# Output termination message
message(STATUS "Finished all process in ${PROJECT_NAME} CMakeLists.txt.")
message(STATUS "-----------------------------------------------------------------------------")
