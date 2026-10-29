#include <cstdint>
#include <iostream>
#include <memory>
#include <vector>

#include "benchmark.hpp"

struct Node {
  std::uint64_t value;
};

// 基线逐对象进入通用堆；优化版一次申请连续对象池，帧尾由 vector 整体回收。
std::uint64_t heap_objects(int count) {
  std::vector<std::unique_ptr<Node>> nodes;
  nodes.reserve(count);
  for (int i = 0; i < count; ++i)
    nodes.emplace_back(new Node{std::uint64_t(i)});
  do_not_optimize(nodes.data());
  std::uint64_t sum = 0;
  for (const auto& node : nodes)
    sum += node->value;
  return sum;
}

std::uint64_t pool_objects(int count) {
  std::vector<Node> nodes(count);
  for (int i = 0; i < count; ++i)
    nodes[i].value = i;
  do_not_optimize(nodes.data());
  std::uint64_t sum = 0;
  for (const auto& node : nodes)
    sum += node.value;
  return sum;
}

int main(int argc, char** argv) {
  std::string mode;
  if (parse_mode(argc, argv, mode))
    return 1;
  constexpr int count = 1 << 18;
  const auto baseline = heap_objects(count), optimized = pool_objects(count);
  if (!require_equal(baseline, optimized))
    return 1;
  std::cout << "correctness=PASS topic=allocation_pool\n";
  if (mode != "optimized")
    print_stats("baseline", sample_us([&] {
                  volatile auto x = heap_objects(count);
                  (void)x;
                }),
                baseline);
  if (mode != "baseline")
    print_stats("optimized", sample_us([&] {
                  volatile auto x = pool_objects(count);
                  (void)x;
                }),
                optimized);
}
