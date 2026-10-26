#include "cuda_raii.hpp"
// 基线写入中间张量；输入范围/常数使两条路径数学语义一致。
__global__ void scale_baseline(const float* x, float* tmp, int n) {
  int i = int(blockIdx.x * blockDim.x + threadIdx.x);
  if (i < n) {
    tmp[i] = x[i] * 0.5f;
  }
}
__global__ void bias_baseline(const float* tmp, float* y, int n) {
  int i = int(blockIdx.x * blockDim.x + threadIdx.x);
  if (i < n) {
    y[i] = tmp[i] + 0.25f;
  }
}
__device__ float affine(float x) {
  float y;
  // 真实手写PTX，非编译结果。sm_110构建后检查最终SASS。
  asm("fma.rn.f32 %0, %1, %2, %3;" : "=f"(y) : "f"(x), "f"(0.5f), "f"(0.25f));
  return y;
}
__global__ void affine_fused4(const float* x, float* y, int n) {
  int i = 4 * int(blockIdx.x * blockDim.x + threadIdx.x);
  // cudaMalloc起点满足16字节对齐；末尾不足4元素时不越界读取。
  if (i + 3 < n) {
    float4 a = reinterpret_cast<const float4*>(x)[i / 4];
    float4 b{affine(a.x), affine(a.y), affine(a.z), affine(a.w)};
    reinterpret_cast<float4*>(y)[i / 4] = b;
  } else {
    for (int j = i; j < n; ++j) {
      y[j] = affine(x[j]);
    }
  }
}
void launch_preprocess(const float* x, float* tmp, float* y, int n, bool fused, cudaStream_t s) {
  if (fused) {
    affine_fused4<<<(n + 1023) / 1024, 256, 0, s>>>(x, y, n);
    ck(cudaGetLastError(), "fused launch");
  } else {
    scale_baseline<<<(n + 255) / 256, 256, 0, s>>>(x, tmp, n);
    ck(cudaGetLastError(), "scale launch");
    bias_baseline<<<(n + 255) / 256, 256, 0, s>>>(tmp, y, n);
    ck(cudaGetLastError(), "bias launch");
  }
}
