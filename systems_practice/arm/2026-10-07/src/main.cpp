#include <algorithm>
#include <chrono>
#include <cstdint>
#include <iostream>
#include <numeric>
#include <random>
#include <stdexcept>
#include <vector>
// 128字节是人为步长，不宣称它等于目标CPU cache line。
struct alignas(128) Node {
  std::size_t next = 0;
  char padding[128 - sizeof(std::size_t)]{};
};
volatile std::size_t sink = 0;
extern "C" __attribute__((noinline)) std::size_t chase(const Node* nodes,
                                                       std::size_t p,
                                                       std::size_t steps) {
  for (std::size_t i = 0; i < steps; ++i) {
    p = nodes[p].next;
  }
  return p;
}
std::vector<Node> make_ring(std::size_t n, bool random) {
  if (n == 0) {
    throw std::invalid_argument("empty ring");
  }
  std::vector<Node> nodes(n);
  std::vector<std::size_t> order(n);
  std::iota(order.begin(), order.end(), 0);
  std::mt19937 engine(7);
  if (random) {
    std::shuffle(order.begin(), order.end(), engine);
  }
  for (std::size_t i = 0; i < n; ++i) {
    nodes[order[i]].next = order[(i + 1) % n];
  }
  std::vector<bool> visited(n, false);
  std::size_t p = 0;
  for (std::size_t i = 0; i < n; ++i) {
    if (p >= n || visited[p]) {
      throw std::runtime_error("not one cycle");
    }
    visited[p] = true;
    p = nodes[p].next;
  }
  if (p != 0 || chase(nodes.data(), 0, n) != 0) {
    throw std::runtime_error("cycle oracle");
  }
  return nodes;
}
int main(int argc, char**) {
  try {
    bool rejected = false;
    try {
      make_ring(0, true);
    } catch (const std::invalid_argument&) {
      rejected = true;
    }
    if (!rejected) {
      return 1;
    }
    for (std::size_t n : {1, 2, 3, 31, 32, 33, 1025}) {
      for (bool random : {false, true}) {
        make_ring(n, random);
      }
    }
    if (argc > 1) {
      std::cout << "PASS boundary_rings=14 zero_rejected=1\n";
      return 0;
    }
    using Clock = std::chrono::steady_clock;
    std::cout << "bytes,pattern,p50_ns_per_dependent_load,p95_ns_per_dependent_load\n";
    for (std::size_t bytes : {4096, 32768, 131072, 1048576, 8388608, 33554432}) {
      for (bool random : {false, true}) {
        auto nodes = make_ring(bytes / sizeof(Node), random);
        const std::size_t steps = std::max<std::size_t>(nodes.size() * 2, 262144);
        // 先触页并跑完整环；每个样本是整批追逐均值，不是请求延迟分位。
        sink = chase(nodes.data(), 0, steps);
        std::vector<double> samples;
        for (int i = 0; i < 11; ++i) {
          auto start = Clock::now();
          auto end = chase(nodes.data(), 0, steps);
          auto stop = Clock::now();
          sink = end;
          samples.push_back(std::chrono::duration<double, std::nano>(stop - start).count() / steps);
        }
        std::sort(samples.begin(), samples.end());
        std::cout << bytes << ',' << (random ? "random" : "sequential") << ',' << samples[5] << ','
                  << samples[10] << '\n';
      }
    }
    std::cout << "PASS boundary_rings=14 zero_rejected=1 sink=" << sink << '\n';
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
