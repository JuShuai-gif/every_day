#pragma once

#include <sys/resource.h>

#include <algorithm>
#include <chrono>
#include <cmath>
#include <cstdint>
#include <fstream>
#include <functional>
#include <iomanip>
#include <iostream>
#include <limits>
#include <stdexcept>
#include <string>
#include <vector>

// 构建元信息与板端探测分开；这里不能证明远端硬件支持哪些指令。
#ifndef EDGE_BUILD_CPU_TUNE
#define EDGE_BUILD_CPU_TUNE "unspecified"
#endif
#ifndef EDGE_BUILD_EXPLICIT_NEON
#define EDGE_BUILD_EXPLICIT_NEON 1
#endif
#ifndef EDGE_BUILD_AUTO_VECTORIZE
#define EDGE_BUILD_AUTO_VECTORIZE 1
#endif

namespace edge {

inline void print_build_contract() {
  std::cout << "build_cpu_tune=" << EDGE_BUILD_CPU_TUNE
            << " explicit_neon_enabled=" << EDGE_BUILD_EXPLICIT_NEON
            << " auto_vectorize_enabled=" << EDGE_BUILD_AUTO_VECTORIZE;
#if defined(__aarch64__)
  std::cout << " compile_arch=aarch64";
#else
  std::cout << " compile_arch=other";
#endif
#if defined(__ARM_NEON)
  std::cout << " compile_neon=1";
#else
  std::cout << " compile_neon=0";
#endif
  std::cout << " feature_scope=compile_time_not_remote_probe\n";
}

struct Options {
  std::string mode = "all";
  std::string csv;
  std::size_t samples = 30;
  std::size_t warmup = 5;
  std::size_t iterations = 1;
  double seconds = 0;
  double budget_us = 0;
  bool test_only = false;
  bool profile = false;
};

inline void require(bool condition, const std::string& message) {
  if (!condition) {
    throw std::runtime_error(message);
  }
}

// 仅为微基准阻止编译器跨调用移动/消除内存工作；不是 CPU 内存屏障或线程同步。
inline void clobber() {
  asm volatile("" : : : "memory");
}

template <typename T>
inline void escape(const T& value) {
  asm volatile("" : : "g"(&value) : "memory");
}

struct Variant {
  std::string name;
  std::function<std::uint64_t()> action;
};

inline double quantile(std::vector<double> values, double fraction) {
  require(!values.empty(), "empty latency samples");
  std::sort(values.begin(), values.end());
  const auto rank = static_cast<std::size_t>(std::ceil(fraction * values.size()));
  return values[std::min(values.size() - 1, rank == 0 ? 0 : rank - 1)];
}

inline std::size_t parse_count(const std::string& text, bool allow_zero = false) {
  require(!text.empty() && text.find_first_not_of("0123456789") == std::string::npos,
          "expected unsigned decimal integer: " + text);
  const auto n = std::stoull(text);
  require(n <= 1000000 && (allow_zero || n != 0), "count must be 1..1000000 (warmup allows 0)");
  return static_cast<std::size_t>(n);
}

inline Options parse(int argc, char** argv) {
  Options options;
  for (int i = 1; i < argc; ++i) {
    const std::string key = argv[i];
    if (key == "--test") {
      options.test_only = true;
    } else if (key == "--profile") {
      options.profile = true;
    } else {
      require(i + 1 < argc, "missing value for " + key);
      const std::string value = argv[++i];
      if (key == "--mode")
        options.mode = value;
      else if (key == "--csv")
        options.csv = value;
      else if (key == "--samples")
        options.samples = parse_count(value);
      else if (key == "--warmup")
        options.warmup = parse_count(value, true);
      else if (key == "--iterations")
        options.iterations = parse_count(value);
      else if (key == "--seconds" || key == "--budget-us") {
        std::size_t consumed = 0;
        const double v = std::stod(value, &consumed);
        require(consumed == value.size() && std::isfinite(v) && v >= 0,
                "expected finite nonnegative value for " + key);
        if (key == "--seconds")
          options.seconds = v;
        else
          options.budget_us = v;
      } else {
        throw std::runtime_error("unknown option: " + key);
      }
    }
  }
  require(options.mode == "all" || options.mode == "baseline" || options.mode == "stage1" ||
              options.mode == "optimized",
          "invalid --mode");
  require(!(options.test_only && options.profile), "--test conflicts with --profile");
  require(!options.profile || options.mode != "all", "--profile requires one explicit --mode");
  return options;
}

inline void benchmark(const Options& options,
                      const std::vector<Variant>& variants,
                      double units_per_invocation = 1) {
  require(units_per_invocation > 0 && std::isfinite(units_per_invocation), "invalid work units");
  std::vector<const Variant*> selected;
  for (const auto& variant : variants) {
    if (options.mode == "all" || options.mode == variant.name)
      selected.push_back(&variant);
  }
  require(!selected.empty(), "requested variant is unavailable");
  std::ofstream csv;
  if (!options.csv.empty()) {
    csv.open(options.csv);
    require(bool(csv), "cannot open CSV: " + options.csv);
    csv << "variant,sample,iterations,batch_us,us_per_invocation,digest,work_units,budget_us,"
           "budget_exceeded\n";
  }

  auto invoke = [](const Variant& variant) {
    clobber();
    const auto digest = variant.action();
    escape(digest);
    clobber();
    return digest;
  };
  for (std::size_t w = 0; w < options.warmup; ++w) {
    for (auto* variant : selected)
      invoke(*variant);
  }

  std::vector<std::vector<double>> timings(selected.size());
  std::vector<std::uint64_t> digests(selected.size(), 0);
  std::vector<std::uint64_t> expected(selected.size(), 0);
  const auto started = std::chrono::steady_clock::now();
  std::size_t round = 0;
  // 所有阶段轮换先后次序，降低固定“先 baseline 后 optimized”带来的热机偏差。
  do {
    require(round < 1000000, "sample limit reached; increase --iterations for long stress runs");
    for (std::size_t j = 0; j < selected.size(); ++j) {
      const auto v = (round + j) % selected.size();
      std::uint64_t digest = 0;
      const auto begin = std::chrono::steady_clock::now();
      for (std::size_t i = 0; i < options.iterations; ++i) {
        digest ^=
            invoke(*selected[v]) + UINT64_C(0x9e3779b97f4a7c15) + (digest << 6) + (digest >> 2);
      }
      const auto end = std::chrono::steady_clock::now();
      const double batch_us = std::chrono::duration<double, std::micro>(end - begin).count();
      const double us = batch_us / options.iterations;
      timings[v].push_back(us);
      if (round == 0)
        expected[v] = digest;
      require(expected[v] == digest, "nondeterministic result during stress: " + selected[v]->name);
      digests[v] ^= digest + UINT64_C(0x9e3779b97f4a7c15) + (digests[v] << 6) + (digests[v] >> 2);
      if (csv) {
        csv << selected[v]->name << ',' << round << ',' << options.iterations << ','
            << std::setprecision(17) << batch_us << ',' << us << ',' << digest << ','
            << units_per_invocation << ',' << options.budget_us << ','
            << (options.budget_us > 0 && us > options.budget_us ? 1 : 0) << '\n';
      }
    }
    ++round;
  } while (round < options.samples ||
           std::chrono::duration<double>(std::chrono::steady_clock::now() - started).count() <
               options.seconds);

  for (std::size_t v = 0; v < selected.size(); ++v) {
    double sum = 0;
    std::size_t misses = 0;
    for (const double us : timings[v]) {
      sum += us;
      if (options.budget_us > 0 && us > options.budget_us)
        ++misses;
    }
    std::cout << std::fixed << std::setprecision(3) << "mode=" << selected[v]->name
              << " samples=" << round << " iterations=" << options.iterations
              << " p50_us=" << quantile(timings[v], .50) << " p95_us=" << quantile(timings[v], .95)
              << " p99_us=" << quantile(timings[v], .99)
              << " max_us=" << *std::max_element(timings[v].begin(), timings[v].end())
              << " work_units_per_s=" << (sum > 0 ? units_per_invocation * round * 1e6 / sum : 0)
              << " work_units_per_invocation=" << units_per_invocation
              << " budget_us=" << options.budget_us << " sample_budget_misses=" << misses
              << " digest=" << digests[v] << '\n';
  }
  if (csv.is_open()) {
    csv.flush();
    require(bool(csv), "CSV write failed");
  }
  rusage usage{};
  if (getrusage(RUSAGE_SELF, &usage) == 0) {
#if defined(__APPLE__)
    const auto rss = static_cast<std::uint64_t>(usage.ru_maxrss);
#else
    const auto rss = static_cast<std::uint64_t>(usage.ru_maxrss) * 1024;
#endif
    std::cout << "process_peak_rss_bytes=" << rss
              << " memory_scope=whole_process_high_water_mark\n";
  }
}

template <typename F>
int main_entry(int argc, char** argv, F&& run) {
  try {
    for (int i = 1; i < argc; ++i) {
      if (std::string(argv[i]) == "--help") {
        std::cout << "--test | --mode all|baseline|stage1|optimized [--profile]\n"
                     "--samples N --warmup N --iterations N --seconds N --budget-us N --csv PATH\n";
        return 0;
      }
    }
    const auto options = parse(argc, argv);
    print_build_contract();
    if (options.profile)
      std::cout << "correctness=SKIPPED profile_only=true\n";
    run(options);
    return 0;
  } catch (const std::exception& error) {
    std::cerr << "FAIL: " << error.what() << '\n';
    return 1;
  }
}

}  // namespace edge
