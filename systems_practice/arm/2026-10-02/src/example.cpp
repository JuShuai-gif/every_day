#include <arm_neon.h>
#include <sys/mman.h>
#include <unistd.h>

#include <algorithm>
#include <chrono>
#include <cstdint>
#include <iostream>
#include <memory>
#include <stdexcept>
#include <vector>
void require(bool b) {
  if (!b) {
    throw std::runtime_error("contract failed");
  }
}
extern "C" __attribute__((noinline)) void scalar(const uint8_t* s, uint8_t* d, std::size_t n) {
  for (std::size_t i = 0; i < n; ++i) {
    d[i] = uint8_t(s[i] + 1);
  }
}
extern "C" __attribute__((noinline)) void neon(const uint8_t* s, uint8_t* d, std::size_t n) {
  std::size_t i = 0;
  // 只有剩余至少16字节才做128位加载；不借用分配器padding。
  for (; n - i >= 16; i += 16) {
    vst1q_u8(d + i, vaddq_u8(vld1q_u8(s + i), vdupq_n_u8(1)));
  }
  for (; i < n; ++i) {
    d[i] = uint8_t(s[i] + 1);
  }
}
struct Guard {
  std::size_t page;
  uint8_t* base;
  Guard() : page(static_cast<std::size_t>(sysconf(_SC_PAGESIZE))), base(nullptr) {
    require(page > 0 && page < 1U << 24);
    void* p = mmap(nullptr, 2 * page, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANON, -1, 0);
    if (p == MAP_FAILED) {
      throw std::runtime_error("mmap failed");
    }
    base = static_cast<uint8_t*>(p);
    if (mprotect(base + page, page, PROT_NONE) != 0) {
      if (munmap(base, 2 * page) != 0) {
        std::cerr << "munmap rollback failed\n";
      }
      throw std::runtime_error("mprotect failed");
    }
  }
  ~Guard() {
    if (munmap(base, 2 * page) != 0) {
      std::cerr << "munmap cleanup failed\n";
    }
  }
  Guard(const Guard&) = delete;
  Guard& operator=(const Guard&) = delete;
};
void checked(const uint8_t* s, std::size_t capacity, uint8_t* d, std::size_t out, std::size_t n) {
  if (n > capacity || n > out || (n && (!s || !d))) {
    throw std::invalid_argument("length/capacity");
  }
  neon(s, d, n);
}
int main() {
  try {
    std::size_t cases = 0;
    for (std::size_t n = 0; n <= 257; ++n) {
      for (std::size_t offset = 0; offset < 16; ++offset) {
        // 精确源分配使ASan能够检出尾部超读；目标哨兵检测越写。
        auto s = std::make_unique<uint8_t[]>(n + offset);
        std::vector<uint8_t> d(n + 2, 0xa5), ref(n);
        for (std::size_t i = 0; i < n; ++i) {
          s[i + offset] = uint8_t(i * 17);
        }
        scalar(s.get() + offset, ref.data(), n);
        checked(s.get() + offset, n, d.data() + 1, n, n);
        require(std::equal(ref.begin(), ref.end(), d.begin() + 1) && d.front() == 0xa5 &&
                d.back() == 0xa5);
        ++cases;
      }
    }
    Guard g;
    for (std::size_t n : {0U, 1U, 15U, 16U, 17U, 31U, 32U, 33U}) {
      uint8_t* s = g.base + g.page - n;
      std::vector<uint8_t> d(n), ref(n);
      for (std::size_t i = 0; i < n; ++i) {
        s[i] = uint8_t(i);
      }
      scalar(s, ref.data(), n);
      checked(s, n, d.data(), n, n);
      require(d == ref);
    }
    bool rejected = false;
    try {
      checked(nullptr, 0, nullptr, 0, 1);
    } catch (const std::invalid_argument&) {
      rejected = true;
    }
    require(rejected);
    // 单线程热数据批均值；禁止解释为板端请求尾延迟。
    std::vector<uint8_t> s(4097, 250), d(4097);
    volatile unsigned checksum = 0;
    for (auto fn : {scalar, neon}) {
      std::vector<double> us;
      for (int batch = 0; batch < 120; ++batch) {
        auto t = std::chrono::steady_clock::now();
        for (int i = 0; i < 128; ++i) {
          fn(s.data(), d.data(), d.size());
          checksum += d[i];
        }
        if (batch >= 20) {
          us.push_back(
              std::chrono::duration<double, std::micro>(std::chrono::steady_clock::now() - t)
                  .count() /
              128);
        }
      }
      std::sort(us.begin(), us.end());
      std::cout << (fn == scalar ? "scalar" : "neon") << " CPU batch_mean_us p50=" << us[49]
                << " p95=" << us[94] << '\n';
    }
    std::cout << "PASS " << cases
              << " offset/length cases, 8 guard-page tails, invalid capacity; checksum=" << checksum
              << '\n';
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
