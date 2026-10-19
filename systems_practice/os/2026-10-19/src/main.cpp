#ifndef _GNU_SOURCE
#define _GNU_SOURCE
#endif
#include <sys/resource.h>

#include <chrono>
#include <cstdint>
#include <cstring>
#include <iostream>
#include <stdexcept>
#include <string>
#include <thread>
#include <vector>
#if defined(__linux__)
#include <sched.h>
#endif
using Clock = std::chrono::steady_clock;
class Joiner {
 public:
  std::vector<std::thread> threads;
  ~Joiner() {
    join();
  }
  void join() {
    for (auto& t : threads) {
      if (t.joinable()) {
        t.join();
      }
    }
  }
};
class Affinity {
#if defined(__linux__)
  cpu_set_t saved_{};
  bool changed_ = false;
#endif
 public:
  explicit Affinity(bool pin) {
#if defined(__linux__)
    if (sched_getaffinity(0, sizeof(saved_), &saved_) != 0) {
      throw std::runtime_error(std::string("getaffinity: ") + std::strerror(errno));
    }
    int first = -1, count = 0;
    for (int i = 0; i < CPU_SETSIZE; ++i) {
      if (CPU_ISSET(i, &saved_)) {
        if (first < 0) {
          first = i;
        }
        ++count;
      }
    }
    std::cout << "allowed=" << count << " first_allowed=" << first << "\n";
    if (pin) {
      if (first < 0) {
        throw std::runtime_error("empty allowed mask");
      }
      cpu_set_t mask;
      CPU_ZERO(&mask);
      CPU_SET(first, &mask);
      if (sched_setaffinity(0, sizeof(mask), &mask) != 0) {
        throw std::runtime_error(std::string("setaffinity: ") + std::strerror(errno));
      }
      changed_ = true;
    }
#else
    if (pin) {
      throw std::invalid_argument("--pin requires Linux; no macOS CPU binding claim");
    }
    std::cout << "affinity=unavailable_on_host\n";
#endif
  }
  ~Affinity() {
#if defined(__linux__)
    if (changed_ && sched_setaffinity(0, sizeof(saved_), &saved_) != 0) {
      std::cerr << "restore affinity failed: " << std::strerror(errno) << "\n";
    }
#endif
  }
};
rusage usage() {
  rusage r{};
  if (getrusage(RUSAGE_SELF, &r) != 0) {
    throw std::runtime_error("getrusage");
  }
  return r;
}
double cpu_seconds(const rusage& r) {
  return r.ru_utime.tv_sec + r.ru_stime.tv_sec + (r.ru_utime.tv_usec + r.ru_stime.tv_usec) * 1e-6;
}
uint64_t work(size_t begin, size_t end) {
  uint64_t s = 0;
  for (size_t i = begin; i < end; ++i) {
    uint64_t x = i;
    for (int k = 0; k < 32; ++k) {
      x = x * 6364136223846793005ULL + 1442695040888963407ULL;
      x ^= x >> 29;
    }
    s += x;
  }
  return s;
}
void observe(size_t workers, size_t total) {
  if (workers == 0 || workers > 32) {
    throw std::invalid_argument("workers must be 1..32");
  }
  std::vector<uint64_t> sums(workers);
  Joiner group;
  group.threads.reserve(workers);
  auto before = usage();
  auto start = Clock::now();
  for (size_t t = 0; t < workers; ++t) {
    group.threads.emplace_back([&, t] {
      sums[t] = work(total * t / workers, total * (t + 1) / workers);
    });
  }
  group.join();
  const auto wall = std::chrono::duration<double, std::milli>(Clock::now() - start).count();
  const auto after = usage();
  uint64_t sum = 0;
  for (auto x : sums) {
    sum += x;
  }
  if (sum != work(0, total)) {
    throw std::runtime_error("partition mismatch");
  }
  std::cout << "workers=" << workers << " jobs=" << total << " launch_join_wall_ms=" << wall
            << " process_cpu_ms=" << 1000 * (cpu_seconds(after) - cpu_seconds(before))
            << " voluntary=" << after.ru_nvcsw - before.ru_nvcsw
            << " involuntary=" << after.ru_nivcsw - before.ru_nivcsw << " checksum=" << sum << "\n";
}
int main(int argc, char** argv) {
  try {
    bool pin = argc == 2 && std::string(argv[1]) == "--pin";
    if (argc > 2 || (argc == 2 && !pin)) {
      throw std::invalid_argument("usage: practice [--pin]");
    }
    Affinity affinity(pin);
    observe(1, 0);
    observe(4, 3);
    bool rejected = false;
    try {
      observe(0, 1);
    } catch (const std::invalid_argument&) {
      rejected = true;
    }
    if (!rejected) {
      throw std::runtime_error("zero workers accepted");
    }
    // 一次固定总工作量观察，不将此日志解释为P95或因果性能结论。
    for (size_t workers : {1, 2, 4, 8}) {
      observe(workers, 200000);
    }
    std::cout << "PASS checksum/empty/uneven/rejection; not a latency distribution\n";
    return 0;
  } catch (const std::exception& e) {
    std::cerr << e.what() << "\n";
    return 1;
  }
}
