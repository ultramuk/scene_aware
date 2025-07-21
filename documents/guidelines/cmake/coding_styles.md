# CMake 코딩 스타일 규칙

버전 v1.0
생성일 2025-07-07
소유자 @kmlim

---

## 0. Overview

- **목적** 프로젝트 전반에 걸쳐 CMake 스크립트의 일관성, 가독성, 유지보수성을 보장하기 위함.
- **범위** 이 리포지토리 내의 모든 `CMakeLists.txt` 및 `*.cmake` 파일.
- **대상** 이 프로젝트에 기여하는 모든 개발자.

---

## 1. 목차

1. [핵심 원칙](#2-핵심-원칙)
2. [서식](#3-서식)
3. [스타일 규칙](#4-스타일-규칙)

---

## 2. 핵심 원칙

### 원칙 1 최신의, 타겟 중심적인 CMake를 선호

- **범위** 모든 타겟 정의 및 속성 수정.
- **근거** `target_*` 명령어를 사용하면 속성을 필요한 타겟에 명시적으로 연결하여 모듈성, 캡슐화 및 명확성을 향상시킴. 이는 구식의 디렉토리 기반 명령어에서 흔히 발생하는 부작용과 숨겨진 종속성을 피하게 함.

### 원칙 2 자체 문서화되는 코드 작성

- **범위** 모든 변수, 함수, 타겟.
- **근거** 명확하고 서술적인 이름은 설명 주석의 필요성을 줄여 빌드 로직을 더 쉽게 이해하고 유지보수할 수 있게 함.

### 원칙 3 약어를 사용하지 않음

- **범위** 모든 식별자(변수, 함수, 타겟 등).
- **근거** 전체 단어를 사용하면 명확성이 보장되어 코드를 처음 접하는 사람도 그 의도를 쉽게 파악할 수 있음.

### 원칙 4 의미적으로 명확한 이름 사용

- **범위** 모든 식별자.
- **근거** 이름은 요소의 목적이나 내용을 명확하게 설명해야 함. 이는 코드의 역할을 반영하고 빌드 프로세스를 이해하는 데 도움이 됨.

---

## 3. 서식

> **설명** 포매터와 린터에 의해 강제될 수 있는 규칙을 포함하여 일관된 모양과 느낌을 보장합니다.

### 3.1 이름 지정 규칙

| 코드 요소 | 이름 지정 스타일 | 예시 |
| :--- | :--- | :--- |
| 명령어 | `lowercase` | `project()`, `add_executable()` |
| 변수 (지역) | `lower_case_with_underscores` | `my_local_variable` |
| 변수 (전역) | `UPPER_CASE_WITH_UNDERSCORES` | `MY_PROJECT_VERSION` |
| 함수/매크로 | `lower_case_with_underscores` | `my_custom_function()` |
| 타겟 | `PascalCase` | `MyExecutable`, `MyLibrary` |
| 속성 | `UPPERCASE` | `CXX_STANDARD` |

### 3.2 서식 규칙

#### 서식 규칙 1 모든 명령어 이름에 소문자 사용

- **범위** 모든 CMake 명령어.
- **근거** CMake 명령어는 대소문자를 구분하지 않지만, 일관된 스타일은 가독성을 향상시킴.


```cmake
# GOOD
project(MyProject)
add_executable(MyTarget main.cpp)

# BAD
PROJECT(MyProject)
Add_Executable(MyTarget main.cpp)
```

#### 서식 규칙 2 들여쓰기는 2칸 공백 사용

- **범위** 모든 들여쓰기 블록.
- **근거** 탭 너비 설정에 의존하지 않고 일관된 들여쓰기를 보장함.

```cmake
# GOOD
if(CONDITION)
  message("2칸으로 들여쓰기")
endif()

# BAD
if(CONDITION)
    message("4칸으로 들여쓰기")
endif()
```

#### 서식 규칙 3 줄 길이는 100자 미만으로 유지

- **범위** 모든 코드 라인.
- **근거** 분할 화면이나 터미널 뷰에서 가독성을 향상시킴.

---

## 4. 스타일 규칙

### 4.1 명령어 사용

#### 명령어 사용 규칙 1 가독성을 위해 다중 인수 명령어 구조화

- **범위** `target_link_libraries`와 같이 여러 인수를 갖는 명령어.
- **근거** 각 인수를 새 줄에 배치하면 종속성과 속성을 쉽게 파악할 수 있음.

```cmake
# GOOD
target_link_libraries(MyTarget
  PUBLIC
    MyLibrary1
  PRIVATE
    MyLibrary2
)

# BAD
target_link_libraries(MyTarget PUBLIC MyLibrary1 PRIVATE MyLibrary2)
```

#### 명령어 사용 규칙 2 항상 PUBLIC/PRIVATE/INTERFACE를 명시

- **범위** 가시성 키워드를 받는 모든 `target_*` 명령어.
- **근거** 종속성과 속성의 범위를 명시적으로 지정하면 모호성을 방지하고 올바르게 전파되도록 보장함.

```cmake
# GOOD
target_include_directories(MyLibrary
  INTERFACE
    "${CMAKE_CURRENT_SOURCE_DIR}/include"
)

# BAD (그리고 PUBLIC으로 기본 설정되어 의도와 다를 수 있음)
target_include_directories(MyLibrary
  "${CMAKE_CURRENT_SOURCE_DIR}/include"
)
```

### 4.2 파일 구조

#### 파일 구조 규칙 1 `CMakeLists.txt` 를 논리적 섹션으로 구성

- **범위** 모든 `CMakeLists.txt` 파일.
- **근거** 일관된 구조는 파일을 예측 가능하고 탐색하기 쉽게 만듦.

```cmake
# GOOD
cmake_minimum_required(VERSION 3.15)
project(MyProject LANGUAGES CXX)

# --- 옵션(Options)
option(BUILD_TESTS "Build the tests" ON)

# --- 종속성(Dependencies)
find_package(fmt REQUIRED)

# --- 타겟(Targets)
add_library(MyLibrary my_library.cpp)

# --- 타겟 속성(Target Properties)
target_link_libraries(MyLibrary PUBLIC fmt::fmt)

# --- 테스팅(Testing)
if(BUILD_TESTS)
  # ...
endif()
```

### 4.3 변수

#### 변수 규칙 1 전역 변수 사용 최소화

- **범위** 변수 선언.
- **근거** 전역 변수는 숨겨진 종속성을 만듦. 함수 인수를 통해 변수를 전달하거나 타겟 속성을 사용하는 것을 선호.

```cmake
# GOOD
# 속성은 타겟과 함께 캡슐화됨
target_compile_definitions(MyTarget PRIVATE MY_DEFINITION)

# BAD
# 이는 디렉토리 내의 모든 후속 타겟에 영향을 미침
add_compile_definitions(MY_DEFINITION)
```

### 4.4 이름 지정 원칙

#### 이름 지정 원칙 규칙 1 약어 대신 전체 단어 사용

- **범위** 모든 식별자.
- **근거** 명확성을 보장하고 코드의 의도를 쉽게 파악할 수 있게 함.

```cmake
# GOOD
set(source_directory ${CMAKE_CURRENT_SOURCE_DIR}/src)

# BAD
set(src_dir ${CMAKE_CURRENT_SOURCE_DIR}/src)
```

#### 이름 지정 원칙 규칙 2 이름은 목적과 내용을 명확하게 설명해야 함

- **범위** 모든 식별자.
- **근거** 자체 설명적인 이름은 주석의 필요성을 줄이고 유지보수성을 향상시킴.


```cmake
# GOOD
set(executable_sources
  main.cpp
  utils.cpp
)

# BAD
set(file_list
  main.cpp
  utils.cpp
)
```
