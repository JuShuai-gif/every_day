#include <unistd.h>

#include <cerrno>
#include <cstdio>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <stdexcept>
#include <string>
#include <vector>
namespace fs = std::filesystem;
struct Dir {
  fs::path path;
  Dir() {
    char name[] = "build/publish-XXXXXX";
    auto p = mkdtemp(name);
    if (!p) {
      throw std::runtime_error("mkdtemp");
    }
    path = p;
  }
  ~Dir() {
    std::error_code ec;
    fs::remove_all(path, ec);
    if (ec) {
      std::cerr << ec.message() << '\n';
    }
  }
};
class Output {
  fs::path temp;
  FILE* file = nullptr;

 public:
  explicit Output(const fs::path& dir) {
    auto name = (dir / "candidate-XXXXXX").string();
    std::vector<char> b(name.begin(), name.end());
    b.push_back(0);
    int fd = mkstemp(b.data());
    if (fd < 0) {
      throw std::runtime_error("mkstemp");
    }
    temp = b.data();
    file = fdopen(fd, "wb");
    if (!file) {
      if (close(fd) != 0) {
        std::cerr << "close failed\n";
      }
      fs::remove(temp);
      throw std::runtime_error("fdopen");
    }
  }
  ~Output() {
    if (file && fclose(file) != 0) {
      std::cerr << "cleanup close failed\n";
    }
    if (!temp.empty()) {
      std::error_code ec;
      fs::remove(temp, ec);
      if (ec) {
        std::cerr << ec.message() << '\n';
      }
    }
  }
  Output(const Output&) = delete;
  Output& operator=(const Output&) = delete;
  void write(const std::string& s) {
    if (!file) {
      throw std::logic_error("closed");
    }
    if (fwrite(s.data(), 1, s.size(), file) != s.size()) {
      throw std::runtime_error("write");
    }
  }
  void publish(const fs::path& target) {
    if (!file) {
      throw std::logic_error("already closed");
    }
    // close错误必须在发布前暴露；rename只保证可见性，不声明掉电持久性。
    FILE* f = file;
    file = nullptr;
    if (fclose(f) != 0) {
      throw std::runtime_error("close");
    }
    fs::rename(temp, target);
    temp.clear();
  }
};
std::string read(const fs::path& p) {
  std::ifstream f(p);
  if (!f) {
    throw std::runtime_error("read");
  }
  return std::string(std::istreambuf_iterator<char>(f), {});
}
int main() {
  try {
    Dir d;
    auto final = d.path / "current";
    {
      Output o(d.path);
      o.write("old");
      o.publish(final);
    }
    {
      Output o(d.path);
      o.write("partial");
    }
    if (read(final) != "old") {
      throw std::logic_error("abandon changed target");
    }
    int failures = 0;
    {
      Output o(d.path);
      o.write("new");
      try {
        o.publish(d.path / "missing" / "current");
      } catch (const fs::filesystem_error&) {
        ++failures;
      }
    }
    if (read(final) != "old") {
      throw std::logic_error("rename rollback");
    }
    {
      Output o(d.path);
      o.write("");
      o.publish(final);
      try {
        o.write("late");
      } catch (const std::logic_error&) {
        ++failures;
      }
    }
    if (read(final) != "" || failures != 2 ||
        std::distance(fs::directory_iterator(d.path), fs::directory_iterator{}) != 1) {
      return 1;
    }
    std::cout << "PASS publish, abandon cleanup, rename failure, empty output, post-close "
                 "rejection; one final file\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
