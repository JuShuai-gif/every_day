#pragma once
#include <cuda_runtime.h>

#include <cstdio>
#include <stdexcept>
#include <string>
inline void cuda_check(cudaError_t e, const char* operation) {
  if (e != cudaSuccess) {
    throw std::runtime_error(std::string(operation) + ": " + cudaGetErrorString(e));
  }
}
inline void cleanup(cudaError_t e) noexcept {
  if (e != cudaSuccess) {
    std::fprintf(stderr, "CUDA cleanup: %s\n", cudaGetErrorString(e));
  }
}
struct Stream {
  cudaStream_t value{};
  Stream() {
    cuda_check(cudaStreamCreate(&value), "stream create");
  }
  ~Stream() {
    cleanup(cudaStreamSynchronize(value));
    cleanup(cudaStreamDestroy(value));
  }
  Stream(const Stream&) = delete;
  Stream& operator=(const Stream&) = delete;
};
struct Buffer {
  void* value{};
  explicit Buffer(std::size_t n) {
    cuda_check(cudaMalloc(&value, n), "malloc");
  }
  ~Buffer() {
    cleanup(cudaFree(value));
  }
  Buffer(const Buffer&) = delete;
  Buffer& operator=(const Buffer&) = delete;
  float* data() const {
    return static_cast<float*>(value);
  }
};
struct Event {
  cudaEvent_t value{};
  Event() {
    cuda_check(cudaEventCreate(&value), "event create");
  }
  ~Event() {
    cleanup(cudaEventDestroy(value));
  }
  Event(const Event&) = delete;
  Event& operator=(const Event&) = delete;
};
// 最后构造此守卫，确保异常展开时先排空，再释放设备缓冲区/执行上下文。
struct Drain {
  cudaStream_t value;
  ~Drain() {
    cleanup(cudaStreamSynchronize(value));
  }
};
inline void require_thor() {
  int device = 0;
  cuda_check(cudaGetDevice(&device), "get device");
  cudaDeviceProp p{};
  cuda_check(cudaGetDeviceProperties(&p, device), "device properties");
  if (p.major != 11 || p.minor != 0) {
    throw std::runtime_error("requires Thor SM110");
  }
  std::printf("device=%s cc=%d.%d\n", p.name, p.major, p.minor);
}
