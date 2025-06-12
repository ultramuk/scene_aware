#pragma once

#include <opencv2/core.hpp>
#include <optional>
#include <string>

namespace inference::types {

enum class ObjectClass {
    Accident = 0,
    Construction = 1,
    Normal = 2,
    Police = 3
};

struct Detection {
    cv::Rect box;
    float confidence;
    ObjectClass class_id;
    std::optional<std::string> label;
};

}
