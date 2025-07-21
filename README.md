# Readable Code C++ Project Template

A C++ project template with a focus on readable code, modular CMake, and developer productivity.

![license](https://img.shields.io/badge/license-HolyGround%20Custom-blueviolet)
![language](https://img.shields.io/badge/language-C++20-blue)
![cmake](https://img.shields.io/badge/language-CMake-orange)

---

## Overview

This project is a comprehensive C++ template designed to kickstart new projects with a clean, maintainable, and scalable structure. It emphasizes "readable code" not just in C++ but also in the build system itself, using a highly modular and modern CMake setup.

**Note:** The included source code (`add`, `subtract`) and tests are simple examples intended to demonstrate the template's structure and features. They are meant to be replaced by your own project's code.

It comes pre-configured with essential tools for high-quality software development:

- **Build Automation**: A powerful, modular CMake build system.
- **Dependency Management**: Easy integration of external libraries with `FetchContent` and Git submodules.
- **Testing**: Unit and integration testing with Catch2, CTest, and code coverage with gcovr.
- **Documentation**: Automatic API documentation generation with Doxygen.
- **Code Quality**: Enforced code style with `clang-format` and static analysis with `clang-tidy`.

This template is ideal for developers who want to focus on writing code without getting bogged down in the initial setup of a C++ project.

---

## Table of Contents

1. [Philosophy and Goals](#1-philosophy-and-goals)
2. [Features](#2-features)
3. [Project Structure](#3-project-structure)
4. [CMake Architecture](#4-cmake-architecture)
5. [Setup and Installation](#5-setup-and-installation)
6. [Usage Guide](#6-usage-guide)
7. [Customization Guide](#7-customization-guide)
8. [Code Style and Guidelines](#8-code-style-and-guidelines)
9. [License](#9-license)

---

## 1. Philosophy and Goals

### 1.1 Problem Definition

Starting a new C++ project involves significant boilerplate and configuration. Developers need to set up a build system, integrate testing frameworks, configure code quality tools, and establish a consistent project structure. This process is often time-consuming and error-prone.

### 1.2 Our Approach

This template solves the problem by providing a robust, pre-configured foundation based on these core principles:

- **Readability First**: Code should be easy to read and understand. This applies to C++ source code as well as the CMake build scripts.
- **Modularity**: The build system is broken down into small, reusable, and self-contained CMake modules. This makes it easy to extend and maintain.
- **Automation**: Repetitive tasks like testing, formatting, and documentation are automated through simple CMake targets.
- **Modern Practices**: The template uses modern C++ (C++20) and CMake (3.15+) features and follows target-centric best practices.

---

## 2. Features

| Feature | Description | Tools Used |
|---|---|---|
| **Build System** | Modular, target-centric build system. | CMake (3.15+) |
| **Core Library** | A sample library to demonstrate the project structure, ready to be replaced. | C++20 |
| **Executables** | Support for multiple executables linked against the core library. | C++20 |
| **Unit Testing** | Integrated unit and integration testing with automatic test discovery. | Catch2, CTest |
| **Code Coverage** | Test coverage reports generated automatically. | gcovr |
| **Code Formatting** | Consistent code style enforced with a single command. | clang-format |
| **Static Analysis** | Proactive bug detection and code quality checks. | clang-tidy |
| **Documentation** | Automatic API documentation from source code comments. | Doxygen |
| **Dependency Management** | Flexible dependency management for external (`FetchContent`) and internal (`Git Submodules`) libraries. | CMake, Git |

---

## 3. Project Structure

The project follows a standard directory layout that separates concerns and promotes modularity.

```bash
readable-code-cpp-project-template/
├── assets/                 # Static assets like Doxyfile.in for Doxygen.
├── cmake/                  # The heart of the build system: modular CMake scripts.
│   ├── common/             # Utility functions used across modules (e.g., auto-adding subdirectories).
│   ├── doxygen/            # Doxygen-specific configuration scripts.
│   ├── interface/          # High-level modules for configuring project components.
│   ├── library/            # Scripts for library and dependency handling.
│   ├── project/            # Project-wide configuration scripts.
│   └── test/               # Test-related configuration scripts.
├── dependencies/           # External and internal dependencies.
│   ├── externals/          # External libraries managed by FetchContent. Add a new folder here for each library.
│   └── internals/          # Dependencies managed as Git Submodules. Add submodules here.
├── documents/              # Project documentation, guidelines, and templates.
├── executables/            # Source code for final executables. Can contain loose .cpp files or subdirectories for larger executables.
├── include/                # Public header files for your library (example provided).
├── source/                 # Private source files for your library (example provided).
├── tests/                  # Test source code for your library (example provided).
├── .clang-format           # Configuration for clang-format.
├── .clang-tidy             # Configuration for clang-tidy.
└── CMakeLists.txt          # Top-level CMake entry point.
```

---

## 4. CMake Architecture

The build system is designed to be highly modular and easy to understand. The logic is organized into a `cmake/` directory, with a clear separation between high-level "interface" modules and their underlying implementations.

### 4.1 High-Level Interface

The main `CMakeLists.txt` uses simple, declarative functions from `cmake/interface/` to configure the project. This keeps the root `CMakeLists.txt` clean and focused on what the project *is*, not *how* it's built.

| Interface Module | File | Role |
|---|---|---|
| `configure_project` | `configure_project.cmake` | Initializes global settings, paths, and compiler flags. |
| `configure_library` | `configure_library.cmake` | Defines the main library target (`STATIC`, `SHARED`, or `INTERFACE`). |
| `configure_executable` | `configure_executable.cmake` | Defines an executable target and links it to libraries. |
| `configure_tests` | `configure_tests.cmake` | Sets up the entire test environment (Catch2, CTest, coverage). |
| `configure_doxygen` | `configure_doxygen.cmake` | Configures and creates the Doxygen documentation target. |
| `configure_formatter` | `configure_formatter.cmake` | Creates the `format` target for `clang-format`. |
| `configure_static_analysis` | `configure_static_analysis.cmake` | Creates the `static_analysis` target for `clang-tidy`. |

### 4.2 Low-Level Modules

The interface modules delegate the actual work to smaller, specialized scripts located in other `cmake/` subdirectories (`project/`, `library/`, `test/`, etc.). This encapsulation makes the system easier to debug and extend. For example, `configure_tests` calls helper scripts in `cmake/test/` to register individual test cases and check code coverage.

This design allows you to easily modify or replace parts of the build process without affecting the entire system. A key feature of this architecture is the automatic discovery of dependencies and executables placed in the `dependencies/` and `executables/` directories, which simplifies project management as it grows.

---

## 5. Setup and Installation

> **Requirements**
>
> - A C++20 compliant compiler (e.g., GCC, Clang, MSVC)
> - CMake 3.15 or higher
> - Git
> - `clang-format`, `clang-tidy` (for code quality tools)
> - `doxygen` (for documentation generation)
> - `gcovr` (for code coverage reporting)
>
> The project includes helper scripts to simplify the installation of these command-line tools.

### Build Instructions

```bash
# 1. Clone the repository and its submodules
git clone --recurse-submodules https://github.com/movingChurch/readable-code-cpp-project-template.git
cd readable-code-cpp-project-template

# If you've already cloned without submodules, run:
# git submodule update --init --recursive

# 2. Create a build directory and run CMake
#    (Use -DCMAKE_BUILD_TYPE=Debug for a debug build)
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release

# 3. Build the project
# For Linux/macOS with Makefiles
make -j$(nproc)

# For Windows with Visual Studio
cmake --build . --config Release

# For other generators (e.g., Ninja)
ninja
```

---

## 6. Usage Guide

All commands should be run from the `build` directory.

### 6.1 Running Executables

Executables are placed in the `build/bin` directory.

```bash
# Run the example executable
./bin/example__print_math_result
```

### 6.2 Running Tests

Run all tests using CTest. Test results and coverage reports will be generated.

```bash
# Run all tests and show output only on failure
ctest --output-on-failure

# Run tests with a specific label (e.g., all 'integration' tests)
ctest -L integration
```

### 6.3 Code Quality Tools

The template provides targets for formatting and static analysis.

```bash
# Auto-format all C++ files using .clang-format rules
make format

# Run static analysis on all sources using .clang-tidy rules
make static_analysis
```

### 6.4 Generating Documentation

Generate API documentation from Doxygen comments in the source code.

```bash
# Generate documentation
make create_documentations
```

The output will be saved in `build/documents/html`. Open `index.html` to view the documentation.

---

## 7. Customization Guide

This template is designed to be easily adapted to your own project. The build system automatically discovers and configures dependencies and executables placed in their respective directories, minimizing manual `CMakeLists.txt` edits.

### 7.1 Adding a New Executable

There are two ways to add a new executable, depending on its complexity.

#### Method 1: Simple Executable (Single Source File)

For a simple executable consisting of one `.cpp` file, the recommended approach is to add it directly to the root `CMakeLists.txt`.

1. Create a new `.cpp` file in the `executables/` directory (e.g., `my_app.cpp`).
2. In the root `CMakeLists.txt`, add a `configure_executable` call:

    ```cmake
    configure_executable(
      SOURCE executables/my_app.cpp
      DEPENDENCIES spdlog # Add other dependencies if needed
    )
    ```

#### Method 2: Complex Executable (Multiple Source Files)

For a more complex executable with multiple source files, you can give it its own subdirectory and `CMakeLists.txt`. This approach is more scalable and is **automatically detected** by the build system.

1. Create a new subdirectory inside `executables/` (e.g., `executables/my_complex_app`).
2. Place all source files for this executable inside the new subdirectory.
3. Create a `CMakeLists.txt` file inside `executables/my_complex_app`.
4. In this new `CMakeLists.txt`, define your executable target. You can use standard CMake commands or the provided helper functions.

    **Example `executables/my_complex_app/CMakeLists.txt`:**

    ```cmake
    # Get all source files in the current directory
    file(GLOB_RECURSE app_sources "*.cpp" "*.h")

    # Use the provided helper function to create the executable
    configure_executable(
      SOURCE ${app_sources}
      DEPENDENCIES spdlog # Add dependencies here
    )
    ```

5. **That's it!** You do not need to modify the root `CMakeLists.txt`. The build system will automatically find and configure your new executable when you run CMake.

### 7.2 Managing Dependencies

This template supports two primary methods for managing dependencies: `FetchContent` for most external libraries and `Git Submodules` for tightly coupled or internal dependencies. Both are designed to be automatically discovered.

#### Method 1: FetchContent (Recommended for most external libraries)

This method downloads and builds dependencies as part of the CMake configuration step. It's clean, automatic, and doesn't require developers to manage submodules.

1. Create a new directory in `dependencies/externals/` named after the library (e.g., `fmt`).
2. Inside that directory, create a `CMakeLists.txt`. You can copy the template from `dependencies/externals/template/CMakeLists.txt`.
3. Edit the new `CMakeLists.txt` and fill in the `add_external_package` function. You can also pass build options to the dependency, which is useful for disabling its tests or examples.

    **Example for `fmt` library (in `dependencies/externals/fmt/CMakeLists.txt`):**

    ```cmake
    include(${CMAKE_SOURCE_DIR}/cmake/library/add_external_package.cmake)

    add_external_package(
      REPOSITORY_URL "https://github.com/fmtlib/fmt.git"
      REPOSITORY_TAG "10.2.1"
      LIBRARIES fmt::fmt
      # You can pass options to the external project's build
      COMPILE_DEFINITIONS ""
      COMPILE_OPTIONS ""
    )
    ```

4. **That's it!** The build system will automatically find this new directory and configure the dependency.
5. Finally, add the library target (`fmt::fmt` in this case) to the `DEPENDENCIES` list of your library or executable in the appropriate `CMakeLists.txt` file.

#### Method 2: Git Submodules (For tightly coupled or internal dependencies)

This method keeps a specific commit of a dependency locked within your repository. It's useful when you need precise control over the dependency's version. The build system is configured to **automatically** detect and include any submodules placed in this directory.

1. Add the dependency as a Git submodule in the `dependencies/internals/` directory.

    ```bash
    git submodule add <repository_url> dependencies/internals/<library_name>
    ```

2. **That's it!** You do not need to modify any `CMakeLists.txt` files. The build system will automatically find the submodule and make its targets available.

3. Link the dependency to your target in the `configure_executable` or `configure_library` call in the relevant `CMakeLists.txt`.

    ```cmake
    configure_executable(
      SOURCE executables/print_math_result.cpp
      DEPENDENCIES spdlog # The target name from the dependency
    )
    ```

---

## 8. Code Style and Guidelines

To maintain consistency, this project follows a set of coding style rules. Please review them before contributing.

- **CMake Style**: See [CMake Coding Style Rules](./documents/guidelines/cmake/coding_styles.md). This document details the conventions for writing clean and maintainable CMake scripts.

---

## 9. License

This project is provided under the **HolyGround Software License Agreement**. Please see the [LICENSE](LICENSE) file for full details.

- **For Non-Commercial Use**: The software is licensed under the terms of the MIT License.
- **For Commercial Use**: Specific commercial terms apply. Please review the license agreement carefully.
