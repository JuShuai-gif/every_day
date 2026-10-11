#include <fcntl.h>
#include <unistd.h>

#include <array>
#include <cerrno>
#include <csignal>
#include <iostream>
#include <stdexcept>

void require(bool v, const char* m) {
  if (!v) {
    throw std::runtime_error(m);
  }
}
struct Fd {
  int value = -1;
  ~Fd() {
    close_now();
  }
  Fd() = default;
  Fd(const Fd&) = delete;
  Fd& operator=(const Fd&) = delete;
  void close_now() {
    if (value >= 0) {
      if (close(value) != 0) {
        std::cerr << "close errno=" << errno << '\n';
      }
      value = -1;
    }
  }
};
struct Pipe {
  Fd reader, writer;
  Pipe() {
    int fds[2];
    require(pipe(fds) == 0, "pipe");
    reader.value = fds[0];
    writer.value = fds[1];
  }
};
struct IgnorePipe {
  struct sigaction previous{};
  IgnorePipe() {
    struct sigaction action{};
    action.sa_handler = SIG_IGN;
    require(sigemptyset(&action.sa_mask) == 0, "signal mask");
    require(sigaction(SIGPIPE, &action, &previous) == 0, "sigaction");
  }
  ~IgnorePipe() {
    if (sigaction(SIGPIPE, &previous, nullptr) != 0) {
      std::cerr << "restore signal failed\n";
    }
  }
};
void nonblocking(int fd) {
  const int flags = fcntl(fd, F_GETFL);
  require(flags >= 0 && fcntl(fd, F_SETFL, flags | O_NONBLOCK) == 0, "fcntl");
}
ssize_t read_retry(int fd, void* p, std::size_t n) {
  ssize_t r;
  do {
    r = read(fd, p, n);
  } while (r < 0 && errno == EINTR);
  return r;
}
ssize_t write_retry(int fd, const void* p, std::size_t n) {
  ssize_t r;
  do {
    r = write(fd, p, n);
  } while (r < 0 && errno == EINTR);
  return r;
}
int main() {
  try {
    IgnorePipe signal_policy;
    Pipe p;
    nonblocking(p.reader.value);
    nonblocking(p.writer.value);
    std::array<unsigned char, 4096> data{};
    data.fill(0x5a);
    std::size_t sent = 0, received = 0;
    // 无消费者时填满；容量由系统决定，不能照抄xv6的512字节。
    for (;;) {
      const auto n = write_retry(p.writer.value, data.data(), data.size());
      if (n < 0 && (errno == EAGAIN || errno == EWOULDBLOCK)) {
        break;
      }
      require(n > 0, "write failed");
      sent += static_cast<std::size_t>(n);
      require(sent < 64U * 1024U * 1024U, "unexpected pipe capacity");
    }
    for (;;) {
      const auto n = read_retry(p.reader.value, data.data(), data.size());
      if (n < 0 && (errno == EAGAIN || errno == EWOULDBLOCK)) {
        break;
      }
      require(n > 0, "premature EOF");
      received += static_cast<std::size_t>(n);
      for (ssize_t i = 0; i < n; ++i) {
        require(data[static_cast<std::size_t>(i)] == 0x5a, "data corruption");
      }
    }
    require(sent == received, "lost bytes");
    Fd duplicate;
    duplicate.value = dup(p.writer.value);
    require(duplicate.value >= 0, "dup");
    p.writer.close_now();
    require(read_retry(p.reader.value, data.data(), 1) == -1 &&
                (errno == EAGAIN || errno == EWOULDBLOCK),
            "hidden writer must prevent EOF");
    duplicate.close_now();
    require(read_retry(p.reader.value, data.data(), 1) == 0, "last writer EOF");
    Pipe broken;
    broken.reader.close_now();
    require(write_retry(broken.writer.value, data.data(), 1) == -1 && errno == EPIPE, "EPIPE");
    std::cout << "PASS filled/drained=" << sent << " bytes; EAGAIN, duplicate writer, EOF, EPIPE\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
