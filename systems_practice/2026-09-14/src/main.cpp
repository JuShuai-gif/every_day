#include <algorithm>
#include <array>
#include <atomic>
#include <chrono>
#include <cstdint>
#include <iostream>
#include <stdexcept>
#include <thread>
#include <vector>

#include "frame_arena.hpp"

struct ControlCommand {
  float velocity[6]{};
  std::uint64_t frame_id = 0;
};
struct ManagedTelemetry {
  explicit ManagedTelemetry(std::atomic<int>& destroyed) noexcept : destroyed_(destroyed) {}
  ~ManagedTelemetry() {
    destroyed_.fetch_add(1, std::memory_order_relaxed);
  }
  std::atomic<int>& destroyed_;
};
template <typename F>
double measure_us(F&& action) {
  const auto begin = std::chrono::steady_clock::now();
  action();
  return std::chrono::duration<double, std::micro>(std::chrono::steady_clock::now() - begin)
      .count();
}
double percentile(std::vector<double> values, double ratio) {
  std::sort(values.begin(), values.end());
  return values[static_cast<std::size_t>((values.size() - 1) * ratio)];
}
int main() {
  try {
    constexpr int kWorkers = 4, kPerWorker = 64;
    FrameArena arena(kWorkers * kPerWorker * sizeof(ControlCommand) + 4096);
    std::atomic<int> made{0}, destroyed{0};
    std::vector<std::thread> workers;
    for (int worker = 0; worker < kWorkers; ++worker)
      workers.emplace_back([&] {
        auto producer = arena.acquire_producer();
        (void)arena.managed_new<ManagedTelemetry>(producer, destroyed);
        for (int i = 0; i < kPerWorker; ++i) {
          auto* command = arena.make<ControlCommand>(producer);
          command->frame_id = static_cast<std::uint64_t>(made.fetch_add(1));
        }
      });
    for (auto& worker : workers) worker.join();
    if (made != kWorkers * kPerWorker || arena.used_bytes() == 0)
      throw std::runtime_error("concurrent allocation failed");
    arena.reset_after_join();
    if (destroyed != kWorkers || arena.used_bytes() != 0)
      throw std::runtime_error("managed destruction/reset failed");
    bool busy_reset_rejected = false;
    auto held = arena.acquire_producer();
    try {
      arena.reset_after_join();
    } catch (const std::logic_error&) {
      busy_reset_rejected = true;
    }
    held = {};
    if (!busy_reset_rejected)
      throw std::runtime_error("active producer reset was not rejected");
    constexpr int kCommands = 256, kWarmup = 20, kSamples = 100;
    FrameArena benchmark_pool(kCommands * sizeof(ControlCommand) + 64);
    volatile std::uint64_t checksum = 0;
    auto run_arena = [&] {
      auto producer = benchmark_pool.acquire_producer();
      for (int i = 0; i < kCommands; ++i) {
        auto* command = benchmark_pool.make<ControlCommand>(producer);
        command->frame_id = static_cast<std::uint64_t>(i);
        checksum += command->frame_id;
      }
      producer = {};
      benchmark_pool.reset_after_join();
    };
    auto run_heap = [&] {
      std::array<ControlCommand*, kCommands> commands{};
      for (int i = 0; i < kCommands; ++i) {
        commands[i] = new ControlCommand{};
        commands[i]->frame_id = static_cast<std::uint64_t>(i);
      }
      for (auto* command : commands) {
        checksum += command->frame_id;
        delete command;
      }
    };
    for (int i = 0; i < kWarmup; ++i) {
      run_arena();
      run_heap();
    }
    std::vector<double> arena_samples, heap_samples;
    for (int i = 0; i < kSamples; ++i) {
      arena_samples.push_back(measure_us(run_arena));
      heap_samples.push_back(measure_us(run_heap));
    }
    std::cout << "correctness=PASS workers=4 managed_destruction=PASS reset_gate=PASS\n";
    std::cout << "arena_us p50=" << percentile(arena_samples, .50)
              << " p95=" << percentile(arena_samples, .95) << '\n';
    std::cout << "heap_us p50=" << percentile(heap_samples, .50)
              << " p95=" << percentile(heap_samples, .95) << '\n';
    std::cout << "checksum=" << checksum << '\n';
  } catch (const std::exception& error) {
    std::cerr << "FAIL: " << error.what() << '\n';
    return 1;
  }
}
