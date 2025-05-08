#include "string_utils/trim.hpp"
#include <iostream>

auto main() -> int {
    std::string raw = "   Hello World!   ";
    std::cout << "Trimmed: [" << string_utils::Trim(raw) << "]" << std::endl;
    return 0;
}
