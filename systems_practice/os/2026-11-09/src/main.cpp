#include <fcntl.h>
#include <unistd.h>

#include <algorithm>
#include <array>
#include <cerrno>
#include <iostream>
#include <stdexcept>
#include <vector>
struct Pipe {
  int fd[2]{-1, -1};
  Pipe() {
    if (pipe(fd) != 0) {
      throw std::runtime_error("pipe");
    }
    for (int f : fd) {
      int flags = fcntl(f, F_GETFL);
      if (flags < 0 || fcntl(f, F_SETFL, flags | O_NONBLOCK) < 0) {
        for (int x : fd) {
          if (close(x) != 0) {
            std::cerr << "close failed\n";
          }
        }
        throw std::runtime_error("fcntl");
      }
    }
  }
  ~Pipe() {
    for (int f : fd) {
      if (close(f) != 0) {
        std::cerr << "close failed\n";
      }
    }
  }
  Pipe(const Pipe&) = delete;
  Pipe& operator=(const Pipe&) = delete;
};
class Sender {
  std::vector<unsigned char> bytes;
  size_t cursor = 0, budget;

 public:
  explicit Sender(size_t b) : budget(b) {
    if (!b) {
      throw std::invalid_argument("zero budget");
    }
  }
  bool enqueue(const std::vector<unsigned char>& b) {
    if (b.size() > budget - pending()) {
      return false;
    }
    // 清除已发送前缀后再追加，逻辑字节上界不等于vector容量/RSS。
    bytes.erase(bytes.begin(), bytes.begin() + cursor);
    cursor = 0;
    bytes.insert(bytes.end(), b.begin(), b.end());
    return true;
  }
  size_t pending() const {
    return bytes.size() - cursor;
  }
  bool flush(int fd) {
    while (pending()) {
      auto n = write(fd, bytes.data() + cursor, pending());
      if (n > 0) {
        cursor += size_t(n);
        continue;
      }
      if (n < 0 && errno == EINTR) {
        continue;
      }
      if (n < 0 && (errno == EAGAIN || errno == EWOULDBLOCK)) {
        return false;
      }
      throw std::runtime_error("write");
    }
    return true;
  }
};
int main() {
  try {
    Pipe p;
    Sender s(1 << 20);
    std::vector<unsigned char> input(1 << 20);
    for (size_t i = 0; i < input.size(); ++i) {
      input[i] = i % 251;
    }
    if (!s.enqueue(input) || s.enqueue({1}) || s.flush(p.fd[1])) {
      throw std::logic_error("backpressure");
    }
    std::vector<unsigned char> output;
    std::array<unsigned char, 4093> tmp{};
    for (int steps = 0; steps < 10000 && output.size() < input.size(); ++steps) {
      auto n = read(p.fd[0], tmp.data(), tmp.size());
      if (n > 0) {
        output.insert(output.end(), tmp.begin(), tmp.begin() + n);
      } else if (n < 0 && errno != EAGAIN && errno != EWOULDBLOCK && errno != EINTR) {
        throw std::runtime_error("read");
      }
      s.flush(p.fd[1]);
    }
    if (output != input || s.pending() != 0) {
      throw std::logic_error("lost or duplicated bytes");
    }
    int rejected = 0;
    try {
      Sender bad(0);
    } catch (const std::invalid_argument&) {
      ++rejected;
    }
    if (rejected != 1) {
      return 1;
    }
    std::cout
        << "PASS 1048576 ordered bytes, EAGAIN/resume, budget rejection, zero budget rejection\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
