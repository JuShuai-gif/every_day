// Tile/barrier structure adapted from NVIDIA cuda-samples v13.0; see ../NVIDIA-LICENSE.txt.
// 独立教学重建：真实INT8存储 + FP32反量化SIMT；不是bnb或Tensor Core性能实现。
#include <cuda_fp16.h>
#include <cuda_runtime.h>

#include <algorithm>
#include <chrono>
#include <cmath>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <iostream>
#include <stdexcept>
#include <string>
#include <vector>

void check(cudaError_t e) {
  if (e != cudaSuccess)
    throw std::runtime_error(cudaGetErrorString(e));
}
void cleanup(cudaError_t e) noexcept {
  if (e != cudaSuccess) {
    std::fprintf(stderr, "CUDA cleanup: %s\n", cudaGetErrorString(e));
    std::abort();
  }
}
template <class T>
struct Buffer {
  T* p = nullptr;
  explicit Buffer(std::size_t n) {
    check(cudaMalloc(reinterpret_cast<void**>(&p), n * sizeof(T)));
  }
  ~Buffer() {
    if (p)
      cleanup(cudaFree(p));
  }
  Buffer(const Buffer&) = delete;
  Buffer& operator=(const Buffer&) = delete;
  void upload(const std::vector<T>& v) {
    check(cudaMemcpy(p, v.data(), v.size() * sizeof(T), cudaMemcpyHostToDevice));
  }
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
struct Inputs {
  const __half* a;
  const std::int8_t* qa;
  const std::int8_t* qw;  // [K,N]，每个输出列一个scale
  const float* sx;
  const float* sw;
  const unsigned char* mask;
  int m, n, k;
};
__device__ float decode_a(Inputs x, int r, int k) {
  return x.mask[k] ? __half2float(x.a[r * x.k + k]) : float(x.qa[r * x.k + k]) * x.sx[r];
}
__device__ float decode_w(Inputs x, int k, int c) {
  return float(x.qw[k * x.n + c]) * x.sw[c];
}
__global__ void mixed_baseline(Inputs x, float* y) {
  const int r = blockIdx.y * 16 + threadIdx.y, c = blockIdx.x * 16 + threadIdx.x;
  if (r >= x.m || c >= x.n)
    return;
  float acc = 0;
  for (int k = 0; k < x.k; ++k)
    acc = fmaf(decode_a(x, r, k), decode_w(x, k, c), acc);
  y[r * x.n + c] = acc;
}
__global__ void mixed_tiled(Inputs x, float* y) {
  __shared__ float a[16][16], b[16][16];
  const int ty = threadIdx.y, tx = threadIdx.x;
  const int r = blockIdx.y * 16 + ty, c = blockIdx.x * 16 + tx;
  float acc = 0;
  for (int base = 0; base < x.k; base += 16) {
    // 边界线程仍参加两次barrier；只屏蔽读写，不能提前return。
    a[ty][tx] = (r < x.m && base + tx < x.k) ? decode_a(x, r, base + tx) : 0;
    b[ty][tx] = (c < x.n && base + ty < x.k) ? decode_w(x, base + ty, c) : 0;
    __syncthreads();
#pragma unroll
    for (int j = 0; j < 16; ++j)
      acc = fmaf(a[ty][j], b[j][tx], acc);
    __syncthreads();
  }
  if (r < x.m && c < x.n)
    y[r * x.n + c] = acc;
}
void launch(Inputs x, float* y, bool tiled) {
  const dim3 block(16, 16), grid((x.n + 15) / 16, (x.m + 15) / 16);
  if (tiled)
    mixed_tiled<<<grid, block>>>(x, y);
  else
    mixed_baseline<<<grid, block>>>(x, y);
  check(cudaGetLastError());
}
void run(int m, int n, int k, int mask_mode, bool benchmark) {
  // 量化参数在计时外；不把量化/传输时间计为GEMM。
  std::vector<__half> a(m * k);
  std::vector<std::int8_t> qa(m * k), qw(k * n);
  std::vector<float> sx(m, 0.02f), sw(n, 0.03f), reference(m * n), out(m * n);
  std::vector<unsigned char> mask(k);
  for (int j = 0; j < k; ++j)
    mask[j] = mask_mode == 2 || (mask_mode == 1 && j % 7 == 0);
  for (int i = 0; i < m * k; ++i) {
    qa[i] = std::int8_t((i * 17) % 255 - 127);
    a[i] = __float2half(float(qa[i]) * 0.02f + (mask[i % k] ? 5.0f : 0.0f));
  }
  for (int i = 0; i < k * n; ++i)
    qw[i] = std::int8_t((i * 13) % 255 - 127);
  for (int r = 0; r < m; ++r)
    for (int c = 0; c < n; ++c) {
      double sum = 0;
      for (int j = 0; j < k; ++j) {
        const float av = mask[j] ? __half2float(a[r * k + j]) : float(qa[r * k + j]) * sx[r];
        const float bv = float(qw[j * n + c]) * sw[c];
        sum += double(av) * double(bv);
      }
      reference[r * n + c] = float(sum);
    }
  Buffer<__half> da(a.size());
  Buffer<std::int8_t> dqa(qa.size()), dqw(qw.size());
  Buffer<float> dsx(sx.size()), dsw(sw.size()), dy(out.size());
  Buffer<unsigned char> dm(mask.size());
  da.upload(a);
  dqa.upload(qa);
  dqw.upload(qw);
  dsx.upload(sx);
  dsw.upload(sw);
  dm.upload(mask);
  Inputs x{da.p, dqa.p, dqw.p, dsx.p, dsw.p, dm.p, m, n, k};
  float max_error = 0;
  for (bool tiled : {false, true}) {
    launch(x, dy.p, tiled);
    check(cudaDeviceSynchronize());
    check(cudaMemcpy(out.data(), dy.p, out.size() * sizeof(float), cudaMemcpyDeviceToHost));
    for (std::size_t i = 0; i < out.size(); ++i) {
      max_error = std::max(max_error, std::abs(out[i] - reference[i]));
      if (!std::isfinite(out[i]) ||
          std::abs(out[i] - reference[i]) > 0.002f + 0.0002f * std::abs(reference[i]))
        throw std::runtime_error("GPU mismatch against decoded-input FP64 oracle");
    }
  }
  std::cout << "PASS " << m << 'x' << n << 'x' << k << " mask=" << mask_mode
            << " max_abs=" << max_error << '\n';
  if (!benchmark)
    return;
  for (bool tiled : {false, true})
    for (int i = 0; i < 5; ++i)
      launch(x, dy.p, tiled);
  check(cudaDeviceSynchronize());
  std::vector<float> samples[2];
  Event start, stop;
  for (int batch = 0; batch < 11; ++batch)
    for (int order = 0; order < 2; ++order) {
      const int mode = (batch + order) % 2;
      check(cudaEventRecord(start.e));
      for (int repeat = 0; repeat < 20; ++repeat)
        launch(x, dy.p, mode != 0);
      check(cudaEventRecord(stop.e));
      check(cudaEventSynchronize(stop.e));
      float ms = 0;
      check(cudaEventElapsedTime(&ms, start.e, stop.e));
      samples[mode].push_back(ms * 1000 / 20);
    }
  for (int mode = 0; mode < 2; ++mode) {
    auto& s = samples[mode];
    std::sort(s.begin(), s.end());
    std::cout << (mode ? "tiled" : "baseline") << " GPU_batch_mean_us_P50=" << s[5]
              << " P95=" << s[10] << '\n';
  }
  // 完整输入H2D + 优化kernel + 输出D2H，仅此子流水线；含pageable复制开销。
  const auto begin = std::chrono::steady_clock::now();
  da.upload(a);
  dqa.upload(qa);
  dqw.upload(qw);
  dsx.upload(sx);
  dsw.upload(sw);
  dm.upload(mask);
  launch(x, dy.p, true);
  check(cudaMemcpy(out.data(), dy.p, out.size() * sizeof(float), cudaMemcpyDeviceToHost));
  const auto end = std::chrono::steady_clock::now();
  std::cout << "transfer_kernel_transfer_single_us="
            << std::chrono::duration<double, std::micro>(end - begin).count() << " payload_bytes="
            << (a.size() * sizeof(__half) + qa.size() + qw.size() + 4 * (sx.size() + sw.size()) +
                mask.size())
            << '\n';
}
int main(int argc, char** argv) {
  try {
    if (argc > 2 || (argc == 2 && std::string(argv[1]) != "--profile"))
      throw std::invalid_argument("usage: mixed [--profile]");
    cudaDeviceProp prop{};
    check(cudaGetDeviceProperties(&prop, 0));
    if (prop.major != 11 || prop.minor != 0)
      throw std::runtime_error("requires Thor SM110");
    std::cout << prop.name << " cc=" << prop.major << '.' << prop.minor << '\n';
    if (argc == 2) {
      run(128, 128, 256, 1, true);
      return 0;
    }
    for (int k : {1, 15, 16, 17, 65})
      for (int mask : {0, 1, 2})
        run(17, 19, k, mask, false);
    run(1, 1, 1, 0, false);
    run(16, 16, 16, 2, false);
    run(128, 128, 256, 1, true);
    return 0;
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
