/**
 * @file add.hpp
 * @author kmlim
 * @brief 정수 연산을 위한 add 함수 선언합니다.
 * @version 0.1
 * @date 2025-07-10
 *
 * @copyright LAONROAD (c) 2025
 *
 */
#ifndef EXAMPLE_MATH_ADD_HPP
#define EXAMPLE_MATH_ADD_HPP

namespace example::math {

/**
 * @brief 두 정소의 합을 계산합니다.
 *
 * 이 함수는 두 정수를 입력으로 받아 그 합을 반환합니다.
 * 이것은 간단한 산술 연산입니다.
 *
 * @param lhs 첫 번째 정수
 * @param rhs 두 번째 정수
 * @return 두 정수의 합
 */
auto Add(int lhs, int rhs) -> int;

} // namespace example::math

#endif // EXAMPLE_MATH_ADD_HPP
