#include <chrono>
#include <iostream>

#include "cuda_raii.cuh"
#include "reference.hpp"
// 基线：一个线程处理一行，稳定 max/sum 语义与最终候选完全相同。
__global__ void softmax_serial(const float* x, float* y, int rows, int cols) {
  int r = blockIdx.x * blockDim.x + threadIdx.x;
  if (r >= rows) {
    return;
  }
  float m = -CUDART_INF_F;
  for (int c = 0; c < cols; ++c) {
    m = fmaxf(m, x[r * cols + c]);
  }
  float sum = 0;
  for (int c = 0; c < cols; ++c) {
    sum += expf(x[r * cols + c] - m);
  }
  for (int c = 0; c < cols; ++c) {
    y[r * cols + c] = expf(x[r * cols + c] - m) / sum;
  }
}
// 候选：一 warp 独占一行；8 个寄存器值覆盖最多 256 列。
__global__ void softmax_warp(const float* x, float* y, int rows, int cols) {
  unsigned lane;
  asm volatile("mov.u32 %0, %%laneid;" : "=r"(lane));  // 真实手写 PTX，非反汇编结果。
  int r = (blockIdx.x * blockDim.x + threadIdx.x) / 32;
  if (r >= rows) {
    return;
  }
  float v[8], m = -CUDART_INF_F;
#pragma unroll
  for (int k = 0; k < 8; ++k) {
    int c = lane + 32 * k;
    v[k] = c < cols ? x[r * cols + c] : -CUDART_INF_F;
    m = fmaxf(m, v[k]);
  }
  for (int d = 16; d > 0; d /= 2) {
    m = fmaxf(m, __shfl_xor_sync(0xffffffff, m, d));
  }
  float sum = 0;
#pragma unroll
  for (int k = 0; k < 8; ++k) {
    v[k] = expf(v[k] - m);
    sum += v[k];
  }
  for (int d = 16; d > 0; d /= 2) {
    sum += __shfl_xor_sync(0xffffffff, sum, d);
  }
#pragma unroll
  for (int k = 0; k < 8; ++k) {
    int c = lane + 32 * k;
    if (c < cols) {
      y[r * cols + c] = v[k] / sum;
    }
  }
}
void launch(bool optimized, const Device& x, Device& y, int r, int c, cudaStream_t s) {
  if (optimized) {
    softmax_warp<<<(r + 3) / 4, 128, 0, s>>>(x.p, y.p, r, c);
  } else {
    softmax_serial<<<(r + 127) / 128, 128, 0, s>>>(x.p, y.p, r, c);
  }
  ck(cudaGetLastError());
}
float percentile(std::vector<float> x, double q) {
  std::sort(x.begin(), x.end());
  return x[static_cast<std::size_t>(q * (x.size() - 1))];
}
int main() {
  try {
    require_thor();
    int cases = 0;
    for (int r : {1, 7, 33, 1024}) {
      for (int c : {1, 7, 31, 32, 33, 127, 255, 256}) {
        for (int p = 0; p < 3; ++p) {
          auto x = input(r, c, p);
          auto ref = softmax_reference(x, r, c);
          std::vector<float> y(x.size());
          Device dx(x.size()), dy(x.size());
          Stream stream;
          ck(cudaMemcpyAsync(
              dx.p, x.data(), x.size() * sizeof(float), cudaMemcpyHostToDevice, stream.s));
          for (bool opt : {false, true}) {
            ck(cudaMemsetAsync(dy.p, 0xff, x.size() * sizeof(float), stream.s));
            launch(opt, dx, dy, r, c, stream.s);
            ck(cudaMemcpyAsync(
                y.data(), dy.p, y.size() * sizeof(float), cudaMemcpyDeviceToHost, stream.s));
            ck(cudaStreamSynchronize(stream.s));
            verify(y, ref, c);
            ++cases;
          }
        }
      }
    }
    const int r = 1024, c = 127;
    auto x = input(r, c);
    std::vector<float> y(x.size());
    Device dx(x.size()), dy(x.size());
    Event a, b;
    Stream stream;
    ck(cudaMemcpyAsync(dx.p, x.data(), x.size() * sizeof(float), cudaMemcpyHostToDevice, stream.s));
    std::vector<float> kernel[2], e2e[2];
    for (int sample = -20; sample < 100; ++sample) {
      for (int j = 0; j < 2; ++j) {
        const int opt = (j + (sample + 20) % 2) % 2;
        ck(cudaEventRecord(a.e, stream.s));
        launch(opt, dx, dy, r, c, stream.s);
        ck(cudaEventRecord(b.e, stream.s));
        ck(cudaEventSynchronize(b.e));
        float ms;
        ck(cudaEventElapsedTime(&ms, a.e, b.e));
        auto start = std::chrono::steady_clock::now();
        ck(cudaMemcpyAsync(
            dx.p, x.data(), x.size() * sizeof(float), cudaMemcpyHostToDevice, stream.s));
        launch(opt, dx, dy, r, c, stream.s);
        ck(cudaMemcpyAsync(
            y.data(), dy.p, y.size() * sizeof(float), cudaMemcpyDeviceToHost, stream.s));
        ck(cudaStreamSynchronize(stream.s));
        float end =
            std::chrono::duration<float, std::milli>(std::chrono::steady_clock::now() - start)
                .count();
        verify(y, softmax_reference(x, r, c), c);
        if (sample >= 0) {
          kernel[opt].push_back(ms);
          e2e[opt].push_back(end);
        }
      }
    }
    std::cout << "GPU comparisons=" << cases << "; warmup=20 samples=100 rows=1024 cols=127 FP32\n";
    for (int opt = 0; opt < 2; ++opt) {
      std::cout << "optimized=" << opt << " kernel_ms_p50=" << percentile(kernel[opt], .5)
                << " p95=" << percentile(kernel[opt], .95)
                << " request_ms_p50=" << percentile(e2e[opt], .5)
                << " p95=" << percentile(e2e[opt], .95) << '\n';
    }
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
