#pragma once

#include "pooling.hpp"

#if defined(__CUDACC__)
#define PRACTICE_HD __host__ __device__
#else
#define PRACTICE_HD
#endif

namespace practice {
// 同一份索引/累加逻辑供 CPU 验证和真实 CUDA kernel 使用。
// 每个 lane 拥有独立输出，完全不需要线程之间传递中间结果。
PRACTICE_HD inline void direct_lane(const float* input,
                                    float* output,
                                    int tokens,
                                    int channels,
                                    int stride,
                                    int tiles,
                                    int group_id,
                                    int lane) {
  const int batch = group_id / tiles;
  const int group = group_id % tiles;
  const int first = group * kRows;
  const int remaining = tokens - first;
  const int count = remaining < kRows ? remaining : kRows;
  float sums[4] = {0, 0, 0, 0};
#if defined(__CUDACC__)
#pragma unroll
#endif
  for (int row = 0; row < kRows; ++row) {
#if defined(__CUDACC__)
#pragma unroll
#endif
    for (int slot = 0; slot < 4; ++slot) {
      const int column = lane + slot * 32;
      if (row < count && column < channels) {
        // 相邻 lane 读取相邻通道；不同 slot 累加链相互独立。
        sums[slot] += input[(batch * tokens + first + row) * stride + column];
      }
    }
  }
#if defined(__CUDACC__)
#pragma unroll
#endif
  for (int slot = 0; slot < 4; ++slot) {
    const int column = lane + slot * 32;
    if (column < channels) {
      output[group_id * channels + column] = sums[slot] / count;
    }
  }
}
}  // namespace practice

#undef PRACTICE_HD
