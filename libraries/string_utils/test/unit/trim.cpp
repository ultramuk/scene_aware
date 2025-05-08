#include "string_utils/trim.hpp"
#include <gtest/gtest.h>

namespace string_utils {
    TEST(Trim, Basic) {
        EXPECT_EQ(Trim("  hello "), "hello");
        EXPECT_EQ(Trim("\\\\n\\\\t test\\\\t\\\\n"), "test");
        EXPECT_EQ(Trim(""), "");
    }
}
