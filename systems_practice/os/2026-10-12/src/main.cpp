#include <array>
#include <atomic>
#include <iostream>
#include <mutex>
#include <stdexcept>
#include <thread>
#include <vector>

// 教学锁序检查器：不用真的制造死锁；低rank必须先取得，禁止同级递归。
struct RankedMutex {
  int rank;
  std::mutex mutex;
};
thread_local std::vector<int> held;
struct Guard {
  std::unique_lock<std::mutex> lock;
  explicit Guard(RankedMutex& m) : lock(m.mutex, std::defer_lock) {
    if (!held.empty() && held.back() >= m.rank) {
      throw std::logic_error("lock order inversion");
    }
    lock.lock();
    held.push_back(m.rank);  // 若分配抛异常，成员unique_lock回滚已取得的锁。
  }
  ~Guard() {
    held.pop_back();
  }
  Guard(const Guard&) = delete;
  Guard& operator=(const Guard&) = delete;
};
struct Cache {
  RankedMutex metadata{1, {}};
  RankedMutex buffer{2, {}};
  int references = 0;
  int data = 0;
  struct Lease {
    Cache& cache;
    std::unique_lock<std::mutex> exclusive;
    explicit Lease(Cache& c) : cache(c), exclusive(c.buffer.mutex, std::defer_lock) {
      {
        Guard guard(cache.metadata);
        ++cache.references;
      }
      // 对应bget: 先pin，再释放全局元数据锁，最后等待单块独占。
      try {
        exclusive.lock();
      } catch (...) {
        Guard guard(cache.metadata);
        --cache.references;
        throw;
      }
    }
    ~Lease() {
      exclusive.unlock();
      Guard guard(cache.metadata);
      --cache.references;
    }
    Lease(const Lease&) = delete;
    Lease& operator=(const Lease&) = delete;
  };
  bool can_recycle() {
    Guard guard(metadata);
    return references == 0;
  }
};
int main() {
  try {
    Cache c;
    bool rejected = false;
    try {
      Guard high(c.buffer);
      Guard low(c.metadata);
    } catch (const std::logic_error&) {
      rejected = true;
    }
    if (!rejected || !held.empty()) {
      throw std::runtime_error("lock-order rollback");
    }
    {
      Guard low(c.metadata);
      Guard high(c.buffer);
    }
    try {
      Cache::Lease lease(c);
      if (c.can_recycle()) {
        throw std::logic_error("recycled pinned buffer");
      }
      throw std::runtime_error("injected consumer failure");
    } catch (const std::runtime_error&) {
    }
    if (!c.can_recycle()) {
      throw std::runtime_error("leaked reference");
    }
    std::atomic<bool> worker_error{false};
    std::thread worker([&] {
      try {
        for (int i = 0; i < 10000; ++i) {
          Cache::Lease lease(c);
          ++c.data;
        }
      } catch (...) {
        worker_error.store(true);
      }
    });
    // 显式捕获确保主线程异常时仍join，避免std::terminate。
    try {
      for (int i = 0; i < 10000; ++i) {
        Cache::Lease lease(c);
        ++c.data;
      }
    } catch (...) {
      worker.join();
      throw;
    }
    worker.join();
    if (worker_error.load() || c.data != 20000 || !c.can_recycle()) {
      throw std::runtime_error("buffer mutual exclusion/refcount");
    }
    std::cout << "PASS increments=" << c.data << " refs=" << c.references
              << " inversion_rejected=1 exception_released=1 ordered_pair=1\n"
              << "Host C++ mutex model; no xv6 interrupts/scheduler/device IO executed\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
