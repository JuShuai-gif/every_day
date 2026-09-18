#include <cuda_runtime.h>

#include <chrono>
#include <iomanip>
#include <iostream>
#include <string>

#include "pooling.hpp"

namespace {
void checked(cudaError_t status, const char* operation) {
  if (status != cudaSuccess) {
    throw std::runtime_error(std::string(operation) + ": " + cudaGetErrorString(status));
  }
}

void cleanup(cudaError_t status, const char* operation) noexcept {
  // 析构不能抛异常，但清理失败必须留下可见诊断。
  if (status != cudaSuccess) {
    std::cerr << "cleanup " << operation << ": " << cudaGetErrorString(status) << '\n';
  }
}

class Stream {
 public:
  Stream() {
    checked(cudaStreamCreateWithFlags(&value_, cudaStreamNonBlocking), "stream create");
  }
  ~Stream() {
    cleanup(cudaStreamDestroy(value_), "stream destroy");
  }
  Stream(const Stream&) = delete;
  Stream& operator=(const Stream&) = delete;
  cudaStream_t get() const {
    return value_;
  }

 private:
  cudaStream_t value_{};
};

class Event {
 public:
  Event() {
    checked(cudaEventCreate(&value_), "event create");
  }
  ~Event() {
    cleanup(cudaEventDestroy(value_), "event destroy");
  }
  Event(const Event&) = delete;
  Event& operator=(const Event&) = delete;
  cudaEvent_t get() const {
    return value_;
  }

 private:
  cudaEvent_t value_{};
};

class Buffer {
 public:
  explicit Buffer(std::size_t count) {
    checked(cudaMalloc(reinterpret_cast<void**>(&value_), count * sizeof(float)), "malloc");
  }
  ~Buffer() {
    cleanup(cudaFree(value_), "free");
  }
  Buffer(const Buffer&) = delete;
  Buffer& operator=(const Buffer&) = delete;
  float* get() const {
    return value_;
  }

 private:
  float* value_{};
};

__device__ void copy_async_16(float* destination, const float* source, int bytes) {
#if defined(__CUDA_ARCH__) && __CUDA_ARCH__ >= 800
  // PTX shared 地址是 32 位空间地址；不能直接截断 generic 指针。
  const unsigned address = static_cast<unsigned>(__cvta_generic_to_shared(destination));
  // 每次始终覆盖 16 字节，src-size 之后的目的字节补零。
  asm volatile("cp.async.cg.shared.global [%0], [%1], 16, %2;"
               :
               : "r"(address), "l"(source), "r"(bytes)
               : "memory");
#else
  // 不提供静默同步回退，以免把其他架构的结果标成 cp.async。
  __trap();
#endif
}

template <bool Async>
__global__ void pool(
    const float* input, float* output, int tokens, int channels, int stride, int tiles) {
  __shared__ __align__(16) float tile[practice::kRows * practice::kColumns];
  const int thread = threadIdx.x;
  const int batch = blockIdx.x / tiles;
  const int group = blockIdx.x % tiles;
  const int row = thread / 32;
  const int column = thread % 32 * 4;
  const int token = group * practice::kRows + row;
  const int remaining = channels - column;
  const int valid = token < tokens && remaining > 0 ? (remaining < 4 ? remaining : 4) : 0;
  // 零长度复制也使用合法、对齐的基址，避免构造越界源地址。
  const float* source = valid > 0 ? input + (batch * tokens + token) * stride + column : input;
  float* destination = tile + row * practice::kColumns + column;
  if constexpr (Async) {
    copy_async_16(destination, source, valid * int(sizeof(float)));
#if defined(__CUDA_ARCH__) && __CUDA_ARCH__ >= 800
    asm volatile("cp.async.commit_group;" ::: "memory");
    // wait_group 只等待当前线程提交的组，不是线程块屏障。
    asm volatile("cp.async.wait_group 0;" ::: "memory");
#endif
  } else {
    for (int j = 0; j < 4; ++j) {
      destination[j] = j < valid ? source[j] : 0.0F;
    }
  }
  // 每个消费者跨 8 个 producer warp 读同一通道，所有线程必须参与屏障。
  __syncthreads();
  if (thread < channels) {
    float sum = 0;
    for (int r = 0; r < practice::kRows; ++r) {
      sum += tile[r * practice::kColumns + thread];
    }
    const int remaining_tokens = tokens - group * practice::kRows;
    const int count = remaining_tokens < practice::kRows ? remaining_tokens : practice::kRows;
    output[(batch * tiles + group) * channels + thread] = sum / count;
  }
}

void launch(bool async,
            const practice::Shape& s,
            const Buffer& input,
            const Buffer& output,
            const Stream& stream) {
  if (async) {
    pool<true><<<s.batch * s.tiles(), 256, 0, stream.get()>>>(
        input.get(), output.get(), s.tokens, s.channels, s.stride(), s.tiles());
  } else {
    pool<false><<<s.batch * s.tiles(), 256, 0, stream.get()>>>(
        input.get(), output.get(), s.tokens, s.channels, s.stride(), s.tiles());
  }
  checked(cudaGetLastError(), "kernel launch");
}

void report(const char* metric, std::vector<double> values) {
  std::sort(values.begin(), values.end());
  // 最近秩分位数，100 样本对应第 50/95 个值。
  const auto percentile = [&](double p) {
    return values[static_cast<std::size_t>(std::ceil(p * values.size())) - 1];
  };
  std::cout << metric << " p50_ms=" << percentile(0.50) << " p95_ms=" << percentile(0.95)
            << " samples=" << values.size() << '\n';
}

void run_case(const practice::Shape& s, bool measure) {
  const auto input = practice::make_input(s);
  const auto expected = practice::reference(s, input);
  std::vector<float> output(s.output_size());
  Stream stream;
  Buffer device_input(s.input_size());
  Buffer device_output(s.output_size());
  Event begin;
  Event end;
  const std::size_t in_bytes = input.size() * sizeof(float);
  const std::size_t out_bytes = output.size() * sizeof(float);
  checked(cudaMemcpyAsync(
              device_input.get(), input.data(), in_bytes, cudaMemcpyHostToDevice, stream.get()),
          "H2D");
  for (const bool async : {false, true}) {
    // 先检查一遍，再进行 20 次预热；最终测量后还会检查输出。
    launch(async, s, device_input, device_output, stream);
    checked(
        cudaMemcpyAsync(
            output.data(), device_output.get(), out_bytes, cudaMemcpyDeviceToHost, stream.get()),
        "D2H check");
    checked(cudaStreamSynchronize(stream.get()), "check synchronize");
    const float error = practice::check(output, expected);
    std::cout << "PASS B=" << s.batch << " T=" << s.tokens << " K=" << s.channels
              << " stride=" << s.stride() << " mode=" << (async ? "async" : "sync")
              << " max_abs_error=" << error << '\n';
    if (!measure) {
      continue;
    }
    for (int i = 0; i < 20; ++i) {
      launch(async, s, device_input, device_output, stream);
    }
    checked(cudaStreamSynchronize(stream.get()), "warmup synchronize");
    std::vector<double> kernel_ms;
    for (int i = 0; i < 100; ++i) {
      checked(cudaEventRecord(begin.get(), stream.get()), "begin record");
      launch(async, s, device_input, device_output, stream);
      checked(cudaEventRecord(end.get(), stream.get()), "end record");
      checked(cudaEventSynchronize(end.get()), "end synchronize");
      float elapsed = 0;
      checked(cudaEventElapsedTime(&elapsed, begin.get(), end.get()), "elapsed");
      kernel_ms.push_back(elapsed);
    }
    report(async ? "async GPU event kernel interval" : "sync GPU event kernel interval", kernel_ms);
    std::vector<double> end_to_end_ms;
    for (int i = 0; i < 120; ++i) {
      const auto start = std::chrono::steady_clock::now();
      // 主机使用 pageable vector；此边界包含其 staging 和阻塞行为。
      checked(cudaMemcpyAsync(
                  device_input.get(), input.data(), in_bytes, cudaMemcpyHostToDevice, stream.get()),
              "H2D timed");
      launch(async, s, device_input, device_output, stream);
      checked(
          cudaMemcpyAsync(
              output.data(), device_output.get(), out_bytes, cudaMemcpyDeviceToHost, stream.get()),
          "D2H timed");
      checked(cudaStreamSynchronize(stream.get()), "E2E synchronize");
      const double ms =
          std::chrono::duration<double, std::milli>(std::chrono::steady_clock::now() - start)
              .count();
      practice::check(output, expected);
      if (i >= 20) {
        end_to_end_ms.push_back(ms);
      }
    }
    report(async ? "async host H2D+kernel+D2H+wait" : "sync host H2D+kernel+D2H+wait",
           end_to_end_ms);
  }
}
}  // namespace

int main() {
  try {
    checked(cudaSetDevice(0), "set device");
    cudaDeviceProp prop{};
    checked(cudaGetDeviceProperties(&prop, 0), "device properties");
    int runtime = 0;
    int driver = 0;
    checked(cudaRuntimeGetVersion(&runtime), "runtime version");
    checked(cudaDriverGetVersion(&driver), "driver version");
    if (prop.major < 8) {
      throw std::runtime_error("cp.async target requires compute capability >= 8.0");
    }
    std::cout << std::setprecision(9) << "device=" << prop.name << " sm=" << prop.major
              << prop.minor << " runtime=" << runtime << " driver=" << driver << '\n';
    for (const auto s : {practice::Shape{1, 1, 1},
                         practice::Shape{1, 7, 64},
                         practice::Shape{2, 9, 127},
                         practice::Shape{2, 8, 128},
                         practice::Shape{1, 9, 65},
                         practice::Shape{1, 9, 66}}) {
      run_case(s, false);
    }
    run_case({2, 197, 67}, true);
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
