#pragma once
#include <cuda_runtime.h>

#include <cstdio>
#include <stdexcept>
inline void ck(cudaError_t e) {
  if (e != cudaSuccess) {
    throw std::runtime_error(cudaGetErrorString(e));
  }
}
inline void cleanup(cudaError_t e) noexcept {
  if (e != cudaSuccess) {
    std::fprintf(stderr, "CUDA cleanup: %s\n", cudaGetErrorString(e));
    std::terminate();
  }
}
struct Stream {
  cudaStream_t s{};
  Stream() {
    ck(cudaStreamCreate(&s));
  }
  ~Stream() {
    cleanup(cudaStreamSynchronize(s));
    cleanup(cudaStreamDestroy(s));
  }
  Stream(const Stream&) = delete;
  Stream& operator=(const Stream&) = delete;
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
struct Device {
  float* p{};
  explicit Device(std::size_t n) {
    ck(cudaMalloc(reinterpret_cast<void**>(&p), n * sizeof(float)));
  }
  ~Device() {
    cleanup(cudaFree(p));
  }
  Device(const Device&) = delete;
  Device& operator=(const Device&) = delete;
};
inline void require_thor() {
  cudaDeviceProp p{};
  ck(cudaGetDeviceProperties(&p, 0));
  if (p.major != 11 || p.minor != 0) {
    throw std::runtime_error("requires Thor SM110");
  }
}
