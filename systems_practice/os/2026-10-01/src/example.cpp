#include <unistd.h>

#include <array>
#include <cerrno>
#include <cstdint>
#include <iostream>
#include <stdexcept>
void require(bool b) {
  if (!b) {
    throw std::runtime_error("trap contract failed");
  }
}
struct Frame {
  std::array<uint64_t, 32> x{};
  uint64_t epc = 0;
};
Frame model_ecall(Frame saved) {
  // 独立状态模型，不执行RISC-V指令。a7=x17为号，a0=x10为返回值。
  if (saved.epc > UINT64_MAX - 4) {
    throw std::invalid_argument("PC overflow");
  }
  saved.epc += 4;
  saved.x[10] = saved.x[17] == 11 ? 123 : UINT64_MAX;
  return saved;
}
int main() {
  try {
    Frame f;
    for (std::size_t i = 0; i < f.x.size(); ++i) {
      f.x[i] = 100 + i;
    }
    f.epc = 0x1000;
    f.x[17] = 11;
    const Frame r = model_ecall(f);
    require(r.epc == 0x1004 && r.x[10] == 123);
    for (std::size_t i = 0; i < f.x.size(); ++i) {
      if (i != 10) {
        require(r.x[i] == f.x[i]);
      }
    }
    f.x[17] = 999;
    require(model_ecall(f).x[10] == UINT64_MAX);
    bool bad = false;
    try {
      f.epc = UINT64_MAX;
      model_ecall(f);
    } catch (const std::invalid_argument&) {
      bad = true;
    }
    require(bad);
    // POSIX包装层失败返回-1并设置errno；进程继续运行，不等于CPU异常。
    char byte = 0;
    errno = 0;
    const auto n = read(-1, &byte, 1);
    const int error = errno;
    require(n == -1 && error == EBADF && getpid() > 0);
    std::cout << "PASS model pc+4, a0 replacement, 31 saved registers, invalid syscall, PC guard\n";
    std::cout << "POSIX read(-1): return=" << n << " errno=" << error << " EBADF=" << EBADF
              << " process continues\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
