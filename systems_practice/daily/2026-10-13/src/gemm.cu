#include <cuda_runtime.h>

#include <cstdio>
#include <iostream>
#include <string>

#include "contract.hpp"
void ck(cudaError_t e) {
  if (e != cudaSuccess) {
    throw std::runtime_error(cudaGetErrorString(e));
  }
}
void cleanup(cudaError_t e) {
  if (e != cudaSuccess) {
    std::fprintf(stderr, "CUDA cleanup: %s\n", cudaGetErrorString(e));
  }
}
struct Buffer {
  float* p = nullptr;
  explicit Buffer(std::size_t n) {
    ck(cudaMalloc(reinterpret_cast<void**>(&p), n * sizeof(float)));
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
__device__ void copy16(float* dst, const float* src, int bytes) {
  unsigned address = static_cast<unsigned>(__cvta_generic_to_shared(dst));
  // 完整向量不传src-size；部分向量只读有效字节，剩余字节置零。
  if (bytes == 16) {
    asm volatile("cp.async.ca.shared.global [%0], [%1], 16;" ::"r"(address), "l"(src) : "memory");
  } else {
    asm volatile(
        "cp.async.ca.shared.global [%0], [%1], 16, %2;" ::"r"(address), "l"(src), "r"(bytes)
        : "memory");
  }
}
__global__ void gemm_baseline(
    const float* a, const float* b, float* c, int m, int n, int k, int lda, int ldb) {
  __shared__ float x[16][16], y[16][16];
  int tx = threadIdx.x, ty = threadIdx.y;
  int r = blockIdx.y * 16 + ty, col = blockIdx.x * 16 + tx;
  float v = 0;
  for (int base = 0; base < k; base += 16) {
    x[ty][tx] = (r < m && base + tx < k) ? a[r * lda + base + tx] : 0;
    y[ty][tx] = (base + ty < k && col < n) ? b[(base + ty) * ldb + col] : 0;
    __syncthreads();
    for (int j = 0; j < 16; ++j) {
      v = fmaf(x[ty][j], y[j][tx], v);
    }
    __syncthreads();
  }
  if (r < m && col < n) {
    c[r * n + col] = v;
  }
}
__global__ void gemm_async(
    const float* a, const float* b, float* c, int m, int n, int k, int lda, int ldb) {
  __shared__ __align__(16) float x[16][16];
  __shared__ __align__(16) float y[16][16];
  int tx = threadIdx.x, ty = threadIdx.y, tid = ty * 16 + tx;
  int r = blockIdx.y * 16 + ty, col = blockIdx.x * 16 + tx;
  float v = 0;
  for (int base = 0; base < k; base += 16) {
    if (tid < 64) {
      int row = tid / 4, lane = (tid % 4) * 4, ar = blockIdx.y * 16 + row, ac = base + lane;
      int bc = blockIdx.x * 16 + lane, br = base + row;
      int na = (ar < m && ac < k) ? min(4, k - ac) : 0,
          nb = (br < k && bc < n) ? min(4, n - bc) : 0;
      // 无效向量仍给一个有效基地址，避免构造越界指针；src-size=0执行补零。
      copy16(&x[row][lane], na ? a + ar * lda + ac : a, na * 4);
      copy16(&y[row][lane], nb ? b + br * ldb + bc : b, nb * 4);
    }
    asm volatile("cp.async.commit_group;" ::: "memory");
    asm volatile("cp.async.wait_group 0;" ::: "memory");
    // wait只等待本线程发起的拷贝；CTA屏障将数据交给其他消费者。
    __syncthreads();
    for (int j = 0; j < 16; ++j) {
      v = fmaf(x[ty][j], y[j][tx], v);
    }
    __syncthreads();  // 所有消费者退出后才能重用单槽。
  }
  if (r < m && col < n) {
    c[r * n + col] = v;
  }
}
void launch(bool opt, const Shape& s, Buffer& a, Buffer& b, Buffer& c) {
  dim3 block(16, 16), grid((s.n + 15) / 16, (s.m + 15) / 16);
  if (opt) {
    gemm_async<<<grid, block>>>(a.p, b.p, c.p, s.m, s.n, s.k, s.lda, s.ldb);
  } else {
    gemm_baseline<<<grid, block>>>(a.p, b.p, c.p, s.m, s.n, s.k, s.lda, s.ldb);
  }
  ck(cudaGetLastError());
}
void run(const Shape& s, bool bench, int mode) {
  auto a = input(s.m, s.k, s.lda, 1), b = input(s.k, s.n, s.ldb, 2), want = reference(s, a, b);
  std::vector<float> got(want.size());
  Buffer da(a.size()), db(b.size()), dc(got.size());
  ck(cudaMemcpy(da.p, a.data(), a.size() * 4, cudaMemcpyHostToDevice));
  ck(cudaMemcpy(db.p, b.data(), b.size() * 4, cudaMemcpyHostToDevice));
  for (int opt = 0; opt < 2; ++opt) {
    if (mode >= 0 && mode != opt) {
      continue;
    }
    launch(opt, s, da, db, dc);
    ck(cudaDeviceSynchronize());
    ck(cudaMemcpy(got.data(), dc.p, got.size() * 4, cudaMemcpyDeviceToHost));
    check(got, want);
  }
  if (!bench) {
    return;
  }
  for (int t = 0; t < 20; ++t) {
    for (int opt = 0; opt < 2; ++opt) {
      if (mode < 0 || mode == opt) {
        launch(opt, s, da, db, dc);
      }
    }
  }
  ck(cudaDeviceSynchronize());
  Event start, end;
  std::vector<float> samples[2];
  for (int t = 0; t < 100; ++t) {
    for (int j = 0; j < 2; ++j) {
      int opt = (j + t) % 2;
      if (mode >= 0 && mode != opt) {
        continue;
      }
      ck(cudaEventRecord(start.e));
      launch(opt, s, da, db, dc);
      ck(cudaEventRecord(end.e));
      ck(cudaEventSynchronize(end.e));
      float ms = 0;
      ck(cudaEventElapsedTime(&ms, start.e, end.e));
      samples[opt].push_back(ms * 1000);
    }
  }
  for (int opt = 0; opt < 2; ++opt) {
    auto& v = samples[opt];
    if (v.empty()) {
      continue;
    }
    std::sort(v.begin(), v.end());
    std::cout << (opt ? "async" : "baseline") << " GPU event single launch us p50=" << v[49]
              << " p95=" << v[94] << '\n';
  }
}
int main(int argc, char** argv) {
  try {
    cudaDeviceProp prop{};
    ck(cudaGetDeviceProperties(&prop, 0));
    if (prop.major != 11 || prop.minor != 0) {
      throw std::runtime_error("requires Thor SM110");
    }
    std::cout << prop.name << " sm_110\n";
    if (argc > 1 && std::string(argv[1]) == "--bench") {
      if (argc != 5 && argc != 6) {
        throw std::invalid_argument("--bench M N K [baseline|async]");
      }
      int mode = -1;
      if (argc == 6) {
        std::string v = argv[5];
        if (v != "baseline" && v != "async") {
          throw std::invalid_argument("bad kernel");
        }
        mode = v == "async" ? 1 : 0;
      }
      run(Shape(std::stoi(argv[2]), std::stoi(argv[3]), std::stoi(argv[4])), true, mode);
    } else {
      int count = 0;
      for (int m : {1, 3, 15, 16, 17, 33}) {
        for (int n : {1, 3, 15, 16, 17, 33}) {
          for (int k : {1, 3, 15, 16, 17, 33}) {
            run(Shape(m, n, k), false, -1);
            ++count;
          }
        }
      }
      std::cout << "PASS GPU shapes=" << count << " kernels=2\n";
    }
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
