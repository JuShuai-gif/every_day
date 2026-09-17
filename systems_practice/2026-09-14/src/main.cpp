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
  // 平凡析构对象可不进析构链：帧 reset 时只需整体复用字节。
  float velocity[6]{};
  std::uint64_t frame_id = 0;
};
struct ManagedTelemetry {
  explicit ManagedTelemetry(std::atomic<int>& destroyed) noexcept : destroyed_(destroyed) {}
  ~ManagedTelemetry() {
    // 用计数验证受管对象不会在 worker 返回前被提前析构。
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
  // 复制后排序，保留原始样本便于后续扩展更多统计量。
  std::sort(values.begin(), values.end());
  return values[static_cast<std::size_t>((values.size() - 1) * ratio)];
}
int main() {
  try {
    // 第一段：模拟四个视觉/状态 worker 向同一控制帧写入临时 command。
    constexpr int kWorkers = 4, kPerWorker = 64;
    FrameArena arena(kWorkers * kPerWorker * sizeof(ControlCommand) + 4096);
    std::atomic<int> made{0}, destroyed{0};
    std::vector<std::thread> workers;
    // 每个 worker 的 Producer 是帧内写权限；离开 lambda 自动归还。
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
    // join 是业务层同步点；之后控制线程才独占本帧的生命周期。
    if (made != kWorkers * kPerWorker || arena.used_bytes() == 0)
      throw std::runtime_error("concurrent allocation failed");
    arena.reset_after_join();  // join 是业务层同步；allocator 的原子操作不能替代它。
    if (destroyed != kWorkers || arena.used_bytes() != 0)
      throw std::runtime_error("managed destruction/reset failed");
    bool busy_reset_rejected = false;
    // 第二段：故意保留租约，验证提前 reset 不会悄悄释放仍在使用的存储。
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
    // 第三段：微基准复用池，只比较分配/关闭路径，不测线程创建或相机推理。
    FrameArena benchmark_pool(kCommands * sizeof(ControlCommand) + 64);
    volatile std::uint64_t checksum = 0;
    auto run_arena = [&] {
      // 复用同一个池，计时只覆盖每帧分配/关闭，不把初始化 vector 分配混入结果。
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
      // 此处裸 new/delete 仅作为内存管理主题的逐对象分配对照。
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
    // 这些仅是 CPU 微基准；不能解释为端到端机器人控制时延。
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
