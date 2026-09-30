#include <cstdio>
#include <iostream>
#include <memory>
#include <stdexcept>
#include <type_traits>
#include <vector>
struct Stats {
  int opened = 0, closed = 0, close_errors = 0;
};
struct CloseFile {
  Stats* stats{};
  void operator()(std::FILE* f) const noexcept {
    if (std::fclose(f) != 0) {
      ++stats->close_errors;
    }
    ++stats->closed;
  }
};
using File = std::unique_ptr<std::FILE, CloseFile>;
File open_file(Stats& stats) {
  // 串行练习专用路径；build被Git忽略，不依赖tmpfile的系统目录选择。
  std::FILE* raw = std::fopen("build/tmp/request.tmp", "w+b");
  if (!raw) {
    throw std::runtime_error("fopen failed");
  }
  ++stats.opened;
  return File(raw, CloseFile{&stats});
}
struct Decoder {
  Decoder(bool fail) {
    if (fail) {
      throw std::runtime_error("injected decoder failure");
    }
  }
};
struct Request {
  File file;
  std::vector<unsigned char> scratch;
  Decoder decoder;
  // 成员按声明序构造；后成员失败时已构造成员自动反序析构。
  Request(Stats& s, bool fail) : file(open_file(s)), scratch(64, 0), decoder(fail) {
  }
  // 没有自定义析构/复制/移动：资源语义由成员组合，Rule of Zero。
};
static_assert(!std::is_copy_constructible<Request>::value, "ownership must be unique");
static_assert(std::is_nothrow_move_constructible<Request>::value, "safe move expected");
void require(bool v) {
  if (!v) {
    throw std::runtime_error("lifetime invariant failed");
  }
}
int main() {
  try {
    Stats s;
    for (int i = 0; i < 1000; ++i) {
      try {
        Request bad(s, true);
      } catch (const std::runtime_error&) {
      }
      require(s.opened == s.closed && s.close_errors == 0);
      {
        Request a(s, false);
        auto b = std::move(a);
        require(!a.file && b.file && b.scratch.size() == 64);
        const unsigned char byte = 42;
        require(std::fwrite(&byte, 1, 1, b.file.get()) == 1);
        require(std::fflush(b.file.get()) == 0);
        require(std::fseek(b.file.get(), 0, SEEK_SET) == 0);
        unsigned char got = 0;
        require(std::fread(&got, 1, 1, b.file.get()) == 1 && got == 42);
        b.file.reset();
        b.file.reset();
        require(!b.file);
      }
      require(s.opened == s.closed && s.close_errors == 0);
    }
    std::cout << "PASS 1000 partial-construction failures, 1000 moves + repeated reset; opened="
              << s.opened << " closed=" << s.closed << '\n';
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
