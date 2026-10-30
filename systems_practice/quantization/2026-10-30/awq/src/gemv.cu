#include <cuda_fp16.h>
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
struct Buffer {
  void* p = nullptr;
  explicit Buffer(std::size_t n) {
    ck(cudaMalloc(&p, std::max(n, std::size_t(1))));
  }
  ~Buffer() {
    if (p) {
      auto e = cudaFree(p);
      if (e != cudaSuccess) {
        std::cerr << cudaGetErrorString(e) << '\n';
      }
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
    auto s = cudaEventDestroy(e);
    if (s != cudaSuccess) {
      std::cerr << cudaGetErrorString(s) << '\n';
    }
  }
  Event(const Event&) = delete;
  Event& operator=(const Event&) = delete;
};
// 独立格式：W[N,K]连续nibble，offset8，group32；与WQLinear交错布局不同。
__device__ float weight(const unsigned char* w, const float* scales, int n, int k, int K) {
  const int index = n * K + k;
  unsigned q;
  const unsigned byte = w[index / 2], shift = (index & 1) * 4;
  asm("bfe.u32 %0, %1, %2, 4;" : "=r"(q) : "r"(byte), "r"(shift));
  return (static_cast<int>(q) - 8) * scales[n * ((K + 31) / 32) + k / 32];
}
__global__ void gemv_baseline(
    const half* x, const unsigned char* w, const float* s, float* y, int M, int N, int K) {
  const int row = blockIdx.x * blockDim.x + threadIdx.x;
  if (row >= M * N) {
    return;
  }
  const int m = row / N, n = row % N;
  float sum = 0;
  for (int k = 0; k < K; ++k) {
    sum = fmaf(__half2float(x[m * K + k]), weight(w, s, n, k, K), sum);
  }
  y[row] = sum;
}
__global__ void gemv_warp(
    const half* x, const unsigned char* w, const float* s, float* y, int M, int N, int K) {
  const int row = blockIdx.x * 4 + threadIdx.x / 32, lane = threadIdx.x % 32;
  if (row >= M * N) {
    return;
  }  // 同warp一致退出；活跃warp所有lane参与shuffle。
  const int m = row / N, n = row % N;
  float sum = 0;
  for (int k = lane; k < K; k += 32) {
    sum = fmaf(__half2float(x[m * K + k]), weight(w, s, n, k, K), sum);
  }
  for (int delta = 16; delta > 0; delta /= 2) {
    sum += __shfl_down_sync(0xffffffff, sum, delta);
  }
  if (lane == 0) {
    y[row] = sum;
  }
}
void run(int M, int N, int K, bool benchmark) {
  const int groups = (K + 31) / 32;
  std::vector<half> x(M * K);
  std::vector<unsigned char> w((N * K + 1) / 2, 0x88);
  std::vector<float> s(N * groups), ref(M * N), got(M * N);
  for (int i = 0; i < M * K; ++i) {
    x[i] = __float2half(float(i % 17 - 8) / 16);
  }
  for (int i = 0; i < N * groups; ++i) {
    s[i] = float(i % 7 + 1) / 32;
  }
  for (int i = 0; i < N * K; ++i) {
    const unsigned q = unsigned(i % 15 + 1);
    w[i / 2] = (w[i / 2] & ~(15u << ((i & 1) * 4))) | (q << ((i & 1) * 4));
  }
  for (int m = 0; m < M; ++m) {
    for (int n = 0; n < N; ++n) {
      double sum = 0;
      for (int k = 0; k < K; ++k) {
        const int i = n * K + k, q = ((w[i / 2] >> ((i & 1) * 4)) & 15) - 8;
        sum += double(__half2float(x[m * K + k])) * q * s[n * groups + k / 32];
      }
      ref[m * N + n] = static_cast<float>(sum);
    }
  }
  Buffer dx(x.size() * sizeof(half)), dw(w.size()), ds(s.size() * 4), dy(got.size() * 4);
  if (!x.empty()) {
    ck(cudaMemcpy(dx.p, x.data(), x.size() * sizeof(half), cudaMemcpyHostToDevice));
  }
  if (!w.empty()) {
    ck(cudaMemcpy(dw.p, w.data(), w.size(), cudaMemcpyHostToDevice));
  }
  if (!s.empty()) {
    ck(cudaMemcpy(ds.p, s.data(), s.size() * 4, cudaMemcpyHostToDevice));
  }
  auto launch = [&](int mode) {
    if (M * N == 0) {
      return;
    }
    if (mode == 0) {
      gemv_baseline<<<(M * N + 127) / 128, 128>>>(static_cast<half*>(dx.p),
                                                  static_cast<unsigned char*>(dw.p),
                                                  static_cast<float*>(ds.p),
                                                  static_cast<float*>(dy.p),
                                                  M,
                                                  N,
                                                  K);
    } else {
      gemv_warp<<<(M * N + 3) / 4, 128>>>(static_cast<half*>(dx.p),
                                          static_cast<unsigned char*>(dw.p),
                                          static_cast<float*>(ds.p),
                                          static_cast<float*>(dy.p),
                                          M,
                                          N,
                                          K);
    }
    ck(cudaGetLastError());
  };
  for (int mode = 0; mode < 2; ++mode) {
    launch(mode);
    ck(cudaDeviceSynchronize());
    if (!got.empty()) {
      ck(cudaMemcpy(got.data(), dy.p, got.size() * 4, cudaMemcpyDeviceToHost));
    }
    for (std::size_t i = 0; i < got.size(); ++i) {
      if (!std::isfinite(got[i]) || std::abs(got[i] - ref[i]) > 1e-4f * (1 + std::abs(ref[i]))) {
        throw std::runtime_error("GPU correctness");
      }
    }
    if (benchmark && M * N) {
      for (int warm = 0; warm < 10; ++warm) {
        launch(mode);
      }
      ck(cudaDeviceSynchronize());
      std::vector<float> samples;
      Event start, end;
      for (int sample = 0; sample < 21; ++sample) {
        ck(cudaEventRecord(start.e));
        for (int r = 0; r < 100; ++r) {
          launch(mode);
        }
        ck(cudaEventRecord(end.e));
        ck(cudaEventSynchronize(end.e));
        float ms = 0;
        ck(cudaEventElapsedTime(&ms, start.e, end.e));
        samples.push_back(ms / 100);
      }
      std::sort(samples.begin(), samples.end());
      std::cout << (mode == 0 ? "baseline" : "warp_candidate")
                << " GPU_kernel_batch_mean_ms P50=" << samples[10] << " P95=" << samples[19]
                << '\n';
    }
  }
}
int main(int argc, char**) {
  try {
    cudaDeviceProp prop{};
    ck(cudaGetDeviceProperties(&prop, 0));
    if (prop.major != 11 || prop.minor != 0) {
      throw std::runtime_error("Jetson Thor SM110 required");
    }
    if (argc > 1) {
      run(1, 128, 1025, true);
    } else {
      for (int m : {0, 1, 3}) {
        for (int n : {1, 7, 32}) {
          for (int k : {0, 1, 31, 32, 33, 65, 1025}) {
            run(m, n, k, false);
          }
        }
      }
      run(1, 128, 1025, true);
    }
    std::cout << "PASS actual Thor GPU baseline/warp\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
