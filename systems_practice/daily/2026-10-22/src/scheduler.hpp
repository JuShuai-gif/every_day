#pragma once
#include <algorithm>
#include <chrono>
#include <cstdint>
#include <limits>
#include <optional>
#include <stdexcept>
#include <vector>

// 单一控制线程拥有全部槽位；设备只能持有submit之后的只读输入租约。
class Scheduler {
 public:
  using Clock = std::chrono::steady_clock;
  using Time = Clock::time_point;
  enum class State { Free, Queued, InFlight };
  enum class Result { Accepted, Expired, Full, Closed };
  struct Ticket {
    std::size_t slot;
    std::uint64_t generation;
  };
  struct Slot {
    State state = State::Free;
    std::uint64_t generation = 0;
    Time deadline{};
    bool abandoned = false;
    std::vector<float> input;
    explicit Slot(std::size_t n) : input(n) {
    }
  };
  Scheduler(std::size_t capacity, std::size_t elements) {
    if (capacity == 0 || capacity > 64 || elements == 0 || elements > 1048576) {
      throw std::invalid_argument("capacity/elements outside bounded contract");
    }
    slots_.reserve(capacity);
    for (std::size_t i = 0; i < capacity; ++i) {
      slots_.emplace_back(elements);
    }
  }
  Result submit(Time now, Time deadline, float value, Ticket& ticket) {
    if (closed_) {
      return Result::Closed;
    }
    if (deadline <= now) {
      return Result::Expired;
    }
    expire(now);
    for (std::size_t i = 0; i < slots_.size(); ++i) {
      auto& s = slots_[i];
      if (s.state == State::Free) {
        if (s.generation == std::numeric_limits<std::uint64_t>::max()) {
          throw std::overflow_error("generation exhausted");
        }
        std::fill(s.input.begin(), s.input.end(), value);
        ++s.generation;
        s.deadline = deadline;
        s.abandoned = false;
        s.state = State::Queued;
        ticket = {i, s.generation};
        return Result::Accepted;
      }
    }
    return Result::Full;
  }
  std::optional<Ticket> dispatch(Time now) {
    expire(now);
    // 有界线性扫描选择最早deadline；不声称等同Triton优先级队列。
    std::optional<std::size_t> best;
    for (std::size_t i = 0; i < slots_.size(); ++i) {
      if (slots_[i].state == State::Queued &&
          (!best || slots_[i].deadline < slots_[*best].deadline)) {
        best = i;
      }
    }
    if (!best) {
      return std::nullopt;
    }
    auto& s = slots_[*best];
    s.state = State::InFlight;
    return Ticket{*best, s.generation};
  }
  void cancel(Ticket t) {
    auto& s = get(t);
    if (s.state == State::Queued) {
      s.state = State::Free;
    } else {
      s.abandoned = true;
    }  // 在途取消只放弃结果，绝不提前覆盖输入。
  }
  bool complete(Ticket t, Time now, bool device_ok) {
    auto& s = get(t);
    if (s.state != State::InFlight) {
      throw std::logic_error("not in flight");
    }
    const bool deliver = device_ok && !s.abandoned && now < s.deadline;
    s.state = State::Free;  // 调用者必须先取得设备完成证据。
    return deliver;
  }
  const std::vector<float>& input(Ticket t) {
    return get(t).input;
  }
  void close() {
    closed_ = true;
    for (auto& s : slots_) {
      if (s.state == State::Queued) {
        s.state = State::Free;
      } else if (s.state == State::InFlight) {
        s.abandoned = true;
      }
    }
  }
  std::size_t live() const {
    std::size_t n = 0;
    for (const auto& s : slots_) {
      n += s.state != State::Free;
    }
    return n;
  }

 private:
  Slot& get(Ticket t) {
    if (t.slot >= slots_.size()) {
      throw std::out_of_range("slot");
    }
    auto& s = slots_[t.slot];
    if (s.state == State::Free || s.generation != t.generation) {
      throw std::logic_error("stale/duplicate ticket");
    }
    return s;
  }
  void expire(Time now) {
    for (auto& s : slots_) {
      if (s.state == State::Queued && s.deadline <= now) {
        s.state = State::Free;
      }
    }
  }
  std::vector<Slot> slots_;
  bool closed_ = false;
};
