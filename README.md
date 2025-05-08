# CrashNet: Real-Time Vehicle Accident Detection System
CrashNet is a real-time vehicle accident detection system built on deep learning and GPU-accelerated inference.
It integrates YOLOv8-based training, ONNX export, TensorRT optimization, and a C++ runtime engine for ultra-fast deployment.

## Features
- Detects vehicle accidents (crash, collision) from dashcam footage
- Supports public datasets (e.g., DAD: Dashcam Accident Dataset)
- Built with YOLOv8 and Ultralytics framework
- Converts PyTorch → ONNX → TensorRT engine for GPU optimization
- Real-time inference using C++ + TensorRT + OpenCV
- Modular structure for dataset prep, training, and deployment

## directory structure
```
CrashNet/
├── datasets/              # Public datasets (not in Git)
│   └── DAD/
│       ├── images/train/
│       ├── labels/train/
│       └── data.yaml
├── models/                # Trained & exported models
│   ├── yolov8_accident.pt
│   ├── yolov8_accident.onnx
│   └── yolov8_accident.trt
├── scripts/
│   ├── executable/
│   │   ├── train_yolov8.py
│   │   ├── export_onnx.py
│   │   └── convert_dad_json_to_yolo.py
│   └── features/
│       └── yolov8_utils.py
├── libraries/
│   └── inference/         # C++ inference module (TensorRT)
├── applications/
│   └── crashnet/          # Main application (C++ + OpenCV)
├── cmake/
│   └── FindTensorRT.cmake
└── CMakeLists.txt
```

## Requirements
- CMake ≥ 3.15
- C++17-compatible compiler (GCC, Clang, MSVC)
- Python ≥ 3.8
- PyTorch, Ultralytics (YOLOv8)
- OpenCV (Python + C++)
- TensorRT
- FFmpeg
- Git
- Bash (for scripts)

## Build & Run
### Configure & Build
```
cmake -B build
cmake --build build
```

### Choose Static or Shared Libraries
```
# Static libraries
cmake -B build -DBUILD_SHARED_LIBS=OFF

# Shared libraries (default)
cmake -B build -DBUILD_SHARED_LIBS=ON
```

### Run Application
```
./build/applications/<app_name>/<app_name>
```

## Add a New Library
1. Create directory:
```
mkdir -p libraries/my_lib/{include/my_lib,src}
```

2. Create `CMakeLists.txt`:
```
add_library_module(
    NAME my_lib
    SOURCES src/my_lib.cpp
)
```
3. Header file: `include/my_lib/my_lib.hpp`
4. Source file: `src/my_lib.cpp`
5. (Optional) Add `test/` directory with `add_test_suite()` if testing is needed

## Add a New Application
1. Create directory:
```
mkdir -p applications/my_app
```
2. Create `CMakeLists.txt`
```
add_application_module(
    NAME my_app
    SOURCES main.cpp
    DEPENDENCIES my_project__my_lib
)
```
3. Add `main.cpp` source file

### Add an External Package
1. Create directory:
```
mkdir -p externals/<package_name>
```

2. Create `CMakeLists.txt`:
```
add_external_package(
    VERSION 1.0.0
    DESCRIPTION "Some external lib"
    REPOSITORY_URL "<https://github.com/example/lib.git>"
    REPOSITORY_TAG "v1.0.0"
    LIBRARIES lib1 lib2
    COMPILE_ARGUMENTS -DBUILD_TESTING=OFF
)
```

3. External packages are installed to:
```
install/<package_name>/<build_type>/
```

4. Registered as IMPORTED STATIC targets for linking

## Testing
- Add test files under `libraries/<module>/test/<category>/`
- Supported categories: `unit`, `integration`, etc.
- Register test suite with:
```
include(${CMAKE_SOURCE_DIR}/cmake/module/test/add_test_suite.cmake)
add_test_suite()
```
- Test executables are built to:
```
build/libraries/<module>/test/
```
- Run manually:
```
./build/libraries/<module>/test/<test_target>
```

## Platform-Aware Builds
- Source selection based on compiler/platform:
```
if(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    set(SOURCE src/msvc/impl.cpp)
else()
    set(SOURCE src/impl.cpp)
endif()
```
- Useful for Windows/Linux/macOS-specific implementations


## Script System
- `scripts/executable/`: Runnable scripts (e.g. `init.sh`)
- `scripts/features/`: Resuable shell modules
- Automatically executed by CMake during configuration
- Failure halt the build and print error messages


## License
MIT License.

## Contact
For questions for contributions:
- GitHub: [ultramuk/project_template](https://github.com/ultramuk/project_template)
