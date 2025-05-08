cmake_minimum_required(VERSION ${CMAKE_VERSION_MINIMUM})

add_application_module(
    NAME printing_goodbye_world
    SOURCES main.cpp
    DEPENDENCIES project_template__utils
)
