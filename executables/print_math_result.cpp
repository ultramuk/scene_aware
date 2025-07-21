/**
 * @file print_math_result.cpp
 * @author kmlim
 * @brief 추가 및 빼기 기능의 사용을 보여줍니다.
 * @version 0.1
 * @date 2025-07-10
 *
 * @copyright LAONROAD (C) 2025
 *
 * */
#include "example/math/add.hpp"
#include "example/math/subtract.hpp"
#include "spdlog/spdlog.h"

/**
 * @brief 프로그램의 주요 진입점
 *
 * 이 기능은 샘플 값으로 추가 및 빼기 기능을 호출하고
 * SPDLOG 라이브러리를 사용하여 결과를 표준 출력에 인쇄합니다.
 *
 * @return int는 성공적인 실행시 0을 반환합니다.
 */
auto main() -> int {
    const int AddResult = example::math::Add(10, 5);
    spdlog::info("10 + 5 = {}", AddResult);

    const int SubtractResult = example::math::Subtract(10, 5);
    spdlog::info("10 - 5 = {}", SubtractResult);

    return 0;
}
