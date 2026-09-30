#include <cuda_profiler_api.h>
#include <cuda_runtime.h>

#include <algorithm>
#include <chrono>
#include <iostream>
#include <limits>
#include <string>

#include "contract.hpp"
#if defined(__CUDA_ARCH__) && __CUDA_ARCH__ != 1100
#error "This lesson executes only on Thor SM110"
#endif
void ck(cudaError_t e) {
  if (e != cudaSuccess) {
    throw std::runtime_error(cudaGetErrorString(e));
  }
}
void cleanup(cudaError_t e) noexcept {
  if (e != cudaSuccess) {
    std::cerr << "CUDA cleanup: " << cudaGetErrorString(e) << '\n';
  }
}
struct Buffer {
  float* p = nullptr;
  explicit Buffer(std::size_t n) {
    ck(cudaMalloc(reinterpret_cast<void**>(&p), n * sizeof(float)));
  }
  ~Buffer() {
    cleanup(cudaFree(p));
  }
  Buffer(const Buffer&) = delete;
  Buffer& operator=(const Buffer&) = delete;
};
struct Stream {
  cudaStream_t v{};
  Stream() {
    ck(cudaStreamCreate(&v));
  }
  ~Stream() {
    cleanup(cudaStreamDestroy(v));
  }
  Stream(const Stream&) = delete;
  Stream& operator=(const Stream&) = delete;
};
struct Event {
  cudaEvent_t v{};
  Event() {
    ck(cudaEventCreate(&v));
  }
  ~Event() {
    cleanup(cudaEventDestroy(v));
  }
  Event(const Event&) = delete;
  Event& operator=(const Event&) = delete;
};
// 真正的inline PTX；4B源/目的对齐。尾部仍传合法base指针，以src-size=0补零。
__device__ void copy4(float* dst, const float* src, bool valid) {
  unsigned shared = static_cast<unsigned>(__cvta_generic_to_shared(dst));
  int bytes = valid ? 4 : 0;
  asm volatile("cp.async.ca.shared.global [%0], [%1], 4, %2;" ::"r"(shared), "l"(src), "r"(bytes)
               : "memory");
}
__device__ void issue(float* sa, float* sb, const float* a, const float* b, Shape s, int tile) {
  int x = threadIdx.x, y = threadIdx.y;
  int row = blockIdx.y * 16 + y, col = blockIdx.x * 16 + x;
  int ak = tile * 16 + x, bk = tile * 16 + y;
  bool va = row < s.m && ak < s.k, vb = col < s.n && bk < s.k;
  copy4(sa + y * 16 + x, va ? a + row * s.k + ak : a, va);
  copy4(sb + y * 16 + x, vb ? b + bk * s.n + col : b, vb);
  asm volatile("cp.async.commit_group;" ::: "memory");
}
__device__ void await_tile() {
  // 每线程等待自己的拷贝；CTA屏障再让其他warp安全消费。
  asm volatile("cp.async.wait_group 0;" ::: "memory");
  __syncthreads();
}
__global__ void gemm_sync(const float* a, const float* b, float* c, Shape s) {
  __shared__ float sa[256], sb[256];
  int x = threadIdx.x, y = threadIdx.y;
  int row = blockIdx.y * 16 + y, col = blockIdx.x * 16 + x;
  float acc = 0;
  for (int tile = 0; tile < (s.k + 15) / 16; ++tile) {
    int ak = tile * 16 + x, bk = tile * 16 + y;
    sa[y * 16 + x] = row < s.m && ak < s.k ? a[row * s.k + ak] : 0;
    sb[y * 16 + x] = col < s.n && bk < s.k ? b[bk * s.n + col] : 0;
    __syncthreads();
#pragma unroll
    for (int k = 0; k < 16; ++k) {
      acc = fmaf(sa[y * 16 + k], sb[k * 16 + x], acc);
    }
    // 消费结束才能覆盖同一个shared tile。
    __syncthreads();
  }
  if (row < s.m && col < s.n) {
    c[row * s.n + col] = acc;
  }
}
__global__ void gemm_async2(const float* a, const float* b, float* c, Shape s) {
  __shared__ float sa[2][256], sb[2][256];
  int x = threadIdx.x, y = threadIdx.y;
  int row = blockIdx.y * 16 + y, col = blockIdx.x * 16 + x;
  int tiles = (s.k + 15) / 16;
  float acc = 0;
  issue(sa[0], sb[0], a, b, s, 0);
  await_tile();
  for (int tile = 0; tile < tiles; ++tile) {
    int slot = tile & 1;
    if (tile + 1 < tiles) {
      issue(sa[slot ^ 1], sb[slot ^ 1], a, b, s, tile + 1);
    }
#pragma unroll
    for (int k = 0; k < 16; ++k) {
      acc = fmaf(sa[slot][y * 16 + k], sb[slot][k * 16 + x], acc);
    }
    // 保守消费屏障：保证完成后再复用slot；仅cp.async.wait不提供CTA会合。
    __syncthreads();
    if (tile + 1 < tiles) {
      await_tile();
    }
  }
  if (row < s.m && col < s.n) {
    c[row * s.n + col] = acc;
  }
}
void launch(bool async, const Buffer& a, const Buffer& b, Buffer& c, Shape s, cudaStream_t stream) {
  dim3 block(16, 16), grid((s.n + 15) / 16, (s.m + 15) / 16);
  if (async) {
    gemm_async2<<<grid, block, 0, stream>>>(a.p, b.p, c.p, s);
  } else {
    gemm_sync<<<grid, block, 0, stream>>>(a.p, b.p, c.p, s);
  }
  ck(cudaGetLastError());
}
void run(Shape s, bool async, bool bench, bool profile) {
  s.validate();
  auto a = input(s.m * s.k, 1), b = input(s.k * s.n, 3), ref = oracle(a, b, s);
  std::vector<float> out(s.m * s.n);
  Buffer da(a.size()), db(b.size()), dc(out.size());
  Stream stream;
  ck(cudaMemcpyAsync(da.p, a.data(), a.size() * 4, cudaMemcpyHostToDevice, stream.v));
  ck(cudaMemcpyAsync(db.p, b.data(), b.size() * 4, cudaMemcpyHostToDevice, stream.v));
  ck(cudaMemsetAsync(dc.p, 0xff, out.size() * 4, stream.v));
  launch(async, da, db, dc, s, stream.v);
  ck(cudaMemcpyAsync(out.data(), dc.p, out.size() * 4, cudaMemcpyDeviceToHost, stream.v));
  ck(cudaStreamSynchronize(stream.v));
  check(out, ref);
  if (!bench && !profile) {
    return;
  }
  for (int i = 0; i < 20; ++i) {
    launch(async, da, db, dc, s, stream.v);
  }
  ck(cudaStreamSynchronize(stream.v));
  if (profile) {
    ck(cudaProfilerStart());
    launch(async, da, db, dc, s, stream.v);
    ck(cudaStreamSynchronize(stream.v));
    ck(cudaProfilerStop());
  } else {
    Event start, stop;
    std::vector<float> gpu;
    std::vector<double> e2e;
    for (int i = 0; i < 101; ++i) {
      ck(cudaEventRecord(start.v, stream.v));
      launch(async, da, db, dc, s, stream.v);
      ck(cudaEventRecord(stop.v, stream.v));
      ck(cudaEventSynchronize(stop.v));
      float ms = 0;
      ck(cudaEventElapsedTime(&ms, start.v, stop.v));
      gpu.push_back(ms);
      auto t0 = std::chrono::steady_clock::now();
      ck(cudaMemcpyAsync(da.p, a.data(), a.size() * 4, cudaMemcpyHostToDevice, stream.v));
      ck(cudaMemcpyAsync(db.p, b.data(), b.size() * 4, cudaMemcpyHostToDevice, stream.v));
      launch(async, da, db, dc, s, stream.v);
      ck(cudaMemcpyAsync(out.data(), dc.p, out.size() * 4, cudaMemcpyDeviceToHost, stream.v));
      ck(cudaStreamSynchronize(stream.v));
      e2e.push_back(
          std::chrono::duration<double, std::milli>(std::chrono::steady_clock::now() - t0).count());
      check(out, ref);
    }
    std::sort(gpu.begin(), gpu.end());
    std::sort(e2e.begin(), e2e.end());
    std::cout << (async ? "async2" : "sync") << " GPU_event_ms p50=" << gpu[50]
              << " p95=" << gpu[95] << " host_H2D_kernel_D2H_wait_ms p50=" << e2e[50]
              << " p95=" << e2e[95] << '\n';
  }
  ck(cudaMemcpyAsync(out.data(), dc.p, out.size() * 4, cudaMemcpyDeviceToHost, stream.v));
  ck(cudaStreamSynchronize(stream.v));
  check(out, ref);
}
int main(int argc, char** argv) {
  try {
    std::string mode = argc > 1 ? argv[1] : "bench";
    std::string variant = argc > 2 ? argv[2] : "async2";
    if (argc > 3 || (mode != "bench" && mode != "sweep" && mode != "profile") ||
        (variant != "async2" && variant != "sync")) {
      throw std::invalid_argument("usage: gemm [bench|sweep|profile] [sync|async2]");
    }
    cudaDeviceProp prop{};
    ck(cudaGetDeviceProperties(&prop, 0));
    if (prop.major != 11 || prop.minor != 0) {
      throw std::runtime_error("Thor SM110 required");
    }
    std::cout << prop.name << " cc=" << prop.major << '.' << prop.minor << '\n';
    if (mode == "sweep") {
      int count = 0;
      for (int m : {1, 15, 16, 17, 33}) {
        for (int n : {1, 15, 16, 17, 35}) {
          for (int k : {1, 15, 16, 17, 31, 32, 33, 65}) {
            run({m, n, k}, false, false, false);
            run({m, n, k}, true, false, false);
            count += 2;
          }
        }
      }
      std::cout << "PASS GPU " << count << " comparisons\n";
    } else if (mode == "profile") {
      run({32, 64, 129}, variant == "async2", false, true);
    } else {
      run({32, 64, 129}, false, true, false);
      run({32, 64, 129}, true, true, false);
    }
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
