#include <cuda_runtime.h>

#include <cmath>
#include <cstdio>
#include <stdexcept>
#include <vector>
// Thor SM110 目标：baseline 与 shared-tile 候选保持同一 FP32 语义。
void check_cuda(cudaError_t error) {
  if (error != cudaSuccess)
    throw std::runtime_error(cudaGetErrorString(error));
}
struct DeviceBuffer {
  float* ptr = nullptr;
  explicit DeviceBuffer(std::size_t n) {
    check_cuda(cudaMalloc(&ptr, n * sizeof(float)));
  }
  ~DeviceBuffer() {
    if (ptr)
      cudaFree(ptr);
  }
  DeviceBuffer(const DeviceBuffer&) = delete;
  DeviceBuffer& operator=(const DeviceBuffer&) = delete;
};
__global__ void baseline(const float* A, const float* B, float* C, int M, int N, int K) {
  int row = blockIdx.y * blockDim.y + threadIdx.y, col = blockIdx.x * blockDim.x + threadIdx.x;
  if (row >= M || col >= N)
    return;
  float s = 0;
  for (int k = 0; k < K; ++k)
    s = fmaf(A[row * K + k], B[k * N + col], s);
  C[row * N + col] = s;
}
__global__ void tiled(const float* A, const float* B, float* C, int M, int N, int K) {
  __shared__ float As[16][16], Bs[16][16];
  int row = blockIdx.y * 16 + threadIdx.y, col = blockIdx.x * 16 + threadIdx.x;
  float s = 0;
  for (int t = 0; t < (K + 15) / 16; ++t) {
    int ak = t * 16 + threadIdx.x, bk = t * 16 + threadIdx.y;
    As[threadIdx.y][threadIdx.x] = (row < M && ak < K) ? A[row * K + ak] : 0;
    Bs[threadIdx.y][threadIdx.x] = (bk < K && col < N) ? B[bk * N + col] : 0;
    __syncthreads();
    for (int j = 0; j < 16; ++j)
      s = fmaf(As[threadIdx.y][j], Bs[j][threadIdx.x], s);
    __syncthreads();
  }
  if (row < M && col < N)
    C[row * N + col] = s;
}
int main() {
  try {
    int device = 0;
    check_cuda(cudaGetDevice(&device));
    cudaDeviceProp prop{};
    check_cuda(cudaGetDeviceProperties(&prop, device));
    if (prop.major != 11 || prop.minor != 0)
      throw std::runtime_error("requires Thor SM110");
    int comparisons = 0;
    for (const auto shape : {std::vector<int>{3, 5, 7}, std::vector<int>{257, 193, 129}}) {
      const int M = shape[0], N = shape[1], K = shape[2];
      std::vector<float> a(M * K), b(K * N), reference(M * N), output(M * N);
      for (std::size_t i = 0; i < a.size(); ++i)
        a[i] = float(int(i % 17) - 8) / 16;
      for (std::size_t i = 0; i < b.size(); ++i)
        b[i] = float(int(i % 13) - 6) / 16;
      for (int m = 0; m < M; ++m)
        for (int n = 0; n < N; ++n)
          for (int k = 0; k < K; ++k)
            reference[m * N + n] = std::fma(a[m * K + k], b[k * N + n], reference[m * N + n]);
      DeviceBuffer da(a.size()), db(b.size()), dc(output.size());
      check_cuda(cudaMemcpy(da.ptr, a.data(), a.size() * sizeof(float), cudaMemcpyHostToDevice));
      check_cuda(cudaMemcpy(db.ptr, b.data(), b.size() * sizeof(float), cudaMemcpyHostToDevice));
      const dim3 block(16, 16), grid((N + 15) / 16, (M + 15) / 16);
      for (int variant = 0; variant < 2; ++variant) {
        check_cuda(cudaMemset(dc.ptr, 0xff, output.size() * sizeof(float)));
        if (variant == 0)
          baseline<<<grid, block>>>(da.ptr, db.ptr, dc.ptr, M, N, K);
        else
          tiled<<<grid, block>>>(da.ptr, db.ptr, dc.ptr, M, N, K);
        check_cuda(cudaGetLastError());
        check_cuda(cudaMemcpy(
            output.data(), dc.ptr, output.size() * sizeof(float), cudaMemcpyDeviceToHost));
        for (std::size_t i = 0; i < output.size(); ++i)
          if (!std::isfinite(output[i]) ||
              std::abs(output[i] - reference[i]) > 1e-4F * (1 + std::abs(reference[i])))
            throw std::runtime_error("GEMM numerical mismatch");
        ++comparisons;
      }
    }
    std::printf("PASS Thor SM110 GEMM comparisons=%d tail_shapes=3x5x7,257x193x129\n", comparisons);
    return 0;
  } catch (const std::exception& e) {
    std::fprintf(stderr, "%s\n", e.what());
    return 1;
  }
}
