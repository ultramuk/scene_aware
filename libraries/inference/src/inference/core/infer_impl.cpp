#include "infer_impl.hpp"

#include <fstream>
#include <stdexcept>
#include <algorithm>

#include <opencv2/imgproc.hpp>

namespace inference::core {

InferImpl::InferImpl(const std::string& engine_path, const InferConfig& config)
    : config_(config) {
    loadEngine(engine_path);
    allocateBuffers();
}

InferImpl::~InferImpl() {
    if (buffers_[0]) cudaFree(buffers_[0]);
    if (buffers_[1]) cudaFree(buffers_[1]);
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

    runtime_.reset(nvinfer1::createInferRuntime(gLogger_));
    engine_.reset(runtime_->deserializeCudaEngine(engine_data.data(), size, nullptr));
    context_.reset(engine_->createExecutionContext());

    input_index_ = engine_->getBindingIndex("input");
    output_index_ = engine_->getBindingIndex("output");

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
    if (image.empty()) {
        throw std::runtime_error("Input image is empty");
    }

    context_->setBindingDimensions(input_index_, nvinfer1::Dims4{1, 3, config_.input_height, config_.input_width});

    if (output_size_ == 0) {
        nvinfer1::Dims output_dims = context_->getBindingDimensions(output_index_);
        int size = 1;
        for (int i=0; i<output_dims.nbDims; ++i)
            size *= output_dims.d[i];
        output_size_ = size;
    }

    preprocess(image, static_cast<float*>(buffers_[input_index_]));

    if(!context_->enqueueV2(buffers_.data(), stream_, nullptr)) {
        std::cerr << "[ERROR] enqueue V2 failed\n";
    }

    std::vector<float> output(output_size_);
    cudaMemcpyAsync(output.data(), buffers_[output_index_], output_size_ * sizeof(float),
                    cudaMemcpyDeviceToHost, stream_);
    cudaStreamSynchronize(stream_);

    return postprocess(output);
}

void InferImpl::preprocess(const cv::Mat& image, float* device_input) {
    cv::Mat resized;
    cv::resize(image, resized, cv::Size(config_.input_width, config_.input_height));
    resized.convertTo(resized, CV_32FC3, 1.0 / 255.0f);

    std::vector<float> chw;
    chw.reserve(3 * config_.input_height * config_.input_width);
    for (int c = 0; c < 3; ++c) {
        for (int i = 0; i < config_.input_height; ++i) {
            for (int j = 0; j < config_.input_width; ++j) {
                chw.push_back(resized.at<cv::Vec3f>(i, j)[c]);
            }
        }
    }

    cudaMemcpyAsync(device_input, chw.data(), chw.size() * sizeof(float), cudaMemcpyHostToDevice, stream_);
}

std::vector<types::Detection> InferImpl::postprocess(const std::vector<float>& output) {
    std::vector<types::Detection> results;

    if (output.empty()) return results;

    auto probs = softmax(output);
    auto max_iter = std::max_element(probs.begin(), probs.end());
    int class_id = std::distance(probs.begin(), max_iter);
    float confidence = *max_iter;

    if (confidence >= config_.conf_threshold) {
        types::Detection det;
        det.class_id = static_cast<types::ObjectClass>(class_id);
        det.confidence = confidence;
        results.push_back(det);
    }

    return results;
}

std::vector<float> InferImpl::softmax(const std::vector<float>& logits) {
    std::vector<float> probs(logits.size());
    if (logits.empty()) return probs;

    float max_logit = *std::max_element(logits.begin(), logits.end());

    float sum_exp = 0.0f;
    for (float logit : logits) {
        sum_exp += std::exp(logit - max_logit);
    }

    for (size_t i=0; i<logits.size(); ++i) {
        probs[i] = std::exp(logits[i] - max_logit) / sum_exp;
    }

    return probs;
}

}  // namespace inference::core
