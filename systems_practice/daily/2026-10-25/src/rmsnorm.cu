#include <cuda_runtime.h>

#include <iostream>
#include <string>

#include "reference.hpp"

void check(cudaError_t e) {
  if (e != cudaSuccess) {
    throw std::runtime_error(cudaGetErrorString(e));
  }
}
void cleanup(cudaError_t e) noexcept {
  if (e != cudaSuccess) {
    std::cerr << "CUDA cleanup: " << cudaGetErrorString(e) << '\n';
  }
}
struct Device {
  float* ptr = nullptr;
  explicit Device(size_t n) {
    check(cudaMalloc(reinterpret_cast<void**>(&ptr), n * sizeof(float)));
  }
  ~Device() {
    cleanup(cudaFree(ptr));
  }
  Device(const Device&) = delete;
  Device& operator=(const Device&) = delete;
};
struct Event {
  cudaEvent_t value{};
  Event() {
    check(cudaEventCreate(&value));
  }
  ~Event() {
    cleanup(cudaEventDestroy(value));
  }
  Event(const Event&) = delete;
  Event& operator=(const Event&) = delete;
};
// 正确性基线：一CTA一行，shared树归约，输出阶段重新加载输入。
__global__ void rms_base(const float* x, float* y, int cols, int stride, float eps) {
  __shared__ float sums[128];
  int row = blockIdx.x, lane = threadIdx.x;
  float sum = 0;
  for (int c = lane; c < cols; c += 128) {
    float a = x[row * stride + c];
    sum += a * a;
  }
  sums[lane] = sum;
  __syncthreads();
  for (int d = 64; d > 0; d /= 2) {
    if (lane < d) {
      sums[lane] += sums[lane + d];
    }
    __syncthreads();
  }
  float scale = rsqrtf(sums[0] / cols + eps);
  for (int c = lane; c < cols; c += 128) {
    y[row * cols + c] = x[row * stride + c] * scale;
  }
}
__device__ float exchange(float v, int distance) {
  float out;
  // 真实手写PTX；完整32lane参与，bfly只交换寄存器，不建立通用内存栅栏。
  asm("shfl.sync.bfly.b32 %0, %1, %2, 31, 0xffffffff;" : "=f"(out) : "f"(v), "r"(distance));
  return out;
}
// 最终优化候选：每warp一行，寄存器缓存输入；Thor收益尚未实测。
__global__ void rms_warp(const float* x, float* y, int rows, int cols, int stride, float eps) {
  int lane = threadIdx.x % 32, row = blockIdx.x * 4 + threadIdx.x / 32;
  if (row >= rows) {
    return;
  }  // 整warp一起退出，不能按col提前退出。
  float values[32];
  float sum = 0;
#pragma unroll
  for (int k = 0; k < 32; ++k) {
    int c = lane + 32 * k;
    values[k] = c < cols ? x[row * stride + c] : 0.0f;
    sum += values[k] * values[k];
  }
#pragma unroll
  for (int d = 16; d > 0; d /= 2) {
    sum += exchange(sum, d);
  }
  float scale = rsqrtf(sum / cols + eps);
#pragma unroll
  for (int k = 0; k < 32; ++k) {
    int c = lane + 32 * k;
    if (c < cols) {
      y[row * cols + c] = values[k] * scale;
    }
  }
}
void launch(bool warp, Device& x, Device& y, int rows, int cols, int stride) {
  if (warp) {
    rms_warp<<<(rows + 3) / 4, 128>>>(x.ptr, y.ptr, rows, cols, stride, 1e-5f);
  } else {
    rms_base<<<rows, 128>>>(x.ptr, y.ptr, cols, stride, 1e-5f);
  }
  check(cudaGetLastError());
}
void run_case(int rows, int cols, bool zero, int variant, bool bench) {
  int stride = cols + 3;
  auto x = inputs(rows, cols, stride, zero);
  auto ref = reference(x, rows, cols, stride, 1e-5f);
  Device dx(x.size()), dy(ref.size());
  check(cudaMemcpy(dx.ptr, x.data(), x.size() * sizeof(float), cudaMemcpyHostToDevice));
  for (int v = 0; v < 2; ++v) {
    if (variant >= 0 && v != variant) {
      continue;
    }
    launch(v == 1, dx, dy, rows, cols, stride);
    check(cudaDeviceSynchronize());
    std::vector<float> y(ref.size());
    check(cudaMemcpy(y.data(), dy.ptr, y.size() * sizeof(float), cudaMemcpyDeviceToHost));
    auto error = compare(y, ref);
    std::cout << (v ? "warp" : "base") << " rows=" << rows << " cols=" << cols << " zero=" << zero
              << " max_abs=" << error;
    if (bench) {
      for (int i = 0; i < 20; ++i) {
        launch(v == 1, dx, dy, rows, cols, stride);
      }
      check(cudaDeviceSynchronize());
      Event start, stop;
      std::vector<float> samples;
      for (int s = 0; s < 31; ++s) {
        check(cudaEventRecord(start.value));
        for (int i = 0; i < 100; ++i) {
          launch(v == 1, dx, dy, rows, cols, stride);
        }
        check(cudaEventRecord(stop.value));
        check(cudaEventSynchronize(stop.value));
        float ms = 0;
        check(cudaEventElapsedTime(&ms, start.value, stop.value));
        samples.push_back(ms * 10);
      }
      std::sort(samples.begin(), samples.end());
      std::cout << " event_batch_mean_us_P50=" << samples[15] << " P95=" << samples[29];
    }
    std::cout << '\n';
  }
}
int main(int argc, char** argv) {
  try {
    cudaDeviceProp prop{};
    check(cudaGetDeviceProperties(&prop, 0));
    require(prop.major == 11 && prop.minor == 0, "requires Thor SM110");
    int driver = 0, runtime = 0;
    check(cudaDriverGetVersion(&driver));
    check(cudaRuntimeGetVersion(&runtime));
    std::cout << prop.name << " driver=" << driver << " runtime=" << runtime << '\n';
    if (argc == 1) {
      for (int rows : {1, 3, 4, 5, 17}) {
        for (int cols : {1, 3, 31, 32, 33, 127, 128, 129, 513, 1024}) {
          for (bool z : {false, true}) {
            run_case(rows, cols, z, -1, false);
          }
        }
      }
    } else {
      require(argc == 4, "usage: rmsnorm rows cols base|warp|both");
      int rows = std::stoi(argv[1]), cols = std::stoi(argv[2]);
      require(cols > 0 && cols <= 1024, "invalid cols");
      contract(rows, cols, cols + 3, 1e-5f);
      std::string mode = argv[3];
      require(mode == "base" || mode == "warp" || mode == "both", "invalid mode");
      run_case(rows, cols, false, mode == "base" ? 0 : mode == "warp" ? 1 : -1, true);
    }
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
