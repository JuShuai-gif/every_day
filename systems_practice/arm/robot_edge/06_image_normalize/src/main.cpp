#include <iostream>

#include "../tests/cases.hpp"
#include "edge_bench.hpp"
#include "pipeline.hpp"

int main(int argc, char** argv) {
  return edge::main_entry(argc, argv, [](const edge::Options& options) {
    if (!options.profile) {
      normalize::self_test();
    }
    if (options.test_only) {
      std::cout << "correctness=PASS\n";
      return;
    }

    const auto frame = normalize::make_frame(1280, 720, 64);
    const normalize::Parameters parameters;
    std::vector<float> output(frame.width * frame.height * 3);
    if (!options.profile) {
      normalize::verify(frame, parameters);
      std::cout << "correctness=PASS\n";
    }
    std::cout << "workload=RGB8_strided_to_NCHW width=" << frame.width << " height=" << frame.height
              << " stride_bytes=" << frame.stride << " output_values=" << output.size()
              << " optimized_backend=" << normalize::backend() << " tolerance_abs=0.000002\n";

    const auto execute = [&](normalize::Mode mode) {
      normalize::run(frame, parameters, mode, output);
      // 让完整输出对优化器可见；抽样 token 只维持可观察性，正确性在计时外逐元素比较。
      edge::escape(output.data());
      edge::clobber();
      return normalize::token(output);
    };
    edge::benchmark(options,
                    {{"baseline",
                      [&] {
                        return execute(normalize::Mode::Multipass);
                      }},
                     {"stage1",
                      [&] {
                        return execute(normalize::Mode::Fused);
                      }},
                     {"optimized",
                      [&] {
                        return execute(normalize::Mode::Vectorized);
                      }}},
                    frame.width * frame.height);
  });
}
