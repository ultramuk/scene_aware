# =============================================================================
# 외부 패키지 추가: Catch2
# =============================================================================
# 이 스크립트는 Catch2 라이브러리를 외부 패키지로 추가합니다.

include(${CMAKE_SOURCE_DIR}/cmake/library/add_external_package.cmake)

add_external_package(
  REPOSITORY_URL "https://github.com/catchorg/Catch2.git"
  REPOSITORY_TAG "v3.8.1"
  LIBRARIES catch2::catch2
)
