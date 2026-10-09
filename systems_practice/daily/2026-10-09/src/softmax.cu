#include <cuda_runtime.h>

#include <cmath>
#include <cstdio>
#include <stdexcept>
#include <vector>

#define CUDA_CHECK(call) do { cudaError_t e = (call); if (e != cudaSuccess) throw std::runtime_error(cudaGetErrorString(e)); } while (0)

// 正确性基线：一个线程串行处理一行，稳定性语义与优化版完全相同。
__global__ void softmax_baseline(const float* x, float* y, int rows, int cols) {
  const int row = blockIdx.x * blockDim.x + threadIdx.x;
  if (row >= rows) return;
  float maximum = -CUDART_INF_F;
  for (int c = 0; c < cols; ++c) maximum = fmaxf(maximum, x[row * cols + c]);
  float sum = 0.0F;
  for (int c = 0; c < cols; ++c) sum += expf(x[row * cols + c] - maximum);
  for (int c = 0; c < cols; ++c) y[row * cols + c] = expf(x[row * cols + c] - maximum) / sum;
}

// 优化候选：一个 warp 独占一行；寄存器保留输入，shuffle 只在 warp 内归约，不需要 block barrier。
__global__ void softmax_warp(const float* x, float* y, int rows, int cols) {
  const int lane = threadIdx.x & 31;
  const int row = (blockIdx.x * blockDim.x + threadIdx.x) / 32;
  if (row >= rows) return;
  float value[8];
  float maximum = -CUDART_INF_F;
#pragma unroll
  for (int item = 0; item < 8; ++item) {
    const int col = lane + 32 * item;
    value[item] = col < cols ? x[row * cols + col] : -CUDART_INF_F;
    maximum = fmaxf(maximum, value[item]);
  }
  for (int delta = 16; delta > 0; delta >>= 1) maximum = fmaxf(maximum, __shfl_xor_sync(0xffffffff, maximum, delta));
  float sum = 0.0F;
#pragma unroll
  for (int item = 0; item < 8; ++item) { value[item] = expf(value[item] - maximum); sum += value[item]; }
  for (int delta = 16; delta > 0; delta >>= 1) sum += __shfl_xor_sync(0xffffffff, sum, delta);
#pragma unroll
  for (int item = 0; item < 8; ++item) { const int col = lane + 32 * item; if (col < cols) y[row * cols + col] = value[item] / sum; }
}

int main() {
  constexpr int rows = 1024, cols = 127;
  int device = 0;
  CUDA_CHECK(cudaGetDevice(&device));
  cudaDeviceProp prop{};
  CUDA_CHECK(cudaGetDeviceProperties(&prop, device));
  if (prop.major != 11 || prop.minor != 0) throw std::runtime_error("this lesson must execute on Thor SM110");
  std::vector<float> host(rows * cols, 0.1F), out(rows * cols);
  float *input = nullptr, *output = nullptr;
  CUDA_CHECK(cudaMalloc(&input, host.size() * sizeof(float)));
  CUDA_CHECK(cudaMalloc(&output, host.size() * sizeof(float)));
  CUDA_CHECK(cudaMemcpy(input, host.data(), host.size() * sizeof(float), cudaMemcpyHostToDevice));
  softmax_baseline<<<(rows + 127) / 128, 128>>>(input, output, rows, cols);
  CUDA_CHECK(cudaGetLastError());
  softmax_warp<<<(rows + 3) / 4, 128>>>(input, output, rows, cols);
  CUDA_CHECK(cudaGetLastError());
  CUDA_CHECK(cudaDeviceSynchronize());
  CUDA_CHECK(cudaFree(input));
  CUDA_CHECK(cudaFree(output));
  std::puts("Thor SM110 compile/run smoke test passed; add numerical and event timing capture before reporting performance.");
}
