#include <cuda_fp8.h>
#include <cuda_runtime.h>

#include <algorithm>
#include <cmath>
#include <cstdio>
#include <iostream>
#include <stdexcept>
#include <string>
#include <vector>
void ck(cudaError_t x) {
  if (x != cudaSuccess) {
    throw std::runtime_error(cudaGetErrorString(x));
  }
}
struct Device {
  void* p = nullptr;
  explicit Device(size_t n) {
    ck(cudaMalloc(&p, n));
  }
  ~Device() {
    if (p) {
      auto e = cudaFree(p);
      if (e != cudaSuccess) {
        std::fprintf(stderr, "cudaFree: %s\n", cudaGetErrorString(e));
      }
    }
  }
  Device(const Device&) = delete;
  Device& operator=(const Device&) = delete;
};
struct Event {
  cudaEvent_t e{};
  Event() {
    ck(cudaEventCreate(&e));
  }
  ~Event() {
    auto x = cudaEventDestroy(e);
    if (x != cudaSuccess) {
      std::fprintf(stderr, "event destroy: %s\n", cudaGetErrorString(x));
    }
  }
  Event(const Event&) = delete;
  Event& operator=(const Event&) = delete;
};
__device__ unsigned char encode(float x, float scale) {
  float y;
  // 真实手写PTX：乘法scale，不是反量化除法scale；SASS需目标编译后读取。
  asm("mul.rn.f32 %0, %1, %2;" : "=f"(y) : "f"(x), "f"(scale));
  return __nv_cvt_float_to_fp8(y, __NV_SATFINITE, __NV_E4M3);
}
__global__ void scalar_encode(const float* x, unsigned char* y, int n, float s) {
  int i = blockIdx.x * blockDim.x + threadIdx.x;
  if (i < n) {
    y[i] = encode(x[i], s);
  }
}
__global__ void vector_encode(const float* x, unsigned char* y, int n, float s) {
  int i = 4 * (blockIdx.x * blockDim.x + threadIdx.x);
  // cudaMalloc首地址对齐；仅完整float4才能向量加载，尾部逐项处理。
  if (i + 3 < n) {
    float4 v = reinterpret_cast<const float4*>(x)[i / 4];
    uchar4 q = make_uchar4(encode(v.x, s), encode(v.y, s), encode(v.z, s), encode(v.w, s));
    reinterpret_cast<uchar4*>(y)[i / 4] = q;
  } else {
    for (int j = i; j < n; ++j) {
      y[j] = encode(x[j], s);
    }
  }
}
void launch(bool optimized, const Device& x, Device& y, int n, float scale) {
  if (optimized) {
    vector_encode<<<(n + 1023) / 1024, 256>>>(
        static_cast<float*>(x.p), static_cast<unsigned char*>(y.p), n, scale);
  } else {
    scalar_encode<<<(n + 255) / 256, 256>>>(
        static_cast<float*>(x.p), static_cast<unsigned char*>(y.p), n, scale);
  }
  ck(cudaGetLastError());
}
int main(int argc, char** argv) {
  try {
    bool opt = argc == 2 && std::string(argv[1]) == "vector";
    if (argc != 2 || (!opt && std::string(argv[1]) != "scalar")) {
      throw std::invalid_argument("scalar|vector");
    }
    cudaDeviceProp prop{};
    ck(cudaGetDeviceProperties(&prop, 0));
    if (prop.major != 11 || prop.minor != 0) {
      throw std::runtime_error("requires Thor SM110");
    }
    // 小边界先验，最后大形状单独计时；两实现使用同一输入和scale。
    for (int n : {1, 3, 4, 17, 1023, 1024, 1025, 1048579}) {
      std::vector<float> input(n);
      std::vector<unsigned char> out(n), reference(n);
      for (int i = 0; i < n; ++i) {
        input[i] = float(i % 999 - 499) / 13;
      }
      float amax = 0;
      for (float v : input) {
        amax = std::max(amax, std::abs(v));
      }
      float scale = 448 / std::max(amax, 1e-12f);
      for (int i = 0; i < n; ++i) {
        reference[i] = __nv_cvt_float_to_fp8(input[i] * scale, __NV_SATFINITE, __NV_E4M3);
      }
      Device x(n * sizeof(float)), y(n);
      ck(cudaMemcpy(x.p, input.data(), n * sizeof(float), cudaMemcpyHostToDevice));
      launch(opt, x, y, n, scale);
      ck(cudaMemcpy(out.data(), y.p, n, cudaMemcpyDeviceToHost));
      if (out != reference) {
        throw std::runtime_error("FP8 bytes differ");
      }
      if (n == 1048579) {
        for (int j = 0; j < 20; ++j) {
          launch(opt, x, y, n, scale);
        }
        ck(cudaDeviceSynchronize());
        Event start, end;
        std::vector<float> ms;
        for (int j = 0; j < 51; ++j) {
          ck(cudaEventRecord(start.e));
          launch(opt, x, y, n, scale);
          ck(cudaEventRecord(end.e));
          ck(cudaEventSynchronize(end.e));
          float t = 0;
          ck(cudaEventElapsedTime(&t, start.e, end.e));
          ms.push_back(t);
        }
        std::sort(ms.begin(), ms.end());
        std::cout << "SM110 " << argv[1] << " kernel_ms p50=" << ms[25] << " p95=" << ms[48]
                  << " n=" << n << "\n";
      }
    }
    std::cout << "PASS 8 shapes host CUDA Math byte oracle\n";
    return 0;
  } catch (const std::exception& e) {
    std::cerr << e.what() << "\n";
    return 1;
  }
}
