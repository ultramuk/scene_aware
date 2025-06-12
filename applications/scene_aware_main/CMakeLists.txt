cmake_minimum_required(VERSION ${CMAKE_VERSION_MINIMUM})

add_application_module(
    NAME string_printer
    SOURCES main.cpp
    DEPENDENCIES scene_aware__inference
)
