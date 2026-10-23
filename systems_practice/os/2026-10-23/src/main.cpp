#include <cstdint>
#include <iostream>
#include <stdexcept>
#include <vector>
void check(bool b) {
  if (!b) {
    throw std::runtime_error("contract failed");
  }
}
enum class State { Cpu, Device, Complete };
// 显式合同模型：token是逻辑映射标识，不是从用户虚拟地址猜出的DMA地址。
class Mapping {
  std::vector<int> cpu_, device_;
  State state_ = State::Cpu;
  std::uint64_t token_ = 0x4000;

 public:
  static int live;
  explicit Mapping(std::size_t n, bool fail = false) : cpu_(n), device_(n) {
    if (n == 0 || fail) {
      throw std::runtime_error("mapping failed");
    }
    ++live;
  }
  ~Mapping() {
    --live;
  }
  Mapping(const Mapping&) = delete;
  Mapping& operator=(const Mapping&) = delete;
  void write(int v) {
    check(state_ == State::Cpu);
    for (auto& x : cpu_) {
      x = v;
    }
  }
  void sync_device() {
    check(state_ == State::Cpu);
    device_ = cpu_;
    state_ = State::Device;
  }
  void execute(std::uint64_t token) {
    check(state_ == State::Device && token == token_);
    for (auto& x : device_) {
      x += 1;
    }
    state_ = State::Complete;
  }
  void sync_cpu() {
    check(state_ == State::Complete);
    cpu_ = device_;
    state_ = State::Cpu;
  }
  int read() {
    check(state_ == State::Cpu);
    return cpu_.at(0);
  }
  std::uint64_t token() const {
    return token_;
  }
};
int Mapping::live = 0;
int main() {
  try {
    int rejected = 0;
    {
      Mapping m(17);
      m.write(41);
      m.sync_device();
      try {
        m.write(99);
      } catch (const std::runtime_error&) {
        ++rejected;
      }
      try {
        m.sync_cpu();
      } catch (const std::runtime_error&) {
        ++rejected;
      }
      try {
        m.execute(0x8000);
      } catch (const std::runtime_error&) {
        ++rejected;
      }
      m.execute(m.token());
      try {
        (void)m.read();
      } catch (const std::runtime_error&) {
        ++rejected;
      }
      m.sync_cpu();
      check(m.read() == 42);
      for (int i = 0; i < 1000; ++i) {
        m.write(i);
        m.sync_device();
        m.execute(m.token());
        m.sync_cpu();
        check(m.read() == i + 1);
      }
    }
    for (auto n : {std::size_t(0), std::size_t(17)}) {
      try {
        Mapping m(n, true);
      } catch (const std::runtime_error&) {
        ++rejected;
      }
    }
    check(rejected == 6 && Mapping::live == 0);
    std::cout << "PASS contract_model_only cycles=1001 rejected=6 live=0 real_dma=NOT_TESTED\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
