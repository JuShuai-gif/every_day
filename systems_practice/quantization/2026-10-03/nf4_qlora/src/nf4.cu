#include <cmath>
#include <cstdint>
#include <string>

#include "../../../../daily/2026-10-03/src/gpu_support.hpp"
constexpr int K = 130, N = 33, G = 64, Groups = (K + G - 1) / G;
// 独立布局：偶数元素在低半字节，每行单独分组，不与bnb原生码流互换。
__device__ float weight(const unsigned char* q, const float* s, const float* book, int row, int k) {
  int i = row * K + k;
  int code = (q[i / 2] >> ((i % 2) * 4)) & 15;
  return book[code] * s[row * Groups + k / G];
}
__global__ void nf4_scalar(
    const unsigned char* q, const float* s, const float* book, const float* x, float* y) {
  int row = blockIdx.x * blockDim.x + threadIdx.x;
  if (row < N) {
    float sum = 0;
    for (int k = 0; k < K; ++k) {
      sum = fmaf(weight(q, s, book, row, k), x[k], sum);
    }
    y[row] = sum;
  }
}
__global__ void nf4_warp(
    const unsigned char* q, const float* s, const float* book, const float* x, float* y) {
  int lane = threadIdx.x % 32, row = blockIdx.x * 4 + threadIdx.x / 32;
  float sum = 0;
  if (row < N) {
    for (int k = lane; k < K; k += 32) {
      sum = fmaf(weight(q, s, book, row, k), x[k], sum);
    }
  }
  // 无效行也以零参与全warp同步，禁止部分lane提前退出。
  sum = warp_sum(sum);
  if (row < N && lane == 0) {
    y[row] = sum;
  }
}
int main(int argc, char** argv) {
  try {
    thor_only();
    int selected = -1;
    if (argc == 2) {
      std::string m = argv[1];
      if (m != "0" && m != "1") {
        throw std::runtime_error("mode 0|1");
      }
      selected = m == "0" ? 0 : 1;
    } else if (argc != 1) {
      throw std::runtime_error("usage nf4 [0|1]");
    }
    std::vector<float> book{-1,
                            -.6961928f,
                            -.52507305f,
                            -.39491749f,
                            -.28444138f,
                            -.18477343f,
                            -.09105004f,
                            0,
                            .07958030f,
                            .16093020f,
                            .24611230f,
                            .33791524f,
                            .44070983f,
                            .562617f,
                            .72295684f,
                            1};
    std::vector<unsigned char> q((N * K + 1) / 2, 0);
    std::vector<float> s(N * Groups), x(K), y(N);
    std::vector<double> gold(N);
    for (int r = 0; r < N; ++r) {
      for (int g = 0; g < Groups; ++g) {
        s[r * Groups + g] = float((r + g) % 9) / 8;
      }
    }
    for (int k = 0; k < K; ++k) {
      x[k] = float(k % 11 - 5) / 8;
    }
    for (int r = 0; r < N; ++r) {
      for (int k = 0; k < K; ++k) {
        int i = r * K + k, code = (r * 3 + k * 7) % 16;
        q[i / 2] |= code << ((i % 2) * 4);
        gold[r] += double(book[code] * s[r * Groups + k / G]) * x[k];
      }
    }
    // RAII封装检查分配和释放错误；设备必须是Thor SM110。
    Buffer<unsigned char> dq(q.size());
    Buffer<float> ds(s.size()), db(16), dx(K), dy(N);
    ck(cudaMemcpy(dq.p, q.data(), q.size(), cudaMemcpyHostToDevice));
    ck(cudaMemcpy(ds.p, s.data(), s.size() * 4, cudaMemcpyHostToDevice));
    ck(cudaMemcpy(db.p, book.data(), 64, cudaMemcpyHostToDevice));
    ck(cudaMemcpy(dx.p, x.data(), K * 4, cudaMemcpyHostToDevice));
    for (int m = 0; m < 2; ++m) {
      if (selected >= 0 && selected != m) {
        continue;
      }
      auto launch = [&] {
        if (m == 0) {
          nf4_scalar<<<(N + 127) / 128, 128>>>(dq.p, ds.p, db.p, dx.p, dy.p);
        } else {
          nf4_warp<<<(N + 3) / 4, 128>>>(dq.p, ds.p, db.p, dx.p, dy.p);
        }
        ck(cudaGetLastError());
      };
      launch();
      ck(cudaDeviceSynchronize());
      ck(cudaMemcpy(y.data(), dy.p, N * 4, cudaMemcpyDeviceToHost));
      for (int r = 0; r < N; ++r) {
        if (!std::isfinite(y[r]) || std::abs(y[r] - gold[r]) > 1e-4) {
          throw std::runtime_error("NF4 kernel mismatch");
        }
      }
      std::cout << "mode=" << m;
      benchmark(launch);
    }
    std::cout << "PASS custom NF4 low-nibble-first SIMT GEMV K=130 N=33; not native Tensor Core\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
