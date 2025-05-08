#include "string_utils/trim.hpp"
#include <cctype>

namespace string_utils {
    std::string Trim(const std::string& input) {
        auto begin = input.find_first_not_of(" \\\\t\\\\n\\\\r");
        auto end = input.find_last_not_of(" \\\\t\\\\n\\\\r");
        return (begin == std::string::npos) ? "" : input.substr(begin, end - begin + 1);
    }
}