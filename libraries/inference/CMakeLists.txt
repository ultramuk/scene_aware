include(${CMAKE_SOURCE_DIR}/cmake/module/common/get_module_project_name.cmake)

cmake_minimum_required(VERSION ${CMAKE_VERSION_MINIMUM})

file(GLOB_RECURSE INFERENCE_SOURCES CONFIGURE_DEPENDS src/*.cpp)

add_library_module(
    NAME inference
    SOURCES ${INFERENCE_SOURCES}
    DEPENDENCIES opencv_world
)

get_module_project_name(MODULE_PROJECT_NAME)
project(${MODULE_PROJECT_NAME})

# ---------------------------------------------------------------------------
# CUDA
# ---------------------------------------------------------------------------
set(THIRDPARTY_INCLUDE_PATH PUBLIC /opt/laonpeople/3rdparty/include)
set(THIRDPARTY_LIBRARY_PATH PUBLIC /opt/laonpeople/3rdparty/lib)

# ---------------------------------------------------------------------------
# CUDA
# ---------------------------------------------------------------------------
# set_property(TARGET ${PROJECT_NAME} PROPERTY CUDA_STANDARD 17)

target_include_directories(${PROJECT_NAME} PUBLIC /usr/local/cuda/include)
find_library(INFERENCE_CUDA_CUDART cudart HINT /usr/local/cuda-11.4/targets/x86_64-linux/lib)
target_link_libraries(${PROJECT_NAME} PUBLIC ${INFERENCE_CUDA_CUDART})
# ---------------------------------------------------------------------------
# NVIDIA TensorRT
# ---------------------------------------------------------------------------
target_include_directories(${PROJECT_NAME} PUBLIC ${THIRDPARTY_INCLUDE_PATH}/tensorrt)
target_include_directories(${PROJECT_NAME} PUBLIC /usr/src/tensorrt/samples/common/)

find_library(INFER_TENSORRT_NVINFER         nvinfer         HINT ${THIRDPARTY_LIBRARY_PATH})
find_library(INFER_TENSORRT_NVINFER_PLUGIN 	nvinfer_plugin 	HINT ${THIRDPARTY_LIBRARY_PATH})
find_library(INFER_TENSORRT_NVPARSERS 		nvparsers 		HINT ${THIRDPARTY_LIBRARY_PATH})
find_library(INFER_TENSORRT_NVONNXPARSER 	nvonnxparser 	HINT ${THIRDPARTY_LIBRARY_PATH})
find_library(INFER_TENSORRT_MYELIN 			myelin 			HINT ${THIRDPARTY_LIBRARY_PATH})

target_link_libraries(${PROJECT_NAME} PUBLIC ${INFER_TENSORRT_NVINFER})
target_link_libraries(${PROJECT_NAME} PUBLIC ${INFER_TENSORRT_NVINFER_PLUGIN})
target_link_libraries(${PROJECT_NAME} PUBLIC ${TAS_INFER_TENSORRT_NVPARSERS})
target_link_libraries(${PROJECT_NAME} PUBLIC ${INFER_TENSORRT_NVONNXPARSER})
if(EXISTS ${INFER_TENSORRT_MYELIN})
    target_link_libraries(${PROJECT_NAME} PUBLIC ${INFER_TENSORRT_MYELIN})
endif()
