include(${CMAKE_SOURCE_DIR}/cmake/core/target/get_library_type.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/external/library/get_library_filename.cmake)

function(configure_library LIBRARY_NAME PACKAGE_IDENTIFIER)
    cmake_parse_arguments(ARG "" "INCLUDE_SUBDIR" "" ${ARGN})

    if(NOT TARGET ${LIBRARY_NAME})
        message(STATUS "[DEBUG] configure_library: LIBRARY_NAME=${LIBRARY_NAME}, PACKAGE_IDENTIFIER=${PACKAGE_IDENTIFIER}")

        get_library_type(LIBRARY_TYPE)
        add_library(${LIBRARY_NAME} ${LIBRARY_TYPE} IMPORTED GLOBAL)

        get_library_filename(${LIBRARY_NAME} LIBRARY_FILENAME ${LIBRARY_TYPE})

        if(ARG_INCLUDE_SUBDIR)
            set(INCLUDE_DIR "${${PACKAGE_IDENTIFIER}_INSTALL_PATH}/include/${ARG_INCLUDE_SUBDIR}")
        else()
            set(INCLUDE_DIR "${${PACKAGE_IDENTIFIER}_INSTALL_PATH}/include")
        endif()

        set_target_properties(${LIBRARY_NAME} PROPERTIES
            IMPORTED_LOCATION "${${PACKAGE_IDENTIFIER}_INSTALL_PATH}/lib/${LIBRARY_FILENAME}"
            INTERFACE_INCLUDE_DIRECTORIES "${INCLUDE_DIR}"
        )
    endif()
endfunction()
