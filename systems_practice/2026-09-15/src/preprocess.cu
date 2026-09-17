#include <cuda_fp16.h>
#include <cuda_runtime.h>

#include <iomanip>
#include <string>

#include "common.hpp"

using namespace practice;
namespace {
void check(cudaError_t status, const char* operation) {
  if (status != cudaSuccess)
    throw std::runtime_error(std::string(operation) + ": " + cudaGetErrorString(status));
}
#define CUDA_CHECK(call) check((call), #call)
bool cleanup_failed = false;
void cleanup(cudaError_t status, const char* operation) noexcept {
  if (status != cudaSuccess) {
    cleanup_failed = true;
    std::cerr << "cleanup failed: " << operation << ": " << cudaGetErrorString(status) << '\n';
  }
}
template <class T, bool pinned = false>
class Buffer {
 public:
  T* ptr = nullptr;
  explicit Buffer(std::size_t n) {
    if (!n)
      return;
    void* allocation = nullptr;
    if constexpr (pinned)
      CUDA_CHECK(cudaMallocHost(&allocation, n * sizeof(T)));
    else
      CUDA_CHECK(cudaMalloc(&allocation, n * sizeof(T)));
    ptr = static_cast<T*>(allocation);
  }
  ~Buffer() {
    if (!ptr)
      return;
    if constexpr (pinned)
      cleanup(cudaFreeHost(ptr), "cudaFreeHost");
    else
      cleanup(cudaFree(ptr), "cudaFree");
  }
  Buffer(const Buffer&) = delete;
  Buffer& operator=(const Buffer&) = delete;
};
struct Stream {
  cudaStream_t value{};
  Stream() {
    CUDA_CHECK(cudaStreamCreateWithFlags(&value, cudaStreamNonBlocking));
  }
  ~Stream() {
    cleanup(cudaStreamSynchronize(value), "cudaStreamSynchronize cleanup");
    cleanup(cudaStreamDestroy(value), "cudaStreamDestroy");
  }
  Stream(const Stream&) = delete;
  Stream& operator=(const Stream&) = delete;
};
struct Event {
  cudaEvent_t value{};
  Event() {
    CUDA_CHECK(cudaEventCreate(&value));
  }
  ~Event() {
    cleanup(cudaEventDestroy(value), "cudaEventDestroy");
  }
  Event(const Event&) = delete;
  Event& operator=(const Event&) = delete;
};
__device__ float normalize(float x, int c) {
  const float means[3] = {0.485f, 0.456f, 0.406f};
  const float stds[3] = {0.229f, 0.224f, 0.225f};
  return (x / 255.0f - means[c]) / stds[c];
}
__global__ void layout(const std::uint8_t* input, float* scratch, std::size_t count,
                       std::size_t plane) {
  const std::size_t i = static_cast<std::size_t>(blockIdx.x) * blockDim.x + threadIdx.x;
  if (i >= count)
    return;
  const auto p = i % plane;
  const auto c = (i / plane) % 3;
  const auto b = i / (3 * plane);
  scratch[i] = input[(b * plane + p) * 3 + c];
}
__global__ void normalize_cast(const float* scratch, __half* output, std::size_t count,
                               std::size_t plane) {
  const std::size_t i = static_cast<std::size_t>(blockIdx.x) * blockDim.x + threadIdx.x;
  if (i < count)
    output[i] = __float2half_rn(normalize(scratch[i], (i / plane) % 3));
}
// Exercise focus: derive NHWC source index from NCHW output index; fuse without scratch.
__global__ void fused(const std::uint8_t* input, __half* output, std::size_t count,
                      std::size_t plane) {
  const std::size_t i = static_cast<std::size_t>(blockIdx.x) * blockDim.x + threadIdx.x;
  if (i >= count)
    return;
  const auto p = i % plane;
  const auto c = (i / plane) % 3;
  const auto b = i / (3 * plane);
  output[i] = __float2half_rn(normalize(input[(b * plane + p) * 3 + c], c));
}
void launch(bool fuse, const std::uint8_t* input, float* scratch, __half* output, Shape s,
            int block, cudaStream_t stream) {
  const auto count = s.elements();
  if (!count)
    return;  // Empty batch is a no-op, never a zero-grid launch.
  const auto grid = static_cast<unsigned int>((count + block - 1) / block);
  const auto plane = static_cast<std::size_t>(s.height) * s.width;
  if (fuse) {
    fused<<<grid, block, 0, stream>>>(input, output, count, plane);
    CUDA_CHECK(cudaGetLastError());
  } else {
    layout<<<grid, block, 0, stream>>>(input, scratch, count, plane);
    CUDA_CHECK(cudaGetLastError());
    normalize_cast<<<grid, block, 0, stream>>>(scratch, output, count, plane);
    CUDA_CHECK(cudaGetLastError());
  }
}
struct Stats {
  double kernel_p50, e2e_p95;
};
Stats benchmark(bool fuse, Shape s, int block) {
  const auto count = s.elements();
  if (!count) {
    launch(fuse, nullptr, nullptr, nullptr, s, block, nullptr);
    std::cout << "PASS empty_batch_noop mode=" << (fuse ? "fused" : "baseline") << '\n';
    return {0, 0};
  }
  auto input = input_for(s);
  if (s.batch == 1 && s.height == 1 && s.width == 1)
    input = {0, 127, 255};
  std::vector<float> expected(count);
  reference(input, expected, s);
  Buffer<std::uint8_t, true> host_input(count);
  Buffer<__half, true> host_output(count);
  std::copy(input.begin(), input.end(), host_input.ptr);
  Buffer<std::uint8_t> device_input(count);
  Buffer<__half> device_output(count);
  Buffer<float> scratch(fuse ? 0 : count);
  Event begin, end;
  // Declared after buffers: synchronizes outstanding work before buffers are freed on exceptions.
  Stream stream;
  auto verify = [&]() {
    float max_error = 0;
    for (std::size_t i = 0; i < count; ++i) {
      const float value = __half2float(host_output.ptr[i]);
      const float error = std::abs(value - expected[i]);
      if (!std::isfinite(value) || error > 1e-3f + 1e-3f * std::abs(expected[i]))
        throw std::runtime_error("GPU correctness failed at index " + std::to_string(i));
      max_error = std::max(max_error, error);
    }
    return max_error;
  };
  auto pipeline = [&]() {
    CUDA_CHECK(cudaMemcpyAsync(device_input.ptr, host_input.ptr, count, cudaMemcpyHostToDevice,
                               stream.value));
    launch(fuse, device_input.ptr, scratch.ptr, device_output.ptr, s, block, stream.value);
    CUDA_CHECK(cudaMemcpyAsync(host_output.ptr, device_output.ptr, count * sizeof(__half),
                               cudaMemcpyDeviceToHost, stream.value));
    CUDA_CHECK(cudaStreamSynchronize(stream.value));
  };
  for (int i = 0; i < warmups; ++i) {
    pipeline();
    (void)verify();
  }
  std::vector<double> kernels, end_to_end;
  float max_error = 0;
  // GPU event timing: excludes copies; measures one fused kernel or both baseline kernels.
  for (int i = 0; i < repeats; ++i) {
    CUDA_CHECK(cudaEventRecord(begin.value, stream.value));
    launch(fuse, device_input.ptr, scratch.ptr, device_output.ptr, s, block, stream.value);
    CUDA_CHECK(cudaEventRecord(end.value, stream.value));
    CUDA_CHECK(cudaEventSynchronize(end.value));
    float ms = 0;
    CUDA_CHECK(cudaEventElapsedTime(&ms, begin.value, end.value));
    kernels.push_back(ms);
    CUDA_CHECK(cudaMemcpyAsync(host_output.ptr, device_output.ptr, count * sizeof(__half),
                               cudaMemcpyDeviceToHost, stream.value));
    CUDA_CHECK(cudaStreamSynchronize(stream.value));
    max_error = std::max(max_error, verify());
  }
  // Host wall timing: includes H2D + launch + kernels + D2H + final synchronization.
  // Preallocated buffers; excludes camera capture, allocations and CPU verification.
  for (int i = 0; i < repeats; ++i) {
    const auto start = Clock::now();
    pipeline();
    end_to_end.push_back(elapsed_ms(start, Clock::now()));
    max_error = std::max(max_error, verify());
  }
  const double kernel50 = percentile(kernels, .50);
  const double e2e95 = percentile(end_to_end, .95);
  const auto device_bytes = count * (fuse ? 3 : 7);
  std::cout << "PASS mode=" << (fuse ? "fused" : "baseline") << " shape=" << s.batch << 'x'
            << s.height << 'x' << s.width << "x3"
            << " block=" << block << " max_abs_error=" << max_error << " kernel_ms_p50=" << kernel50
            << " kernel_ms_p95=" << percentile(kernels, .95)
            << " e2e_ms_p50=" << percentile(end_to_end, .50) << " e2e_ms_p95=" << e2e95
            << " device_payload_bytes=" << device_bytes << " pinned_payload_bytes=" << count * 3
            << " theoretical_logical_traffic_bytes=" << count * (fuse ? 3 : 11) << "\n";
  return {kernel50, e2e95};
}
}  // namespace

int main(int argc, char** argv) try {
  if (argc > 2)
    throw std::invalid_argument("usage: cuda_preprocess [128|256|512]");
  int block = 256;
  if (argc == 2) {
    const std::string arg(argv[1]);
    if (arg != "128" && arg != "256" && arg != "512")
      throw std::invalid_argument("block must be 128, 256 or 512");
    block = std::stoi(arg);
  }
  int devices = 0;
  CUDA_CHECK(cudaGetDeviceCount(&devices));
  if (!devices)
    throw std::runtime_error("no CUDA device; GPU validation unavailable");
  CUDA_CHECK(cudaSetDevice(0));
  cudaDeviceProp prop{};
  CUDA_CHECK(cudaGetDeviceProperties(&prop, 0));
  int driver = 0, runtime = 0;
  CUDA_CHECK(cudaDriverGetVersion(&driver));
  CUDA_CHECK(cudaRuntimeGetVersion(&runtime));
  if (block > prop.maxThreadsPerBlock)
    throw std::runtime_error("block exceeds device limit");
  std::cout << std::fixed << std::setprecision(6) << "device=" << prop.name
            << " compute_capability=" << prop.major << '.' << prop.minor << " driver=" << driver
            << " runtime=" << runtime << " warmups=" << warmups << " repeats=" << repeats << '\n';
  const std::array<Shape, 4> cases{{{2, 224, 224}, {2, 223, 225}, {1, 1, 1}, {0, 224, 224}}};
  for (const auto s : cases) {
    const auto baseline = benchmark(false, s, block);
    const auto fused_stats = benchmark(true, s, block);
    if (s.batch == 2 && s.height == 224 && s.width == 224) {
      const bool kernel_pass = fused_stats.kernel_p50 <= baseline.kernel_p50;
      const bool e2e_pass = fused_stats.e2e_p95 <= 1.0;
      std::cout << "PERF_GOAL kernel_not_slower=" << (kernel_pass ? "PASS" : "MISS")
                << " e2e_p95_le_1ms=" << (e2e_pass ? "PASS" : "MISS") << '\n';
    }
  }
  return cleanup_failed ? 1 : 0;
} catch (const std::exception& e) {
  std::cerr << "FAIL: " << e.what() << '\n';
  return 1;
}
