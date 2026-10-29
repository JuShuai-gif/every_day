#include <array>
#include <atomic>
#include <cstdint>
#include <iostream>
#include <thread>

#include "benchmark.hpp"

constexpr int kThreads = 4, kIterations = 1 << 20;

// 相邻原子量可能共享缓存行并发生 false sharing；padded 让每个线程的写入落在独立缓存行。
struct Padded {
  alignas(64) std::atomic<std::uint64_t> value{0};
};

std::uint64_t crowded() {
  std::array<std::atomic<std::uint64_t>, kThreads> counters{};
  std::array<std::thread, kThreads> threads;
  for (int i = 0; i < kThreads; ++i)
    threads[i] = std::thread([&, i] {
      for (int j = 0; j < kIterations; ++j)
        counters[i].fetch_add(1, std::memory_order_relaxed);
    });
  for (auto& thread : threads)
    thread.join();
  std::uint64_t sum = 0;
  for (auto& counter : counters)
    sum += counter.load();
  return sum;
}

std::uint64_t padded() {
  std::array<Padded, kThreads> counters;
  std::array<std::thread, kThreads> threads;
  for (int i = 0; i < kThreads; ++i)
    threads[i] = std::thread([&, i] {
      for (int j = 0; j < kIterations; ++j)
        counters[i].value.fetch_add(1, std::memory_order_relaxed);
    });
  for (auto& thread : threads)
    thread.join();
  std::uint64_t sum = 0;
  for (auto& counter : counters)
    sum += counter.value.load();
  return sum;
}

int main(int argc, char** argv) {
  std::string mode;
  if (parse_mode(argc, argv, mode))
    return 1;
  const auto baseline = crowded(), optimized = padded();
  if (!require_equal(baseline, optimized))
    return 1;
  std::cout << "correctness=PASS topic=false_sharing threads=4\n";
  if (mode != "optimized")
    print_stats("baseline", sample_us(crowded, 3, 20), baseline);
  if (mode != "baseline")
    print_stats("optimized", sample_us(padded, 3, 20), optimized);
}
