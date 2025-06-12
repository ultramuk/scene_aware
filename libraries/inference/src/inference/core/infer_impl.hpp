#pragma once

#include "inference/core/infer.hpp"
#include "inference/core/config.hpp"
#include "inference/types/types.hpp"

#include <NvInfer.h>
#include <cuda_runtime_api.h>
#include <memory>
#include <string>
#include <vector>
#include <array>

#include <logger.h>

namespace inference::core {

// Custom deleter for TensorRT objects
template <typename T>
struct TRTDestory {
    void operator()(T* obj) const {
        if (obj) obj->destroy();
    }
};

class InferImpl : public Infer {
public:
    InferImpl(const std::string& engine_path, const InferConfig& config);
    ~InferImpl() override;

    std::vector<types::Detection> infer(const cv::Mat& image) override;

private:
    void loadEngine(const std::string& path);
    void allocateBuffers();
    void preprocess(const cv::Mat& image, float* device_input);
    std::vector<types::Detection> postprocess(const std::vector<float>& output);
    std::vector<float> softmax(const std::vector<float>& logits);

    sample::Logger gLogger_;
    std::unique_ptr<nvinfer1::IRuntime, TRTDestory<nvinfer1::IRuntime>> runtime_;
    std::unique_ptr<nvinfer1::ICudaEngine, TRTDestory<nvinfer1::ICudaEngine>> engine_;
    std::unique_ptr<nvinfer1::IExecutionContext, TRTDestory<nvinfer1::IExecutionContext>> context_;

    cudaStream_t stream_ = nullptr;

    std::array<void*, 2> buffers_ = {nullptr, nullptr}; // input=0, output=0
    int input_index_ = -1;
    int output_index_ = -1;

    size_t output_size_ = 0;
    InferConfig config_;
};

} // namespace infenece::core
