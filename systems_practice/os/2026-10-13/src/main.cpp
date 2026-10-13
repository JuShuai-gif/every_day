#include <fcntl.h>
#include <sys/stat.h>
#include <unistd.h>

#include <cerrno>
#include <cstring>
#include <iostream>
#include <stdexcept>
#include <string>
void require(bool ok, const char* message) {
  if (!ok) {
    throw std::runtime_error(std::string(message) + ": " + std::strerror(errno));
  }
}
struct Fd {
  int fd;
  explicit Fd(int f) : fd(f) {
    require(fd >= 0, "fd");
  }
  ~Fd() {
    if (close(fd) != 0) {
      std::cerr << "close: " << std::strerror(errno) << '\n';
    }
  }
  Fd(const Fd&) = delete;
  Fd& operator=(const Fd&) = delete;
};
struct Directory {
  std::string path;
  Directory() {
    char name[] = "build/fd-XXXXXX";
    char* p = mkdtemp(name);
    require(p != nullptr, "mkdtemp");
    path = p;
  }
  ~Directory() {
    for (const char* n : {"model", "candidate"}) {
      if (unlink((path + "/" + n).c_str()) != 0 && errno != ENOENT) {
        std::cerr << "cleanup unlink failed\n";
      }
    }
    if (rmdir(path.c_str()) != 0) {
      std::cerr << "cleanup rmdir failed\n";
    }
  }
};
void write_text(int fd, const std::string& s) {
  std::size_t at = 0;
  while (at < s.size()) {
    ssize_t n = write(fd, s.data() + at, s.size() - at);
    if (n < 0 && errno == EINTR) {
      continue;
    }
    require(n > 0, "write");
    at += n;
  }
}
std::string read_text(int fd, int count) {
  std::string s(count, '\0');
  int at = 0;
  while (at < count) {
    ssize_t n = read(fd, s.data() + at, count - at);
    if (n < 0 && errno == EINTR) {
      continue;
    }
    require(n >= 0, "read");
    if (n == 0) {
      break;
    }
    at += int(n);
  }
  s.resize(at);
  return s;
}
int main() {
  try {
    Directory d;
    auto path = d.path + "/model", candidate = d.path + "/candidate";
    {
      Fd f(open(path.c_str(), O_CREAT | O_EXCL | O_WRONLY, 0600));
      write_text(f.fd, "OLD");
    }
    Fd old(open(path.c_str(), O_RDONLY)), duplicate(dup(old.fd)),
        independent(open(path.c_str(), O_RDONLY));
    require(read_text(old.fd, 1) == "O", "old byte");
    require(read_text(duplicate.fd, 1) == "L", "dup shares offset");
    require(read_text(independent.fd, 1) == "O", "open independent offset");
    {
      Fd f(open(candidate.c_str(), O_CREAT | O_EXCL | O_WRONLY, 0600));
      write_text(f.fd, "NEW");
    }
    // 同目录rename发布新inode；已打开的旧FD保持旧对象。
    require(rename(candidate.c_str(), path.c_str()) == 0, "rename");
    Fd fresh(open(path.c_str(), O_RDONLY));
    struct stat a{}, b{};
    require(fstat(old.fd, &a) == 0 && fstat(fresh.fd, &b) == 0, "fstat");
    require(a.st_ino != b.st_ino && a.st_nlink == 0, "inode contract");
    require(lseek(old.fd, 0, SEEK_SET) == 0, "seek");
    require(read_text(old.fd, 3) == "OLD" && read_text(fresh.fd, 3) == "NEW", "snapshot");
    require(unlink(path.c_str()) == 0, "unlink");
    require(lseek(fresh.fd, 0, SEEK_SET) == 0, "seek");
    require(read_text(fresh.fd, 3) == "NEW", "unlinked fd alive");
    int missing = open(path.c_str(), O_RDONLY);
    if (missing >= 0) {
      Fd unexpected(missing);
      throw std::runtime_error("unlinked path exists");
    }
    require(errno == ENOENT, "missing errno");
    {
      Fd f(open(path.c_str(), O_CREAT | O_EXCL | O_RDWR, 0600));
      write_text(f.fd, "ABC");
      Fd alias(open(path.c_str(), O_RDONLY));
      require(lseek(f.fd, 0, SEEK_SET) == 0, "seek");
      write_text(f.fd, "BAD");
      require(read_text(alias.fd, 3) == "BAD", "in-place overwrite observed");
    }
    std::cout << "PASS dup_offset independent_open rename_old_NEW unlink_nlink0 ENOENT "
                 "in_place_counterexample\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
