#include <array>
#include <iostream>

#include "direct_pool.hpp"
#include "options.hpp"
#include "pooling.hpp"

// 仅检验索引、有效字节与补零契约；不能模拟 CUDA 异步内存模型。
std::vector<float> staged_reference(const practice::Shape& s, const std::vector<float>& input) {
  std::vector<float> output(s.output_size());
  for (int b = 0; b < s.batch; ++b) {
    for (int tile = 0; tile < s.tiles(); ++tile) {
      std::array<float, practice::kRows * practice::kColumns> shared;
      shared.fill(std::numeric_limits<float>::quiet_NaN());
      for (int thread = 0; thread < 256; ++thread) {
        const int row = thread / 32;
        const int col = thread % 32 * 4;
        const int token = tile * practice::kRows + row;
        const int bytes = practice::valid_bytes(token < s.tokens, col, s.channels);
        for (int j = 0; j < 4; ++j) {
          shared[row * practice::kColumns + col + j] =
              j * int(sizeof(float)) < bytes
                  ? input[(std::size_t(b) * s.tokens + token) * s.stride() + col + j]
                  : 0.0F;
        }
      }
      // 所有未写入的通道和 token 均应为零，不能只验证最终有效输出。
      for (int row = 0; row < practice::kRows; ++row) {
        for (int col = 0; col < practice::kColumns; ++col) {
          const float value = shared[row * practice::kColumns + col];
          if (!std::isfinite(value) ||
              ((tile * practice::kRows + row >= s.tokens || col >= s.channels) && value != 0.0F)) {
            throw std::runtime_error("tile zero-fill contract failed");
          }
        }
      }
      const int count = std::min(practice::kRows, s.tokens - tile * practice::kRows);
      for (int col = 0; col < s.channels; ++col) {
        float sum = 0;
        for (int row = 0; row < practice::kRows; ++row) {
          sum += shared[row * practice::kColumns + col];
        }
        output[(std::size_t(b) * s.tiles() + tile) * s.channels + col] = sum / count;
      }
    }
  }
  return output;
}

int main() {
  try {
    // 扫过所有通道尾数及 token 边界，覆盖 0/4/8/12/16 有效字节。
    int cases = 0;
    for (int channels = 1; channels <= 128; ++channels) {
      for (int tokens : {1, 7, 8, 9, 197}) {
        const practice::Shape s{2, tokens, channels};
        const auto input = practice::make_input(s);
        const auto expected = practice::reference(s, input);
        practice::check(staged_reference(s, input), expected);
        // NaN 哨兵能发现漏写；每个逻辑输出还必须恰有一个 lane 拥有。
        std::vector<float> direct(s.output_size(), std::numeric_limits<float>::quiet_NaN());
        std::vector<int> owners(s.output_size(), 0);
        for (int group = 0; group < s.batch * s.tiles(); ++group) {
          for (int lane = 0; lane < 32; ++lane) {
            practice::direct_lane(input.data(),
                                  direct.data(),
                                  s.tokens,
                                  s.channels,
                                  s.stride(),
                                  s.tiles(),
                                  group,
                                  lane);
            for (int column = lane; column < s.channels; column += 32) {
              ++owners[group * s.channels + column];
            }
          }
        }
        practice::check(direct, expected);
        if (!std::all_of(owners.begin(), owners.end(), [](int count) {
              return count == 1;
            })) {
          throw std::runtime_error("direct output ownership violation");
        }
        ++cases;
      }
    }
    for (const auto s :
         {practice::Shape{0, 8, 64}, practice::Shape{1, 0, 64}, practice::Shape{1, 8, 129}}) {
      bool rejected = false;
      try {
        s.validate();
      } catch (const std::invalid_argument&) {
        rejected = true;
      }
      if (!rejected) {
        throw std::runtime_error("invalid shape accepted");
      }
    }
    if (practice::parse_options({}).variants.front() != practice::Variant::Optimized ||
        practice::parse_options({"--variant", "all"}).variants.size() != 3 ||
        !practice::parse_options({"--profile", "optimized"}).profile ||
        !practice::parse_options({"--sweep"}).sweep) {
      throw std::runtime_error("variant/profile dispatch failed");
    }
    for (const auto args : {std::vector<std::string>{"--profile", "all"},
                            std::vector<std::string>{"--variant", "unknown"}}) {
      bool rejected = false;
      try {
        practice::parse_options(args);
      } catch (const std::invalid_argument&) {
        rejected = true;
      }
      if (!rejected) {
        throw std::runtime_error("invalid profile mode accepted");
      }
    }
    std::cout << "PASS " << cases
              << " CPU tile + final direct contracts; single-writer outputs, CLI/profile "
                 "selection, poison padding, zero fill, "
              << "3 invalid shapes; GPU/PTX NOT validated\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
