#include <fcntl.h>
#include <poll.h>
#include <unistd.h>

#include <array>
#include <cerrno>
#include <cstdint>
#include <cstring>
#include <iostream>
#include <stdexcept>
#include <string>
#include <vector>
#ifdef __linux__
#include <sys/epoll.h>
#endif
void check(bool ok, const char* why) {
  if (!ok) {
    throw std::runtime_error(why);
  }
}
class Fd {
 public:
  explicit Fd(int fd) : v(fd) {
    check(fd >= 0, "fd creation");
  }
  ~Fd() {
    if (close(v) < 0) {
      std::cerr << "close: " << std::strerror(errno) << '\n';
    }
  }
  Fd(const Fd&) = delete;
  Fd& operator=(const Fd&) = delete;
  int v;
};
struct Pipe {
  static std::array<int, 2> create() {
    std::array<int, 2> a{};
    check(pipe(a.data()) == 0, "pipe");
    return a;
  }
  std::array<int, 2> a = create();
  Fd r{a[0]}, w{a[1]};
  Pipe() {
    for (int fd : a) {
      int flags = fcntl(fd, F_GETFL);
      check(flags >= 0 && fcntl(fd, F_SETFL, flags | O_NONBLOCK) == 0, "fcntl");
    }
  }
};
class Parser {
 public:
  void add(unsigned char b) {
    if (header == 0) {
      length = unsigned(b) << 8;
      header = 1;
      return;
    }
    if (header == 1) {
      length |= b;
      header = 2;
      check(length <= 32, "oversize");
      if (length == 0) {
        emit();
      }
      return;
    }
    pending.push_back(char(b));
    if (pending.size() == length) {
      emit();
    }
  }
  void eof() const {
    check(header == 0, "truncated frame");
  }
  std::vector<std::string> frames;

 private:
  void emit() {
    frames.push_back(pending);
    pending.clear();
    header = 0;
    length = 0;
  }
  unsigned header = 0, length = 0;
  std::string pending;
};
void send(int fd, std::vector<unsigned char> bytes) {
  std::size_t offset = 0;
  while (offset < bytes.size()) {
    auto n = write(fd, bytes.data() + offset, bytes.size() - offset);
    if (n > 0) {
      offset += n;
    } else if (n < 0 && errno == EINTR) {
      continue;
    } else {
      throw std::runtime_error("small test write");
    }
  }
}
std::size_t drain(int fd, Parser& p) {
  std::size_t count = 0;
  for (;;) {
    unsigned char bytes[3];
    auto n = read(fd, bytes, sizeof(bytes));
    if (n > 0) {
      for (ssize_t i = 0; i < n; ++i) {
        p.add(bytes[i]);
      }
      count += n;
    } else if (n == 0) {
      p.eof();
      return count;
    } else if (errno == EINTR) {
      continue;
    } else if (errno == EAGAIN || errno == EWOULDBLOCK) {
      return count;
    } else {
      throw std::runtime_error(std::strerror(errno));
    }
  }
}
#ifdef __linux__
void epoll_case(bool edge) {
  Pipe p;
  Fd ep(epoll_create1(EPOLL_CLOEXEC));
  epoll_event ev{};
  ev.events =
      static_cast<std::uint32_t>(EPOLLIN) | (edge ? static_cast<std::uint32_t>(EPOLLET) : 0U);
  ev.data.fd = p.r.v;
  check(epoll_ctl(ep.v, EPOLL_CTL_ADD, p.r.v, &ev) == 0, "epoll_ctl");
  auto wait = [&] {
    int n;
    do {
      n = epoll_wait(ep.v, &ev, 1, 0);
    } while (n < 0 && errno == EINTR);
    check(n >= 0, "epoll_wait");
    return n;
  };
  send(p.w.v, {0, 3, 'a', 'b', 'c'});
  check(wait() == 1, "initial event");
  Parser parser;
  unsigned char first = 255;
  check(read(p.r.v, &first, 1) == 1, "partial read");
  parser.add(first);
  int next = wait();
  check(next == (edge ? 0 : 1), "ET/LT");
  check(drain(p.r.v, parser) == 4 && parser.frames == std::vector<std::string>{"abc"}, "drain");
  check(wait() == 0, "drained");
  send(p.w.v, {0, 0});
  check(wait() == 1, "new event");
  drain(p.r.v, parser);
  parser.eof();
  std::cout << "Linux " << (edge ? "ET" : "LT") << " event_after_partial=" << next << '\n';
}
#endif
int main() {
  try {
    Pipe p;
    Parser parser;
    send(p.w.v, {0});
    pollfd ev{p.r.v, POLLIN, 0};
    int ready;
    do {
      ready = poll(&ev, 1, 0);
    } while (ready < 0 && errno == EINTR);
    check(ready == 1, "poll");
    check(drain(p.r.v, parser) == 1 && parser.frames.empty(), "not whole frame");
    send(p.w.v, {3, 'a', 'b', 'c', 0, 0, 0, 1, 'z'});
    check(drain(p.r.v, parser) == 9, "remainder");
    parser.eof();
    check(parser.frames == std::vector<std::string>{"abc", "", "z"}, "frames");
    int rejected = 0;
    try {
      Parser bad;
      bad.add(0);
      bad.add(33);
    } catch (const std::runtime_error&) {
      ++rejected;
    }
    try {
      Parser bad;
      bad.add(0);
      bad.eof();
    } catch (const std::runtime_error&) {
      ++rejected;
    }
    check(rejected == 2, "invalid frame checks");
    // 非阻塞write返回正值才推进offset；EAGAIN保留未完成尾部。
    Pipe full;
    std::array<char, 1024> block{};
    std::size_t sent = 0, received = 0;
    for (;;) {
      auto n = write(full.w.v, block.data(), block.size());
      if (n > 0) {
        sent += n;
      } else if (n < 0 && errno == EINTR) {
        continue;
      } else {
        check(n < 0 && (errno == EAGAIN || errno == EWOULDBLOCK), "write EAGAIN");
        break;
      }
    }
    for (;;) {
      auto n = read(full.r.v, block.data(), block.size());
      if (n > 0) {
        received += n;
      } else if (n < 0 && errno == EINTR) {
        continue;
      } else {
        check(n < 0 && (errno == EAGAIN || errno == EWOULDBLOCK), "read EAGAIN");
        break;
      }
    }
    check(sent > 0 && sent == received, "no byte loss");
#ifdef __linux__
    epoll_case(false);
    epoll_case(true);
#else
    std::cout << "SKIP epoll: non-Linux host; portable pipe/poll only\n";
#endif
    std::cout << "PASS frames=3 rejected=2 EAGAIN_bytes=" << sent << " drained=" << received
              << '\n';
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
