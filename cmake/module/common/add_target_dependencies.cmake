function(add_target_dependencies TARGET_NAME)
    cmake_parse_arguments(ARGUMENTS "" "" "DEPENDENCIES" ${ARGN})

    if(ARGUMENTS_DEPENDENCIES)
        target_link_libraries(${TARGET_NAME} PUBLIC ${ARGUMENTS_DEPENDENCIES})
    endif()
endfunction()
