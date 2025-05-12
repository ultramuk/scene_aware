#pragma once

#include <opencv2/core.hpp>
#include <optional>
#include <string>

namespace inference::types {

enum class ObjectClass {
    Vehicle = 0,
    Person = 1,
    Crash = 2,
    Unknown = -1
};

struct Detection {
    cv::Rect box;
    float confidence;
    ObjectClass class_id;
    std::optional<std::string> label;
};

}
