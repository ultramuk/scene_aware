#include "infer_impl.hpp"
#include "inference/logger/logger.hpp"  // logger 는 별도 구현 필요

#include <fstream>
#include <iostream>

namespace inference::core {

InferImpl::InferImpl(const std::string& engine_path, const InferConfig& config)
    : config_(config)
{
    loadEngine(engine_path);
    allocateBuffers();
}

InferImpl::~InferImpl() {
    if (buffers_[0]) cudaFree(buffers_[0]);
    if (buffers_[1]) cudaFree(buffers_[1]);

    if (context_) context_->destroy();
    if (engine_) engine_->destroy();
    if (runtime_) runtime_->destroy();

    if (stream_) cudaStreamDestroy(stream_);
}

void InferImpl::loadEngine(const std::string& path) {
    std::ifstream file(path, std::ios::binary);
    if (!file) throw std::runtime_error("Failed to open engine file: " + path);

    file.seekg(0, std::ios::end);
    size_t size = file.tellg();
    file.seekg(0, std::ios::beg);

    std::vector<char> engine_data(size);
    file.read(engine_data.data(), size);

    runtime_ = nvinfer1::createInferRuntime(inference::logger::gLogger);
    engine_ = runtime_->deserializeCudaEngine(engine_data.data(), size, nullptr);
    context_ = engine_->createExecutionContext();

    input_index_ = engine_->getBindingIndex("images");
    output_index_ = engine_->getBindingIndex("output0");

    cudaStreamCreate(&stream_);
}

void InferImpl::allocateBuffers() {
    auto input_dims = engine_->getBindingDimensions(input_index_);
    auto output_dims = engine_->getBindingDimensions(output_index_);

    size_t input_size = 1;
    for (int i = 0; i < input_dims.nbDims; ++i)
        input_size *= input_dims.d[i];

    size_t output_size = 1;
    for (int i = 0; i < output_dims.nbDims; ++i)
        output_size *= output_dims.d[i];

    cudaMalloc(&buffers_[0], input_size * sizeof(float));
    cudaMalloc(&buffers_[1], output_size * sizeof(float));
}

std::vector<types::Detection> InferImpl::infer(const cv::Mat& image) {
    // 1. preprocess(image, buffers_[0])  ← 추후 구현
    // 2. context_->enqueueV2(buffers_, stream_, nullptr);
    // 3. cudaMemcpy from output buffer
    // 4. postprocess(output_data) → std::vector<Detection>

    return {};  // 임시 반환
}

}  // namespace inference::core
