#include <cuda_profiler_api.h>
#include <cuda_runtime.h>

#include <algorithm>
#include <cmath>
#include <cstdint>
#include <iostream>
#include <stdexcept>
#include <string>
#include <vector>
#if defined(__CUDA_ARCH__) && __CUDA_ARCH__ != 1100
#error "Only Thor SM110 is permitted"
#endif
void ck(cudaError_t s) {
  if (s != cudaSuccess) {
    throw std::runtime_error(cudaGetErrorString(s));
  }
}
template <class T>
struct Device {
  T* p = nullptr;
  explicit Device(std::size_t n) {
    ck(cudaMalloc(reinterpret_cast<void**>(&p), std::max(n, std::size_t(1)) * sizeof(T)));
  }
  Device(const Device&) = delete;
  Device& operator=(const Device&) = delete;
  ~Device() {
    if (p) {
      auto e = cudaFree(p);
      if (e != cudaSuccess) {
        std::cerr << "cudaFree: " << cudaGetErrorString(e) << '\n';
      }
    }
  }
};
struct Event {
  cudaEvent_t e{};
  Event() {
    ck(cudaEventCreate(&e));
  }
  ~Event() {
    auto s = cudaEventDestroy(e);
    if (s != cudaSuccess) {
      std::cerr << cudaGetErrorString(s) << '\n';
    }
  }
  Event(const Event&) = delete;
};
__device__ std::int8_t encode(float x, float scale) {
  if (scale == 0) {
    return 0;
  }
  float normalized = x / scale;
  int rounded;
  // 手写PTX，舍入到偶数；并非编译器输出或SASS。
  asm("cvt.rni.s32.f32 %0, %1;" : "=r"(rounded) : "f"(normalized));
  return static_cast<std::int8_t>(max(-127, min(127, rounded)));
}
// 基线每个输出元素重读本块256项；数学语义相同但冗余访存/指令多。
__global__ void codec_baseline(const float* x, std::int8_t* q, float* scales, int n) {
  int i = blockIdx.x * 256 + threadIdx.x;
  if (i >= n) {
    return;
  }
  int base = (i / 256) * 256;
  float a = 0;
  for (int j = base; j < min(base + 256, n); ++j) {
    a = fmaxf(a, fabsf(x[j]));
  }
  float scale = a / 127.0f;
  if (threadIdx.x == 0) {
    scales[blockIdx.x] = scale;
  }
  q[i] = encode(x[i], scale);
}
// 最终候选每元素一次读取，CTA树归约；尾线程参加所有barrier。
__global__ void codec_optimized(const float* x, std::int8_t* q, float* scales, int n) {
  __shared__ float reduction[256];
  int t = threadIdx.x, i = blockIdx.x * 256 + t;
  float value = i < n ? x[i] : 0;
  reduction[t] = fabsf(value);
  __syncthreads();
  for (int s = 128; s > 0; s /= 2) {
    if (t < s) {
      reduction[t] = fmaxf(reduction[t], reduction[t + s]);
    }
    __syncthreads();
  }
  float scale = reduction[0] / 127.0f;
  if (t == 0) {
    scales[blockIdx.x] = scale;
  }
  if (i < n) {
    q[i] = encode(value, scale);
  }
}
void launch(int variant, const float* x, std::int8_t* q, float* scales, int n) {
  if (!n) {
    return;
  }
  int blocks = (n + 255) / 256;
  if (variant == 0) {
    codec_baseline<<<blocks, 256>>>(x, q, scales, n);
  } else {
    codec_optimized<<<blocks, 256>>>(x, q, scales, n);
  }
  ck(cudaGetLastError());
}
void test(int n, bool zero = false) {
  std::vector<float> x(n);
  for (int i = 0; i < n; ++i) {
    x[i] = zero ? 0 : float((i % 251) - 125) * .125f;
  }
  const int blocks = (n + 255) / 256;
  Device<float> dx(n), ds(blocks);
  Device<std::int8_t> dq(n);
  if (n) {
    ck(cudaMemcpy(dx.p, x.data(), n * sizeof(float), cudaMemcpyHostToDevice));
  }
  std::vector<std::int8_t> baseline;
  for (int variant = 0; variant < 2; ++variant) {
    if (n) {
      ck(cudaMemset(dq.p, 0x80, n));
    }
    launch(variant, dx.p, dq.p, ds.p, n);
    ck(cudaDeviceSynchronize());
    std::vector<std::int8_t> q(n);
    std::vector<float> s(blocks);
    if (n) {
      ck(cudaMemcpy(q.data(), dq.p, n, cudaMemcpyDeviceToHost));
      ck(cudaMemcpy(s.data(), ds.p, blocks * sizeof(float), cudaMemcpyDeviceToHost));
    }
    if (variant == 0) {
      baseline = q;
    } else if (q != baseline) {
      throw std::runtime_error("variant code mismatch");
    }
    for (int b = 0; b < blocks; ++b) {
      float a = 0;
      for (int i = b * 256; i < std::min(n, (b + 1) * 256); ++i) {
        a = std::max(a, std::abs(x[i]));
      }
      if (s[b] != a / 127.0f) {
        throw std::runtime_error("scale mismatch");
      }
      for (int i = b * 256; i < std::min(n, (b + 1) * 256); ++i) {
        float recovered = float(q[i]) * s[b];
        if (q[i] == -128 || std::abs(recovered - x[i]) > s[b] * .501f + 1e-6f) {
          throw std::runtime_error("codec error");
        }
      }
    }
  }
}
int main(int argc, char** argv) {
  try {
    cudaDeviceProp prop{};
    ck(cudaGetDeviceProperties(&prop, 0));
    if (prop.major != 11 || prop.minor != 0) {
      throw std::runtime_error("requires Thor SM110");
    }
    for (int n : {0, 1, 255, 256, 257, 4099}) {
      test(n);
      test(n, true);
    }
    int variant = 1;
    if (argc == 3 && std::string(argv[1]) == "--profile") {
      variant = std::stoi(argv[2]);
      if (variant < 0 || variant > 1) {
        throw std::invalid_argument("variant");
      }
    } else if (argc != 1) {
      throw std::invalid_argument("usage: codec [--profile 0|1]");
    }
    const int n = 65539;
    std::vector<float> x(n, .125f);
    Device<float> dx(n), ds((n + 255) / 256);
    Device<std::int8_t> dq(n);
    ck(cudaMemcpy(dx.p, x.data(), n * sizeof(float), cudaMemcpyHostToDevice));
    for (int j = 0; j < 20; ++j) {
      launch(variant, dx.p, dq.p, ds.p, n);
    }
    ck(cudaDeviceSynchronize());
    if (argc == 3) {
      ck(cudaProfilerStart());
      launch(variant, dx.p, dq.p, ds.p, n);
      ck(cudaDeviceSynchronize());
      ck(cudaProfilerStop());
    } else {
      Event begin, end;
      for (int v = 0; v < 2; ++v) {
        for (int j = 0; j < 20; ++j) {
          launch(v, dx.p, dq.p, ds.p, n);
        }
        ck(cudaDeviceSynchronize());
        std::vector<float> ms;
        for (int j = 0; j < 101; ++j) {
          ck(cudaEventRecord(begin.e));
          launch(v, dx.p, dq.p, ds.p, n);
          ck(cudaEventRecord(end.e));
          ck(cudaEventSynchronize(end.e));
          float t = 0;
          ck(cudaEventElapsedTime(&t, begin.e, end.e));
          ms.push_back(t);
        }
        std::sort(ms.begin(), ms.end());
        std::cout << "variant=" << v << " device_kernel_ms_p50=" << ms[50] << " p95=" << ms[95]
                  << '\n';
      }
    }
    std::cout
        << "PASS 24 boundary/zero variant tests; uniform signed codec only, not native bnb Adam\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
