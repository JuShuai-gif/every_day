#pragma once
#include <cuda_runtime.h>

#include <cstdio>
#include <stdexcept>
#include <string>
inline void ck(cudaError_t e, const char* what) {
  if (e != cudaSuccess) {
    throw std::runtime_error(std::string(what) + ": " + cudaGetErrorString(e));
  }
}
inline void cleanup(cudaError_t e) noexcept {
  if (e != cudaSuccess) {
    std::fprintf(stderr, "CUDA cleanup: %s\n", cudaGetErrorString(e));
  }
}
struct Stream {
  cudaStream_t s{};
  Stream() {
    ck(cudaStreamCreateWithFlags(&s, cudaStreamNonBlocking), "create stream");
  }
  ~Stream() {
    cleanup(cudaStreamSynchronize(s));
    cleanup(cudaStreamDestroy(s));
  }
  Stream(const Stream&) = delete;
};
struct Buffer {
  float* p{};
  explicit Buffer(int n) {
    ck(cudaMalloc(reinterpret_cast<void**>(&p), sizeof(float) * n), "malloc");
  }
  ~Buffer() {
    cleanup(cudaFree(p));
  }
  Buffer(const Buffer&) = delete;
};
struct Host {
  float* p{};
  explicit Host(int n) {
    ck(cudaMallocHost(reinterpret_cast<void**>(&p), sizeof(float) * n), "pinned alloc");
  }
  ~Host() {
    cleanup(cudaFreeHost(p));
  }
  Host(const Host&) = delete;
};
struct Drain {
  cudaStream_t s;
  ~Drain() {
    cleanup(cudaStreamSynchronize(s));
  }
};
struct Event {
  cudaEvent_t e{};
  Event() {
    ck(cudaEventCreate(&e), "event create");
  }
  ~Event() {
    cleanup(cudaEventDestroy(e));
  }
  Event(const Event&) = delete;
};
struct Graph {
  cudaGraph_t graph{};
  cudaGraphExec_t exec{};
  ~Graph() {
    if (exec) {
      cleanup(cudaGraphExecDestroy(exec));
    }
    if (graph) {
      cleanup(cudaGraphDestroy(graph));
    }
  }
  Graph() = default;
  Graph(const Graph&) = delete;
};
void launch_preprocess(const float*, float*, float*, int, bool, cudaStream_t);
