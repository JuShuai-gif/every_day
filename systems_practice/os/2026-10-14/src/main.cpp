#include <array>
#include <condition_variable>
#include <iostream>
#include <mutex>
#include <stdexcept>
#include <thread>
#include <vector>
class Cache {
  struct Block {
    int key = -1, refs = 0, value = 0;
    bool valid = false;
    std::mutex content;
  };
  std::array<Block, 2> blocks;
  std::mutex meta;
  std::condition_variable changed;

 public:
  class Lease {
    Cache* owner;
    Block* b;
    std::unique_lock<std::mutex> content;

   public:
    Lease(Cache& c, Block& block) : owner(&c), b(&block), content(block.content) {
      if (!b->valid) {
        b->value = 0;
        b->valid = true;
      }
    }
    ~Lease() {
      content.unlock();
      std::lock_guard<std::mutex> l(owner->meta);
      --b->refs;
      owner->changed.notify_all();
    }
    Lease(const Lease&) = delete;
    Lease& operator=(const Lease&) = delete;
    int& value() {
      return b->value;
    }
  };
  Lease get(int key) {
    if (key < 0) {
      throw std::invalid_argument("negative block");
    }
    std::unique_lock<std::mutex> l(meta);
    Block* b = nullptr;
    for (auto& x : blocks) {
      if (x.key == key) {
        b = &x;
        break;
      }
    }
    if (!b) {
      for (auto& x : blocks) {
        if (!x.refs) {
          b = &x;
          b->key = key;
          b->valid = false;
          break;
        }
      }
    }
    if (!b) {
      throw std::runtime_error("cache exhausted");
    }
    ++b->refs;
    changed.notify_all();
    l.unlock();
    // 在等待content前pin住身份；否则等待者的槽可能被第三者复用。
    try {
      return Lease(*this, *b);
    } catch (...) {
      std::lock_guard<std::mutex> g(meta);
      --b->refs;
      changed.notify_all();
      throw;
    }
  }
  void wait_refs(int key, int count) {
    std::unique_lock<std::mutex> l(meta);
    changed.wait(l, [&] {
      for (auto& b : blocks) {
        if (b.key == key && b.refs == count) {
          return true;
        }
      }
      return false;
    });
  }
  int refs() {
    std::lock_guard<std::mutex> l(meta);
    int r = 0;
    for (auto& b : blocks) {
      r += b.refs;
    }
    return r;
  }
};
int main() {
  try {
    Cache cache;
    std::thread waiting;
    {
      auto a = cache.get(7);
      auto b = cache.get(8);
      a.value() = 41;
      waiting = std::thread([&] {
        auto t = cache.get(7);
        if (t.value() != 41) {
          std::terminate();
        }
        ++t.value();
      });
      cache.wait_refs(7, 2);
      bool full = false;
      try {
        auto c = cache.get(9);
      } catch (const std::runtime_error&) {
        full = true;
      }
      if (!full) {
        std::terminate();
      }
      std::cout << "pinned waiter refs=" << cache.refs() << " eviction rejected\n";
    }
    waiting.join();
    {
      auto t = cache.get(7);
      if (t.value() != 42) {
        throw std::runtime_error("waiter identity changed");
      }
    }
    std::vector<std::thread> jobs;
    try {
      for (int i = 0; i < 4; ++i) {
        jobs.emplace_back([&] {
          for (int j = 0; j < 5000; ++j) {
            auto t = cache.get(7);
            ++t.value();
          }
        });
      }
    } catch (...) {
      for (auto& t : jobs) {
        t.join();
      }
      throw;
    }
    for (auto& t : jobs) {
      t.join();
    }
    {
      auto t = cache.get(7);
      if (t.value() != 20042) {
        throw std::runtime_error("lost update");
      }
    }
    try {
      auto t = cache.get(7);
      throw std::runtime_error("injected");
    } catch (const std::runtime_error&) {
    }
    if (cache.refs() != 0) {
      throw std::runtime_error("leaked pin");
    }
    {
      auto t = cache.get(99);
      if (t.value() != 0) {
        throw std::runtime_error("stale valid");
      }
    }
    try {
      auto t = cache.get(-1);
      throw std::runtime_error("negative accepted");
    } catch (const std::invalid_argument&) {
    }
    std::cout << "PASS 20000 serialized updates; waiter pin; exhaustion; invalidate reuse; "
                 "exception refs=0\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
