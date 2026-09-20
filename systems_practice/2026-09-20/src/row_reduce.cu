// 独立教学实现：PyTorch多累加器和NVIDIA warp/block归约机制，见README来源。
#include <cuda_profiler_api.h>
#include <cuda_runtime.h>

#include <chrono>
#include <iostream>
#include <string>

#include "reduce.hpp"
#if defined(__CUDA_ARCH__) && __CUDA_ARCH__ != 1100
#error "Only Thor SM110"
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

// 真实inline PTX：所有32个lane都参加；clamp=31，membermask=全warp。
__device__ float warp_sum(float value) {
  for (int delta = 16; delta > 0; delta /= 2) {
    float other;
    asm volatile("shfl.sync.bfly.b32 %0, %1, %2, 31, 0xffffffff;"
                 : "=f"(other)
                 : "f"(value), "r"(delta));
    value += other;
  }
  return value;
}
template <int Acc, int Threads>
__global__ void row_reduce(const float* input, float* output, Shape s) {
  static_assert(Threads == 128 || Threads == 256);
  __shared__ float warps[Threads / 32];
  int row = int(blockIdx.x), tid = int(threadIdx.x);
  float value = partial<Acc, Threads>(input + std::size_t(row) * s.stride, s.cols, tid);
  value = warp_sum(value);
  if (tid % 32 == 0) {
    warps[tid / 32] = value;
  }
  // 无有效输入的线程仍以0参与；shared跨warp交接必须有CTA屏障。
  __syncthreads();
  if (tid < 32) {
    value = tid < Threads / 32 ? warps[tid] : 0.0f;
    value = warp_sum(value);
    if (tid == 0) {
      output[row] = value;
    }
  }
}
template <int Acc, int Threads>
void resource_info(const cudaDeviceProp& prop) {
  cudaFuncAttributes attr{};
  CUDA(cudaFuncGetAttributes(&attr, row_reduce<Acc, Threads>));
  int blocks = 0;
  CUDA(
      cudaOccupancyMaxActiveBlocksPerMultiprocessor(&blocks, row_reduce<Acc, Threads>, Threads, 0));
  std::cout << "acc=" << Acc << " threads=" << Threads << " regs/thread=" << attr.numRegs
            << " static_shared=" << attr.sharedSizeBytes << " local_bytes=" << attr.localSizeBytes
            << " theoretical_active_blocks/SM=" << blocks << " theoretical_occupancy="
            << double(blocks * Threads) / prop.maxThreadsPerMultiProcessor << '\n';
}
void launch(int variant, const Buffer& a, Buffer& out, Shape s) {
  switch (variant) {
    case 0:
      row_reduce<1, 128><<<s.rows, 128>>>(a.ptr, out.ptr, s);
      break;
    case 1:
      row_reduce<2, 128><<<s.rows, 128>>>(a.ptr, out.ptr, s);
      break;
    case 2:
      row_reduce<4, 128><<<s.rows, 128>>>(a.ptr, out.ptr, s);
      break;
    case 3:
      row_reduce<8, 128><<<s.rows, 128>>>(a.ptr, out.ptr, s);
      break;
    case 4:
      row_reduce<4, 256><<<s.rows, 256>>>(a.ptr, out.ptr, s);
      break;
    default:
      throw std::invalid_argument("variant 0..4");
  }
  CUDA(cudaGetLastError());
}
void correctness(Shape s, int variant, int pattern = 0) {
  auto a = input(s, pattern);
  std::vector<float> out(s.rows, NAN);
  Buffer da(a.size()), dy(out.size());
  CUDA(cudaMemcpy(da.ptr, a.data(), a.size() * sizeof(float), cudaMemcpyHostToDevice));
  CUDA(cudaMemcpy(dy.ptr, out.data(), out.size() * sizeof(float), cudaMemcpyHostToDevice));
  launch(variant, da, dy, s);
  CUDA(cudaDeviceSynchronize());
  CUDA(cudaMemcpy(out.data(), dy.ptr, out.size() * sizeof(float), cudaMemcpyDeviceToHost));
  check(s, a, out);
}
double percentile(std::vector<double> x, double p) {
  std::sort(x.begin(), x.end());
  return x[std::size_t(std::ceil(p * x.size())) - 1];
}
void benchmark(Shape s, int variant, bool profile) {
  correctness(s, variant);
  auto a = input(s);
  std::vector<float> out(s.rows, NAN);
  Buffer da(a.size()), dy(out.size());
  Event start, stop;
  CUDA(cudaMemcpy(da.ptr, a.data(), a.size() * sizeof(float), cudaMemcpyHostToDevice));
  for (int i = 0; i < 20; ++i) {
    launch(variant, da, dy, s);
  }
  CUDA(cudaDeviceSynchronize());
  if (profile) {
    CUDA(cudaProfilerStart());
    launch(variant, da, dy, s);
    CUDA(cudaDeviceSynchronize());
    CUDA(cudaProfilerStop());
  } else {
    std::vector<double> gpu, e2e;
    for (int i = 0; i < 100; ++i) {
      CUDA(cudaEventRecord(start.event));
      launch(variant, da, dy, s);
      CUDA(cudaEventRecord(stop.event));
      CUDA(cudaEventSynchronize(stop.event));
      float ms = 0;
      CUDA(cudaEventElapsedTime(&ms, start.event, stop.event));
      gpu.push_back(ms);
    }
    for (int i = 0; i < 120; ++i) {
      auto begin = std::chrono::steady_clock::now();
      CUDA(cudaMemcpy(da.ptr, a.data(), a.size() * sizeof(float), cudaMemcpyHostToDevice));
      launch(variant, da, dy, s);
      CUDA(cudaMemcpy(out.data(), dy.ptr, out.size() * sizeof(float), cudaMemcpyDeviceToHost));
      CUDA(cudaDeviceSynchronize());
      auto end = std::chrono::steady_clock::now();
      if (i >= 20) {
        e2e.push_back(std::chrono::duration<double, std::milli>(end - begin).count());
      }
    }
    std::cout << "variant=" << variant << " rows=" << s.rows << " cols=" << s.cols
              << " gpu_p50_ms=" << percentile(gpu, .5) << " gpu_p95_ms=" << percentile(gpu, .95)
              << " useful_GBps="
              << (double(s.rows) * s.cols + s.rows) * 4 / (percentile(gpu, .5) * 1e6)
              << " e2e_p50_ms=" << percentile(e2e, .5) << " e2e_p95_ms=" << percentile(e2e, .95)
              << '\n';
  }
  CUDA(cudaMemcpy(out.data(), dy.ptr, out.size() * sizeof(float), cudaMemcpyDeviceToHost));
  check(s, a, out);
}
int main(int argc, char** argv) {
  try {
    int variant = 2;
    bool all = false, sweep = false, profile = false;
    Shape s{394, 4097, 4100};
    for (int i = 1; i < argc; ++i) {
      std::string arg = argv[i];
      if (arg == "--all") {
        all = true;
      } else if (arg == "--sweep") {
        sweep = true;
      } else if (arg == "--profile") {
        profile = true;
      } else if (arg == "--small") {
        s = {2, 4097, 4100};
      } else if (arg == "--variant" && i + 1 < argc) {
        std::string v = argv[++i];
        if (v.size() != 1 || v[0] < '0' || v[0] > '4') {
          throw std::invalid_argument("variant 0..4");
        }
        variant = v[0] - '0';
      } else {
        throw std::invalid_argument("usage: --all|--sweep|--profile [--variant 0..4] [--small]");
      }
    }
    if (int(all) + int(sweep) + int(profile) > 1) {
      throw std::invalid_argument("exclusive modes");
    }
    s.validate();
    CUDA(cudaSetDevice(0));
    cudaDeviceProp prop{};
    CUDA(cudaGetDeviceProperties(&prop, 0));
    if (prop.major != 11 || prop.minor != 0) {
      throw std::runtime_error("Thor SM110 (11.0) required");
    }
    int driver = 0, runtime = 0;
    CUDA(cudaDriverGetVersion(&driver));
    CUDA(cudaRuntimeGetVersion(&runtime));
    std::cout << prop.name << " CC=11.0 SMs=" << prop.multiProcessorCount
              << " driver_api=" << driver << " runtime=" << runtime << '\n';
    resource_info<1, 128>(prop);
    resource_info<2, 128>(prop);
    resource_info<4, 128>(prop);
    resource_info<8, 128>(prop);
    resource_info<4, 256>(prop);
    if (sweep) {
      for (auto shape : cases()) {
        for (int p = 0; p < 3; ++p) {
          for (int v = 0; v < 5; ++v) {
            correctness(shape, v, p);
          }
        }
      }
      std::cout << "GPU PASS 675 comparisons\n";
    } else if (all) {
      for (int v = 0; v < 5; ++v) {
        benchmark(s, v, false);
      }
    } else {
      benchmark(s, variant, profile);
    }
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
