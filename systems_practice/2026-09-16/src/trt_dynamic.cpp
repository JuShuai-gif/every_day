#include <NvInfer.h>
#include <NvInferVersion.h>
#include <cuda_runtime_api.h>

#include <atomic>
#include <cstdio>
#include <fstream>
#include <iomanip>
#include <memory>

#include "common.hpp"

#if NV_TENSORRT_MAJOR != 10 && NV_TENSORRT_MAJOR != 11
#error "This exercise targets TensorRT 10.x or 11.x; review APIs for other majors."
#endif
namespace {
using namespace nvinfer1;
using namespace practice;
std::atomic<bool> cleanup_failed{false};
void cuda_check(cudaError_t result, const char* call) {
  if (result != cudaSuccess)
    throw std::runtime_error(std::string(call) + ": " + cudaGetErrorString(result));
}
void cuda_cleanup(cudaError_t result, const char* call) noexcept {
  if (result != cudaSuccess) {
    cleanup_failed.store(true);
    std::fprintf(stderr, "CUDA cleanup failure %s: %s\n", call, cudaGetErrorString(result));
  }
}
#define CUDA_CHECK(call) cuda_check((call), #call)
void require(bool condition, const char* message) {
  if (!condition)
    throw std::runtime_error(message);
}
template <typename T>
std::unique_ptr<T> own(T* object, const char* message) {
  require(object != nullptr, message);
  return std::unique_ptr<T>(object);
}
class Logger final : public ILogger {
  void log(Severity severity, const char* message) noexcept override {
    // C stdio supports calls from TensorRT's internal worker threads.
    if (severity <= Severity::kWARNING)
      std::fprintf(stderr, "TensorRT: %s\n", message);
  }
};
struct Stream {
  cudaStream_t value{};
  Stream() {
    CUDA_CHECK(cudaStreamCreateWithFlags(&value, cudaStreamNonBlocking));
  }
  ~Stream() {
    cuda_cleanup(cudaStreamDestroy(value), "cudaStreamDestroy");
  }
  Stream(const Stream&) = delete;
  Stream& operator=(const Stream&) = delete;
};
struct Buffer {
  void* value{};
  bool pinned;
  Buffer(std::size_t bytes, bool host) : pinned(host) {
    if (pinned)
      CUDA_CHECK(cudaMallocHost(&value, bytes));
    else
      CUDA_CHECK(cudaMalloc(&value, bytes));
  }
  ~Buffer() {
    if (pinned)
      cuda_cleanup(cudaFreeHost(value), "cudaFreeHost");
    else
      cuda_cleanup(cudaFree(value), "cudaFree");
  }
  float* data() {
    return static_cast<float*>(value);
  }
  Buffer(const Buffer&) = delete;
  Buffer& operator=(const Buffer&) = delete;
};
struct Event {
  cudaEvent_t value{};
  Event() {
    CUDA_CHECK(cudaEventCreate(&value));
  }
  ~Event() {
    cuda_cleanup(cudaEventDestroy(value), "cudaEventDestroy");
  }
  Event(const Event&) = delete;
  Event& operator=(const Event&) = delete;
};
struct Drain {
  cudaStream_t stream;
  // Declared last: drains even on exceptions, before events/buffers/context die.
  ~Drain() {
    cuda_cleanup(cudaStreamSynchronize(stream), "exception-safe stream drain");
  }
};
Dims shape(int batch) {
  Dims result{};
  result.nbDims = 2;
  result.d[0] = batch;
  result.d[1] = kFeatures;
  return result;
}

void run(const char* engine_path) {
  Logger logger;  // Outlives every TensorRT object.
  int count = 0;
  CUDA_CHECK(cudaGetDeviceCount(&count));
  require(count > 0, "no CUDA GPU");
  CUDA_CHECK(cudaSetDevice(0));
  cudaDeviceProp properties{};
  CUDA_CHECK(cudaGetDeviceProperties(&properties, 0));
  int driver = 0, runtime_version = 0;
  CUDA_CHECK(cudaDriverGetVersion(&driver));
  CUDA_CHECK(cudaRuntimeGetVersion(&runtime_version));
  std::cout << "device=" << properties.name << " sm=" << properties.major << properties.minor
            << " CUDA_driver=" << driver << " CUDA_runtime=" << runtime_version
            << " TRT=" << NV_TENSORRT_MAJOR << '.' << NV_TENSORRT_MINOR << '.' << NV_TENSORRT_PATCH
            << '\n';
  auto builder = own(createInferBuilder(logger), "createInferBuilder failed");
  uint32_t flags = 0;
#if NV_TENSORRT_MAJOR == 10
  flags = 1U << static_cast<uint32_t>(NetworkDefinitionCreationFlag::kSTRONGLY_TYPED);
#endif
  auto network = own(builder->createNetworkV2(flags), "createNetworkV2 failed");
  auto config = own(builder->createBuilderConfig(), "createBuilderConfig failed");
  config->setMemoryPoolLimit(MemoryPoolType::kWORKSPACE, 16U * 1024U * 1024U);
  auto* input = network->addInput("features", DataType::kFLOAT, shape(-1));
  require(input != nullptr, "addInput failed");
  const float scale = 0.5F, bias = 0.25F;  // Weight storage lives through engine build.
  Dims singleton{};
  singleton.nbDims = 2;
  singleton.d[0] = 1;
  singleton.d[1] = 1;
  auto* scale_layer = network->addConstant(singleton, Weights{DataType::kFLOAT, &scale, 1});
  auto* bias_layer = network->addConstant(singleton, Weights{DataType::kFLOAT, &bias, 1});
  require(scale_layer && bias_layer, "addConstant failed");
  auto* product =
      network->addElementWise(*input, *scale_layer->getOutput(0), ElementWiseOperation::kPROD);
  require(product != nullptr, "add product failed");
  auto* sum = network->addElementWise(
      *product->getOutput(0), *bias_layer->getOutput(0), ElementWiseOperation::kSUM);
  require(sum != nullptr, "add sum failed");
  auto* relu = network->addActivation(*sum->getOutput(0), ActivationType::kRELU);
  require(relu != nullptr, "add activation failed");
  relu->getOutput(0)->setName("actions");
  network->markOutput(*relu->getOutput(0));
  // IBuilder owns profiles created through createOptimizationProfile().
  auto* profile = builder->createOptimizationProfile();
  require(profile != nullptr, "createOptimizationProfile failed");
  require(profile->setDimensions("features", OptProfileSelector::kMIN, shape(1)),
          "MIN profile failed");
  require(profile->setDimensions("features", OptProfileSelector::kOPT, shape(2)),
          "OPT profile failed");
  require(profile->setDimensions("features", OptProfileSelector::kMAX, shape(4)),
          "MAX profile failed");
  require(profile->isValid(), "invalid optimization profile");
  require(config->addOptimizationProfile(profile) == 0, "add profile failed");
  auto plan = own(builder->buildSerializedNetwork(*network, *config), "engine build failed");
  std::ofstream file(engine_path, std::ios::binary);
  require(file.good(), "cannot open engine output");
  file.write(static_cast<const char*>(plan->data()), static_cast<std::streamsize>(plan->size()));
  file.close();
  require(file.good(), "engine write failed");
  auto runtime = own(createInferRuntime(logger), "createInferRuntime failed");
  auto engine =
      own(runtime->deserializeCudaEngine(plan->data(), plan->size()), "deserialize failed");
  auto context = own(engine->createExecutionContext(), "createExecutionContext failed");
  Stream stream;
  constexpr auto capacity_bytes = kMaxBatch * kFeatures * sizeof(float);
  Buffer host_input(capacity_bytes, true), host_output(capacity_bytes, true);
  Buffer device_input(capacity_bytes, false), device_output(capacity_bytes, false);
  Event begin, end;
  Drain drain{stream.value};
  require(context->setOptimizationProfileAsync(0, stream.value), "select profile failed");
  CUDA_CHECK(cudaStreamSynchronize(stream.value));
  require(context->setTensorAddress("features", device_input.value), "input address failed");
  require(context->setTensorAddress("actions", device_output.value), "output address failed");
  std::cout << "io_device_bytes=" << 2 * capacity_bytes << " io_pinned_bytes=" << 2 * capacity_bytes
            << " serialized_engine_bytes=" << plan->size()
            << " workspace_limit_bytes=" << 16U * 1024U * 1024U << '\n';
  std::array<float, kMaxBatch * kFeatures> expected{};
  double host_enqueue_ms = 0;
  auto infer = [&](int batch, bool measure_events) {
    const auto bytes = elements(batch) * sizeof(float);  // Reject before touching context/buffers.
    require(context->setInputShape("features", shape(batch)), "setInputShape failed");
    const auto output_shape = context->getTensorShape("actions");
    require(
        output_shape.nbDims == 2 && output_shape.d[0] == batch && output_shape.d[1] == kFeatures,
        "unresolved or unexpected output shape");
    CUDA_CHECK(cudaMemcpyAsync(
        device_input.value, host_input.value, bytes, cudaMemcpyHostToDevice, stream.value));
    if (measure_events)
      CUDA_CHECK(cudaEventRecord(begin.value, stream.value));
    const auto enqueue_start = Clock::now();
    require(context->enqueueV3(stream.value), "enqueueV3 failed");
    host_enqueue_ms = milliseconds(enqueue_start, Clock::now());
    if (measure_events)
      CUDA_CHECK(cudaEventRecord(end.value, stream.value));
    CUDA_CHECK(cudaMemcpyAsync(
        host_output.value, device_output.value, bytes, cudaMemcpyDeviceToHost, stream.value));
    CUDA_CHECK(cudaStreamSynchronize(stream.value));
    float gpu_ms = 0;
    if (measure_events)
      CUDA_CHECK(cudaEventElapsedTime(&gpu_ms, begin.value, end.value));
    return static_cast<double>(gpu_ms);
  };
  unsigned frame = 0;
  for (int batch : {1, 4, 2, 1, 3, 2}) {
    fill_input(host_input.data(), batch, frame);
    reference(host_input.data(), expected.data(), batch);
    std::fill_n(host_output.data(), kMaxBatch * kFeatures, -999.0F);
    infer(batch, false);
    check_known(host_output.data(), batch, frame++);
    const auto error = compare(host_output.data(), expected.data(), batch);
    for (std::size_t i = elements(batch); i < kMaxBatch * kFeatures; ++i)
      require(host_output.data()[i] == -999.0F, "host output tail overwritten");
    std::cout << "GPU correctness PASS batch=" << batch << " max_abs_error=" << error << '\n';
  }
  for (int batch : {-1, 0, 5}) {
    bool rejected = false;
    try {
      infer(batch, false);
    } catch (const std::invalid_argument&) {
      rejected = true;
    }
    require(rejected, "out-of-profile request accepted");
    std::cout << "GPU request guard PASS batch=" << batch << '\n';
  }
  constexpr int batch = 2;
  fill_input(host_input.data(), batch);
  reference(host_input.data(), expected.data(), batch);
  std::vector<double> gpu, enqueue, e2e;
  gpu.reserve(kSamples);
  enqueue.reserve(kSamples);
  e2e.reserve(kSamples);
  // Two passes: event-instrumented GPU interval, then event-free request timing.
  for (bool events : {true, false}) {
    for (int sample = -kWarmup; sample < kSamples; ++sample) {
      const auto start = Clock::now();
      const auto gpu_ms = infer(batch, events);
      const auto elapsed = milliseconds(start, Clock::now());
      compare(host_output.data(), expected.data(), batch);  // Outside timing, every result checked.
      if (sample >= 0) {
        if (events) {
          gpu.push_back(gpu_ms);
          enqueue.push_back(host_enqueue_ms);
        } else
          e2e.push_back(elapsed);
      }
    }
  }
  std::cout << "benchmark batch=2 warmup_per_pass=" << kWarmup << '\n';
  stats("gpu_inference_interval_cuda_events", gpu);
  stats("cpu_enqueue_api", enqueue);
  stats("e2e_shape_h2d_enqueue_d2h_sync", e2e);
  double total_ms = 0;
  for (double value : e2e)
    total_ms += value;
  std::cout << "serial_requests_per_second=" << 1000.0 * e2e.size() / total_ms << '\n';
  std::cout << "single_kernel_time=NOT_MEASURED use Nsight Systems/Compute\n";
  CUDA_CHECK(cudaStreamSynchronize(stream.value));
}
}  // namespace
int main(int argc, char** argv) {
  if (argc != 2) {
    std::cerr << "usage: trt_dynamic PATH_TO_NEW_ENGINE\n";
    return 2;
  }
  try {
    std::cout << std::fixed << std::setprecision(6);
    run(argv[1]);
  } catch (const std::exception& error) {
    std::cerr << "FAIL: " << error.what() << '\n';
    return 1;
  }
  return cleanup_failed.load() ? 1 : 0;
}
