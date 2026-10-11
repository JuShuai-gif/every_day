#include <NvInfer.h>

#include <chrono>
#include <iostream>
#include <memory>

#include "contract.hpp"
#include "cuda_raii.hpp"
class Logger final : public nvinfer1::ILogger {
  void log(Severity s, const char* m) noexcept override {
    if (s <= Severity::kWARNING) {
      std::cerr << m << '\n';
    }
  }
};
void require(bool ok, const char* m) {
  if (!ok) {
    throw std::runtime_error(m);
  }
}
template <class T>
std::unique_ptr<T> own(T* p) {
  require(p != nullptr, "TensorRT object creation");
  return std::unique_ptr<T>(p);
}
int main() {
  using namespace nvinfer1;
  try {
    require_thor();
    Logger logger;
    auto builder = own(createInferBuilder(logger));
    auto network = own(builder->createNetworkV2(
        1U << static_cast<unsigned>(NetworkDefinitionCreationFlag::kSTRONGLY_TYPED)));
    auto config = own(builder->createBuilderConfig());
    // profile由builder拥有；不可用unique_ptr再次删除。
    auto* profile = builder->createOptimizationProfile();
    require(profile != nullptr, "profile allocation");
    auto* x = network->addInput("x", DataType::kFLOAT, Dims2{-1, -1});
    require(x != nullptr, "input");
    float scale = 0.5F, bias = 0.25F;
    auto* a = network->addConstant(Dims2{1, 1}, Weights{DataType::kFLOAT, &scale, 1});
    auto* b = network->addConstant(Dims2{1, 1}, Weights{DataType::kFLOAT, &bias, 1});
    require(a && b, "constants");
    auto* mul = network->addElementWise(*x, *a->getOutput(0), ElementWiseOperation::kPROD);
    require(mul != nullptr, "product");
    auto* add =
        network->addElementWise(*mul->getOutput(0), *b->getOutput(0), ElementWiseOperation::kSUM);
    require(add != nullptr, "sum");
    auto* relu = network->addActivation(*add->getOutput(0), ActivationType::kRELU);
    require(relu != nullptr, "activation");
    relu->getOutput(0)->setName("y");
    network->markOutput(*relu->getOutput(0));
    require(profile->setDimensions("x", OptProfileSelector::kMIN, Dims2{1, 1}), "min");
    require(profile->setDimensions("x", OptProfileSelector::kOPT, Dims2{4, 33}), "opt");
    require(profile->setDimensions("x", OptProfileSelector::kMAX, Dims2{8, 4097}), "max");
    require(config->addOptimizationProfile(profile) >= 0, "profile");
    config->setMemoryPoolLimit(MemoryPoolType::kWORKSPACE, 64U * 1024U * 1024U);
    auto plan = own(builder->buildSerializedNetwork(*network, *config));
    auto runtime = own(createInferRuntime(logger));
    auto engine = own(runtime->deserializeCudaEngine(plan->data(), plan->size()));
    auto context = own(engine->createExecutionContext());
    Stream stream;
    const std::size_t capacity = elements(8, 4097);
    Buffer input(capacity * sizeof(float)), output(capacity * sizeof(float));
    Drain drain{stream.value};
    require(context->setOptimizationProfileAsync(0, stream.value), "select profile");
    require(context->setTensorAddress("x", input.value), "bind x");
    require(context->setTensorAddress("y", output.value), "bind y");
    for (int batch : {1, 4, 8}) {
      for (int width : {1, 3, 4, 5, 31, 32, 33, 4097}) {
        const auto n = elements(batch, width);
        std::vector<float> xhost(n), yhost(n);
        Drain host_lifetime{stream.value};
        for (std::size_t i = 0; i < n; ++i) {
          xhost[i] = static_cast<float>(static_cast<int>(i % 37) - 18) / 8;
        }
        require(context->setInputShape("x", Dims2{batch, width}), "shape");
        const auto actual = context->getTensorShape("y");
        require(actual.nbDims == 2 && actual.d[0] == batch && actual.d[1] == width,
                "resolved output shape");
        const auto start = std::chrono::steady_clock::now();
        cuda_check(
            cudaMemcpyAsync(
                input.value, xhost.data(), n * sizeof(float), cudaMemcpyHostToDevice, stream.value),
            "H2D");
        require(context->enqueueV3(stream.value), "enqueue");
        cuda_check(cudaMemcpyAsync(yhost.data(),
                                   output.value,
                                   n * sizeof(float),
                                   cudaMemcpyDeviceToHost,
                                   stream.value),
                   "D2H");
        cuda_check(cudaStreamSynchronize(stream.value), "inference sync");
        const auto stop = std::chrono::steady_clock::now();
        check(xhost, yhost);
        // 这是含复制/同步的单次冷形状诊断，不是稳态性能结论。
        std::cout << "PASS shape=" << batch << 'x' << width << " cold_request_us="
                  << std::chrono::duration<double, std::micro>(stop - start).count() << '\n';
      }
    }
    require(!context->setInputShape("x", Dims2{9, 33}), "out-of-profile must fail");
    std::cout << "PASS 24 TRT shapes; rejected B=9\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
