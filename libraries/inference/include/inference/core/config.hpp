#pragma once

namespace inference::core {

struct InferConfig {
    int input_width = 640;
    int input_height = 640;
    float conf_threshold = 0.5f;
    float nms_threshold = 0.45f;
    bool use_fp16 = true;
};

} // namespace inference::core
