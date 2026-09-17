#include <algorithm>
#include <array>
#include <chrono>
#include <cstdint>
#include <iostream>
#include <stdexcept>
#include <vector>

#include "frame_arena.hpp"

struct alignas(64) CameraToken {
  std::uint64_t frame_id = 0;
  std::array<float, 12> pose{};
};

struct DestructionProbe {
  explicit DestructionProbe(std::vector<int>& trace, int id) : trace_(trace), id_(id) {}
  ~DestructionProbe() {
    trace_.push_back(id_);
  }
  std::vector<int>& trace_;
  int id_;
};

struct ControlCommand {
  float velocity[6]{};
  std::uint64_t timestamp = 0;
};

template <typename F>
double measure_us(F&& action) {
  const auto start = std::chrono::steady_clock::now();
  action();
  const auto end = std::chrono::steady_clock::now();
  return std::chrono::duration<double, std::micro>(end - start).count();
}

double percentile(std::vector<double> samples, double ratio) {
  std::sort(samples.begin(), samples.end());
  return samples[static_cast<std::size_t>((samples.size() - 1) * ratio)];
}

int main() {
  try {
    FrameArena arena(4096, 8);
    auto* token = arena.make<CameraToken>();
    if (reinterpret_cast<std::uintptr_t>(token) % alignof(CameraToken) != 0) {
      throw std::runtime_error("64-byte alignment check failed");
    }
    std::vector<int> destruction_trace;
    arena.make<DestructionProbe>(destruction_trace, 1);
    arena.make<DestructionProbe>(destruction_trace, 2);
    arena.reset();
    if (destruction_trace != std::vector<int>{2, 1} || arena.used_bytes() != 0) {
      throw std::runtime_error("reverse destruction or reset check failed");
    }

    FrameArena tiny(32, 1);
    bool out_of_memory = false;
    try {
      (void)tiny.make<CameraToken>();
    } catch (const std::bad_alloc&) {
      out_of_memory = true;
    }
    if (!out_of_memory || tiny.used_bytes() != 0) {
      throw std::runtime_error("capacity failure must not corrupt arena state");
    }

    constexpr int kCommands = 256;
    constexpr int kWarmup = 20;
    constexpr int kSamples = 100;
    volatile std::uint64_t checksum = 0;  // 防止基准循环被完全消除。
    FrameArena frame_pool(sizeof(ControlCommand) * kCommands + 64, 0);
    auto run_arena = [&] {
      for (int i = 0; i < kCommands; ++i) {
        auto* command = frame_pool.make<ControlCommand>();
        command->timestamp = static_cast<std::uint64_t>(i);
        checksum += command->timestamp;
      }
      frame_pool.reset();  // 计时只含每帧 bump 分配，不含池的初始化分配。
    };
    auto run_heap = [&] {
      std::array<ControlCommand*, kCommands> commands{};
      for (int i = 0; i < kCommands; ++i) {
        commands[i] = new ControlCommand{};  // 仅作为内存管理主题的对照。
        commands[i]->timestamp = static_cast<std::uint64_t>(i);
      }
      for (auto* command : commands) {
        checksum += command->timestamp;
        delete command;
      }
    };
    for (int i = 0; i < kWarmup; ++i) {
      run_arena();
      run_heap();
    }
    std::vector<double> arena_samples, heap_samples;
    arena_samples.reserve(kSamples);
    heap_samples.reserve(kSamples);
    for (int i = 0; i < kSamples; ++i) {
      arena_samples.push_back(measure_us(run_arena));
      heap_samples.push_back(measure_us(run_heap));
    }
    std::cout << "correctness=PASS alignment=64 reverse_destruction=PASS oom_rollback=PASS\n";
    std::cout << "arena_us p50=" << percentile(arena_samples, 0.50)
              << " p95=" << percentile(arena_samples, 0.95) << "\n";
    std::cout << "heap_us p50=" << percentile(heap_samples, 0.50)
              << " p95=" << percentile(heap_samples, 0.95) << "\n";
    std::cout << "checksum=" << checksum << "\n";
  } catch (const std::exception& error) {
    std::cerr << "FAIL: " << error.what() << '\n';
    return 1;
  }
}
