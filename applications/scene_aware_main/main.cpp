#include <iostream>
#include <opencv2/imgcodecs.hpp>

#include "inference/types/types.hpp"
#include "../../libraries/inference/src/inference/core/infer_impl.hpp"

int main(int argc, char** argv) {
    inference::core::InferConfig config;
    config.input_width = 224;
    config.input_height = 224;
    config.conf_threshold = 0.3f;

    inference::core::InferImpl infer("/home/super/workspace/scene_aware/model/scene_classifier.engine", config);

    // 유효한 이미지 입력
    cv::Mat image = cv::imread("/home/super/workspace/scene_aware/datasets/sceneaware_small/val/none/none-0006.jpg");
    if(image.empty()) {
        std::cerr << "image empty\n";
    }

    // 추론 수행
    std::vector<inference::types::Detection> result = infer.infer(image);

    if(result.empty()) {
        std::cerr << "result is empty\n";
    }

    std::cout << "class_id : " << static_cast<int>(result[0].class_id) << "\n";

    return 0;
}
