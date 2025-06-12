#include "inference/core/infer.hpp"
#include "infer_impl.hpp"

namespace inference::core {

std::unique_ptr<Infer> Infer::create(const std::string& engine_path, const InferConfig& config) {
    return std::make_unique<InferImpl>(engine_path, config);
}

}

