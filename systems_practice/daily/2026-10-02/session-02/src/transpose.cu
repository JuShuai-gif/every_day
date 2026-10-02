#include <cuda_runtime.h>

#include <chrono>
#include <cstdlib>
#include <iostream>
#include <string>

#include "contract.hpp"
void ck(cudaError_t e) {
  if (e != cudaSuccess)
    throw std::runtime_error(cudaGetErrorString(e));
}
void cleanup(cudaError_t e) {
  if (e != cudaSuccess) {
    std::cerr << "CUDA cleanup: " << cudaGetErrorString(e) << '\n';
    std::abort();
  }
}
struct Buffer {
  float* p = nullptr;
  explicit Buffer(std::size_t n) {
    ck(cudaMalloc(reinterpret_cast<void**>(&p), n * sizeof(float)));
  }
  ~Buffer() {
    if (p)
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
// 原始独立实现；源阅读中的tile换位机制见README。输出行跨度必须是ldo。
__global__ void transpose_naive(const float* a, float* b, int h, int w, int ldi, int ldo) {
  int x = blockIdx.x * 32 + threadIdx.x, y = blockIdx.y * 32 + threadIdx.y;
  for (int j = 0; j < 32; j += 8)
    if (x < w && y + j < h)
      b[std::size_t(x) * ldo + y + j] = a[std::size_t(y + j) * ldi + x];
}
// PAD=0是隔离bank conflict的中间对照；PAD=1是最终优化候选。
template <int PAD>
__global__ void transpose_tile(const float* a, float* b, int h, int w, int ldi, int ldo) {
  __shared__ float tile[32][32 + PAD];
  int x = blockIdx.x * 32 + threadIdx.x, y = blockIdx.y * 32 + threadIdx.y;
  for (int j = 0; j < 32; j += 8)
    if (x < w && y + j < h)
      tile[threadIdx.y + j][threadIdx.x] = a[std::size_t(y + j) * ldi + x];
  // 边界线程也必须到达屏障；有效输出所读的tile元素必有一个有效生产者。
  __syncthreads();
  x = blockIdx.y * 32 + threadIdx.x;
  y = blockIdx.x * 32 + threadIdx.y;
  for (int j = 0; j < 32; j += 8)
    if (x < h && y + j < w)
      b[std::size_t(y + j) * ldo + x] = tile[threadIdx.x][threadIdx.y + j];
}
void launch(int mode, const Buffer& a, Buffer& b, Shape s) {
  dim3 t(32, 8), g((s.w + 31) / 32, (s.h + 31) / 32);
  if (mode == 0)
    transpose_naive<<<g, t>>>(a.p, b.p, s.h, s.w, s.ldi, s.ldo);
  else if (mode == 1)
    transpose_tile<0><<<g, t>>>(a.p, b.p, s.h, s.w, s.ldi, s.ldo);
  else
    transpose_tile<1><<<g, t>>>(a.p, b.p, s.h, s.w, s.ldi, s.ldo);
  ck(cudaGetLastError());
}
void run(Shape s, int selected, bool measure) {
  validate(s);
  auto a = input(s), gold = oracle(a, s);
  std::vector<float> b(gold.size(), -999);
  Buffer da(a.size()), db(b.size());
  auto wall = std::chrono::steady_clock::now();
  ck(cudaMemcpy(da.p, a.data(), a.size() * 4, cudaMemcpyHostToDevice));
  double h2d =
      std::chrono::duration<double, std::micro>(std::chrono::steady_clock::now() - wall).count();
  for (int mode = 0; mode < 3; ++mode) {
    if (selected >= 0 && mode != selected)
      continue;
    std::fill(b.begin(), b.end(), -999);
    ck(cudaMemcpy(db.p, b.data(), b.size() * 4, cudaMemcpyHostToDevice));
    launch(mode, da, db, s);
    ck(cudaDeviceSynchronize());
    wall = std::chrono::steady_clock::now();
    ck(cudaMemcpy(b.data(), db.p, b.size() * 4, cudaMemcpyDeviceToHost));
    double d2h =
        std::chrono::duration<double, std::micro>(std::chrono::steady_clock::now() - wall).count();
    check(b == gold, "GPU value or stride sentinel mismatch");
    if (measure) {
      for (int k = 0; k < 10; ++k)
        launch(mode, da, db, s);
      ck(cudaDeviceSynchronize());
      Event begin, end;
      std::vector<float> ms;
      for (int k = 0; k < 30; ++k) {
        ck(cudaEventRecord(begin.e));
        launch(mode, da, db, s);
        ck(cudaEventRecord(end.e));
        ck(cudaEventSynchronize(end.e));
        float x = 0;
        ck(cudaEventElapsedTime(&x, begin.e, end.e));
        ms.push_back(x);
      }
      std::sort(ms.begin(), ms.end());
      std::cout << "mode=" << mode << " h=" << s.h << " w=" << s.w << " kernel_p50_ms=" << ms[15]
                << " kernel_p95_ms=" << ms[28]
                << " effective_GBps=" << (8.0 * s.h * s.w / (ms[15] * 1e6))
                << " H2D_host_us=" << h2d << " D2H_host_us=" << d2h << '\n';
    }
  }
}
int main(int argc, char** argv) {
  try {
    cudaDeviceProp p{};
    ck(cudaGetDeviceProperties(&p, 0));
    check(p.major == 11 && p.minor == 0, "execution requires Thor SM110");
    std::cout << "device=" << p.name << " cc=" << p.major << '.' << p.minor
              << " warmup=10 samples=30 resident-input\n";
    if (argc == 2) {
      int mode = std::stoi(argv[1]);
      check(mode >= 0 && mode <= 2, "mode must be 0,1,2");
      run({1024, 2048, 2051, 1027}, mode, true);
    } else {
      for (int h : {1, 7, 31, 32, 33, 65, 129})
        for (int w : {1, 7, 31, 32, 33, 65, 129})
          for (int pad : {0, 3})
            run({h, w, w + pad, h + pad}, -1, false);
      run({1024, 2048, 2051, 1027}, -1, true);
    }
    std::cout << "PASS GPU exact equality and output padding\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
