#include <array>
#include <iostream>
#include <stdexcept>

void check(bool ok) {
  if (!ok) {
    throw std::runtime_error("check failed");
  }
}
// 可控完成事件模型；不模拟DMA、驱动或GPU。CPU单线程枚举状态而非制造数据竞争。
class Slot {
  enum class Phase { free, submitted, complete };
  Phase phase_ = Phase::free;
  unsigned generation_ = 0;
  bool abandoned_ = false;
  std::array<int, 32> input_{};
  int output_ = 0;

 public:
  unsigned submit(int value) {
    if (phase_ != Phase::free) {
      throw std::runtime_error("buffer still owned by device");
    }
    input_.fill(value);
    abandoned_ = false;
    phase_ = Phase::submitted;
    return ++generation_;
  }
  void cancel(unsigned token) {
    if (token != generation_ || phase_ == Phase::free) {
      throw std::runtime_error("stale cancel");
    }
    abandoned_ = true;  // 放弃结果不撤销设备持有的输入。
  }
  void complete(unsigned token, bool failure = false) {
    if (token != generation_ || phase_ != Phase::submitted) {
      throw std::runtime_error("stale completion");
    }
    output_ = 0;
    for (int v : input_) {
      output_ += v;
    }
    abandoned_ = abandoned_ || failure;
    phase_ = Phase::complete;
  }
  bool reclaim(unsigned token) {
    if (token != generation_ || phase_ != Phase::complete) {
      throw std::runtime_error("completion not established");
    }
    bool valid = !abandoned_;
    phase_ = Phase::free;
    return valid;
  }
  int result() const {
    if (phase_ != Phase::complete || abandoned_) {
      throw std::runtime_error("result unavailable");
    }
    return output_;
  }
};
int main() {
  try {
    int rejected = 0, delivered = 0, abandoned = 0;
    auto fails = [&](auto f) {
      try {
        f();
      } catch (const std::runtime_error&) {
        ++rejected;
        return;
      }
      throw std::runtime_error("expected rejection");
    };
    Slot slot;
    unsigned old = 0;
    for (int i = 0; i < 1000; ++i) {
      auto token = slot.submit(i);
      fails([&] {
        slot.submit(99);
      });
      fails([&] {
        slot.reclaim(token);
      });
      if (old) {
        fails([&] {
          slot.complete(old);
        });
      }
      if (i % 2) {
        slot.cancel(token);
        fails([&] {
          slot.submit(99);
        });
      }
      slot.complete(token, i % 5 == 0);
      if (i % 2 || i % 5 == 0) {
        fails([&] {
          slot.result();
        });
        check(!slot.reclaim(token));
        ++abandoned;
      } else {
        check(slot.result() == 32 * i);
        check(slot.reclaim(token));
        ++delivered;
      }
      fails([&] {
        slot.complete(token);
      });
      old = token;
    }
    std::cout << "PASS cycles=1000 delivered=" << delivered << " abandoned_or_failed=" << abandoned
              << " rejects=" << rejected << " free_at_end=1\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
