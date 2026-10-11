#include <sys/mman.h>
#include <sys/resource.h>
#include <unistd.h>

#include <algorithm>
#include <chrono>
#include <cstdint>
#include <cstring>
#include <iostream>
#include <numeric>
#include <random>
#include <stdexcept>
#include <vector>

struct Mapping {
  unsigned char* data;
  std::size_t bytes;
  explicit Mapping(std::size_t n) : data(nullptr), bytes(n) {
    if (n == 0) {
      throw std::invalid_argument("empty mapping");
    }
    void* p = mmap(nullptr, n, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANON, -1, 0);
    if (p == MAP_FAILED) {
      throw std::runtime_error("mmap");
    }
    data = static_cast<unsigned char*>(p);
  }
  ~Mapping() {
    if (munmap(data, bytes) != 0) {
      std::cerr << "munmap failed\n";
    }
  }
  Mapping(const Mapping&) = delete;
  Mapping& operator=(const Mapping&) = delete;
};
long faults() {
  rusage r{};
  if (getrusage(RUSAGE_SELF, &r) != 0) {
    throw std::runtime_error("getrusage");
  }
  return r.ru_minflt;
}
// 每个节点保存下一个字节偏移；memcpy允许无对齐别名假设，A64应观察到依赖LDR。
__attribute__((noinline)) std::uint64_t chase(const unsigned char* p,
                                              std::uint64_t offset,
                                              std::size_t count) {
  for (std::size_t i = 0; i < count; ++i) {
    std::memcpy(&offset, p + offset, sizeof(offset));
  }
  return offset;
}
volatile std::uint64_t sink = 0;
void trial(std::size_t nodes, std::size_t stride, std::size_t page) {
  Mapping mem(nodes * stride);
  std::vector<std::size_t> order(nodes);
  std::iota(order.begin(), order.end(), 0);
  std::mt19937 gen(1011);
  std::shuffle(order.begin(), order.end(), gen);
  const long before = faults();
  for (std::size_t i = 0; i < nodes; ++i) {
    const std::uint64_t next = order[(i + 1) % nodes] * stride;
    std::memcpy(mem.data + order[i] * stride, &next, sizeof(next));
  }
  const long first_touch = faults() - before;
  const auto start = order.front() * stride;
  if (chase(mem.data, start, nodes) != start) {
    throw std::runtime_error("broken ring");
  }
  sink = chase(mem.data, start, 2 * nodes);
  const std::size_t loads = 262144;
  const long warmed = faults();
  std::vector<double> times;
  for (int sample = 0; sample < 11; ++sample) {
    const auto t0 = std::chrono::steady_clock::now();
    sink = chase(mem.data, start, loads);
    const auto t1 = std::chrono::steady_clock::now();
    times.push_back(std::chrono::duration<double, std::nano>(t1 - t0).count() / loads);
  }
  std::sort(times.begin(), times.end());
  std::cout << "nodes=" << nodes << " stride=" << stride << " reserved_bytes=" << nodes * stride
            << " virtual_pages=" << (nodes * stride + page - 1) / page
            << " first_touch_minflt=" << first_touch << " warm_minflt=" << faults() - warmed
            << " ns_per_load_p50=" << times[5] << " p95=" << times[10] << '\n';
}
int main() {
  try {
    const long raw = sysconf(_SC_PAGESIZE);
    if (raw <= 0) {
      throw std::runtime_error("page size query");
    }
    const auto page = static_cast<std::size_t>(raw);
    std::cout << "host_page_bytes=" << page << " sample=262144 dependent CPU loads\n";
    for (auto nodes : {std::size_t{1}, std::size_t{16}, std::size_t{256}, std::size_t{4096}}) {
      trial(nodes, 64, page);
      trial(nodes, page, page);
    }
    bool rejected = false;
    try {
      Mapping bad(0);
    } catch (const std::invalid_argument&) {
      rejected = true;
    }
    if (!rejected) {
      throw std::runtime_error("empty rejection");
    }
    std::cout << "PASS 8 rings, rejected zero; TLB counters and board unverified\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
