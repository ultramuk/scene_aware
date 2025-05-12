cmake_minimum_required(VERSION ${CMAKE_VERSION_MINIMUM})

file(GLOB_RECURSE INFERENCE_SOURCES CONFIGURE_DEPENDS src/*.cpp)

add_library_module(
    NAME inference
    SOURCES ${INFERENCE_SOURCES}
    DEPENDENCIES opencv nvinfer
)
