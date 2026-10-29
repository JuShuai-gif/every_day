#include <algorithm>  // std::sort。
#include <array>      // 堆分配对照所用的固定指针数组。
#include <atomic>     // worker 间共享的计数器。
#include <chrono>     // 稳态时钟和微秒换算。
#include <cstdint>    // std::uint64_t。
#include <iostream>   // 标准输出与错误输出。
#include <stdexcept>  // 测试失败时抛出的异常。
#include <thread>     // std::thread。
#include <vector>     // 性能样本。

#include "frame_arena.hpp"  // 本练习实现的固定容量、帧生命周期 arena。

struct ControlCommand {
  // 平凡析构对象可不进析构链：帧 reset 时只需整体复用字节。
  float velocity[6]{};
  std::uint64_t frame_id = 0;
};
struct ManagedTelemetry {
  // 保存引用而不拥有计数器；对象析构时只记录一次析构事件。
  explicit ManagedTelemetry(std::atomic<int>& destroyed) noexcept : destroyed_(destroyed) {
  }
  ~ManagedTelemetry() {
    // 用计数验证受管对象不会在 worker 返回前被提前析构。
    destroyed_.fetch_add(1, std::memory_order_relaxed);
  }
  std::atomic<int>& destroyed_;
};
// 测量一次可调用对象的运行时间，单位为微秒；不包含任何统计汇总。
template <typename F>
double measure_us(F&& action) {
  const auto begin = std::chrono::steady_clock::now();
  action();
  return std::chrono::duration<double, std::micro>(std::chrono::steady_clock::now() - begin)
      .count();
}
// 返回排序样本中 ratio 对应的离散位置。本例只传入 .50 和 .95。
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
    // made 记录生成的 command 数；destroyed 记录受管对象析构次数。
    std::atomic<int> made{0}, destroyed{0};
    std::vector<std::thread> workers;
    // 每个 worker 的 Producer 是帧内写权限；离开 lambda 自动归还。
    for (int worker = 0; worker < kWorkers; ++worker) {
      workers.emplace_back([&] {  // 每个线程独立获取租约，但共享同一个 arena。
        auto producer = arena.acquire_producer();
        (void)arena.managed_new<ManagedTelemetry>(producer, destroyed);
        for (int i = 0; i < kPerWorker; ++i) {
          auto* command = arena.make<ControlCommand>(producer);
          command->frame_id = static_cast<std::uint64_t>(made.fetch_add(1));
        }
      });
    }

    for (auto& worker : workers) {
      worker.join();
    }
    // join 是业务层同步点；之后控制线程才独占本帧的生命周期。
    if (made != kWorkers * kPerWorker || arena.used_bytes() == 0) {
      throw std::runtime_error("concurrent allocation failed");
    }
    arena.reset_after_join();  // join 是业务层同步；allocator 的原子操作不能替代它。
    if (destroyed != kWorkers || arena.used_bytes() != 0) {
      throw std::runtime_error("managed destruction/reset failed");
    }
    bool busy_reset_rejected = false;
    // 第二段：故意保留租约，验证提前 reset 不会悄悄释放仍在使用的存储。
    auto held = arena.acquire_producer();  // 保持租约，模拟仍在工作的 worker。
    try {
      arena.reset_after_join();
    } catch (const std::logic_error&) {
      busy_reset_rejected = true;
    }
    held = {};  // 移动赋值一个空租约，立即执行原租约的 release()。
    if (!busy_reset_rejected) {
      throw std::runtime_error("active producer reset was not rejected");
    }
    constexpr int kCommands = 256, kWarmup = 20, kSamples = 100;
    // 第三段：微基准复用池，只比较分配/关闭路径，不测线程创建或相机推理。
    FrameArena benchmark_pool(kCommands * sizeof(ControlCommand) + 64);
    // 防止基准循环中对 command 的写入与读取被完全优化掉。
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
    // 分别保存 arena 和逐对象堆分配的每轮耗时，用于计算 p50/p95。
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
