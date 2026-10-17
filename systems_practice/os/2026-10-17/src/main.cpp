#include <condition_variable>
#include <future>
#include <iostream>
#include <memory>
#include <mutex>
#include <stdexcept>
#include <thread>
#include <vector>
// 宿主设备模型：提交占用槽，完成发布结果，wait才回收；不是DMA模拟器。
class Device {
  enum class State { Free, Pending, Complete };
  std::mutex m_;
  std::condition_variable cv_;
  State state_ = State::Free;
  bool stop_ = false;
  bool fail_ = false;
  std::shared_ptr<const std::vector<int>> input_;
  int result_ = 0;
  std::thread worker_;
  void loop() {
    std::unique_lock<std::mutex> lock(m_);
    for (;;) {
      cv_.wait(lock, [&] {
        return stop_ || state_ == State::Pending;
      });
      if (state_ != State::Pending) {
        return;
      }
      auto lease = input_;
      bool fail = fail_;
      lock.unlock();
      int sum = 0;
      for (int x : *lease) {
        sum += x;
      }
      lock.lock();
      result_ = fail ? -1 : sum;
      state_ = State::Complete;
      cv_.notify_all();
      cv_.wait(lock, [&] {
        return stop_ || state_ != State::Complete;
      });
      if (stop_) {
        return;
      }
    }
  }

 public:
  Device()
      : worker_([this] {
          loop();
        }) {
  }
  ~Device() {
    {
      std::lock_guard<std::mutex> lock(m_);
      stop_ = true;
      cv_.notify_all();
    }
    worker_.join();  // 不在持锁状态join；在途lease由worker排空。
  }
  Device(const Device&) = delete;
  Device& operator=(const Device&) = delete;
  void submit(std::shared_ptr<const std::vector<int>> input, bool fail = false) {
    std::lock_guard<std::mutex> lock(m_);
    if (!input || input->empty() || input->size() > 1024) {
      throw std::invalid_argument("input");
    }
    for (int x : *input) {
      if (x < -1000 || x > 1000) {
        throw std::invalid_argument("value");
      }
    }
    if (state_ != State::Free) {
      throw std::runtime_error("slot is owned until wait");
    }
    input_ = std::move(input);
    fail_ = fail;
    state_ = State::Pending;
    cv_.notify_all();
  }
  int wait() {
    std::unique_lock<std::mutex> lock(m_);
    if (state_ == State::Free) {
      throw std::logic_error("no request");
    }
    cv_.wait(lock, [&] {
      return state_ == State::Complete;
    });
    int result = result_;
    input_.reset();
    state_ = State::Free;
    cv_.notify_all();
    if (fail_) {
      throw std::runtime_error("device status failed, slot reclaimed");
    }
    return result;
  }
  void noise() {
    cv_.notify_all();
  }
};
int main() {
  try {
    Device d;
    int rejected = 0;
    try {
      d.wait();
    } catch (const std::logic_error&) {
      ++rejected;
    }
    try {
      d.submit(nullptr);
    } catch (const std::invalid_argument&) {
      ++rejected;
    }
    auto input = std::make_shared<const std::vector<int>>(std::vector<int>{1, 2, 3});
    d.submit(input);  // 即使完成很快，尚未wait也不得复用。
    try {
      d.submit(input);
    } catch (const std::runtime_error&) {
      ++rejected;
    }
    d.noise();
    if (d.wait() != 6) {
      throw std::runtime_error("sum");
    }
    d.submit(input, true);
    try {
      d.wait();
    } catch (const std::runtime_error&) {
      ++rejected;
    }
    for (int i = 0; i < 2000; ++i) {
      d.submit(input);
      if (d.wait() != 6) {
        throw std::runtime_error("reuse");
      }
    }
    std::weak_ptr<const std::vector<int>> weak;
    {
      Device closing;
      auto owned = std::make_shared<const std::vector<int>>(std::vector<int>{7});
      weak = owned;
      closing.submit(owned);
      owned.reset();
    }
    if (!weak.expired() || rejected != 4) {
      throw std::runtime_error("lifetime/reject");
    }
    std::cout << "PASS 2000 reuse submit!=complete!=reclaim rejected=4 shutdown_lease_released\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
