#include <fcntl.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

#include <cerrno>
#include <cstdlib>
#include <cstring>
#include <iostream>
#include <stdexcept>
#include <string>

int state = 7;
class Fd {
 public:
  explicit Fd(int fd) : fd_(fd) {
    if (fd < 0) {
      throw std::runtime_error("fd creation");
    }
  }
  ~Fd() {
    if (fd_ >= 0 && close(fd_) != 0) {
      std::cerr << "close failed\n";
    }
  }
  Fd(const Fd&) = delete;
  Fd& operator=(const Fd&) = delete;
  int get() const {
    return fd_;
  }
  void reset() {
    if (fd_ >= 0) {
      int old = fd_;
      fd_ = -1;
      if (close(old) != 0) {
        throw std::runtime_error("close");
      }
    }
  }

 private:
  int fd_;
};
class Child {
 public:
  explicit Child(pid_t pid) : pid_(pid) {
    if (pid < 0) {
      throw std::runtime_error("fork");
    }
  }
  Child(const Child&) = delete;
  Child& operator=(const Child&) = delete;
  ~Child() {
    if (pid_ > 0) {
      int s;
      if (wait(s) != 0) {
        std::cerr << "wait cleanup failed\n";
      }
    }
  }
  int wait(int& status) noexcept {
    pid_t r;
    do {
      r = waitpid(pid_, &status, 0);
    } while (r < 0 && errno == EINTR);
    if (r < 0) {
      return errno;
    }
    pid_ = -1;
    return 0;
  }

 private:
  pid_t pid_;
};
struct Message {
  long pid;
  int value;
  int error;
};
bool send(int fd, const Message& msg) {
  const auto* p = reinterpret_cast<const char*>(&msg);
  std::size_t n = sizeof(msg);
  while (n) {
    const auto k = write(fd, p, n);
    if (k < 0 && errno == EINTR) {
      continue;
    }
    if (k <= 0) {
      return false;
    }
    n -= static_cast<std::size_t>(k);
    p += k;
  }
  return true;
}
Message receive(int fd) {
  Message m{};
  auto* p = reinterpret_cast<char*>(&m);
  std::size_t n = sizeof(m);
  while (n) {
    const auto k = read(fd, p, n);
    if (k < 0 && errno == EINTR) {
      continue;
    }
    if (k <= 0) {
      throw std::runtime_error("short pipe message");
    }
    n -= static_cast<std::size_t>(k);
    p += k;
  }
  return m;
}
void check(bool ok, const char* msg) {
  if (!ok) {
    throw std::runtime_error(msg);
  }
}
void observe(const char* program, bool fail_exec) {
  int raw[2];
  check(pipe(raw) == 0, "pipe");
  Fd reader(raw[0]), writer(raw[1]);
  // 只让报告管道穿过exec；真实worker其余FD应设置FD_CLOEXEC。
  const std::string fd_arg = std::to_string(writer.get());
  const pid_t pid = fork();
  if (pid == 0) {
    if (close(reader.get()) != 0) {
      _exit(120);
    }
    state = 99;
    if (!send(writer.get(), {static_cast<long>(getpid()), state, 0})) {
      _exit(121);
    }
    const char* path = fail_exec ? "./build/definitely-not-an-executable" : program;
    execl(path, path, "--worker", fd_arg.c_str(), static_cast<char*>(nullptr));
    // 成功的exec不返回；失败路径用_exit，避免复制的stdio/析构再次执行。
    const int saved_errno = errno;
    if (!send(writer.get(), {static_cast<long>(getpid()), state, saved_errno})) {
      _exit(122);
    }
    _exit(127);
  }
  Child child(pid);
  writer.reset();
  const auto before = receive(reader.get());
  const auto after = receive(reader.get());
  int status = 0;
  check(child.wait(status) == 0 && WIFEXITED(status), "wait exit");
  check(before.pid == pid && before.value == 99 && after.pid == pid && state == 7,
        "fork isolation/PID");
  if (fail_exec) {
    check(after.error == ENOENT && after.value == 99 && WEXITSTATUS(status) == 127,
          "exec failure state");
  } else {
    check(after.error == 0 && after.value == 7 && WEXITSTATUS(status) == 0, "exec image reset");
  }
  std::cout << "PASS exec_" << (fail_exec ? "failure" : "success") << " parent=" << getpid()
            << " child=" << pid << " before=" << before.value << " after=" << after.value
            << " errno=" << after.error << " parent_state=" << state << '\n';
}
int main(int argc, char** argv) {
  try {
    if (argc == 3 && std::strcmp(argv[1], "--worker") == 0) {
      char* end = nullptr;
      const long fd = std::strtol(argv[2], &end, 10);
      check(end && *end == '\0' && fd >= 0 && fd < 1000000, "worker fd argument");
      Fd report(static_cast<int>(fd));
      check(send(report.get(), {static_cast<long>(getpid()), state, 0}), "worker report");
      return 0;
    }
    check(argc == 1, "no arguments expected");
    observe(argv[0], false);
    observe(argv[0], true);
    std::cout << "POSIX host observation only; xv6/QEMU/Linux board not tested\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
