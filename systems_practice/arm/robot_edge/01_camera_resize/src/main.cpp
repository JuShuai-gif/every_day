#include <array>
#include <iostream>

#include "camera.hpp"
#include "edge_bench.hpp"

int main(int argc, char** argv) {
  return edge::main_entry(argc, argv, [](const edge::Options& options) {
    if (!options.profile) {
      camera::self_test();
      std::cout << "correctness=PASS\n";
    }
    if (options.test_only)
      return;

    std::vector<camera::Frame> frames;
    for (unsigned i = 0; i < 8; ++i)
      frames.push_back(camera::make_frame(640, 480, 32, 42 + i));
    const camera::Roi roi{3, 2, 633, 475};
    std::array<camera::Result, 3> reports;
    std::cout << "workload=8_frames_640x480_stride672_roi633x475 queue_capacity=3"
                 " queue_policy=blocking_backpressure input=deterministic_replay"
                 " timing_scope=thread_start_queue_preprocess_hash_join unit=frame"
              << " optimized_backend=" << camera::optimized_backend() << '\n';

    const auto run = [&](std::size_t index, camera::Mode mode) {
      reports[index] = camera::pipeline(frames, roi, mode, 3);
      return reports[index].digest;
    };
    edge::benchmark(options,
                    {{"baseline",
                      [&] {
                        return run(0, camera::Mode::baseline);
                      }},
                     {"stage1",
                      [&] {
                        return run(1, camera::Mode::stage1);
                      }},
                     {"optimized",
                      [&] {
                        return run(2, camera::Mode::optimized);
                      }}},
                    frames.size());

    const char* names[] = {"baseline", "stage1", "optimized"};
    for (std::size_t i = 0; i < reports.size(); ++i) {
      if (reports[i].processed == 0)
        continue;
      std::cout << "last_batch_mode=" << names[i] << " frames=" << reports[i].processed
                << " queue_high_water=" << reports[i].queue_high_water
                << " dropped=0 frame_queue_plus_processing_p95_us="
                << edge::quantile(reports[i].frame_us, .95) << '\n';
    }
  });
}
