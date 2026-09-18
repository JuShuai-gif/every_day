#include <cuda_fp16.h>
#include <cuda_profiler_api.h>
#include <cuda_runtime.h>

#include <iomanip>
#include <iostream>
#include <type_traits>

#include "quant.hpp"
#if defined(__CUDA_ARCH__) && __CUDA_ARCH__ != 1100
#error "Thor SM110 only"
#endif
namespace {
void check(cudaError_t s, const char* what) {
  if (s != cudaSuccess) {
    throw std::runtime_error(std::string(what) + ": " + cudaGetErrorString(s));
  }
}
void clean(cudaError_t s, const char* what) noexcept {
  if (s != cudaSuccess) {
    std::cerr << "cleanup " << what << ": " << cudaGetErrorString(s) << '\n';
  }
}
struct Stream {
  cudaStream_t value{};
  Stream() {
    check(cudaStreamCreateWithFlags(&value, cudaStreamNonBlocking), "stream create");
  }
  ~Stream() {
    clean(cudaStreamDestroy(value), "stream destroy");
  }
  Stream(const Stream&) = delete;
  Stream& operator=(const Stream&) = delete;
};
struct Event {
  cudaEvent_t value{};
  Event() {
    check(cudaEventCreate(&value), "event create");
  }
  ~Event() {
    clean(cudaEventDestroy(value), "event destroy");
  }
  Event(const Event&) = delete;
  Event& operator=(const Event&) = delete;
};
class Buffer {
  void* pointer_ = nullptr;
  std::size_t size_;

 public:
  explicit Buffer(std::size_t size) : size_(std::max(std::size_t(1), size)) {
    check(cudaMalloc(&pointer_, size_), "cudaMalloc");
  }
  ~Buffer() {
    clean(cudaFree(pointer_), "cudaFree");
  }
  Buffer(const Buffer&) = delete;
  Buffer& operator=(const Buffer&) = delete;
  template <class T>
  T* ptr() const {
    return static_cast<T*>(pointer_);
  }
  void upload(const void* data, std::size_t size, const Stream& stream) {
    quant::require(size <= size_, "upload exceeds buffer");
    if (size) {
      check(cudaMemcpyAsync(pointer_, data, size, cudaMemcpyHostToDevice, stream.value), "H2D");
    }
  }
};
class Profile {
  bool active_ = true;

 public:
  Profile() {
    check(cudaProfilerStart(), "profile start");
  }
  ~Profile() {
    if (active_) {
      clean(cudaProfilerStop(), "profile stop cleanup");
    }
  }
  Profile(const Profile&) = delete;
  Profile& operator=(const Profile&) = delete;
  void stop() {
    check(cudaProfilerStop(), "profile stop");
    active_ = false;
  }
};
struct View {
  const uint8_t* a;
  const uint8_t* w;
  const float* scales;
  const uint16_t* ar;
  const uint16_t* wr;
  const float* fa;
  const float* fw;
  float* y;
  int m, k, n, groups, outliers;
  float ascale;
};
// 真实inline PTX：从字节中按0/4偏移提取有符号4bit；不是SASS。
template <int Bits>
__device__ int code(const uint8_t* values, int index) {
  if constexpr (Bits == 4) {
    const unsigned byte = values[index / 2], offset = (index & 1) * 4;
    int result;
    asm("bfe.s32 %0, %1, %2, 4;" : "=r"(result) : "r"(byte), "r"(offset));
    return result;
  } else {
    const int value = values[index];
    return value >= 128 ? value - 256 : value;
  }
}
__device__ float half_value(const uint16_t* values, int index) {
  return __half2float(__ushort_as_half(values[index]));
}
__device__ float residual(View v, int m, int n) {
  float result = 0;
  for (int o = 0; o < v.outliers; ++o) {
    result += half_value(v.ar, m * v.outliers + o) * half_value(v.wr, o * v.n + n);
  }
  return result;
}
__global__ void fp32_gemm(View v) {
  const int m = blockIdx.y * blockDim.y + threadIdx.y, n = blockIdx.x * blockDim.x + threadIdx.x;
  if (m < v.m && n < v.n) {
    float sum = 0;
    for (int k = 0; k < v.k; ++k) {
      sum += v.fa[m * v.k + k] * v.fw[k * v.n + n];
    }
    v.y[m * v.n + n] = sum;
  }
}
template <int WB, int AB>
__global__ void quant_baseline(View v) {
  const int m = blockIdx.y * 8 + threadIdx.y, n = blockIdx.x * 16 + threadIdx.x;
  if (m >= v.m || n >= v.n) {
    return;
  }
  float sum = 0;
  for (int g = 0; g < v.groups; ++g) {
    int integer = 0;
    float real = 0;
    for (int k = g * 16; k < min(v.k, g * 16 + 16); ++k) {
      const int w = code<WB>(v.w, k * v.n + n);
      if constexpr (AB == 16) {
        real += half_value(reinterpret_cast<const uint16_t*>(v.a), m * v.k + k) * w;
      } else {
        integer += code<AB>(v.a, m * v.k + k) * w;
      }
    }
    if constexpr (AB == 16) {
      sum += real * v.scales[g * v.n + n];
    } else {
      sum += integer * v.ascale * v.scales[g * v.n + n];
    }
  }
  v.y[m * v.n + n] = sum + residual(v, m, n);
}
template <int WB, int AB>
__global__ void quant_tiled(View v) {
  // 最终优化候选：一次解码供8行/16列复用，group=16恰好对齐K tile。
  using AType = typename std::conditional<AB == 16, float, int>::type;
  __shared__ AType a[8][16];
  __shared__ int w[16][16];
  const int tx = threadIdx.x, ty = threadIdx.y, tid = ty * 16 + tx;
  const int m = blockIdx.y * 8 + ty, n = blockIdx.x * 16 + tx;
  float sum = 0;
  for (int g = 0; g < v.groups; ++g) {
    const int k = g * 16 + tx;
    if constexpr (AB == 16) {
      a[ty][tx] = (m < v.m && k < v.k)
                      ? half_value(reinterpret_cast<const uint16_t*>(v.a), m * v.k + k)
                      : 0;
    } else {
      a[ty][tx] = (m < v.m && k < v.k) ? code<AB>(v.a, m * v.k + k) : 0;
    }
    for (int i = tid; i < 256; i += 128) {
      const int row = i / 16, col = i % 16, wk = g * 16 + row, wn = blockIdx.x * 16 + col;
      w[row][col] = (wk < v.k && wn < v.n) ? code<WB>(v.w, wk * v.n + wn) : 0;
    }
    __syncthreads();
    AType partial = 0;
#pragma unroll
    for (int kk = 0; kk < 16; ++kk) {
      partial += a[ty][kk] * w[kk][tx];
    }
    if (n < v.n) {
      if constexpr (AB == 16) {
        sum += partial * v.scales[g * v.n + n];
      } else {
        sum += partial * v.ascale * v.scales[g * v.n + n];
      }
    }
    // 所有消费者读完后才能覆盖下一组的shared tile。
    __syncthreads();
  }
  if (m < v.m && n < v.n) {
    v.y[m * v.n + n] = sum + residual(v, m, n);
  }
}
void launch(View v, int wb, int ab, const std::string& kernel, const Stream& stream) {
  const dim3 block(16, 8), grid((v.n + 15) / 16, (v.m + 7) / 8);
  if (kernel == "fp32") {
    fp32_gemm<<<grid, block, 0, stream.value>>>(v);
  }
#define LAUNCH(W, A)                                             \
  if (wb == W && ab == A) {                                      \
    if (kernel == "tiled") {                                     \
      quant_tiled<W, A><<<grid, block, 0, stream.value>>>(v);    \
    } else {                                                     \
      quant_baseline<W, A><<<grid, block, 0, stream.value>>>(v); \
    }                                                            \
  }
  else {
    LAUNCH(4, 4) LAUNCH(4, 16) LAUNCH(8, 8) LAUNCH(8, 16)
  }
#undef LAUNCH
  check(cudaGetLastError(), "GEMM launch");
}
void verify(const quant::Matrix& actual, const quant::Matrix& oracle) {
  for (std::size_t i = 0; i < actual.data.size(); ++i) {
    quant::require(std::isfinite(actual.data[i]) && std::abs(actual.data[i] - oracle.data[i]) <=
                                                        1e-3F + 1e-4F * std::abs(oracle.data[i]),
                   "GPU vs CPU quantized oracle mismatch");
  }
}
void report(const std::string& label, std::vector<double> values) {
  std::sort(values.begin(), values.end());
  std::cout << label << " p50_ms=" << values[(values.size() - 1) / 2]
            << " p95_ms=" << values[std::size_t(std::ceil(values.size() * 0.95)) - 1] << '\n';
}
void run(const quant::Data& data,
         int wb,
         int ab,
         const std::string& method,
         const std::string& only_kernel,
         bool profile,
         bool include_fp32) {
  const quant::Model model = quant::build(data, wb, ab, method);
  const quant::Batch batch = quant::prepare(data.evaluation, model);
  const quant::Matrix oracle = quant::packed_gemm(batch, model),
                      reference = quant::gemm(data.evaluation, data.weights);
  quant::Matrix output(batch.m, model.n);
  Stream stream;
  Event begin, end;
  const std::size_t abytes = ab == 16 ? batch.half.size() * 2 : batch.codes.bytes.size();
  Buffer a(abytes), w(model.weights.bytes.size()), scales(model.scales.size() * 4),
      ar(batch.residual.size() * 2), wr(model.residual_weights.size() * 2),
      fa(data.evaluation.data.size() * 4), fw(data.weights.data.size() * 4),
      y(output.data.size() * 4);
  w.upload(model.weights.bytes.data(), model.weights.bytes.size(), stream);
  scales.upload(model.scales.data(), model.scales.size() * 4, stream);
  wr.upload(model.residual_weights.data(), model.residual_weights.size() * 2, stream);
  fa.upload(data.evaluation.data.data(), data.evaluation.data.size() * 4, stream);
  fw.upload(data.weights.data.data(), data.weights.data.size() * 4, stream);
  const auto upload = [&](const quant::Batch& b) {
    try {
      a.upload(ab == 16 ? static_cast<const void*>(b.half.data())
                        : static_cast<const void*>(b.codes.bytes.data()),
               abytes,
               stream);
      ar.upload(b.residual.data(), b.residual.size() * 2, stream);
      // 本例不做传输重叠；返回前结束借用，在线Batch即使异常退出也不会悬空。
      check(cudaStreamSynchronize(stream.value), "activation upload synchronize");
    } catch (...) {
      clean(cudaStreamSynchronize(stream.value), "drain borrowed activation before unwinding");
      throw;
    }
  };
  upload(batch);
  View view{a.ptr<uint8_t>(),
            w.ptr<uint8_t>(),
            scales.ptr<float>(),
            ar.ptr<uint16_t>(),
            wr.ptr<uint16_t>(),
            fa.ptr<float>(),
            fw.ptr<float>(),
            y.ptr<float>(),
            batch.m,
            model.k,
            model.n,
            model.groups,
            int(model.outlier.size()),
            model.activation_scale};
  const auto download = [&] {
    check(cudaMemcpyAsync(output.data.data(),
                          y.ptr<float>(),
                          output.data.size() * 4,
                          cudaMemcpyDeviceToHost,
                          stream.value),
          "D2H");
    check(cudaStreamSynchronize(stream.value), "download synchronize");
  };
  std::vector<std::string> kernels = profile ? std::vector<std::string>{only_kernel}
                                             : std::vector<std::string>{"baseline", "tiled"};
  if (include_fp32 && !profile) {
    kernels.insert(kernels.begin(), "fp32");
  }
  for (const auto& kernel : kernels) {
    const auto& expected = kernel == "fp32" ? reference : oracle;
    check(cudaMemsetAsync(y.ptr<float>(), 0xff, output.data.size() * 4, stream.value),
          "output poison");
    launch(view, wb, ab, kernel, stream);
    download();
    verify(output, expected);
    const std::string label =
        "W" + std::to_string(wb) + "A" + std::to_string(ab) + "/" + method + "/" + kernel;
    std::cout << "PASS " << label
              << " original_FP32_nrmse=" << quant::metrics(output, reference).nrmse << '\n';
    for (int i = 0; i < 20; ++i) {
      launch(view, wb, ab, kernel, stream);
    }
    check(cudaStreamSynchronize(stream.value), "warmup synchronize");
    if (profile) {
      Profile range;
      launch(view, wb, ab, kernel, stream);
      check(cudaStreamSynchronize(stream.value), "profile synchronize");
      range.stop();
      download();
      verify(output, expected);
      continue;
    }
    std::vector<double> times;
    for (int i = 0; i < 100; ++i) {
      check(cudaEventRecord(begin.value, stream.value), "begin record");
      launch(view, wb, ab, kernel, stream);
      check(cudaEventRecord(end.value, stream.value), "end record");
      check(cudaEventSynchronize(end.value), "event wait");
      float ms = 0;
      check(cudaEventElapsedTime(&ms, begin.value, end.value), "event elapsed");
      times.push_back(ms);
    }
    report(label + " GPU_kernel", times);
    times.clear();
    for (int i = 0; i < 120; ++i) {
      const auto start = std::chrono::steady_clock::now();
      // 权重已驻留；量化版本计入在线CPU缩放/量化/packing和输入传输。
      quant::Batch online;
      if (kernel == "fp32") {
        fa.upload(data.evaluation.data.data(), data.evaluation.data.size() * 4, stream);
      } else {
        online = quant::prepare(data.evaluation, model);
        upload(online);
      }
      launch(view, wb, ab, kernel, stream);
      download();
      const double ms =
          std::chrono::duration<double, std::milli>(std::chrono::steady_clock::now() - start)
              .count();
      verify(output, expected);
      if (i >= 20) {
        times.push_back(ms);
      }
    }
    report(label + " host_preprocess_H2D_GEMM_D2H_wait", times);
  }
}
}  // namespace
int main(int argc, char** argv) {
  try {
    bool profile = argc > 1;
    int wb = 4, ab = 4;
    std::string method = "qat", kernel = "tiled";
    if (profile) {
      quant::require(
          argc == 5 && std::string(argv[1]) == "--profile",
          "usage: quant_gpu [--profile W4A4|W4A16|W8A8|W8A16 method baseline|tiled|fp32]");
      const std::string format = argv[2];
      method = argv[3];
      kernel = argv[4];
      quant::require(format == "W4A4" || format == "W4A16" || format == "W8A8" || format == "W8A16",
                     "invalid format");
      wb = format[1] - '0';
      ab = format.find("A16") != std::string::npos ? 16 : format.back() - '0';
      quant::require(kernel == "baseline" || kernel == "tiled" || kernel == "fp32",
                     "invalid kernel");
    }
    check(cudaSetDevice(0), "set device");
    cudaDeviceProp prop{};
    check(cudaGetDeviceProperties(&prop, 0), "device properties");
    quant::require(prop.major == 11 && prop.minor == 0, "Thor SM110 required");
    int runtime = 0, driver = 0;
    check(cudaRuntimeGetVersion(&runtime), "runtime");
    check(cudaDriverGetVersion(&driver), "driver");
    std::cout << std::setprecision(9) << "device=" << prop.name << " sm=110 runtime=" << runtime
              << " driver=" << driver << '\n';
    quant::Data data;
    if (profile) {
      run(data, wb, ab, method, kernel, true, false);
    } else {
      bool first = true;
      for (const auto mode : {std::pair<int, int>{4, 4}, {4, 16}, {8, 8}, {8, 16}}) {
        for (const std::string method_name :
             {"absmax", "smoothquant", "calibrated", "outlier", "qat"}) {
          run(data, mode.first, mode.second, method_name, "tiled", false, first);
          first = false;
        }
      }
    }
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
