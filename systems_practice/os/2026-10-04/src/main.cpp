#include <algorithm>
#include <array>
#include <cstdint>
#include <iostream>
#include <limits>
#include <stdexcept>
#include <vector>
constexpr std::size_t page_size = 16;  // 独立模型缩小页方便手算；真实xv6页为4096字节。
struct Page {
  std::array<unsigned char, page_size> data{};
  bool user = true, write = true, present = true;
};
class UserMemory {
 public:
  std::array<Page, 3> pages;
  // 返回已复制字节；失败可能已经修改前缀，不承诺事务原子性。
  std::size_t copy(std::uint64_t va, unsigned char* bytes, std::size_t n, bool to_user) {
    std::size_t done = 0;
    while (done < n) {
      if (va >= pages.size() * page_size) {
        break;
      }
      auto& p = pages[va / page_size];
      if (!p.present || !p.user || (to_user && !p.write)) {
        break;
      }
      auto off = static_cast<std::size_t>(va % page_size);
      auto count = std::min(n - done, page_size - off);
      if (to_user) {
        std::copy_n(bytes + done, count, p.data.data() + off);
      } else {
        std::copy_n(p.data.data() + off, count, bytes + done);
      }
      done += count;
      va += count;
    }
    return done;
  }
  bool snapshot(std::uint64_t va, std::vector<unsigned char>& destination) {
    // 提交层采用临时缓冲：跨页失败时，业务对象保持旧值。
    auto candidate = destination;
    if (copy(va, candidate.data(), candidate.size(), false) != candidate.size()) {
      return false;
    }
    destination.swap(candidate);
    return true;
  }
};
void check(bool ok) {
  if (!ok) {
    throw std::runtime_error("copy contract failed");
  }
}
int main() {
  try {
    UserMemory m;
    for (std::size_t i = 0; i < 48; ++i) {
      m.pages[i / 16].data[i % 16] = static_cast<unsigned char>(i);
    }
    int cases = 0;
    for (std::size_t start = 0; start <= 48; ++start) {
      for (std::size_t n = 0; n <= 49; ++n) {
        std::vector<unsigned char> dst(n + 1, 255);
        auto copied = m.copy(start, dst.data(), n, false);
        check(copied == std::min(n, 48 - start));
        for (std::size_t i = 0; i < copied; ++i) {
          check(dst[i] == start + i);
        }
        check(dst.back() == 255);
        ++cases;
      }
    }
    m.pages[1].present = false;
    std::vector<unsigned char> dst(4, 222);
    check(m.copy(14, dst.data(), 4, false) == 2 && dst[0] == 14 && dst[2] == 222);
    dst.assign(4, 222);
    check(!m.snapshot(14, dst) && dst == std::vector<unsigned char>(4, 222));
    m.pages[1].present = true;
    m.pages[1].write = false;
    std::vector<unsigned char> src(4, 99);
    check(m.copy(14, src.data(), 4, true) == 2 && m.pages[0].data[14] == 99 &&
          m.pages[1].data[0] == 16);
    m.pages[1].user = false;
    check(m.copy(16, dst.data(), 4, false) == 0);
    check(m.copy(std::numeric_limits<std::uint64_t>::max(), dst.data(), 4, false) == 0);
    check(m.copy(std::numeric_limits<std::uint64_t>::max(), dst.data(), 0, false) == 0);
    std::cout << "PASS " << cases
              << " ranges; partial prefix=2; transactional snapshot rollback; readonly write "
                 "reject; user permission; UINT64_MAX; zero length\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
