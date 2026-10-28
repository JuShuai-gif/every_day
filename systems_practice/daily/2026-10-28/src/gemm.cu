#include <cuda_runtime.h>

#include <cstdio>
#include <cstdlib>
// Thor SM110 目标：baseline 与 shared-tile 候选保持同一 FP32 语义。
#define CUDA_OK(x)                                                                        \
  do {                                                                                    \
    cudaError_t e = (x);                                                                  \
    if (e != cudaSuccess) {                                                               \
      std::fprintf(stderr, "CUDA %s:%d %s\n", __FILE__, __LINE__, cudaGetErrorString(e)); \
      return 2;                                                                           \
    }                                                                                     \
  } while (0)
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
  int M = 257, N = 193, K = 129;
  float *a, *b, *c;
  CUDA_OK(cudaMalloc(&a, M * K * 4));
  CUDA_OK(cudaMalloc(&b, K * N * 4));
  CUDA_OK(cudaMalloc(&c, M * N * 4));
  dim3 block(16, 16);
  baseline<<<(N + 15) / 16, (M + 15) / 16>>>(a, b, c, M, N, K);
  CUDA_OK(cudaGetLastError());
  CUDA_OK(cudaDeviceSynchronize());
  tiled<<<dim3((N + 15) / 16, (M + 15) / 16), block>>>(a, b, c, M, N, K);
  CUDA_OK(cudaGetLastError());
  CUDA_OK(cudaDeviceSynchronize());
  cudaFree(a);
  cudaFree(b);
  cudaFree(c);
  std::puts("thor_sm110_candidate_ok");
}
