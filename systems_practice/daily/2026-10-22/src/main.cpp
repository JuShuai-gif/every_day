#include <algorithm>
#include <iostream>
#include <string>

#include "scheduler.hpp"
void require(bool ok, const char* why) {
  if (!ok) {
    throw std::runtime_error(why);
  }
}
template <class F>
void rejects(F f) {
  bool rejected = false;
  try {
    f();
  } catch (const std::exception&) {
    rejected = true;
  }
  require(rejected, "expected rejection");
}
int main() {
  try {
    using R = Scheduler::Result;
    const Scheduler::Time t{};
    using namespace std::chrono_literals;
    rejects([] {
      Scheduler invalid(0, 1);
    });
    rejects([] {
      Scheduler invalid(1, 0);
    });
    for (int trial = 0; trial < 1000; ++trial) {
      Scheduler s(2, 17);
      Scheduler::Ticket a{}, b{}, c{};
      require(s.submit(t, t, 1, a) == R::Expired, "deadline equality");
      require(s.submit(t, t + 10ms, 7, a) == R::Accepted, "accept A");
      require(s.submit(t, t + 5ms, 3, b) == R::Accepted, "accept B");
      require(s.submit(t, t + 6ms, 9, c) == R::Full, "bounded");
      auto running = s.dispatch(t);
      require(running && running->slot == b.slot, "earliest deadline");
      s.cancel(*running);
      require(s.submit(t, t + 6ms, 9, c) == R::Full, "cancel retains lease");
      require(std::all_of(s.input(b).begin(),
                          s.input(b).end(),
                          [](float x) {
                            return x == 3;
                          }),
              "input not reused");
      require(!s.complete(b, t + 2ms, true), "cancelled result dropped");
      require(s.submit(t, t + 4ms, 9, c) == R::Accepted, "reuse after completion");
      rejects([&] {
        s.complete(b, t, true);
      });
      auto second = s.dispatch(t);
      require(second && second->generation == c.generation, "new generation");
      require(!s.complete(c, t + 4ms, true), "late result dropped");
      auto third = s.dispatch(t);
      require(third.has_value(), "A dispatched");
      s.close();
      require(s.live() == 1, "close retains in-flight");
      require(s.submit(t, t + 9ms, 0, c) == R::Closed, "closed");
      require(!s.complete(a, t + 3ms, false) && s.live() == 0, "error drain");
      rejects([&] {
        s.complete(a, t, true);
      });
    }
    Scheduler edge(1, 1);
    Scheduler::Ticket a{}, b{};
    require(edge.submit(t, t + 1ms, 1, a) == R::Accepted, "edge");
    require(edge.submit(t + 1ms, t + 3ms, 2, b) == R::Accepted, "queued expiry reclaims");
    require(edge.dispatch(t + 1ms).has_value(), "dispatch boundary");
    require(edge.complete(b, t + 2ms, true), "valid result");
    require(!edge.dispatch(t + 5ms), "empty");
    std::cout << "PASS trials=1000 expiry/full/cancel/late/stale/close/device-error; "
                 "valid-delivery=1; live=0\n"
              << "Logical injected timestamps only; no inference latency measurement.\n";
    return 0;
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
