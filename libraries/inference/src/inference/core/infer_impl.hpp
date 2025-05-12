#pragma once

#include "inference/core/infer.hpp"
#include "inference/core/config.hpp"
#include "inference/types/types.hpp"

#include <NvInfer.h>
#include <cuda_runtime_api.h>
#include <memory>
#include <string>
#include <vector>

namespace inference::core {

class InferImpl : public Infer {
public:
    InferImpl(const std::string& engine_path, const InterConfig& config);
    ~InferImpl() override;

    std::vector<types::Detection> infer(const cv::Mat& image) override;

private:
    void loadEngine(const std::string& path);
    void allocateBuffers();

    nvinfer1::IRuntime* runtime_ = nullptr;
    nvinfer1::ICudaEngine* engine_ = nullptr;
    nvinfer1::IExecutionContext* context_ = nullptr;
    cudaStream_t stream_ = nullptr;

    void* buffers_[2] = {nullptr, nullptr}; // [0]=input, [1]=output
    int input_index_ = -1;
    int output_index_ = -1;

    InterConfig config_;
}

} // namespace infenece::core
