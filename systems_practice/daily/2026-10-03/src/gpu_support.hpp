#pragma once
#include <cuda_runtime.h>

#include <algorithm>
#include <chrono>
#include <cstdlib>
#include <iostream>
#include <stdexcept>
#include <vector>
inline void ck(cudaError_t e) {
  if (e != cudaSuccess) {
    throw std::runtime_error(cudaGetErrorString(e));
  }
}
inline void cleanup(cudaError_t e) {
  if (e != cudaSuccess) {
    std::cerr << "cleanup: " << cudaGetErrorString(e) << '\n';
    std::abort();
  }
}
template <class T>
struct Buffer {
  T* p = nullptr;
  explicit Buffer(std::size_t n) {
    ck(cudaMalloc(reinterpret_cast<void**>(&p), n * sizeof(T)));
  }
  ~Buffer() {
    if (p) {
      cleanup(cudaFree(p));
    }
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
inline void thor_only() {
  cudaDeviceProp p{};
  ck(cudaGetDeviceProperties(&p, 0));
  if (p.major != 11 || p.minor != 0) {
    throw std::runtime_error("requires Thor SM110");
  }
  std::cout << "GPU=" << p.name << " SM=" << p.multiProcessorCount
            << " maxThreadsPerSM=" << p.maxThreadsPerMultiProcessor << '\n';
}
// 热输入、单次kernel的event区间；逐次同步，不能称端到端请求时间。
template <class F>
void benchmark(F launch) {
  for (int i = 0; i < 20; ++i) {
    launch();
  }
  ck(cudaDeviceSynchronize());
  Event a, b;
  std::vector<float> t;
  for (int i = 0; i < 100; ++i) {
    ck(cudaEventRecord(a.e));
    launch();
    ck(cudaEventRecord(b.e));
    ck(cudaEventSynchronize(b.e));
    float ms = 0;
    ck(cudaEventElapsedTime(&ms, a.e, b.e));
    t.push_back(ms);
  }
  std::sort(t.begin(), t.end());
  std::cout << " kernel_p50_ms=" << t[50] << " kernel_p95_ms=" << t[94] << '\n';
}
// 明确写出的PTX源码，不是声称已生成的机器码；32个lane都要参与。
__device__ inline float shuffle_xor(float v, int delta) {
  float q;
  asm("shfl.sync.bfly.b32 %0, %1, %2, 31, -1;" : "=f"(q) : "f"(v), "r"(delta));
  return q;
}
__device__ inline float warp_sum(float v) {
  for (int d = 16; d > 0; d /= 2) {
    v += shuffle_xor(v, d);
  }
  return v;
}
