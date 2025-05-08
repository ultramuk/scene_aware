#include "math/add.hpp"
#include <gtest/gtest.h>

namespace project_template::math {
    TEST(Add, AddTwoNumbers) {
        EXPECT_EQ(Add(1, 2), 3);
        EXPECT_EQ(Add(-1, -1), -2);
    }
}
