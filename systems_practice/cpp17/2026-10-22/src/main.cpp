#include <unistd.h>

#include <cstdlib>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <stdexcept>
#include <string>
#include <vector>
namespace fs = std::filesystem;
void require(bool ok, const char* msg) {
  if (!ok) {
    throw std::runtime_error(msg);
  }
}
class Workspace {
 public:
  Workspace() {
    std::string pattern = "build/fs-XXXXXX";
    std::vector<char> buf(pattern.begin(), pattern.end());
    buf.push_back('\0');
    char* p = mkdtemp(buf.data());
    if (!p) {
      throw std::runtime_error("mkdtemp failed");
    }
    path = p;
  }
  ~Workspace() {
    std::error_code ec;
    fs::remove_all(path, ec);
    if (ec) {
      std::cerr << "cleanup: " << ec.message() << '\n';
    }
  }
  Workspace(const Workspace&) = delete;
  Workspace& operator=(const Workspace&) = delete;
  fs::path path;
};
void write(const fs::path& p, const std::string& data) {
  std::ofstream f;
  f.exceptions(std::ios::badbit | std::ios::failbit);
  f.open(p, std::ios::binary);
  f.write(data.data(), static_cast<std::streamsize>(data.size()));
  f.close();
}
std::string read(std::ifstream& f) {
  std::string s;
  std::getline(f, s);
  require(!f.bad(), "read failed");
  return s;
}
int main() {
  try {
    Workspace w;
    const auto active = w.path / "active";
    const auto candidate = w.path / "candidate";
    write(active, "old-generation");
    write(candidate, "new-generation");
    std::error_code ec;
    require(fs::exists(active, ec) && !ec, "exists old");
    std::ifstream lease(active);
    require(lease.is_open(), "open old");
    // POSIX rename改变路径绑定；已打开的流仍持有旧对象，证明exists不是租约。
    fs::rename(candidate, active, ec);
    require(!ec, "rename");
    std::ifstream fresh(active);
    require(fresh.is_open(), "open fresh");
    require(read(lease) == "old-generation" && read(fresh) == "new-generation",
            "snapshot identity");
    require(fs::exists(active, ec) && !ec, "check before simulated race");
    require(fs::remove(active, ec) && !ec, "controlled intervening unlink");
    std::ifstream missing(active);
    require(!missing.is_open(), "exists did not reserve path");
    auto size = fs::file_size(active, ec);
    require(ec && size == static_cast<std::uintmax_t>(-1), "error_code sentinel");
    std::cout << "missing error=" << ec.message() << '\n';
    bool threw = false;
    try {
      (void)fs::file_size(active);
    } catch (const fs::filesystem_error&) {
      threw = true;
    }
    require(threw, "throwing overload");
    require(fs::create_directory(w.path / "empty", ec) && !ec, "ec cleared by success");
    require(fs::is_empty(w.path / "empty", ec) && !ec, "empty boundary");
    write(w.path / "zero", "");
    require(fs::file_size(w.path / "zero", ec) == 0 && !ec, "zero file");
    fs::rename(w.path / "absent", active, ec);
    require(bool(ec), "failed rename");
    std::cout << "PASS old-open/new-path; deterministic TOCTOU; missing/sentinel/throw; "
                 "empty/zero; cleanup by RAII\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
