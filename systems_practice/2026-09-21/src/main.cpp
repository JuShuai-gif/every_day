#include <atomic>
#include <cmath>
#include <functional>
#include <iostream>
#include <numeric>
#include <string>

#include "bounded_pool.hpp"

using namespace std::chrono_literals;
using practice::Admission;
using practice::BoundedQueue;
using practice::Clock;
using practice::Pool;

void require(bool condition, const char* message) {
  if (!condition) {
    throw std::runtime_error(message);
  }
}

template <class F>
bool eventually(F&& predicate) {
  const auto end = Clock::now() + 3s;
  while (!predicate()) {
    if (Clock::now() > end) {
      return false;
    }
    std::this_thread::yield();
  }
  return true;
}

void queue_contracts() {
  bool invalid = false;
  try {
    BoundedQueue<int> bad(0);
  } catch (const std::invalid_argument&) {
    invalid = true;
  }
  require(invalid, "zero capacity rejected");
  BoundedQueue<std::unique_ptr<int>> q(1);
  auto first = std::make_unique<int>(7);
  require(q.push(first) == Admission::accepted && !first, "accepted ownership");
  auto second = std::make_unique<int>(9);
  require(q.push(second, Clock::now()) == Admission::timeout && second,
          "timeout preserves ownership");
  q.close();
  q.close();
  require(q.push(second) == Admission::closed && second, "close preserves ownership");
  auto out = q.pop();
  require(out && **out == 7 && !q.pop(), "close drains accepted item");

  BoundedQueue<int> full(1);
  int initial = 1;
  full.push(initial);
  auto blocked = std::async(std::launch::async, [&] {
    int item = 2;
    return full.push(item);
  });
  const bool waiting = eventually([&] {
    return full.snapshot().producers_waiting == 1;
  });
  full.close();  // 即使观察失败也先唤醒，避免测试自身卡在 async 析构。
  const auto rejected = blocked.get();
  require(waiting && rejected == Admission::closed, "close wakes full-queue producer");

  BoundedQueue<int> empty(2);
  std::vector<std::future<std::optional<int>>> consumers;
  for (int i = 0; i < 4; ++i) {
    consumers.push_back(std::async(std::launch::async, [&] {
      return empty.pop();
    }));
  }
  const bool all_waiting = eventually([&] {
    return empty.snapshot().consumers_waiting == 4;
  });
  empty.close();
  bool all_exited = true;
  for (auto& consumer : consumers) {
    all_exited = !consumer.get() && all_exited;
  }
  require(all_waiting && all_exited, "close wakes all empty-queue consumers");

  // 真实等待中的生产者在 pop 后被唤醒，环绕后 FIFO 仍成立。
  BoundedQueue<int> wake(1);
  wake.push(initial);
  auto producer = std::async(std::launch::async, [&] {
    int value = 12;
    return wake.push(value, Clock::now() + 3s);
  });
  const bool producer_waiting = eventually([&] {
    return wake.snapshot().producers_waiting == 1;
  });
  const auto old = wake.pop();
  const auto accepted = producer.get();
  wake.close();
  auto next = wake.pop();
  require(producer_waiting && old == 1 && accepted == Admission::accepted && next == 12,
          "pop wakes producer and preserves FIFO");
  std::cout << "PASS queue: capacity/ownership/timeout/drain/FIFO/close wakes both wait sets\n";
}

void pool_contracts() {
  bool invalid = false;
  try {
    Pool bad(0, 1);
  } catch (const std::invalid_argument&) {
    invalid = true;
  }
  require(invalid, "zero workers rejected");
  Pool pool(2, 2);
  auto bad = pool.submit([]() -> int {
    throw std::runtime_error("request failed");
  });
  bool propagated = false;
  try {
    (void)bad.result.get();
  } catch (const std::runtime_error&) {
    propagated = true;
  }
  auto good = pool.submit([owned = std::make_unique<int>(42)] {
    return *owned;
  });
  require(propagated && good.result.get() == 42, "future exception and move-only task");
  auto recursive = pool.submit([&] {
    return pool
        .submit([] {
          return 1;
        })
        .result.get();
  });
  auto self_join = pool.submit([&] {
    pool.shutdown();
  });
  int guarded = 0;
  try {
    (void)recursive.result.get();
  } catch (const std::logic_error&) {
    ++guarded;
  }
  try {
    self_join.result.get();
  } catch (const std::logic_error&) {
    ++guarded;
  }
  pool.shutdown();
  pool.shutdown();
  auto rejected = pool.submit([] {
    return 0;
  });
  require(guarded == 2 && rejected.status == Admission::closed && !rejected.result.valid(),
          "self-deadlock guards and shutdown idempotence");

  std::future<int> surviving;
  std::weak_ptr<int> observer;
  {
    Pool scoped(1, 1);
    auto payload = std::make_shared<int>(81);
    observer = payload;
    surviving = scoped
                    .submit([payload] {
                      return *payload;
                    })
                    .result;
  }
  require(surviving.get() == 81 && observer.expired(), "destructor drains/releases payload");

  // 单 worker 由门闩占住：size==0 时仍有 in-flight 请求。
  Pool gated(1, 1);
  std::promise<void> release, started;
  auto gate = release.get_future().share();
  auto active = gated.submit([&] {
    started.set_value();
    gate.wait();
    return 1;
  });
  started.get_future().wait();
  const bool empty_while_active = gated.snapshot().size == 0;
  auto queued = gated.submit([] {
    return 2;
  });
  auto timed = gated.submit(
      [] {
        return 3;
      },
      Clock::now() + 2ms);
  auto waiting = std::async(std::launch::async, [&] {
    return gated.submit([] {
      return 4;
    });
  });
  const bool observed = eventually([&] {
    return gated.snapshot().producers_waiting == 1;
  });
  gated.close();
  auto closed = waiting.get();
  release.set_value();
  gated.shutdown();
  require(empty_while_active && observed && timed.status == Admission::timeout &&
              closed.status == Admission::closed && active.result.get() == 1 &&
              queued.result.get() == 2,
          "inflight/timeout/blocked-submit close/drain");
  std::cout
      << "PASS pool: exceptions/move-only/recursive guard/RAII/inflight/blocked-submit close\n";
}

void stress() {
  for (std::size_t capacity : {1U, 7U, 64U}) {
    constexpr int producers = 4, each = 500, total = producers * each;
    std::vector<std::atomic<int>> seen(total);
    for (auto& value : seen) {
      value.store(0);
    }
    Pool pool(4, capacity);
    std::vector<std::future<void>> senders;
    for (int p = 0; p < producers; ++p) {
      senders.push_back(std::async(std::launch::async, [&, p] {
        std::vector<std::future<int>> replies;
        for (int j = 0; j < each; ++j) {
          const int id = p * each + j;
          auto ticket = pool.submit([&, id] {
            seen[id].fetch_add(1);
            return id;
          });
          require(ticket.status == Admission::accepted, "stress admission");
          replies.push_back(std::move(ticket.result));
        }
        for (int j = 0; j < each; ++j) {
          require(replies[j].get() == p * each + j, "result belongs to request");
        }
      }));
    }
    for (auto& sender : senders) {
      sender.get();
    }
    pool.shutdown();
    for (const auto& value : seen) {
      require(value.load() == 1, "exactly once");
    }
    require(pool.snapshot().high_water <= capacity, "bounded queue");
    std::cout << "PASS MPMC capacity=" << capacity << " producers=4 workers=4 requests=" << total
              << '\n';
  }

  // close 与多个 submit 的竞争：接受成功的集合必须等于执行集合。
  for (int round = 0; round < 20; ++round) {
    Pool pool(2, 3);
    std::atomic<int> executed{0}, accepted{0}, closed{0};
    std::vector<std::future<void>> senders;
    for (int p = 0; p < 4; ++p) {
      senders.push_back(std::async(std::launch::async, [&] {
        std::vector<std::future<void>> replies;
        for (int i = 0; i < 100; ++i) {
          auto ticket = pool.submit([&] {
            executed.fetch_add(1);
          });
          if (ticket.status == Admission::accepted) {
            accepted.fetch_add(1);
            replies.push_back(std::move(ticket.result));
          } else {
            require(ticket.status == Admission::closed, "race rejection status");
            closed.fetch_add(1);
          }
        }
        for (auto& reply : replies) {
          reply.get();
        }
      }));
    }
    const bool progress = eventually([&] {
      return executed.load() > 0;
    });
    pool.close();
    for (auto& sender : senders) {
      sender.get();
    }
    pool.shutdown();
    require(
        progress && accepted.load() == executed.load() && accepted.load() + closed.load() == 400,
        "close linearization: every accepted job drains");
  }
  std::cout << "PASS concurrent close: 20 rounds x 400 attempted requests\n";
}

double us(Clock::duration d) {
  return std::chrono::duration<double, std::micro>(d).count();
}
double percentile(std::vector<double> values, double fraction) {
  std::sort(values.begin(), values.end());
  return values[static_cast<std::size_t>(std::ceil(fraction * values.size())) - 1];
}

void benchmark() {
  constexpr int count = 2 * 197 * 32, requests = 128, warmup = 10, samples = 30;
  auto input = std::make_shared<std::vector<float>>(count);
  for (int i = 0; i < count; ++i) {
    (*input)[i] = static_cast<float>(i % 17 - 8) / 16.0F;
  }
  const long double oracle = std::accumulate(input->begin(), input->end(), 0.0L);
  struct Timing {
    double checksum, queue_us, work_us, end_to_end_us;
  };
  for (std::size_t capacity : {1U, 8U, 64U}) {
    Pool pool(2, capacity);
    std::vector<double> batch_us, queue_us, work_us, e2e_us, admission_us;
    for (int sample = -warmup; sample < samples; ++sample) {
      std::vector<std::future<Timing>> replies;
      replies.reserve(requests);
      const auto batch_start = Clock::now();
      for (int request = 0; request < requests; ++request) {
        const auto begin = Clock::now();
        auto ticket = pool.submit([input, begin] {
          const auto start = Clock::now();
          double sum = 0;
          for (float x : *input) {
            sum += x;
          }
          const auto end = Clock::now();
          return Timing{sum, us(start - begin), us(end - start), us(end - begin)};
        });
        const double admission = us(Clock::now() - begin);
        require(ticket.status == Admission::accepted, "benchmark keeps all requests");
        if (sample >= 0) {
          admission_us.push_back(admission);
        }
        replies.push_back(std::move(ticket.result));
      }
      for (auto& reply : replies) {
        const auto timing = reply.get();
        require(std::isfinite(timing.checksum) && timing.checksum == oracle, "benchmark checksum");
        if (sample >= 0) {
          queue_us.push_back(timing.queue_us);
          work_us.push_back(timing.work_us);
          e2e_us.push_back(timing.end_to_end_us);
        }
      }
      if (sample >= 0) {
        batch_us.push_back(us(Clock::now() - batch_start));
      }
    }
    pool.shutdown();
    std::cout << "CPU capacity=" << capacity
              << " workers=2 shape=[2,197,32] requests_per_batch=" << requests
              << " warmup=" << warmup << " samples=" << samples
              << " batch_p50_us=" << percentile(batch_us, .5)
              << " batch_p95_us=" << percentile(batch_us, .95)
              << " admission_p95_us=" << percentile(admission_us, .95)
              << " submit_to_start_p95_us=" << percentile(queue_us, .95)
              << " cpu_work_p50_us=" << percentile(work_us, .5)
              << " request_e2e_p95_us=" << percentile(e2e_us, .95)
              << " queue_high_water=" << pool.snapshot().high_water << '\n';
  }
}

int main(int argc, char** argv) {
  try {
    const std::string mode = argc == 2 ? argv[1] : "check";
    if (argc > 2 || (mode != "check" && mode != "bench")) {
      throw std::invalid_argument("usage: pool_check check|bench");
    }
    if (mode == "check") {
      queue_contracts();
      pool_contracts();
      stress();
    } else {
      benchmark();
    }
    return 0;
  } catch (const std::exception& error) {
    std::cerr << "FAIL: " << error.what() << '\n';
    return 1;
  }
}
