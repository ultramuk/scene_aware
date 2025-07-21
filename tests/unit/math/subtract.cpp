/**
 * @file subtract.cpp
 * @author kmlim
 * @brief Subtract function에 대한 단위 테스트.
 * @version 0.1
 * @date 2025-07-10
 *
 * @copyright LAONROAD (c) 2025
 *
 */
#include "example/math/subtract.hpp"

#include <catch2/catch_test_macros.hpp>
#include <random>

TEST_CASE("Subtract function with random numbers", "[unit][math][subtract]") {
    // 준비(Arrange)
    constexpr int kNumIterations = 100;
    constexpr int kRange = 10000;
    std::random_device random_device;
    std::mt19937 generator(random_device());
    std::uniform_int_distribution<> distribution(-kRange, kRange);

    for(int i=0; i<kNumIterations; ++i) {
        const int FirstNumber = distribution(generator);
        const int SecondNumber = distribution(generator);
        const int ExpectedResult = FirstNumber - SecondNumber;

        // 실행(Act)
        const int ActualResult = example::math::Subtract(FirstNumber, SecondNumber);

        // 단언(Assert)
        REQUIRE(ActualResult == ExpectedResult);
    }
}
