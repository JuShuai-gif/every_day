#include <cuda_runtime.h>

#include <algorithm>
#include <chrono>
#include <iostream>
#include <string>

#include "contract.hpp"
void check(cudaError_t e) {
  if (e != cudaSuccess) {
    throw std::runtime_error(cudaGetErrorString(e));
  }
}
void cleanup(cudaError_t e) noexcept {
  if (e != cudaSuccess) {
    std::cerr << "cleanup: " << cudaGetErrorString(e) << '\n';
  }
}
struct Buffer {
  float* p = nullptr;
  explicit Buffer(std::size_t n) {
    if (n) {
      check(cudaMalloc(reinterpret_cast<void**>(&p), n * sizeof(float)));
    }
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
    check(cudaEventCreate(&e));
  }
  ~Event() {
    cleanup(cudaEventDestroy(e));
  }
  Event(const Event&) = delete;
  Event& operator=(const Event&) = delete;
};
__global__ void transpose_direct(const float* a, float* b, Shape s) {
  int c = blockIdx.x * 32 + threadIdx.x, r = blockIdx.y * 32 + threadIdx.y;
  for (int j = 0; j < 32; j += 8) {
    if (c < s.cols && r + j < s.rows) {
      b[std::size_t(c) * s.out_stride + r + j] = a[std::size_t(r + j) * s.in_stride + c];
    }
  }
}
// PAD=0用于消融：全局合并已改善，但shared列读取仍有bank冲突。
template <int PAD>
__global__ void transpose_tile(const float* a, float* b, Shape s) {
  __shared__ float tile[32][32 + PAD];
  int c = blockIdx.x * 32 + threadIdx.x, r = blockIdx.y * 32 + threadIdx.y;
  for (int j = 0; j < 32; j += 8) {
    if (c < s.cols && r + j < s.rows) {
      tile[threadIdx.y + j][threadIdx.x] = a[std::size_t(r + j) * s.in_stride + c];
    }
  }
  // 边界线程也必须到达CTA屏障；有效输出恰好对应有效生产者。
  asm volatile("bar.sync 0;" ::: "memory");
  int outc = blockIdx.y * 32 + threadIdx.x, outr = blockIdx.x * 32 + threadIdx.y;
  for (int j = 0; j < 32; j += 8) {
    if (outc < s.rows && outr + j < s.cols) {
      b[std::size_t(outr + j) * s.out_stride + outc] = tile[threadIdx.x][threadIdx.y + j];
    }
  }
}
void launch(int mode, const Buffer& a, Buffer& b, Shape s) {
  if (!s.rows || !s.cols) {
    return;
  }
  dim3 block(32, 8), grid((s.cols + 31) / 32, (s.rows + 31) / 32);
  if (mode == 0) {
    transpose_direct<<<grid, block>>>(a.p, b.p, s);
  } else if (mode == 1) {
    transpose_tile<0><<<grid, block>>>(a.p, b.p, s);
  } else {
    transpose_tile<1><<<grid, block>>>(a.p, b.p, s);
  }
  check(cudaGetLastError());
}
void run(Shape s, int mode, bool timed) {
  s.check();
  if (!s.rows || !s.cols) {
    return;
  }
  auto a = input(s), gold = reference(a, s);
  std::vector<float> b(gold.size(), -999.f);
  Buffer da(a.size()), db(b.size());
  check(cudaMemcpy(da.p, a.data(), a.size() * 4, cudaMemcpyHostToDevice));
  check(cudaMemcpy(db.p, b.data(), b.size() * 4, cudaMemcpyHostToDevice));
  launch(mode, da, db, s);
  check(cudaDeviceSynchronize());
  check(cudaMemcpy(b.data(), db.p, b.size() * 4, cudaMemcpyDeviceToHost));
  if (b != gold) {
    throw std::runtime_error("GPU output/padding mismatch");
  }
  if (!timed) {
    return;
  }
  for (int i = 0; i < 10; ++i) {
    launch(mode, da, db, s);
  }
  check(cudaDeviceSynchronize());
  Event start, stop;
  std::vector<float> samples;
  for (int sample = 0; sample < 21; ++sample) {
    check(cudaEventRecord(start.e));
    for (int i = 0; i < 100; ++i) {
      launch(mode, da, db, s);
    }
    check(cudaEventRecord(stop.e));
    check(cudaEventSynchronize(stop.e));
    float ms = 0;
    check(cudaEventElapsedTime(&ms, start.e, stop.e));
    samples.push_back(ms / 100);
  }
  std::sort(samples.begin(), samples.end());
  // 请求时间包含pageable H2D、一个kernel、D2H同步；不含分配和输入生成。
  std::vector<double> end_to_end;
  for (int i = 0; i < 21; ++i) {
    auto t = std::chrono::steady_clock::now();
    check(cudaMemcpy(da.p, a.data(), a.size() * 4, cudaMemcpyHostToDevice));
    launch(mode, da, db, s);
    check(cudaMemcpy(b.data(), db.p, b.size() * 4, cudaMemcpyDeviceToHost));
    end_to_end.push_back(
        std::chrono::duration<double, std::milli>(std::chrono::steady_clock::now() - t).count());
    if (b != gold) {
      throw std::runtime_error("timed correctness");
    }
  }
  std::sort(end_to_end.begin(), end_to_end.end());
  std::cout << "mode=" << mode << " kernel_batch_mean_p50_ms=" << samples[10]
            << " p95_ms=" << samples[19]
            << " logical_GBps=" << (8.0 * s.rows * s.cols / 1e6 / samples[10])
            << " transfer_request_p50_ms=" << end_to_end[10] << '\n';
}
int main(int argc, char** argv) {
  try {
    cudaDeviceProp prop{};
    check(cudaGetDeviceProperties(&prop, 0));
    if (prop.major != 11 || prop.minor != 0) {
      throw std::runtime_error("requires Thor SM110");
    }
    if (argc == 2 && std::string(argv[1]) == "check") {
      int count = 0;
      for (int r : {1, 31, 32, 33, 65}) {
        for (int c : {1, 31, 32, 33, 67}) {
          for (int pad : {0, 3}) {
            for (int mode = 0; mode < 3; ++mode) {
              run({r, c, c + pad, r + pad}, mode, false);
              ++count;
            }
          }
        }
      }
      std::cout << "PASS GPU " << count << " mode/shape cases\n";
      return 0;
    }
    int mode = argc > 1 ? std::stoi(argv[1]) : 2;
    if (mode < 0 || mode > 2) {
      throw std::invalid_argument("mode 0..2");
    }
    run({1537, 769, 772, 1540}, mode, true);
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
