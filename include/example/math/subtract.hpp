/**
 * @file subtract.hpp
 * @author kmlim
 * @brief 정수 연산을 위한 Subtract 함수를 선언합니다.
 * @version 0.1
 * @date 2025-07-10
 *
 * @copyright LAONROAD (c) 2025
 */
#ifndef EXAMPLE_MATH_SUBTRACT_HPP
#define EXAMPLE_MATH_SUBTRACT_HPP

namespace example::math {

/**
 * @brief 두 정수 간의 차이를 계산합니다.
 *
 * @param lhs 뺄셈을 당하는 정수.
 * @param rhs 빼는 정수.
 * @return 두 정수 간의 차이.
 */
auto Subtract(int lhs, int rhs) -> int;

}  // namespace example::math

#endif // EXAMPLE_MATH_SUBTRACT_HPP
