// Tile转置机制受NVIDIA官方transpose示例启发；来源与边界见README。
#include <cuda_profiler_api.h>
#include <cuda_runtime.h>

#include <chrono>
#include <iostream>
#include <string>

#include "layout.hpp"

#if defined(__CUDA_ARCH__) && __CUDA_ARCH__ != 1100
#error "Fixed target is Thor SM110"
#endif
using namespace practice;
void checked(cudaError_t status, const char* operation) {
  if (status != cudaSuccess) {
    throw std::runtime_error(std::string(operation) + ": " + cudaGetErrorString(status));
  }
}
void cleanup(cudaError_t status, const char* operation) noexcept {
  if (status != cudaSuccess) {
    std::cerr << "cleanup " << operation << ": " << cudaGetErrorString(status) << '\n';
  }
}
#define CUDA(call) checked((call), #call)
struct Buffer {
  float* ptr = nullptr;
  explicit Buffer(std::size_t count) {
    CUDA(cudaMalloc(reinterpret_cast<void**>(&ptr), count * sizeof(float)));
  }
  ~Buffer() {
    if (ptr) {
      cleanup(cudaFree(ptr), "cudaFree");
    }
  }
  Buffer(const Buffer&) = delete;
  Buffer& operator=(const Buffer&) = delete;
};
struct Event {
  cudaEvent_t event{};
  Event() {
    CUDA(cudaEventCreate(&event));
  }
  ~Event() {
    cleanup(cudaEventDestroy(event), "cudaEventDestroy");
  }
  Event(const Event&) = delete;
  Event& operator=(const Event&) = delete;
};
// 真实手写inline PTX；选择默认cache语义，不把强制绕过L1当作优化。
__device__ float load_global(const float* pointer) {
  float value;
  asm volatile("ld.global.f32 %0, [%1];" : "=f"(value) : "l"(pointer) : "memory");
  return value;
}
__global__ void transpose_naive(const float* input, float* output, Shape s) {
  int c = int(blockIdx.x) * 32 + int(threadIdx.x);
  int b = int(blockIdx.z);
  for (int j = 0; j < 32; j += 8) {
    int r = int(blockIdx.y) * 32 + int(threadIdx.y) + j;
    if (r < s.rows && c < s.cols) {
      output[(std::size_t(b) * s.cols + c) * s.output_stride + r] =
          load_global(input + (std::size_t(b) * s.rows + r) * s.input_stride + c);
    }
  }
}
template <int Pad, int BlockRows>
__global__ void transpose_tiled(const float* input, float* output, Shape s) {
  static_assert(32 % BlockRows == 0);
  __shared__ float scratch[32][32 + Pad];
  int tx = int(threadIdx.x), ty = int(threadIdx.y), b = int(blockIdx.z);
  int c = int(blockIdx.x) * 32 + tx;
  for (int j = 0; j < 32; j += BlockRows) {
    int r = int(blockIdx.y) * 32 + ty + j;
    if (r < s.rows && c < s.cols) {
      scratch[ty + j][tx] = load_global(input + (std::size_t(b) * s.rows + r) * s.input_stride + c);
    }
  }
  // 尾块线程也必须到达barrier，不能提前return；两侧guard互为转置。
  __syncthreads();
  int r = int(blockIdx.y) * 32 + tx;
  for (int j = 0; j < 32; j += BlockRows) {
    int out_c = int(blockIdx.x) * 32 + ty + j;
    if (r < s.rows && out_c < s.cols) {
      output[(std::size_t(b) * s.cols + out_c) * s.output_stride + r] = scratch[tx][ty + j];
    }
  }
}
void launch(int variant, const Buffer& a, Buffer& out, Shape s) {
  dim3 grid((s.cols + 31) / 32, (s.rows + 31) / 32, s.batches);
  if (variant == 0) {
    transpose_naive<<<grid, dim3(32, 8)>>>(a.ptr, out.ptr, s);
  } else if (variant == 1) {
    transpose_tiled<0, 8><<<grid, dim3(32, 8)>>>(a.ptr, out.ptr, s);
  } else if (variant == 2) {
    transpose_tiled<1, 8><<<grid, dim3(32, 8)>>>(a.ptr, out.ptr, s);
  } else if (variant == 3) {
    transpose_tiled<1, 4><<<grid, dim3(32, 4)>>>(a.ptr, out.ptr, s);
  } else {
    throw std::invalid_argument("variant must be 0..3");
  }
  CUDA(cudaGetLastError());
}
void correctness(Shape s, int variant) {
  auto a = input(s), expected = oracle(s, a);
  std::vector<float> out(s.output_count(), sentinel);
  // 有效元素用NaN污染，padding用sentinel；缺写/越界写分别可被发现。
  for (int b = 0; b < s.batches; ++b) {
    for (int c = 0; c < s.cols; ++c) {
      for (int r = 0; r < s.rows; ++r) {
        out[(std::size_t(b) * s.cols + c) * s.output_stride + r] = NAN;
      }
    }
  }
  Buffer device_a(a.size()), device_out(out.size());
  CUDA(cudaMemcpy(device_a.ptr, a.data(), a.size() * sizeof(float), cudaMemcpyHostToDevice));
  CUDA(cudaMemcpy(device_out.ptr, out.data(), out.size() * sizeof(float), cudaMemcpyHostToDevice));
  launch(variant, device_a, device_out, s);
  CUDA(cudaDeviceSynchronize());
  CUDA(cudaMemcpy(out.data(), device_out.ptr, out.size() * sizeof(float), cudaMemcpyDeviceToHost));
  check(out, expected);
}
double percentile(std::vector<double> values, double p) {
  std::sort(values.begin(), values.end());
  return values[std::size_t(std::ceil(p * values.size())) - 1];
}
void benchmark(Shape s, int variant, bool profile) {
  correctness(s, variant);
  auto a = input(s), expected = oracle(s, a);
  std::vector<float> out(s.output_count(), sentinel);
  Buffer device_a(a.size()), device_out(out.size());
  Event start, stop;
  CUDA(cudaMemcpy(device_a.ptr, a.data(), a.size() * sizeof(float), cudaMemcpyHostToDevice));
  CUDA(cudaMemcpy(device_out.ptr, out.data(), out.size() * sizeof(float), cudaMemcpyHostToDevice));
  for (int i = 0; i < 20; ++i) {
    launch(variant, device_a, device_out, s);
  }
  CUDA(cudaDeviceSynchronize());
  if (profile) {
    // ncu --profile-from-start off只采集这个单独launch，不依赖易变的skip计数。
    CUDA(cudaProfilerStart());
    launch(variant, device_a, device_out, s);
    CUDA(cudaDeviceSynchronize());
    CUDA(cudaProfilerStop());
  } else {
    std::vector<double> gpu_ms, e2e_ms;
    for (int i = 0; i < 100; ++i) {
      CUDA(cudaEventRecord(start.event));
      launch(variant, device_a, device_out, s);
      CUDA(cudaEventRecord(stop.event));
      CUDA(cudaEventSynchronize(stop.event));
      float ms = 0;
      CUDA(cudaEventElapsedTime(&ms, start.event, stop.event));
      gpu_ms.push_back(ms);
    }
    // pageable主机内存、预分配buffer；含H2D、提交、执行、D2H与等待。
    for (int i = 0; i < 120; ++i) {
      auto begin = std::chrono::steady_clock::now();
      CUDA(cudaMemcpy(device_a.ptr, a.data(), a.size() * sizeof(float), cudaMemcpyHostToDevice));
      launch(variant, device_a, device_out, s);
      CUDA(cudaMemcpy(
          out.data(), device_out.ptr, out.size() * sizeof(float), cudaMemcpyDeviceToHost));
      CUDA(cudaDeviceSynchronize());
      auto end = std::chrono::steady_clock::now();
      if (i >= 20) {
        e2e_ms.push_back(std::chrono::duration<double, std::milli>(end - begin).count());
      }
    }
    double p50 = percentile(gpu_ms, .5);
    double useful_bytes = 2.0 * s.batches * s.rows * s.cols * sizeof(float);
    std::cout << "variant=" << variant << " gpu_p50_ms=" << p50
              << " gpu_p95_ms=" << percentile(gpu_ms, .95)
              << " useful_GBps=" << useful_bytes / (p50 * 1e6)
              << " e2e_p50_ms=" << percentile(e2e_ms, .5)
              << " e2e_p95_ms=" << percentile(e2e_ms, .95) << '\n';
  }
  CUDA(cudaMemcpy(out.data(), device_out.ptr, out.size() * sizeof(float), cudaMemcpyDeviceToHost));
  check(out, expected);
}
int main(int argc, char** argv) {
  try {
    int variant = 2;
    bool all = false, sweep = false, profile = false;
    for (int i = 1; i < argc; ++i) {
      std::string arg = argv[i];
      if (arg == "--all") {
        all = true;
      } else if (arg == "--sweep") {
        sweep = true;
      } else if (arg == "--profile") {
        profile = true;
      } else if (arg == "--variant" && i + 1 < argc) {
        std::string value = argv[++i];
        if (value.size() != 1 || value[0] < '0' || value[0] > '3') {
          throw std::invalid_argument("variant 0..3");
        }
        variant = value[0] - '0';
      } else {
        throw std::invalid_argument("usage: transpose [--all|--sweep|--profile] [--variant 0..3]");
      }
    }
    if (int(all) + int(sweep) + int(profile) > 1) {
      throw std::invalid_argument("exclusive run modes");
    }
    cudaDeviceProp prop{};
    CUDA(cudaSetDevice(0));
    CUDA(cudaGetDeviceProperties(&prop, 0));
    if (prop.major != 11 || prop.minor != 0) {
      throw std::runtime_error("Thor SM110 required");
    }
    int driver = 0, runtime = 0;
    CUDA(cudaDriverGetVersion(&driver));
    CUDA(cudaRuntimeGetVersion(&runtime));
    std::cout << "device=" << prop.name << " CC=11.0 driver=" << driver << " runtime=" << runtime
              << '\n';
    if (sweep) {
      for (auto s : cases()) {
        for (int v = 0; v < 4; ++v) {
          correctness(s, v);
        }
      }
      std::cout << "PASS 196 shapes x 4 GPU variants\n";
    } else {
      Shape s{2, 197, 128, 131, 200};
      std::cout
          << "B=2 rows=197 cols=128 input_stride=131 output_stride=200 warmup=20 samples=100\n";
      if (all) {
        for (int v = 0; v < 4; ++v) {
          benchmark(s, v, false);
        }
      } else {
        benchmark(s, variant, profile);
      }
    }
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
