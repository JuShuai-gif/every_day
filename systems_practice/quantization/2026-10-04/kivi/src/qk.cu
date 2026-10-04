#include <cuda_profiler_api.h>
#include <cuda_runtime.h>

#include <algorithm>
#include <iostream>
#include <string>

#include "qk.hpp"
#if defined(__CUDA_ARCH__) && __CUDA_ARCH__ != 1100
#error "Thor SM110 only"
#endif
void ck(cudaError_t e) {
  if (e != cudaSuccess) {
    throw std::runtime_error(cudaGetErrorString(e));
  }
}
void cleanup(cudaError_t e) {
  if (e != cudaSuccess) {
    std::cerr << "cleanup: " << cudaGetErrorString(e) << '\n';
  }
}
template <class T>
struct Buffer {
  T* p = nullptr;
  explicit Buffer(std::size_t n) {
    ck(cudaMalloc(reinterpret_cast<void**>(&p), n * sizeof(T)));
  }
  ~Buffer() {
    cleanup(cudaFree(p));
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
__device__ float decode(const unsigned* code, const float* s, const float* m, int x, int j, int d) {
  unsigned bits;
  unsigned shift = 2 * (x % 16);
  // 实际inline PTX候选：抽取无符号2位；并非已生成的SASS。
  asm("bfe.u32 %0, %1, %2, 2;" : "=r"(bits) : "r"(code[(x / 16) * d + j]), "r"(shift));
  return bits * s[(x / 32) * d + j] + m[(x / 32) * d + j];
}
__global__ void qk_base(
    const unsigned* c, const float* s, const float* m, const float* q, float* y, int t, int d) {
  int x = blockIdx.x * blockDim.x + threadIdx.x;
  if (x < t) {
    float sum = 0;
    for (int j = 0; j < d; ++j) {
      sum += q[j] * decode(c, s, m, x, j, d);
    }
    y[x] = sum;
  }
}
__global__ void qk_warp(
    const unsigned* c, const float* s, const float* m, const float* q, float* y, int t, int d) {
  int lane = threadIdx.x % 32, x = (blockIdx.x * blockDim.x + threadIdx.x) / 32;
  if (x >= t) {
    return;
  }  // 同一warp一致退出，其余warp全部32lane参与。
  float sum = 0;
  for (int j = lane; j < d; j += 32) {
    sum += q[j] * decode(c, s, m, x, j, d);
  }
  for (int delta = 16; delta; delta /= 2) {
    sum += __shfl_down_sync(0xffffffffU, sum, delta);
  }
  if (lane == 0) {
    y[x] = sum;
  }
}
int main(int argc, char** argv) {
  try {
    std::string mode = argc == 2 ? argv[1] : "all";
    if (mode != "all" && mode != "base" && mode != "warp") {
      throw std::invalid_argument("all|base|warp");
    }
    cudaDeviceProp prop{};
    ck(cudaGetDeviceProperties(&prop, 0));
    if (prop.major != 11 || prop.minor != 0) {
      throw std::runtime_error("requires Thor SM110");
    }
    for (auto shape : {std::pair<int, int>{1, 1}, {17, 17}, {33, 65}, {1024, 128}}) {
      if (mode != "all" && shape.first != 1024) {
        continue;
      }
      Data a(shape.first, shape.second);
      Buffer<unsigned> c(a.code.size());
      Buffer<float> s(a.scale.size()), m(a.mn.size()), q(a.q.size()), y(a.t);
      ck(cudaMemcpy(c.p, a.code.data(), a.code.size() * 4, cudaMemcpyHostToDevice));
      ck(cudaMemcpy(s.p, a.scale.data(), a.scale.size() * 4, cudaMemcpyHostToDevice));
      ck(cudaMemcpy(m.p, a.mn.data(), a.mn.size() * 4, cudaMemcpyHostToDevice));
      ck(cudaMemcpy(q.p, a.q.data(), a.q.size() * 4, cudaMemcpyHostToDevice));
      for (int variant = 0; variant < 2; ++variant) {
        if ((mode == "base" && variant == 1) || (mode == "warp" && variant == 0)) {
          continue;
        }
        auto launch = [&] {
          if (variant == 0) {
            qk_base<<<(a.t + 127) / 128, 128>>>(c.p, s.p, m.p, q.p, y.p, a.t, a.d);
          } else {
            qk_warp<<<(a.t + 3) / 4, 128>>>(c.p, s.p, m.p, q.p, y.p, a.t, a.d);
          }
          ck(cudaGetLastError());
        };
        ck(cudaMemset(y.p, 0xff, a.t * 4));
        launch();
        ck(cudaDeviceSynchronize());
        std::vector<float> out(a.t);
        ck(cudaMemcpy(out.data(), y.p, a.t * 4, cudaMemcpyDeviceToHost));
        for (int x = 0; x < a.t; ++x) {
          double ref = a.reference(x);
          if (!std::isfinite(out[x]) || std::abs(out[x] - ref) > 1e-4 + 1e-4 * std::abs(ref)) {
            throw std::runtime_error("GPU correctness");
          }
        }
        for (int i = 0; i < 20; ++i) {
          launch();
        }
        ck(cudaDeviceSynchronize());
        if (mode != "all") {
          ck(cudaProfilerStart());
          launch();
          ck(cudaDeviceSynchronize());
          ck(cudaProfilerStop());
        } else {
          Event begin, end;
          std::vector<float> times;
          for (int i = 0; i < 100; ++i) {
            ck(cudaEventRecord(begin.e));
            launch();
            ck(cudaEventRecord(end.e));
            ck(cudaEventSynchronize(end.e));
            float ms;
            ck(cudaEventElapsedTime(&ms, begin.e, end.e));
            times.push_back(ms);
          }
          std::sort(times.begin(), times.end());
          std::cout << "T=" << a.t << " D=" << a.d << " variant=" << variant
                    << " GPU kernel ms P50=" << times[50] << " P95=" << times[95] << '\n';
        }
      }
    }
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
