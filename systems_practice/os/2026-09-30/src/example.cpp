#include <sys/wait.h>
#include <unistd.h>

#include <cerrno>
#include <csignal>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <iostream>
#include <stdexcept>
void require(bool v, const char* msg) {
  if (!v) {
    throw std::runtime_error(msg);
  }
}
struct Fd {
  int v;
  explicit Fd(int fd) : v(fd) {
  }
  ~Fd() {
    close_now();
  }
  Fd(const Fd&) = delete;
  Fd& operator=(const Fd&) = delete;
  void close_now() noexcept {
    if (v >= 0) {
      int old = v;
      v = -1;
      // close失败只报告，不盲目重试以免误关被复用的FD。
      if (::close(old) != 0) {
        std::perror("close");
      }
    }
  }
};
struct Child {
  pid_t pid;
  ~Child() {
    if (pid > 0) {
      int s;
      pid_t r;
      do {
        r = waitpid(pid, &s, 0);
      } while (r < 0 && errno == EINTR);
      if (r < 0) {
        std::perror("cleanup waitpid");
      }
    }
  }
  Child(const Child&) = delete;
  Child& operator=(const Child&) = delete;
  explicit Child(pid_t p) : pid(p) {
  }
  int reap() {
    int s = 0;
    pid_t r;
    do {
      r = waitpid(pid, &s, 0);
    } while (r < 0 && errno == EINTR);
    require(r == pid, "waitpid failed");
    pid = -1;
    return s;
  }
};
void case_exit(bool signal_exit) {
  int fds[2];
  require(pipe(fds) == 0, "pipe failed");
  Fd reader(fds[0]), writer(fds[1]);
  pid_t pid = fork();
  require(pid >= 0, "fork failed");
  if (pid == 0) {
    reader.close_now();
    // 子进程只使用退出/FD接口；_exit不运行C++自动析构。
    char v = 'x';
    if (write(writer.v, &v, 1) != 1) {
      _exit(120);
    }
    if (signal_exit) {
      if (kill(getpid(), SIGKILL) != 0) {
        _exit(121);
      }
      _exit(122);
    }
    _exit(37);
  }
  Child child(pid);
  writer.close_now();
  char v = 0;
  ssize_t n;
  do {
    n = read(reader.v, &v, 1);
  } while (n < 0 && errno == EINTR);
  require(n == 1 && v == 'x', "child payload missing");
  do {
    n = read(reader.v, &v, 1);
  } while (n < 0 && errno == EINTR);
  require(n == 0, "EOF requires all write references closed");
  // WNOWAIT只观察保留退出记录；waitpid才最终回收。
  siginfo_t info{};
  int rc;
  do {
    rc = waitid(P_PID, static_cast<id_t>(pid), &info, WEXITED | WNOWAIT);
  } while (rc < 0 && errno == EINTR);
  require(rc == 0 && info.si_pid == pid, "waitid observation failed");
  std::cout << "before reap: pid=" << info.si_pid << " si_code=" << info.si_code
            << " si_status=" << info.si_status << " pipe_EOF=true\n";
  int status = child.reap();
  require(signal_exit ? WIFSIGNALED(status) && WTERMSIG(status) == SIGKILL
                      : WIFEXITED(status) && WEXITSTATUS(status) == 37,
          "wrong exit reason");
  errno = 0;
  require(waitpid(pid, &status, WNOHANG) == -1 && errno == ECHILD, "child not fully reaped");
}
int main() {
  try {
    // 只派生本练习的子进程；不操作其他进程。
    case_exit(false);
    case_exit(true);
    std::cout << "PASS normal exit37, signal9, EOF before reap, WNOWAIT, ECHILD\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
