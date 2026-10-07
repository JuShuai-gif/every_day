#include <cuda_runtime.h>

#include <algorithm>
#include <cmath>
#include <cstdint>
#include <iostream>
#include <stdexcept>
#include <vector>
void ck(cudaError_t e) {
  if (e != cudaSuccess) {
    throw std::runtime_error(cudaGetErrorString(e));
  }
}
void cleanup(cudaError_t e) noexcept {
  if (e != cudaSuccess) {
    std::cerr << "cleanup: " << cudaGetErrorString(e) << '\n';
  }
}
template <class T>
struct Device {
  T* p = nullptr;
  explicit Device(std::size_t n) {
    ck(cudaMalloc(reinterpret_cast<void**>(&p), n * sizeof(T)));
  }
  ~Device() {
    if (p) {
      cleanup(cudaFree(p));
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
    cleanup(cudaEventDestroy(e));
  }
  Event(const Event&) = delete;
  Event& operator=(const Event&) = delete;
};
__host__ __device__ float fp8(unsigned b) {
  int e = (b >> 3) & 15, m = b & 7;
  return e == 0 ? ldexpf(static_cast<float>(m), -9) : ldexpf(1.f + m / 8.f, e - 7);
}
__host__ __device__ float fp4(unsigned c) {
  const float lut[8] = {0, .5f, 1, 1.5f, 2, 3, 4, 6};
  return (c & 8) ? -lut[c & 7] : lut[c & 7];
}
// 手写PTX是真实源码，尚无本机nvcc生成物；基础位提取不依赖架构专属后缀。
__device__ unsigned nibble(unsigned b, unsigned offset) {
  unsigned result;
  asm("bfe.u32 %0, %1, %2, 4;" : "=r"(result) : "r"(b), "r"(offset));
  return result;
}
__global__ void decode_baseline(
    const unsigned char* p, const unsigned char* s, float g, float* y, int n) {
  int i = blockIdx.x * blockDim.x + threadIdx.x;
  if (i < n) {
    y[i] = fp4(nibble(p[i / 2], (i % 2) * 4)) * fp8(s[i / 16]) * g;
  }
}
__global__ void decode_pairs(
    const unsigned char* p, const unsigned char* s, float g, float* y, int n) {
  int byte = blockIdx.x * blockDim.x + threadIdx.x;
  int i = byte * 2;
  if (i < n) {
    // 一线程拥有一字节与两个输出，不跨16元素scale边界。
    unsigned v = p[byte];
    float scale = fp8(s[i / 16]) * g;
    y[i] = fp4(nibble(v, 0)) * scale;
    if (i + 1 < n) {
      y[i + 1] = fp4(nibble(v, 4)) * scale;
    }
  }
}
void launch(bool pairs,
            Device<unsigned char>& p,
            Device<unsigned char>& s,
            float g,
            Device<float>& y,
            int n) {
  if (n == 0) {
    return;
  }
  int count = pairs ? (n + 1) / 2 : n;
  if (pairs) {
    decode_pairs<<<(count + 255) / 256, 256>>>(p.p, s.p, g, y.p, n);
  } else {
    decode_baseline<<<(count + 255) / 256, 256>>>(p.p, s.p, g, y.p, n);
  }
  ck(cudaGetLastError());
}
void trial(int n, bool timing) {
  std::vector<unsigned char> p((n + 1) / 2), s((n + 15) / 16);
  for (std::size_t i = 0; i < p.size(); ++i) {
    p[i] = static_cast<unsigned char>(i * 37);
  }
  for (std::size_t i = 0; i < s.size(); ++i) {
    s[i] = static_cast<unsigned char>(1 + i % 126);
  }
  const float g = .125f;
  Device<unsigned char> dp(std::max<std::size_t>(1, p.size())),
      ds(std::max<std::size_t>(1, s.size()));
  Device<float> dy(std::max(1, n));
  if (n) {
    ck(cudaMemcpy(dp.p, p.data(), p.size(), cudaMemcpyHostToDevice));
    ck(cudaMemcpy(ds.p, s.data(), s.size(), cudaMemcpyHostToDevice));
  }
  std::vector<float> got(n);
  for (bool pairs : {false, true}) {
    launch(pairs, dp, ds, g, dy, n);
    ck(cudaDeviceSynchronize());
    if (n) {
      ck(cudaMemcpy(got.data(), dy.p, n * sizeof(float), cudaMemcpyDeviceToHost));
    }
    for (int i = 0; i < n; ++i) {
      float ref = fp4((p[i / 2] >> ((i % 2) * 4)) & 15) * fp8(s[i / 16]) * g;
      if (!std::isfinite(got[i]) || std::abs(ref - got[i]) > 1e-6f * std::max(1.f, std::abs(ref))) {
        throw std::runtime_error("decode mismatch");
      }
    }
    if (timing && n) {
      for (int i = 0; i < 10; ++i) {
        launch(pairs, dp, ds, g, dy, n);
      }
      ck(cudaDeviceSynchronize());
      std::vector<float> samples;
      Event start, stop;
      for (int sample = 0; sample < 21; ++sample) {
        ck(cudaEventRecord(start.e));
        for (int i = 0; i < 100; ++i) {
          launch(pairs, dp, ds, g, dy, n);
        }
        ck(cudaEventRecord(stop.e));
        ck(cudaEventSynchronize(stop.e));
        float ms = 0;
        ck(cudaEventElapsedTime(&ms, start.e, stop.e));
        samples.push_back(ms / 100);
      }
      std::sort(samples.begin(), samples.end());
      std::cout << (pairs ? "pairs" : "baseline") << " n=" << n
                << " GPU_event_batch_ms_p50=" << samples[10] << " p95=" << samples[19] << '\n';
    }
  }
}
int main(int argc, char**) {
  try {
    cudaDeviceProp prop{};
    ck(cudaGetDeviceProperties(&prop, 0));
    if (prop.major != 11 || prop.minor != 0) {
      throw std::runtime_error("Thor SM110 required");
    }
    // profile模式只有代表shape，便于准确控制launch-skip。
    if (argc > 1) {
      trial(1048577, true);
    } else {
      for (int n : {0, 1, 2, 15, 16, 17, 31, 32, 33, 255, 256, 257, 1048577}) {
        trial(n, n == 1048577);
      }
    }
    std::cout << "PASS SIMT NVFP4 decode; no Tensor Core GEMM\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
