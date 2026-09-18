#include <cuda_profiler_api.h>
#include <cuda_runtime.h>

#if defined(__CUDA_ARCH__) && __CUDA_ARCH__ != 1100
#error "This practice targets Jetson Thor SM110 only"
#endif

#include <chrono>
#include <iomanip>
#include <iostream>
#include <string>

#include "direct_pool.hpp"
#include "options.hpp"
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
#if defined(__CUDA_ARCH__) && __CUDA_ARCH__ == 1100
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
#if defined(__CUDA_ARCH__) && __CUDA_ARCH__ == 1100
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

// 最终优化版：一块一个 warp，直接合并读取并在寄存器累加。
// 没有 shared 中间缓冲，也没有跨线程依赖，因此不需要 CTA 屏障。
__global__ void pool_direct(
    const float* input, float* output, int tokens, int channels, int stride, int tiles) {
  practice::direct_lane(input, output, tokens, channels, stride, tiles, blockIdx.x, threadIdx.x);
}

void launch(practice::Variant variant,
            const practice::Shape& s,
            const Buffer& input,
            const Buffer& output,
            const Stream& stream) {
  if (variant == practice::Variant::Optimized) {
    pool_direct<<<s.batch * s.tiles(), 32, 0, stream.get()>>>(
        input.get(), output.get(), s.tokens, s.channels, s.stride(), s.tiles());
  } else if (variant == practice::Variant::Async) {
    pool<true><<<s.batch * s.tiles(), 256, 0, stream.get()>>>(
        input.get(), output.get(), s.tokens, s.channels, s.stride(), s.tiles());
  } else {
    pool<false><<<s.batch * s.tiles(), 256, 0, stream.get()>>>(
        input.get(), output.get(), s.tokens, s.channels, s.stride(), s.tiles());
  }
  checked(cudaGetLastError(), "kernel launch");
}

class ProfileRange {
 public:
  ProfileRange() {
    checked(cudaProfilerStart(), "profiler start");
  }
  ~ProfileRange() {
    if (active_) {
      cleanup(cudaProfilerStop(), "profiler stop during cleanup");
    }
  }
  ProfileRange(const ProfileRange&) = delete;
  ProfileRange& operator=(const ProfileRange&) = delete;
  void stop() {
    checked(cudaProfilerStop(), "profiler stop");
    active_ = false;
  }

 private:
  bool active_ = true;
};

void report(const char* metric, std::vector<double> values) {
  std::sort(values.begin(), values.end());
  // 最近秩分位数，100 样本对应第 50/95 个值。
  const auto percentile = [&](double p) {
    return values[static_cast<std::size_t>(std::ceil(p * values.size())) - 1];
  };
  std::cout << metric << " p50_ms=" << percentile(0.50) << " p95_ms=" << percentile(0.95)
            << " samples=" << values.size() << '\n';
}

void run_case(const practice::Shape& s, bool measure, const practice::Options& options) {
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
  for (const auto variant : options.variants) {
    const std::string label = practice::name(variant);
    // 每个版本先重新毒化输出，避免上一版本的正确结果掩盖漏写。
    checked(cudaMemsetAsync(device_output.get(), 0xFF, out_bytes, stream.get()), "poison output");
    // 先检查一遍，再进行 20 次预热；最终测量后还会检查输出。
    launch(variant, s, device_input, device_output, stream);
    checked(
        cudaMemcpyAsync(
            output.data(), device_output.get(), out_bytes, cudaMemcpyDeviceToHost, stream.get()),
        "D2H check");
    checked(cudaStreamSynchronize(stream.get()), "check synchronize");
    const float error = practice::check(output, expected);
    std::cout << "PASS B=" << s.batch << " T=" << s.tokens << " K=" << s.channels
              << " stride=" << s.stride() << " mode=" << label << " max_abs_error=" << error
              << '\n';
    if (!measure && !options.profile) {
      continue;
    }
    for (int i = 0; i < 20; ++i) {
      launch(variant, s, device_input, device_output, stream);
    }
    checked(cudaStreamSynchronize(stream.get()), "warmup synchronize");
    if (options.profile) {
      // 预热与精度检查在采集区外，ncu 只采集这个范围内的一个 kernel。
      ProfileRange range;
      launch(variant, s, device_input, device_output, stream);
      checked(cudaStreamSynchronize(stream.get()), "profile synchronize");
      range.stop();
      checked(
          cudaMemcpyAsync(
              output.data(), device_output.get(), out_bytes, cudaMemcpyDeviceToHost, stream.get()),
          "profile D2H");
      checked(cudaStreamSynchronize(stream.get()), "profile check synchronize");
      practice::check(output, expected);
      std::cout << "PROFILE " << label << " one kernel after 20 warmups; correctness PASS\n";
      continue;
    }
    std::vector<double> kernel_ms;
    for (int i = 0; i < 100; ++i) {
      checked(cudaEventRecord(begin.get(), stream.get()), "begin record");
      launch(variant, s, device_input, device_output, stream);
      checked(cudaEventRecord(end.get(), stream.get()), "end record");
      checked(cudaEventSynchronize(end.get()), "end synchronize");
      float elapsed = 0;
      checked(cudaEventElapsedTime(&elapsed, begin.get(), end.get()), "elapsed");
      kernel_ms.push_back(elapsed);
    }
    report((label + " GPU event kernel interval").c_str(), kernel_ms);
    std::vector<double> end_to_end_ms;
    for (int i = 0; i < 120; ++i) {
      const auto start = std::chrono::steady_clock::now();
      // 主机使用 pageable vector；此边界包含其 staging 和阻塞行为。
      checked(cudaMemcpyAsync(
                  device_input.get(), input.data(), in_bytes, cudaMemcpyHostToDevice, stream.get()),
              "H2D timed");
      launch(variant, s, device_input, device_output, stream);
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
    report((label + " host H2D+kernel+D2H+wait").c_str(), end_to_end_ms);
  }
}
}  // namespace

int main(int argc, char** argv) {
  try {
    const auto options = practice::parse_options(std::vector<std::string>(argv + 1, argv + argc));
    checked(cudaSetDevice(0), "set device");
    cudaDeviceProp prop{};
    checked(cudaGetDeviceProperties(&prop, 0), "device properties");
    int runtime = 0;
    int driver = 0;
    checked(cudaRuntimeGetVersion(&runtime), "runtime version");
    checked(cudaDriverGetVersion(&driver), "driver version");
    if (prop.major != 11 || prop.minor != 0) {
      throw std::runtime_error("all variants require the selected Jetson Thor SM110 target");
    }
    std::cout << std::setprecision(9) << "device=" << prop.name << " sm=" << prop.major
              << prop.minor << " runtime=" << runtime << " driver=" << driver << '\n';
    if (options.profile) {
      run_case({2, 197, 67}, false, options);
      return 0;
    }
    if (options.sweep) {
      for (int channels = 1; channels <= 128; ++channels) {
        for (int tokens : {1, 7, 8, 9, 197}) {
          run_case({2, tokens, channels}, false, options);
        }
      }
      return 0;
    }
    for (const auto s : {practice::Shape{1, 1, 1},
                         practice::Shape{1, 7, 64},
                         practice::Shape{2, 9, 127},
                         practice::Shape{2, 8, 128},
                         practice::Shape{1, 9, 65},
                         practice::Shape{1, 9, 66}}) {
      run_case(s, false, options);
    }
    run_case({2, 197, 67}, true, options);
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
