include(${CMAKE_SOURCE_DIR}/cmake/core/target/get_library_type.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/external/library/get_library_filename.cmake)

function(configure_library LIBRARY_NAME PACKAGE_IDENTIFIER)
    if(NOT TARGET ${LIBRARY_NAME})
        message(STATUS "[DEBUG] configure_library: LIBRARY_NAME=${LIBRARY_NAME}, PACKAGE_IDENTIFIER=${PACKAGE_IDENTIFIER}")

        get_library_type(LIBRARY_TYPE)
        add_library(${LIBRARY_NAME} ${LIBRARY_TYPE} IMPORTED GLOBAL)

        get_library_filename(${LIBRARY_NAME} LIBRARY_FILENAME ${LIBRARY_TYPE})

        set_target_properties(${LIBRARY_NAME} PROPERTIES
            IMPORTED_LOCATION "${${PACKAGE_IDENTIFIER}_INSTALL_PATH}/lib/${LIBRARY_FILENAME}"
            INTERFACE_INCLUDE_DIRECTORIES "${${PACKAGE_IDENTIFIER}_INSTALL_PATH}/include"
        )
    endif()
endfunction()
