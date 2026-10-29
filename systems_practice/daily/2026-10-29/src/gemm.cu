#include <cuda_fp16.h>
#include <cuda_runtime.h>

#include <algorithm>
#include <iostream>

#include "data.hpp"
#define CUDA(call) check_cuda((call), #call)
void check_cuda(cudaError_t s, const char *call) {
  if (s != cudaSuccess) {
    throw std::runtime_error(std::string(call) + ": " + cudaGetErrorString(s));
  }
}
void cleanup(cudaError_t s) {
  if (s != cudaSuccess) {
    std::cerr << "CUDA cleanup: " << cudaGetErrorString(s) << '\n';
  }
}
template <class T> struct Device {
  T *p = nullptr;
  explicit Device(std::size_t n) {
    CUDA(cudaMalloc(reinterpret_cast<void **>(&p),
                    std::max(n, std::size_t(1)) * sizeof(T)));
  }
  ~Device() { cleanup(cudaFree(p)); }
  Device(const Device &) = delete;
  Device &operator=(const Device &) = delete;
  void put(const std::vector<T> &v) {
    if (!v.empty()) {
      CUDA(cudaMemcpy(p, v.data(), v.size() * sizeof(T),
                      cudaMemcpyHostToDevice));
    }
  }
};
struct Event {
  cudaEvent_t p{};
  Event() { CUDA(cudaEventCreate(&p)); }
  ~Event() { cleanup(cudaEventDestroy(p)); }
  Event(const Event &) = delete;
};
__device__ int unpack(const unsigned char *p, int i, int bits) {
  if (bits == 4) {
    int value; // 手写PTX：从byte取有符号nibble，非反汇编产物。
    asm("bfe.s32 %0, %1, %2, 4;"
        : "=r"(value)
        : "r"(int(p[i / 2])), "r"((i % 2) * 4));
    return value;
  }
  int u = p[i];
  return u >= 128 ? u - 256 : u;
}
__device__ float fp16(const unsigned char *p, int i) {
  return __half2float(reinterpret_cast<const __half *>(p)[i]);
}
// 正确性基线：每个线程负责一个输出，直接读取真实packed字节，组内INT32累加。
__global__ void qgemm_baseline(const unsigned char *a, const unsigned char *w,
                               const float *sa, const float *sw, float *y,
                               int M, int N, int K, int WB, int AB) {
  int n = blockIdx.x * 16 + threadIdx.x, m = blockIdx.y * 16 + threadIdx.y,
      G = (K + 15) / 16;
  if (m >= M || n >= N) {
    return;
  }
  float out = 0;
  for (int g = 0; g < G; ++g) {
    int ii = 0;
    float ff = 0;
    for (int k = g * 16; k < K && k < (g + 1) * 16; ++k) {
      int qw = unpack(w, n * K + k, WB);
      if (AB == 16) {
        ff += fp16(a, m * K + k) * qw;
      } else {
        ii += unpack(a, m * K + k, AB) * qw;
      }
    }
    out += (AB == 16 ? ff : float(ii) * sa[m * G + g]) * sw[n * G + g];
  }
  y[m * N + n] = out;
}
// 最终候选：每个输入tile仅解码一次，16×16输出复用shared；尾部线程也必须到达屏障。
__global__ void qgemm_tiled(const unsigned char *a, const unsigned char *w,
                            const float *sa, const float *sw, float *y, int M,
                            int N, int K, int WB, int AB) {
  __shared__ int ai[16][16], wi[16][17];
  __shared__ float ah[16][16];
  int tx = threadIdx.x, ty = threadIdx.y, m = blockIdx.y * 16 + ty,
      n = blockIdx.x * 16 + tx, G = (K + 15) / 16;
  float out = 0;
  for (int g = 0; g < G; ++g) {
    int k = g * 16 + tx, wn = blockIdx.x * 16 + ty;
    wi[ty][tx] = (wn < N && k < K) ? unpack(w, wn * K + k, WB) : 0;
    if (AB == 16) {
      ah[ty][tx] = (m < M && k < K) ? fp16(a, m * K + k) : 0;
    } else {
      ai[ty][tx] = (m < M && k < K) ? unpack(a, m * K + k, AB) : 0;
    }
    __syncthreads();
    int ii = 0;
    float ff = 0;
#pragma unroll
    for (int j = 0; j < 16; ++j) {
      if (AB == 16) {
        ff += ah[ty][j] * wi[tx][j];
      } else {
        ii += ai[ty][j] * wi[tx][j];
      }
    }
    if (m < M && n < N) {
      out += (AB == 16 ? ff : float(ii) * sa[m * G + g]) * sw[n * G + g];
    }
    __syncthreads();
  }
  if (m < M && n < N) {
    y[m * N + n] = out;
  }
}
int main(int argc, char **argv) {
  try {
    if (argc != 3) {
      throw std::runtime_error("usage: gemm fixture baseline|tiled");
    }
    bool tiled = std::string(argv[2]) == "tiled";
    if (!tiled && std::string(argv[2]) != "baseline") {
      throw std::runtime_error("bad variant");
    }
    cudaDeviceProp prop{};
    CUDA(cudaGetDeviceProperties(&prop, 0));
    if (prop.major != 11 || prop.minor != 0) {
      throw std::runtime_error("requires Thor SM110");
    }
    auto d = read_data(argv[1]);
    Device<unsigned char> a(d.a.size()), w(d.w.size());
    Device<float> sa(d.sa.size()), sw(d.sw.size()), y(d.oracle.size());
    a.put(d.a);
    w.put(d.w);
    sa.put(d.sa);
    sw.put(d.sw);
    dim3 block(16, 16), grid((d.n() + 15) / 16, (d.m() + 15) / 16);
    auto launch = [&] {
      if (tiled) {
        qgemm_tiled<<<grid, block>>>(a.p, w.p, sa.p, sw.p, y.p, d.m(), d.n(),
                                     d.k(), d.wb(), d.ab());
      } else {
        qgemm_baseline<<<grid, block>>>(a.p, w.p, sa.p, sw.p, y.p, d.m(), d.n(),
                                        d.k(), d.wb(), d.ab());
      }
      CUDA(cudaGetLastError());
    };
    for (int i = 0; i < 10; ++i) {
      launch();
    }
    CUDA(cudaDeviceSynchronize());
    std::vector<float> out(d.oracle.size());
    CUDA(cudaMemcpy(out.data(), y.p, out.size() * sizeof(float),
                    cudaMemcpyDeviceToHost));
    compare(out, d.oracle);
    compare(out, reference(d));
    Event start, end;
    std::vector<float> ms;
    for (int i = 0; i < 50; ++i) {
      CUDA(cudaEventRecord(start.p));
      launch();
      CUDA(cudaEventRecord(end.p));
      CUDA(cudaEventSynchronize(end.p));
      float t = 0;
      CUDA(cudaEventElapsedTime(&t, start.p, end.p));
      ms.push_back(t);
    }
    std::sort(ms.begin(), ms.end());
    std::cout << "PASS SM110 " << argv[2] << " W" << d.wb() << "A" << d.ab()
              << " kernel_event_ms p50=" << ms[25] << " p95=" << ms[47]
              << " samples=50 warmup=10\n";
    return 0;
  } catch (const std::exception &e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
