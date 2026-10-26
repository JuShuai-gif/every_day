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
template <class T>
std::unique_ptr<T> own(T* p) {
  require(p != nullptr, "TRT null");
  return std::unique_ptr<T>(p);
}
int main(int argc, char** argv) {
  using namespace nvinfer1;
  try {
    require(argc <= 3, "usage: trt_graph [N] [mode=0|1|2]");
    int selected = -1;
    if (argc == 3) {
      require(
          std::string(argv[2]) == "0" || std::string(argv[2]) == "1" || std::string(argv[2]) == "2",
          "mode");
      selected = argv[2][0] - '0';
    }
    std::size_t parsed = 0;
    int n = checked_size(argc >= 2 ? std::stoi(argv[1], &parsed) : 65539);
    require(argc < 2 || parsed == std::string(argv[1]).size(), "trailing CLI text");
    cudaDeviceProp prop{};
    ck(cudaGetDeviceProperties(&prop, 0), "device");
    require(prop.major == 11 && prop.minor == 0, "requires Thor SM110");
    Logger logger;
    auto builder = own(createInferBuilder(logger));
    auto net = own(
        builder->createNetworkV2(1U << unsigned(NetworkDefinitionCreationFlag::kSTRONGLY_TYPED)));
    auto config = own(builder->createBuilderConfig());
    auto* x = net->addInput("x", DataType::kFLOAT, Dims2{1, -1});
    require(x, "input");
    auto* relu = net->addActivation(*x, ActivationType::kRELU);
    require(relu, "relu");
    relu->getOutput(0)->setName("y");
    net->markOutput(*relu->getOutput(0));
    auto* profile = builder->createOptimizationProfile();
    require(profile, "profile");
    // builder拥有profile；本例不会单独delete它。
    require(profile->setDimensions("x", OptProfileSelector::kMIN, Dims2{1, 1}), "min");
    require(profile->setDimensions("x", OptProfileSelector::kOPT, Dims2{1, 4097}), "opt");
    require(profile->setDimensions("x", OptProfileSelector::kMAX, Dims2{1, 65539}), "max");
    require(config->addOptimizationProfile(profile) >= 0, "add profile");
    config->setMemoryPoolLimit(MemoryPoolType::kWORKSPACE, 64U << 20);
    auto plan = own(builder->buildSerializedNetwork(*net, *config));
    auto runtime = own(createInferRuntime(logger));
    auto engine = own(runtime->deserializeCudaEngine(plan->data(), plan->size()));
    auto context = own(engine->createExecutionContext());
    Stream stream;
    Buffer input(n), tmp(n), pre(n), output(n);
    Host hx(n), hy(n);
    Graph graph;
    Event begin, end;
    Drain drain{stream.s};
    require(context->setOptimizationProfileAsync(0, stream.s), "profile selection");
    require(context->setInputShape("x", Dims2{1, n}), "shape");
    require(context->setTensorAddress("x", pre.p), "x address");
    require(context->setTensorAddress("y", output.p), "y address");
    auto shape = context->getTensorShape("y");
    require(shape.nbDims == 2 && shape.d[1] == n, "output shape");
    auto enqueue = [&](bool fused) {
      launch_preprocess(input.p, tmp.p, pre.p, n, fused, stream.s);
      require(context->enqueueV3(stream.s), "enqueueV3");
    };
    auto initial = inputs(n, 0);
    std::copy(initial.begin(), initial.end(), hx.p);
    ck(cudaMemcpyAsync(input.p, hx.p, n * sizeof(float), cudaMemcpyHostToDevice, stream.s), "H2D");
    enqueue(true);
    ck(cudaStreamSynchronize(stream.s), "initialize outside capture");
    ck(cudaStreamBeginCapture(stream.s, cudaStreamCaptureModeThreadLocal), "begin capture");
    try {
      enqueue(true);
    } catch (...) {
      // 无论enqueue是否失败都结束capture，避免污染后续清理路径。
      cleanup(cudaStreamEndCapture(stream.s, &graph.graph));
      throw;
    }
    ck(cudaStreamEndCapture(stream.s, &graph.graph), "end capture");
    ck(cudaGraphInstantiateWithFlags(&graph.exec, graph.graph, 0), "instantiate");
    GraphKey key{n,
                 0,
                 reinterpret_cast<std::uintptr_t>(context.get()),
                 reinterpret_cast<std::uintptr_t>(input.p),
                 reinterpret_cast<std::uintptr_t>(output.p),
                 1};
    ReplayGate gate(key);
    gate.captured();
    auto submit = [&](int mode) {
      if (mode == 2) {
        gate.submit(key);
        ck(cudaGraphLaunch(graph.exec, stream.s), "graph launch");
      } else {
        enqueue(mode == 1);
      }
    };
    // 每帧更新内容，保持地址不变；单槽同步回收后才允许下一次写入。
    for (int mode = 0; mode < 3; ++mode) {
      if (selected >= 0 && mode != selected) {
        continue;
      }
      std::vector<double> wall, gpu, host_submit;
      for (int frame = 0; frame < 51; ++frame) {
        auto host = inputs(n, frame);
        std::copy(host.begin(), host.end(), hx.p);
        auto start = std::chrono::steady_clock::now();
        ck(cudaMemcpyAsync(input.p, hx.p, n * sizeof(float), cudaMemcpyHostToDevice, stream.s),
           "H2D");
        ck(cudaEventRecord(begin.e, stream.s), "begin event");
        auto a = std::chrono::steady_clock::now();
        submit(mode);
        auto b = std::chrono::steady_clock::now();
        ck(cudaEventRecord(end.e, stream.s), "end event");
        ck(cudaMemcpyAsync(hy.p, output.p, n * sizeof(float), cudaMemcpyDeviceToHost, stream.s),
           "D2H");
        ck(cudaStreamSynchronize(stream.s), "completion");
        if (mode == 2) {
          gate.complete();
        }
        auto stop = std::chrono::steady_clock::now();
        check(host, hy.p);
        float ms = 0;
        ck(cudaEventElapsedTime(&ms, begin.e, end.e), "elapsed");
        if (frame >= 20) {
          gpu.push_back(ms * 1000);
          wall.push_back(std::chrono::duration<double, std::micro>(stop - start).count());
          host_submit.push_back(std::chrono::duration<double, std::micro>(b - a).count());
        }
      }
      for (auto* v : {&wall, &gpu, &host_submit}) {
        std::sort(v->begin(), v->end());
      }
      std::cout << "mode=" << mode << " n=" << n << " GPU_pipeline_us_P50/P95=" << gpu[15] << '/'
                << gpu[29] << " host_submit_us_P50=" << host_submit[15]
                << " H2D_pipeline_D2H_sync_us_P50/P95=" << wall[15] << '/' << wall[29] << '\n';
    }
    // 单独kernel对照不混入TensorRT，20预热、31个单次event样本。
    for (bool fused : {false, true}) {
      std::vector<float> times;
      for (int i = 0; i < 51; ++i) {
        ck(cudaEventRecord(begin.e, stream.s), "kernel begin");
        launch_preprocess(input.p, tmp.p, pre.p, n, fused, stream.s);
        ck(cudaEventRecord(end.e, stream.s), "kernel end");
        ck(cudaEventSynchronize(end.e), "kernel sync");
        float ms;
        ck(cudaEventElapsedTime(&ms, begin.e, end.e), "kernel time");
        if (i >= 20) {
          times.push_back(ms);
        }
      }
      std::sort(times.begin(), times.end());
      std::cout << "preprocess fused=" << fused << " GPU_event_ms_P50=" << times[15]
                << " P95=" << times[29] << '\n';
    }
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
