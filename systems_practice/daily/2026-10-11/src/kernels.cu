#include <iostream>

#include "contract.hpp"
#include "cuda_raii.hpp"

__global__ void affine_baseline(const float* x, float* t, int n) {
  const int i = blockIdx.x * blockDim.x + threadIdx.x;
  if (i < n) {
    t[i] = x[i] * 0.5F + 0.25F;
  }
}
__global__ void relu_baseline(const float* t, float* y, int n) {
  const int i = blockIdx.x * blockDim.x + threadIdx.x;
  if (i < n) {
    y[i] = fmaxf(0, t[i]);
  }
}
__device__ float activate(float x) {
  const float a = x * 0.5F + 0.25F;
  float y;
  // 真实手写 PTX；不是声称已生成或测得的 SASS。
  asm("max.f32 %0, %1, 0f00000000;" : "=f"(y) : "f"(a));
  return y;
}
__global__ void affine_relu_fused(const float* x, float* y, int n) {
  const int i = (blockIdx.x * blockDim.x + threadIdx.x) * 4;
  // cudaMalloc 基址对齐；跨行也连续，只有全局末尾需要标量尾部。
  if (i + 3 < n) {
    const float4 a = reinterpret_cast<const float4*>(x)[i / 4];
    reinterpret_cast<float4*>(y)[i / 4] =
        make_float4(activate(a.x), activate(a.y), activate(a.z), activate(a.w));
  } else {
    for (int j = i; j < n; ++j) {
      y[j] = activate(x[j]);
    }
  }
}
void launch(
    int version, const Buffer& x, const Buffer& temp, const Buffer& y, int n, cudaStream_t s) {
  if (version == 0) {
    affine_baseline<<<(n + 255) / 256, 256, 0, s>>>(x.data(), temp.data(), n);
    cuda_check(cudaGetLastError(), "affine launch");
    relu_baseline<<<(n + 255) / 256, 256, 0, s>>>(temp.data(), y.data(), n);
  } else {
    affine_relu_fused<<<(n + 1023) / 1024, 256, 0, s>>>(x.data(), y.data(), n);
  }
  cuda_check(cudaGetLastError(), "relu/fused launch");
}
int main(int argc, char** argv) {
  try {
    require_thor();
    const int batch = argc > 1 ? std::stoi(argv[1]) : 8;
    const int width = argc > 2 ? std::stoi(argv[2]) : 4097;
    const int n = static_cast<int>(elements(batch, width));
    const std::size_t bytes = n * sizeof(float);
    std::vector<float> host(n), result(n);
    for (int i = 0; i < n; ++i) {
      host[i] = static_cast<float>(i % 37 - 18) / 8;
    }
    Stream stream;
    Buffer x(bytes), temp(bytes), y(bytes);
    Event start, stop;
    Drain drain{stream.value};
    cuda_check(cudaMemcpyAsync(x.value, host.data(), bytes, cudaMemcpyHostToDevice, stream.value),
               "H2D");
    for (int version = 0; version < 2; ++version) {
      launch(version, x, temp, y, n, stream.value);
      cuda_check(
          cudaMemcpyAsync(result.data(), y.value, bytes, cudaMemcpyDeviceToHost, stream.value),
          "D2H");
      cuda_check(cudaStreamSynchronize(stream.value), "correctness sync");
      check(host, result);
      for (int i = 0; i < 20; ++i) {
        launch(version, x, temp, y, n, stream.value);
      }
      cuda_check(cudaStreamSynchronize(stream.value), "warmup sync");
      std::vector<float> samples;
      for (int sample = 0; sample < 11; ++sample) {
        cuda_check(cudaEventRecord(start.value, stream.value), "start");
        for (int i = 0; i < 100; ++i) {
          launch(version, x, temp, y, n, stream.value);
        }
        cuda_check(cudaEventRecord(stop.value, stream.value), "stop");
        cuda_check(cudaEventSynchronize(stop.value), "stop sync");
        float ms = 0;
        cuda_check(cudaEventElapsedTime(&ms, start.value, stop.value), "elapsed");
        samples.push_back(ms * 1000 / 100);
      }
      std::sort(samples.begin(), samples.end());
      std::cout << "version=" << version << " B=" << batch << " K=" << width
                << " device_batch_mean_us_p50=" << samples[5] << " p95=" << samples[10] << '\n';
    }
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
