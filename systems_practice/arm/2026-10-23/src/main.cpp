#include <algorithm>
#include <chrono>
#include <cmath>
#include <iostream>
#include <stdexcept>
#include <string>
#include <vector>

#include "../../../daily/2026-10-21/src/quantize.hpp"
using Clock = std::chrono::steady_clock;
void check(bool b) {
  if (!b) {
    throw std::runtime_error("verification failed");
  }
}
double percentile(std::vector<double> x, double p) {
  check(!x.empty());
  std::sort(x.begin(), x.end());
  return x.at(static_cast<std::size_t>(std::ceil(p * x.size())) - 1);
}
int main(int argc, char** argv) {
  try {
    if (argc > 3) {
      throw std::invalid_argument("usage: app [seconds 1..600] [n 0..1048577]");
    }
    int seconds = argc > 1 ? std::stoi(argv[1]) : 2;
    long long raw = argc > 2 ? std::stoll(argv[2]) : 65539;
    if (seconds < 1 || seconds > 600 || raw < 0 || raw > 1048577) {
      throw std::invalid_argument("bounds");
    }
    const auto n = static_cast<std::size_t>(raw);
    std::vector<float> x(n);
    std::vector<std::int8_t> ref(n), q(n);
    for (std::size_t i = 0; i < n; ++i) {
      x[i] = float(int(i % 511) - 255) / 2;
    }
    practice::scalar(x.data(), ref.data(), n, 1.25f);
    // 预热后每次计量单次CPU调用；校验在计时外，避免把批均值当请求P95。
    for (int i = 0; i < 20; ++i) {
      practice::neon(x.data(), q.data(), n, 1.25f);
    }
    std::vector<double> early, late;
    std::size_t count = 0;
    const auto start = Clock::now();
    std::cout << "elapsed_s,scalar_us,neon_us\n";
    do {
      auto a = Clock::now();
      // AB/BA交替，减轻固定顺序对频率/缓存的偏置。
      double scalar_us = 0, neon_us = 0;
      auto sample = [&](bool neon) {
        auto t = Clock::now();
        if (neon) {
          practice::neon(x.data(), q.data(), n, 1.25f);
        } else {
          practice::scalar(x.data(), q.data(), n, 1.25f);
        }
        auto us = std::chrono::duration<double, std::micro>(Clock::now() - t).count();
        check(q == ref);
        return us;
      };
      if (count % 2 == 0) {
        scalar_us = sample(false);
        neon_us = sample(true);
      } else {
        neon_us = sample(true);
        scalar_us = sample(false);
      }
      double elapsed = std::chrono::duration<double>(a - start).count();
      if (elapsed < seconds / 3.0) {
        if (early.size() < 100000) {
          early.push_back(neon_us);
        }
      } else if (elapsed >= 2 * seconds / 3.0) {
        if (late.size() < 100000) {
          late.push_back(neon_us);
        }
      }
      if (count % 1000 == 0) {
        std::cout << elapsed << ',' << scalar_us << ',' << neon_us << '\n';
      }
      ++count;
    } while (std::chrono::duration<double>(Clock::now() - start).count() < seconds);
    check(!early.empty() && !late.empty());
    std::cout << "PASS n=" << n << " requests=" << count << " early_n=" << early.size()
              << " late_n=" << late.size() << " early_p50_us=" << percentile(early, .5)
              << " early_p95_us=" << percentile(early, .95)
              << " late_p50_us=" << percentile(late, .5) << " late_p95_us=" << percentile(late, .95)
              << " thermal_cause=UNVERIFIED energy=UNMEASURED e2e=UNMEASURED\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
