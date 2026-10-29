#include <cassert>
#include <condition_variable>
#include <iostream>
#include <mutex>
#include <queue>
#include <thread>
struct Pipeline {
  std::mutex m;
  std::condition_variable cv;
  std::queue<int> q;
  bool closing = false;
  int done = 0;
  void submit(int x) {
    std::lock_guard<std::mutex> l(m);
    if (closing)
      throw std::runtime_error("closed");
    q.push(x);
    cv.notify_one();
  }
  void worker() {
    for (;;) {
      std::unique_lock<std::mutex> l(m);
      cv.wait(l, [&] { return closing || !q.empty(); });
      if (q.empty() && closing)
        return;
      int x = q.front();
      q.pop();
      l.unlock();
      {
        std::lock_guard<std::mutex> g(m);
        done += x;
      }
    }
  }
  void close() {
    std::lock_guard<std::mutex> l(m);
    closing = true;
    cv.notify_all();
  }
};
int main() {
  Pipeline p;
  std::thread t(&Pipeline::worker, &p);
  for (int i = 1; i <= 4; ++i)
    p.submit(i);
  p.close();
  t.join();
  assert(p.done == 10);
  try {
    p.submit(1);
    assert(false);
  } catch (const std::runtime_error &) {
  }
  std::cout << "PASS bounded_pipeline done=" << p.done << " close_reject=1\n";
}
