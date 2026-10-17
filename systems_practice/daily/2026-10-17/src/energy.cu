#include <cuda_runtime.h>

#include <algorithm>
#include <chrono>
#include <cstdio>
#include <iostream>
#include <string>

#include "contract.hpp"
void ck(cudaError_t e) {
  if (e != cudaSuccess) {
    throw std::runtime_error(cudaGetErrorString(e));
  }
}
void cleanup(cudaError_t e) noexcept {
  if (e != cudaSuccess) {
    std::fprintf(stderr, "cleanup: %s\n", cudaGetErrorString(e));
  }
}
struct Buffer {
  float* p = nullptr;
  explicit Buffer(std::size_t count) {
    ck(cudaMalloc(reinterpret_cast<void**>(&p), count * sizeof(float)));
  }
  ~Buffer() {
    cleanup(cudaFree(p));
  }
  Buffer(const Buffer&) = delete;
  Buffer& operator=(const Buffer&) = delete;
};
struct Event {
  cudaEvent_t e{};
  Event() {
    ck(cudaEventCreate(&e));
  }
  ~Event() {
    cleanup(cudaEventDestroy(e));
  }
  Event(const Event&) = delete;
  Event& operator=(const Event&) = delete;
};
// 手写PTX，不是实际生成的SASS；所有32个lane必须到达同一shuffle。
__device__ float down(float x, int offset) {
  unsigned v = __float_as_uint(x), out;
  asm volatile("shfl.sync.bfly.b32 %0, %1, %2, 31, 0xffffffff;" : "=r"(out) : "r"(v), "r"(offset));
  return __uint_as_float(out);
}
// 一个warp独占一行，四个warp/CTA；U只改变独立累加器数与循环跨度。
template <int U>
__global__ void row_energy(const float* x, float* y, int rows, int cols, int stride) {
  const int lane = threadIdx.x & 31;
  const int row = blockIdx.x * 4 + threadIdx.x / 32;
  if (row >= rows) {
    return;
  }  // 整warp统一退出，不产生部分活跃mask。
  float acc[U] = {};
  for (int base = lane; base < cols; base += 32 * U) {
#pragma unroll
    for (int u = 0; u < U; ++u) {
      int col = base + 32 * u;
      if (col < cols) {
        const float v = x[static_cast<std::size_t>(row) * stride + col];
        acc[u] = fmaf(v, v, acc[u]);
      }
    }
  }
  float sum = 0;
#pragma unroll
  for (int u = 0; u < U; ++u) {
    sum += acc[u];
  }
  for (int d = 16; d > 0; d /= 2) {
    sum += down(sum, d);
  }
  if (lane == 0) {
    y[row] = sum;
  }
}
void launch(int u, const Buffer& x, Buffer& y, int rows, int cols, int stride) {
  if (u == 1) {
    row_energy<1><<<(rows + 3) / 4, 128>>>(x.p, y.p, rows, cols, stride);
  } else {
    row_energy<4><<<(rows + 3) / 4, 128>>>(x.p, y.p, rows, cols, stride);
  }
  ck(cudaGetLastError());
}
template <int U>
void resource() {
  cudaFuncAttributes a{};
  ck(cudaFuncGetAttributes(&a, row_energy<U>));
  int blocks = 0;
  ck(cudaOccupancyMaxActiveBlocksPerMultiprocessor(&blocks, row_energy<U>, 128, 0));
  std::cout << "U=" << U << " registers=" << a.numRegs << " local_bytes=" << a.localSizeBytes
            << " shared_bytes=" << a.sharedSizeBytes << " max_active_blocks_per_SM=" << blocks
            << '\n';
}
int main(int argc, char** argv) {
  try {
    const int rows = argc > 1 ? std::stoi(argv[1]) : 4096;
    const int cols = argc > 2 ? std::stoi(argv[2]) : 4097;
    const int stride = cols + 3;
    const int only = argc > 3 ? std::stoi(argv[3]) : 0;
    validate(rows, cols, stride);
    if (only != 0 && only != 1 && only != 4) {
      throw std::invalid_argument("mode 0/1/4");
    }
    cudaDeviceProp prop{};
    ck(cudaGetDeviceProperties(&prop, 0));
    if (prop.major != 11 || prop.minor != 0) {
      throw std::runtime_error("Requires Thor SM110");
    }
    int driver = 0, runtime = 0;
    ck(cudaDriverGetVersion(&driver));
    ck(cudaRuntimeGetVersion(&runtime));
    std::cout << prop.name << " driver=" << driver << " runtime=" << runtime << '\n';
    resource<1>();
    resource<4>();
    auto x = input(rows, cols, stride);
    std::vector<float> y(rows);
    Buffer dx(x.size()), dy(y.size());
    ck(cudaMemcpy(dx.p, x.data(), x.size() * sizeof(float), cudaMemcpyHostToDevice));
    for (int u : {1, 4}) {
      if (only != 0 && only != u) {
        continue;
      }
      for (int i = 0; i < 10; ++i) {
        launch(u, dx, dy, rows, cols, stride);
      }
      ck(cudaDeviceSynchronize());
      Event begin, end;
      std::vector<float> samples;
      for (int s = 0; s < 21; ++s) {
        ck(cudaEventRecord(begin.e));
        for (int i = 0; i < 50; ++i) {
          launch(u, dx, dy, rows, cols, stride);
        }
        ck(cudaEventRecord(end.e));
        ck(cudaEventSynchronize(end.e));
        float ms = 0;
        ck(cudaEventElapsedTime(&ms, begin.e, end.e));
        samples.push_back(ms / 50);
      }
      ck(cudaMemcpy(y.data(), dy.p, y.size() * sizeof(float), cudaMemcpyDeviceToHost));
      for (int r = 0; r < rows; ++r) {
        check(y[r], reference(x.data() + static_cast<std::size_t>(r) * stride, cols));
      }
      std::sort(samples.begin(), samples.end());
      // 预分配H2D+kernel+D2H同步主机区间；不含数据生成/资源创建。
      std::vector<double> e2e;
      for (int i = 0; i < 24; ++i) {
        const auto t = std::chrono::steady_clock::now();
        ck(cudaMemcpy(dx.p, x.data(), x.size() * sizeof(float), cudaMemcpyHostToDevice));
        launch(u, dx, dy, rows, cols, stride);
        ck(cudaMemcpy(y.data(), dy.p, y.size() * sizeof(float), cudaMemcpyDeviceToHost));
        double ms =
            std::chrono::duration<double, std::milli>(std::chrono::steady_clock::now() - t).count();
        if (i >= 3) {
          e2e.push_back(ms);
        }
      }
      std::sort(e2e.begin(), e2e.end());
      std::cout << "PASS U=" << u << " GPU_batch_mean_P50_ms=" << samples[10]
                << " P95_ms=" << samples[19] << " transfer_kernel_host_P50_ms=" << e2e[10] << '\n';
    }
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
