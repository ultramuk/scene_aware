/**
 * @file add.cpp
 * @author kmlim
 * @brief Add 함수와 Subtract 함수에 대한 통합 테스트.
 * @version 0.1
 * @date 2025-07-10
 *
 * @copyright LAONROAD (c) 2025
 *
 */
#include <catch2/catch_test_macros.hpp>

#include <random>

#include "example/math/add.hpp"
#include "example/math/subtract.hpp"

TEST_CASE(
        "Integration: Combined Add and Subtract operations with random numbers",
        "[integration][math][arithmetic]") {
    // 준비 (Arrange)
    constexpr int kNumIterations = 100;
    constexpr int kRange = 10000;
    std::random_device random_device;
    std::mt19937 generator(random_device());
    std::uniform_int_distribution<> distribution(-kRange, kRange);

    for (int i = 0; i < kNumIterations; ++i) {
        const int FirstNumber = distribution(generator);
        const int SecondNumber = distribution(generator);
        const int ThirdNumber = distribution(generator);

        // (a + b) - c에 대한 실행(Act)
        const int AddFirstResult = example::math::Add(FirstNumber, SecondNumber);
        const int FinalResult1 =
            example::math::Subtract(AddFirstResult, ThirdNumber);
        // FinalResult1에 대한 단언(Assert)
        REQUIRE(FinalResult1 == (FirstNumber + SecondNumber) - ThirdNumber);


        // a - (b + c)에 대한 실행(Act)
        const int AddSecondResult = example::math::Add(SecondNumber, ThirdNumber);
        const int FinalResult2 =
            example::math::Subtract(FirstNumber, AddSecondResult);
        // FinalResult2에 대한 단언(Assert)
        REQUIRE(FinalResult2 == FirstNumber - (SecondNumber + ThirdNumber));
    }
}
