#include <NvInfer.h>
#include <cuda_profiler_api.h>

#include <chrono>
#include <iostream>
#include <memory>
#include <string>

#include "../../2026-09-26/src/cuda_raii.cuh"
#include "../../2026-09-26/src/reference.hpp"
class Logger final : public nvinfer1::ILogger {
  void log(Severity s, const char* msg) noexcept override {
    if (s <= Severity::kWARNING) {
      std::cerr << msg << '\n';
    }
  }
};
void require(bool ok, const char* msg) {
  if (!ok) {
    throw std::runtime_error(msg);
  }
}
float pct(std::vector<float> x, double p) {
  std::sort(x.begin(), x.end());
  return x[static_cast<std::size_t>(p * (x.size() - 1))];
}
// 声明在每帧主机张量之后：异常展开先同步，再释放异步复制使用的主机内存。
struct FrameDrain {
  Stream& infer;
  Stream& producer;
  ~FrameDrain() noexcept {
    cleanup(cudaStreamSynchronize(infer.s));
    cleanup(cudaStreamSynchronize(producer.s));
  }
};
int main(int argc, char** argv) {
  try {
    const bool profile = argc == 2 && std::string(argv[1]) == "--profile";
    require(argc == 1 || profile, "usage: trt [--profile]");
    require_thor();
    Logger logger;
    std::unique_ptr<nvinfer1::IBuilder> builder(nvinfer1::createInferBuilder(logger));
    require(bool(builder), "builder");
    std::unique_ptr<nvinfer1::INetworkDefinition> net(builder->createNetworkV2(
        1U << static_cast<unsigned>(nvinfer1::NetworkDefinitionCreationFlag::kSTRONGLY_TYPED)));
    require(bool(net), "network");
    auto* x = net->addInput("logits", nvinfer1::DataType::kFLOAT, nvinfer1::Dims2{1024, 127});
    require(x, "input");
    auto* softmax = net->addSoftMax(*x);
    require(softmax, "softmax");
    softmax->setAxes(1U << 1);
    auto* out = softmax->getOutput(0);
    require(out, "output");
    out->setName("probabilities");
    net->markOutput(*out);
    std::unique_ptr<nvinfer1::IBuilderConfig> config(builder->createBuilderConfig());
    require(bool(config), "config");
    config->setMemoryPoolLimit(nvinfer1::MemoryPoolType::kWORKSPACE, 64ULL << 20);
    config->setProfilingVerbosity(nvinfer1::ProfilingVerbosity::kDETAILED);
    std::unique_ptr<nvinfer1::IHostMemory> plan(builder->buildSerializedNetwork(*net, *config));
    require(bool(plan), "build");
    std::unique_ptr<nvinfer1::IRuntime> runtime(nvinfer1::createInferRuntime(logger));
    require(bool(runtime), "runtime");
    std::unique_ptr<nvinfer1::ICudaEngine> engine(
        runtime->deserializeCudaEngine(plan->data(), plan->size()));
    require(bool(engine), "deserialize");
    std::unique_ptr<nvinfer1::IExecutionContext> context(engine->createExecutionContext());
    require(bool(context), "context");
    Device dx(1024 * 127), dy(1024 * 127);
    Event consumed, a, b;
    Stream infer, producer;
    require(context->setTensorAddress("logits", dx.p), "bind input");
    require(context->setTensorAddress("probabilities", dy.p), "bind output");
    require(context->setInputConsumedEvent(consumed.e), "input event");
    std::vector<float> device_ms, request_ms, submit_us;
    for (int frame = -20; frame < 100; ++frame) {
      // profiler只覆盖预热后的推理，不混入建引擎的tactic搜索。
      if (profile && frame == 0) {
        ck(cudaProfilerStart());
      }
      auto host = input(1024, 127, (frame + 20) % 3);
      auto ref = softmax_reference(host, 1024, 127);
      std::vector<float> result(host.size());
      FrameDrain drain{infer, producer};
      auto begin = std::chrono::steady_clock::now();
      ck(cudaMemcpyAsync(
          dx.p, host.data(), host.size() * sizeof(float), cudaMemcpyHostToDevice, infer.s));
      ck(cudaEventRecord(a.e, infer.s));
      auto submit = std::chrono::steady_clock::now();
      require(context->enqueueV3(infer.s), "enqueue");
      auto submitted = std::chrono::steady_clock::now();
      ck(cudaEventRecord(b.e, infer.s));
      ck(cudaMemcpyAsync(
          result.data(), dy.p, result.size() * sizeof(float), cudaMemcpyDeviceToHost, infer.s));
      // 输入消费与输出完成是两个不同的所有权边界。事件必须跨整次推理存活。
      ck(cudaStreamWaitEvent(producer.s, consumed.e, 0));
      ck(cudaMemsetAsync(dx.p, 0, host.size() * sizeof(float), producer.s));
      ck(cudaStreamSynchronize(infer.s));
      ck(cudaStreamSynchronize(producer.s));
      auto end = std::chrono::steady_clock::now();
      verify(result, ref, 127);
      float ms;
      ck(cudaEventElapsedTime(&ms, a.e, b.e));
      if (frame >= 0) {
        device_ms.push_back(ms);
        request_ms.push_back(std::chrono::duration<float, std::milli>(end - begin).count());
        submit_us.push_back(std::chrono::duration<float, std::micro>(submitted - submit).count());
      }
    }
    if (profile) {
      ck(cudaProfilerStop());
    }
    std::cout << "TensorRT " << NV_TENSORRT_MAJOR << '.' << NV_TENSORRT_MINOR << '.'
              << NV_TENSORRT_PATCH << " Thor SM110 PASS120frames input-poison-after-consumption\n";
    std::cout << "GPU engine ms P50/P95=" << pct(device_ms, .5) << '/' << pct(device_ms, .95)
              << " CPU submit us=" << pct(submit_us, .5) << '/' << pct(submit_us, .95)
              << " request including input recycle ms=" << pct(request_ms, .5) << '/'
              << pct(request_ms, .95) << '\n';
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
