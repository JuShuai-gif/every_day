#include <atomic>
#include <iostream>
#include <numeric>
#include <string>

#include "pool.hpp"
using namespace std::chrono_literals;
void check(bool ok) {
  if (!ok) {
    throw std::runtime_error("check failed");
  }
}
int main() {
  try {
    for (int fail : {0, 1, 2}) {
      bool rejected = false;
      try {
        Pool p(3, 2, fail);
      } catch (const std::runtime_error&) {
        rejected = true;
      }
      check(rejected);
    }
    for (auto shape : {std::pair<int, int>{0, 1}, {1, 0}}) {
      bool rejected = false;
      try {
        Pool p(shape.first, shape.second);
      } catch (const std::invalid_argument&) {
        rejected = true;
      }
      check(rejected);
    }
    {
      Pool p(1, 1);
      std::promise<void> start, release;
      auto gate = release.get_future().share();
      auto first = p.submit_for(
          [&] {
            start.set_value();
            gate.wait();
            return 7;
          },
          1s);
      start.get_future().wait();
      auto second = p.submit_for(
          [] {
            return 9;
          },
          1s);
      bool timeout = false;
      try {
        p.submit_for(
            [] {
              return 0;
            },
            5ms);
      } catch (const std::runtime_error& e) {
        timeout = std::string(e.what()) == "queue timeout";
      }
      auto blocked = std::async(std::launch::async, [&] {
        try {
          p.submit_for(
              [] {
                return 0;
              },
              5s);
          return false;
        } catch (const std::runtime_error& e) {
          return std::string(e.what()) == "pool closed";
        }
      });
      auto waiting = std::async(std::launch::async, [&] {
        p.wait_idle();
      });
      bool held = waiting.wait_for(5ms) == std::future_status::timeout;
      p.close();
      bool rejected = blocked.get();
      release.set_value();  // 先释放所有等待者，再做会抛出的断言。
      waiting.get();
      check(timeout && held && rejected && first.get() == 7 && second.get() == 9);
      p.close();
    }
    {
      Pool p(2, 3);
      auto bad = p.submit_for(
          []() -> int {
            throw std::runtime_error("inference failure");
          },
          1s);
      auto recursive = p.submit_for(
          [&] {
            p.wait_idle();
            return 0;
          },
          1s);
      auto nested = p.submit_for(
          [&] {
            p.submit_for(
                [] {
                  return 1;
                },
                1s);
            return 0;
          },
          1s);
      int errors = 0;
      for (auto* f : {&bad, &recursive, &nested}) {
        try {
          (void)f->get();
        } catch (const std::exception&) {
          ++errors;
        }
      }
      check(errors == 3);
      check(p.submit_for(
                 [] {
                   return 42;
                 },
                 1s)
                .get() == 42);
    }
    {
      Pool p(1, 1);
      std::promise<void> started, release;
      auto gate = release.get_future().share();
      auto task = p.submit_for(
          [&] {
            started.set_value();
            gate.wait();
            return 1;
          },
          1s);
      started.get_future().wait();
      // 唯一任务已经出队：queue空不等于idle。
      auto waiter = std::async(std::launch::async, [&] {
        p.wait_idle();
      });
      bool still_active = waiter.wait_for(5ms) == std::future_status::timeout;
      p.close();
      release.set_value();
      waiter.get();
      check(still_active && task.get() == 1);
    }
    std::atomic<int> executed{0};
    std::vector<int> seen(800, 0);
    {
      Pool p(4, 7);
      std::vector<std::future<void>> producers;
      for (int producer = 0; producer < 4; ++producer) {
        producers.emplace_back(std::async(std::launch::async, [&, producer] {
          std::vector<std::future<int>> fs;
          for (int i = 0; i < 200; ++i) {
            int id = producer * 200 + i;
            fs.push_back(p.submit_for(
                [&, id] {
                  seen[id]++;
                  executed.fetch_add(1);
                  return id;
                },
                10s));
          }
          for (int i = 0; i < 200; ++i) {
            check(fs[i].get() == producer * 200 + i);
          }
        }));
      }
      for (auto& f : producers) {
        f.get();
      }
      p.close();
      p.wait_idle();
    }
    check(executed == 800);
    for (int count : seen) {
      check(count == 1);
    }
    std::cout << "PASS 800 tasks exactly once; full timeout; close wake/drain; in-flight idle; 3 "
                 "task errors; 3 constructor rollbacks; 2 invalid shapes\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
