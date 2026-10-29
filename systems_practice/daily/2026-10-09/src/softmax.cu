#include <cuda_runtime.h>
#include <math_constants.h>

#include <algorithm>
#include <cmath>
#include <cstdio>
#include <stdexcept>
#include <vector>

#define CUDA_CHECK(call)                               \
  do {                                                 \
    cudaError_t e = (call);                            \
    if (e != cudaSuccess)                              \
      throw std::runtime_error(cudaGetErrorString(e)); \
  } while (0)

// 正确性基线：一个线程串行处理一行，稳定性语义与优化版完全相同。
__global__ void softmax_baseline(const float* x, float* y, int rows, int cols) {
  const int row = blockIdx.x * blockDim.x + threadIdx.x;
  if (row >= rows)
    return;
  float maximum = -CUDART_INF_F;
  for (int c = 0; c < cols; ++c)
    maximum = fmaxf(maximum, x[row * cols + c]);
  float sum = 0.0F;
  for (int c = 0; c < cols; ++c)
    sum += expf(x[row * cols + c] - maximum);
  for (int c = 0; c < cols; ++c)
    y[row * cols + c] = expf(x[row * cols + c] - maximum) / sum;
}

// 优化候选：一个 warp 独占一行；寄存器保留输入，shuffle 只在 warp 内归约，不需要 block barrier。
__global__ void softmax_warp(const float* x, float* y, int rows, int cols) {
  const int lane = threadIdx.x & 31;
  const int row = (blockIdx.x * blockDim.x + threadIdx.x) / 32;
  if (row >= rows)
    return;
  float value[8];
  float maximum = -CUDART_INF_F;
#pragma unroll
  for (int item = 0; item < 8; ++item) {
    const int col = lane + 32 * item;
    value[item] = col < cols ? x[row * cols + col] : -CUDART_INF_F;
    maximum = fmaxf(maximum, value[item]);
  }
  for (int delta = 16; delta > 0; delta >>= 1)
    maximum = fmaxf(maximum, __shfl_xor_sync(0xffffffff, maximum, delta));
  float sum = 0.0F;
#pragma unroll
  for (int item = 0; item < 8; ++item) {
    value[item] = expf(value[item] - maximum);
    sum += value[item];
  }
  for (int delta = 16; delta > 0; delta >>= 1)
    sum += __shfl_xor_sync(0xffffffff, sum, delta);
#pragma unroll
  for (int item = 0; item < 8; ++item) {
    const int col = lane + 32 * item;
    if (col < cols)
      y[row * cols + col] = value[item] / sum;
  }
}

struct DeviceBuffer {
  float* ptr = nullptr;
  explicit DeviceBuffer(std::size_t count) {
    CUDA_CHECK(cudaMalloc(&ptr, count * sizeof(float)));
  }
  ~DeviceBuffer() {
    if (ptr)
      cudaFree(ptr);
  }
  DeviceBuffer(const DeviceBuffer&) = delete;
  DeviceBuffer& operator=(const DeviceBuffer&) = delete;
};

int main() {
  try {
    int device = 0;
    CUDA_CHECK(cudaGetDevice(&device));
    cudaDeviceProp prop{};
    CUDA_CHECK(cudaGetDeviceProperties(&prop, device));
    if (prop.major != 11 || prop.minor != 0)
      throw std::runtime_error("this lesson must execute on Thor SM110");
    int comparisons = 0;
    for (int rows : {1, 5, 1024}) {
      for (int cols : {1, 31, 32, 33, 127, 256}) {
        std::vector<float> host(rows * cols), expected(rows * cols), out(rows * cols);
        for (std::size_t i = 0; i < host.size(); ++i)
          host[i] = float(int(i % 73) - 36) * 0.25F;
        for (int r = 0; r < rows; ++r) {
          const auto begin = host.begin() + r * cols;
          const float maximum = *std::max_element(begin, begin + cols);
          double sum = 0;
          for (int c = 0; c < cols; ++c)
            sum += std::exp(double(host[r * cols + c] - maximum));
          for (int c = 0; c < cols; ++c)
            expected[r * cols + c] = float(std::exp(double(host[r * cols + c] - maximum)) / sum);
        }
        DeviceBuffer input(host.size()), output(host.size());
        CUDA_CHECK(cudaMemcpy(
            input.ptr, host.data(), host.size() * sizeof(float), cudaMemcpyHostToDevice));
        for (int variant = 0; variant < 2; ++variant) {
          if (variant == 0)
            softmax_baseline<<<(rows + 127) / 128, 128>>>(input.ptr, output.ptr, rows, cols);
          else
            softmax_warp<<<(rows + 3) / 4, 128>>>(input.ptr, output.ptr, rows, cols);
          CUDA_CHECK(cudaGetLastError());
          CUDA_CHECK(cudaMemcpy(
              out.data(), output.ptr, out.size() * sizeof(float), cudaMemcpyDeviceToHost));
          for (std::size_t i = 0; i < out.size(); ++i) {
            if (!std::isfinite(out[i]) || std::abs(out[i] - expected[i]) > 2e-6F)
              throw std::runtime_error("softmax numerical mismatch");
          }
          ++comparisons;
        }
      }
    }
    std::printf("PASS Thor SM110 softmax comparisons=%d rows=1,5,1024 cols=1,31,32,33,127,256\n",
                comparisons);
    return 0;
  } catch (const std::exception& e) {
    std::fprintf(stderr, "%s\n", e.what());
    return 1;
  }
}
