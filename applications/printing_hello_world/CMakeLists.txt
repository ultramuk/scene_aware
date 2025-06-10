cmake_minimum_required(VERSION ${CMAKE_VERSION_MINIMUM})

add_application_module(
    NAME printing_hello_world
    SOURCES main.cpp
    DEPENDENCIES scene_aware__utils
)
