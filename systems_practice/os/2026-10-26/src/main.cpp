#include <fcntl.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>

#include <cerrno>
#include <cstdlib>
#include <cstring>
#include <iostream>
#include <stdexcept>
#include <string>
struct Fd {
  int n;
  explicit Fd(int fd) : n(fd) {
    if (n < 0) {
      throw std::runtime_error(std::strerror(errno));
    }
  }
  ~Fd() {
    if (close(n) != 0) {
      std::cerr << "close: " << std::strerror(errno) << '\n';
    }
  }
  Fd(const Fd&) = delete;
};
void require(bool ok, const char* message) {
  if (!ok) {
    throw std::runtime_error(message);
  }
}
struct Mapping {
  void* p;
  std::size_t n;
  explicit Mapping(int fd) : p(MAP_FAILED), n(0) {
    struct stat st{};
    require(fstat(fd, &st) == 0, "fstat");
    require(st.st_size > 0 && st.st_size < 4096, "invalid model size");
    n = std::size_t(st.st_size);
    p = mmap(nullptr, n, PROT_READ, MAP_PRIVATE, fd, 0);
    require(p != MAP_FAILED, "mmap");
  }
  ~Mapping() {
    if (p != MAP_FAILED && munmap(p, n) != 0) {
      std::cerr << "munmap failed\n";
    }
  }
  Mapping(const Mapping&) = delete;
  std::string text() const {
    return std::string(static_cast<const char*>(p), n);
  }
};
void write_file(const std::string& path, const std::string& data) {
  Fd fd(open(path.c_str(), O_CREAT | O_EXCL | O_WRONLY, 0600));
  std::size_t off = 0;
  while (off < data.size()) {
    auto n = write(fd.n, data.data() + off, data.size() - off);
    if (n < 0 && errno == EINTR) {
      continue;
    }
    require(n > 0, "write");
    off += std::size_t(n);
  }
  require(fsync(fd.n) == 0, "fsync file");
}
struct Directory {
  std::string path;
  Directory() {
    char p[] = "build/models-XXXXXX";
    auto* result = mkdtemp(p);
    require(result, "mkdtemp");
    path = result;
  }
  ~Directory() {
    for (const char* name : {"current", "candidate", "empty"}) {
      if (unlink((path + "/" + name).c_str()) != 0 && errno != ENOENT) {
        std::cerr << "unlink failed\n";
      }
    }
    if (rmdir(path.c_str()) != 0) {
      std::cerr << "rmdir failed\n";
    }
  }
};
int main() {
  try {
    Directory dir;
    auto current = dir.path + "/current";
    auto candidate = dir.path + "/candidate";
    write_file(current, "model-v1");
    Fd old(open(current.c_str(), O_RDONLY));
    Mapping mapped(old.n);
    write_file(candidate, "model-v2-longer");
    require(rename(candidate.c_str(), current.c_str()) == 0, "rename");
    Fd fresh(open(current.c_str(), O_RDONLY));
    Mapping newmap(fresh.n);
    require(mapped.text() == "model-v1" && newmap.text() == "model-v2-longer", "version ownership");
    // 新pathname并不改写旧inode；unlink后仍能使用已经拥有的映射。
    require(unlink(current.c_str()) == 0, "unlink");
    require(newmap.text() == "model-v2-longer", "mapping survival");
    errno = 0;
    int missing = open(current.c_str(), O_RDONLY);
    require(missing == -1 && errno == ENOENT, "missing path");
    write_file(dir.path + "/empty", "");
    int rejected = 0;
    try {
      Fd empty(open((dir.path + "/empty").c_str(), O_RDONLY));
      Mapping bad(empty.n);
    } catch (const std::runtime_error&) {
      ++rejected;
    }
    require(rejected == 1, "empty rejection");
    // 本例验证可见性/寿命，不宣称断电持久化；目录fsync留给Linux迁移验收。
    std::cout << "PASS old=model-v1 new=model-v2-longer unlink_survival=1 empty_rejected=1 "
                 "ENOENT=1 durability_unverified\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
