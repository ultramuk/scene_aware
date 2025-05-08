cmake_minimum_required(VERSION ${CMAKE_VERSION_MINIMUM})

if(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    set(PRINT_SOURCE src/msvc/print.cpp)
else()
    set(PRINT_SOURCE src/print.cpp)
endif()

# Custom option -based branch example
# option(USE_ALT_PRINT "Use alternative print implementation" OFF)

# if(USE_ALT_PRINT)
#     set(PRINT_SOURCE src/alt/print.cpp)
# endif()

# Examples of environment variable -based branch
# if(DEFINED ENV{USE_MOCK_PRINT})
#     set(PRINT_SOURCE src/mock/print.cpp)
# endif()

add_library_module(
    NAME utils
    SOURCES ${PRINT_SOURCE}
)
