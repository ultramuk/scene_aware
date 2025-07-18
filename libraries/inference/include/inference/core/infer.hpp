#pragma once
#include <memory>
#include <vector>
#include <opencv2/core.hpp>

#include "inference/types/types.hpp"
#include "inference/core/config.hpp"

namespace inference::core {

/**
 * @brief Abstract class representing a generic inference engine.
 *        Users interact with this interface only.
 */
class Infer {
public:
    virtual ~Infer() = default;

    /**
     * @brief Create an instance of the interence engine.
     * @param engine_path Path to the serialized TensorRT engine (.engine)
     * @param config Configuration parameters (input size, thresholds, etc.)
     * @return unique_ptr to an Infer object
     */
    static std::unique_ptr<Infer> create(const std::string& engine_path, const inference::core::InferConfig& config);

    /**
     * @brief Perform inference on a given image
     * @param image Input image (OpenCV Mat, BGR or RGB depending on preprocess)
     * @return Vector of detection results
     */
    virtual std::vector<types::Detection> infer(const cv::Mat& image) = 0;

protected:
    Infer() = default;
};

} // namespace inference::core
