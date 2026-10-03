#include <string>

#include "contract.hpp"
#include "gpu_support.hpp"
// 基线：一行一个CTA，128个线程共享树归约；所有线程参加屏障。
__global__ void energy_cta(const float* a, float* out, int rows, int cols, int stride) {
  __shared__ float partial[128];
  int row = blockIdx.x, t = threadIdx.x;
  float sum = 0;
  for (int c = t; c < cols; c += 128) {
    float v = a[std::size_t(row) * stride + c];
    sum = fmaf(v, v, sum);
  }
  partial[t] = sum;
  __syncthreads();
  for (int d = 64; d > 0; d /= 2) {
    if (t < d) {
      partial[t] += partial[t + d];
    }
    __syncthreads();
  }
  if (t == 0 && row < rows) {
    out[row] = partial[0];
  }
}
// 最终候选：四个warp处理四行，不需要跨warp共享或CTA屏障。
__global__ void energy_warp(const float* a, float* out, int rows, int cols, int stride) {
  int lane = threadIdx.x % 32, row = blockIdx.x * 4 + threadIdx.x / 32;
  float sum = 0;
  // 最后不满四行也不按lane退出；全warp以零贡献参与shuffle。
  if (row < rows) {
    for (int c = lane; c < cols; c += 32) {
      float v = a[std::size_t(row) * stride + c];
      sum = fmaf(v, v, sum);
    }
  }
  sum = warp_sum(sum);
  if (row < rows && lane == 0) {
    out[row] = sum;
  }
}
void launch(int mode, Buffer<float>& a, Buffer<float>& b, Shape s) {
  if (mode == 0) {
    energy_cta<<<s.rows, 128>>>(a.p, b.p, s.rows, s.cols, s.stride);
  } else {
    energy_warp<<<(s.rows + 3) / 4, 128>>>(a.p, b.p, s.rows, s.cols, s.stride);
  }
  ck(cudaGetLastError());
}
void run(Shape s, int selected, bool timing) {
  auto a = input(s);
  auto gold = oracle(a, s);
  std::vector<float> b(s.rows);
  Buffer<float> da(a.size()), db(b.size());
  ck(cudaMemcpy(da.p, a.data(), a.size() * sizeof(float), cudaMemcpyHostToDevice));
  for (int mode = 0; mode < 2; ++mode) {
    if (selected >= 0 && mode != selected) {
      continue;
    }
    ck(cudaMemset(db.p, 0xff, b.size() * sizeof(float)));
    launch(mode, da, db, s);
    ck(cudaDeviceSynchronize());
    ck(cudaMemcpy(b.data(), db.p, b.size() * sizeof(float), cudaMemcpyDeviceToHost));
    compare(b, gold);
    if (timing) {
      cudaFuncAttributes f{};
      int blocks = 0;
      if (mode == 0) {
        ck(cudaFuncGetAttributes(&f, energy_cta));
        ck(cudaOccupancyMaxActiveBlocksPerMultiprocessor(&blocks, energy_cta, 128, 0));
      } else {
        ck(cudaFuncGetAttributes(&f, energy_warp));
        ck(cudaOccupancyMaxActiveBlocksPerMultiprocessor(&blocks, energy_warp, 128, 0));
      }
      std::cout << "mode=" << mode << " rows=" << s.rows << " cols=" << s.cols
                << " regs=" << f.numRegs << " shared=" << f.sharedSizeBytes
                << " local=" << f.localSizeBytes << " resident_blocks_bound=" << blocks;
      benchmark([&] {
        launch(mode, da, db, s);
      });
      // E2E包括H2D、kernel、D2H和等待；排除分配、输入生成和正确性比较。
      std::vector<double> us;
      for (int k = -20; k < 100; ++k) {
        auto start = std::chrono::steady_clock::now();
        ck(cudaMemcpy(da.p, a.data(), a.size() * 4, cudaMemcpyHostToDevice));
        launch(mode, da, db, s);
        ck(cudaMemcpy(b.data(), db.p, b.size() * 4, cudaMemcpyDeviceToHost));
        ck(cudaDeviceSynchronize());
        double dt =
            std::chrono::duration<double, std::micro>(std::chrono::steady_clock::now() - start)
                .count();
        if (k >= 0) {
          us.push_back(dt);
        }
      }
      compare(b, gold);
      std::sort(us.begin(), us.end());
      std::cout << " transfer_kernel_wait_e2e_p50_us=" << us[50] << " p95_us=" << us[94] << '\n';
    }
  }
}
int main(int argc, char** argv) {
  try {
    thor_only();
    if (argc == 2) {
      std::string m = argv[1];
      require(m == "0" || m == "1", "mode 0 or 1");
      run({394, 129, 136}, m == "0" ? 0 : 1, true);
    } else {
      require(argc == 1, "usage: energy [0|1]");
      for (int r : {1, 3, 4, 5, 394}) {
        for (int c : {1, 31, 32, 33, 129, 1025}) {
          run({r, c, c + 7}, -1, false);
        }
      }
      for (int c : {33, 129, 1025, 8192}) {
        run({394, c, c + 7}, -1, true);
      }
    }
    std::cout << "PASS GPU\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
