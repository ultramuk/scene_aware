#include "utils/print.hpp"
#include <iostream>

namespace project_template::utils {
    void Print(const std::string& message) {
        std::cout << "[Common] " << message << std::endl;
    }
}
