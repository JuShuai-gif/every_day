#include <sys/mman.h>
#include <sys/resource.h>
#include <unistd.h>

#include <cerrno>
#include <chrono>
#include <cstdint>
#include <iostream>
#include <stdexcept>
#include <system_error>
#include <vector>
void check(bool ok) {
  if (!ok) {
    throw std::runtime_error("check failed");
  }
}
class Mapping {
 public:
  explicit Mapping(std::size_t bytes) : bytes_(bytes) {
    if (!bytes) {
      throw std::invalid_argument("zero mapping");
    }
    address_ = mmap(nullptr, bytes, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANON, -1, 0);
    if (address_ == MAP_FAILED) {
      throw std::system_error(errno, std::generic_category(), "mmap");
    }
  }
  ~Mapping() {
    if (munmap(address_, bytes_) != 0) {
      std::cerr << "munmap errno=" << errno << '\n';
      std::terminate();
    }
  }
  Mapping(const Mapping&) = delete;
  Mapping& operator=(const Mapping&) = delete;
  volatile std::uint8_t* bytes() {
    return static_cast<volatile std::uint8_t*>(address_);
  }
  std::size_t resident(std::size_t page) {
#ifdef __APPLE__
    std::vector<char> vec(bytes_ / page);
#else
    std::vector<unsigned char> vec(bytes_ / page);
#endif
    if (mincore(address_, bytes_, vec.data()) != 0) {
      throw std::system_error(errno, std::generic_category(), "mincore");
    }
    std::size_t n = 0;
    for (auto v : vec) {
      n += (v & 1) != 0;
    }
    return n;
  }

 private:
  void* address_ = MAP_FAILED;
  std::size_t bytes_;
};
rusage usage() {
  rusage r{};
  if (getrusage(RUSAGE_SELF, &r) != 0) {
    throw std::system_error(errno, std::generic_category(), "getrusage");
  }
  return r;
}
double cpu_us(const rusage& r) {
  return 1e6 * (r.ru_utime.tv_sec + r.ru_stime.tv_sec) + r.ru_utime.tv_usec + r.ru_stime.tv_usec;
}
int main() {
  try {
    int rejected = 0;
    try {
      Mapping m(0);
    } catch (const std::invalid_argument&) {
      ++rejected;
    }
    errno = 0;
    void* bad = mmap(nullptr, 0, PROT_READ, MAP_PRIVATE | MAP_ANON, -1, 0);
    check(bad == MAP_FAILED && errno == EINVAL);
    ++rejected;
    const long raw_page = sysconf(_SC_PAGESIZE);
    check(raw_page > 0);
    const auto page = static_cast<std::size_t>(raw_page);
    Mapping map(page * 2048);
    std::cout << "page_bytes=" << page << " pages=2048 resident_initial=" << map.resident(page)
              << '\n';
    for (int phase = 0; phase < 3; ++phase) {
      const auto before = usage();
      const auto begin = std::chrono::steady_clock::now();
      std::uint64_t sum = 0;
      // 只读可能共享零页；逐页写才要求私有可写内容。第三轮保持相同写工作量。
      for (std::size_t i = 0; i < 2048; ++i) {
        if (phase) {
          map.bytes()[i * page] = static_cast<std::uint8_t>(i);
        }
        sum += map.bytes()[i * page];
      }
      const auto wall =
          std::chrono::duration<double, std::micro>(std::chrono::steady_clock::now() - begin)
              .count();
      const auto after = usage();
      check(sum == (phase ? 261120u : 0u));
      std::cout << "phase=" << phase << " wall_us=" << wall
                << " process_cpu_us=" << cpu_us(after) - cpu_us(before)
                << " minor_faults=" << after.ru_minflt - before.ru_minflt
                << " major_faults=" << after.ru_majflt - before.ru_majflt
                << " resident=" << map.resident(page) << " checksum=" << sum << '\n';
    }
    std::cout << "PASS mapping/read/write/rewarm rejects=" << rejected << '\n';
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
