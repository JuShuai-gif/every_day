#include <iostream>
#include <mutex>
#include <stdexcept>
#include <thread>
#include <vector>
struct Pool {
  std::mutex mutex;
  int credits = 100000;
};
void check(bool b) {
  if (!b) {
    throw std::runtime_error("invariant failed");
  }
}
void transfer(Pool& a, Pool& b, int n, bool inject = false) {
  if (&a == &b || n < 0) {
    throw std::invalid_argument("alias or negative transfer");
  }
  std::scoped_lock guard(a.mutex, b.mutex);
  if (a.credits < n) {
    throw std::runtime_error("insufficient credits");
  }
  // 所有可能失败的操作放在修改前；锁析构不会自动回滚业务字段。
  if (inject) {
    throw std::runtime_error("injected failure before commit");
  }
  a.credits -= n;
  b.credits += n;
}
class Joiner {
  std::vector<std::thread>& ts;

 public:
  explicit Joiner(std::vector<std::thread>& t) : ts(t) {
  }
  ~Joiner() {
    for (auto& t : ts) {
      if (t.joinable()) {
        t.join();
      }
    }
  }
};
int main() {
  try {
    Pool a, b;
    int rejected = 0;
    try {
      transfer(a, a, 1);
    } catch (const std::invalid_argument&) {
      ++rejected;
    }
    try {
      transfer(a, b, -1);
    } catch (const std::invalid_argument&) {
      ++rejected;
    }
    try {
      transfer(a, b, 100001);
    } catch (const std::runtime_error&) {
      ++rejected;
    }
    try {
      transfer(a, b, 1, true);
    } catch (const std::runtime_error&) {
      ++rejected;
    }
    check(a.credits == 100000 && b.credits == 100000 && rejected == 4);
    transfer(a, b, 0);
    std::vector<std::thread> ts;
    {
      Joiner join(ts);
      ts.emplace_back([&] {
        for (int i = 0; i < 10000; ++i) {
          transfer(a, b, 1);
        }
      });
      ts.emplace_back([&] {
        for (int i = 0; i < 10000; ++i) {
          transfer(b, a, 1);
        }
      });
    }
    check(a.credits == 100000 && b.credits == 100000);
    // 可控Lockable验证第二把锁抛异常时第一把被释放，不制造真实死锁。
    struct Probe {
      bool held = false, throws = false;
      void lock() {
        if (throws) {
          throw std::runtime_error("lock failure");
        }
        check(!held);
        held = true;
      }
      bool try_lock() {
        lock();
        return true;
      }
      void unlock() {
        held = false;
      }
    } x, y;
    y.throws = true;
    bool caught = false;
    try {
      std::scoped_lock guard(x, y);
    } catch (const std::runtime_error&) {
      caught = true;
    }
    check(caught && !x.held && !y.held);
    std::cout << "PASS transfers=20000 total=200000 rejected=4 lock_exception_cleanup=1\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
