#include <array>
#include <iostream>
#include <stdexcept>
// 独立持久化状态机：每一步模拟原子、已落盘的块写；不声称模拟真实磁盘。
struct Disk {
  std::array<int, 2> home{1, 2}, log{0, 0};
  int committed = 0;
};
void recover(Disk& d) {
  if (d.committed == 2) {
    d.home = d.log;
  } else if (d.committed != 0) {
    throw std::runtime_error("corrupt log header");
  }
  d.committed = 0;
}
void require(bool b) {
  if (!b) {
    throw std::runtime_error("invariant");
  }
}
int main() {
  try {
    // 崩溃发生在任意两个持久化步骤之间，包括安装一半、清除header之前。
    for (int crash = 0; crash <= 6; ++crash) {
      Disk d;
      for (int step = 0; step < crash; ++step) {
        switch (step) {
          case 0:
            d.log[0] = 11;
            break;
          case 1:
            d.log[1] = 22;
            break;
          case 2:
            d.committed = 2;
            break;
          case 3:
            d.home[0] = d.log[0];
            break;
          case 4:
            d.home[1] = d.log[1];
            break;
          case 5:
            d.committed = 0;
            break;
        }
      }
      recover(d);
      auto first = d.home;
      recover(d);
      require(d.home == first);
      require(d.home == (crash < 3 ? std::array<int, 2>{1, 2} : std::array<int, 2>{11, 22}));
      std::cout << "crash_after=" << crash << " home=" << d.home[0] << "," << d.home[1]
                << " recovery_idempotent=yes\n";
    }
    Disk bad;
    bad.log[0] = 11;
    bad.committed = 2;
    recover(bad);
    require(bad.home == std::array<int, 2>{11, 0});
    std::cout << "counterexample header-before-data recovers mixed generation 11,0\n";
    Disk torn;
    torn.committed = 1;
    bool rejected = false;
    try {
      recover(torn);
    } catch (const std::runtime_error&) {
      rejected = true;
    }
    require(rejected);
    std::cout
        << "PASS 7 crash points; invalid header rejected; no real power-loss/durability test\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
