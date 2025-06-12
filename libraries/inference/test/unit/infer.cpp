#include <gtest/gtest.h>
#include <opencv2/imgcodecs.hpp>

#include "../../src/inference/core/infer_impl.hpp"
#include "inference/types/types.hpp"

namespace inference::core {
    TEST(infer, LoadEngineAndInferReturnsEmptyOnBlankInput) {
        InferConfig config;
        config.input_width = 224;
        config.input_height = 640;
        config.conf_threshold = 0.1f;

        InferImpl infer("/home/super/workspace/scene_aware/model/scene_classifier.engine", config);

        // 빈 이미지 입력
        cv::Mat dummy(640, 640, CV_8UC3, cv::Scalar(0, 0, 0));
        std::vector<types::Detection> result = infer.infer(dummy);

        // 결과 확인
        EXPECT_TRUE(result.empty() || result[0].confidence < 0.5f);
    }

    TEST(infer, LoadEngineAndInferReturnsDetectionOnValidImage) {
        InferConfig config;
        config.input_width = 224;
        config.input_height = 224;
        config.conf_threshold = 0.3f;

        InferImpl infer("/home/super/workspace/scene_aware/model/scene_classifier.engine", config);

        // 유효한 이미지 입력
        cv::Mat image = cv::imread("/home/super/workspace/scene_aware/datasets/sceneaware_small/val/accident/accident-0004.jpg");
        ASSERT_FALSE(image.empty());

        // 추론 수행
        std::vector<types::Detection> result = infer.infer(image);

        // 결과 확인
        ASSERT_FALSE(result.empty()) << "유효 이미지에 대한 Detection이 없음";

        EXPECT_GT(result[0].confidence, 0.3f);
    }
}

