#include "lesson.hpp"
using namespace lesson;
double quantile(Vec v, double p) {
  require(!v.empty() && p >= 0 && p <= 1, "invalid quantile");
  std::sort(v.begin(), v.end());
  const double index = (v.size() - 1) * p;
  const auto lo = size_t(std::floor(index)), hi = size_t(std::ceil(index));
  return v[lo] + (v[hi] - v[lo]) * (index - lo);
}
struct Bounds {
  Vec bounds;
  int step = 0;
  bool frozen = false;
  void observe(const Vec& post_relu) {
    if (frozen) {
      return;
    }
    const Vec pair = {quantile(post_relu, .001), quantile(post_relu, .999)};
    const double alpha = .2 / (1 + .1 * step);
    if (bounds.empty()) {
      bounds = pair;
    } else {
      for (size_t i = 0; i < 2; ++i) {
        bounds[i] = (1 - alpha) * bounds[i] + alpha * pair[i];
      }
    }
    ++step;
  }
};
Vec batch(unsigned seed, bool relu = false) {
  Random rng(seed);
  Vec v;
  for (int i = 0; i < 3999; ++i) {
    const double x = rng.normal();
    v.push_back(relu ? std::max(0.0, x) : x);
  }
  v.push_back(30);
  return v;
}
Vec uadr(const Vec& v) {
  require(!v.empty(), "empty regularizer input");
  const double mean = std::accumulate(v.begin(), v.end(), 0.0) / v.size();
  double variance = 0, skew = 0, kurt = 0;
  for (double x : v) {
    variance += (x - mean) * (x - mean) / v.size();
  }
  for (double x : v) {
    const double z = (x - mean) / std::sqrt(variance + 1e-8);
    skew += z * z * z / v.size();
    kurt += z * z * z * z / v.size();
  }
  // 仅统计正则，不声称已经执行作者的反向传播训练。
  return {skew,
          kurt,
          .01 * std::pow(std::max(0.0, skew), 2) + .01 * std::pow(std::max(0.0, kurt - 3), 2)};
}
std::pair<Bytes, Vec> encode(const Vec& v, const Vec& bounds) {
  const double lo = bounds.at(0), hi = bounds.at(1);
  require(std::isfinite(lo) && std::isfinite(hi) && hi >= lo, "invalid bounds");
  const double scale = hi > lo ? (hi - lo) / 255 : 1;
  Bytes blob;
  put_float(blob, lo);
  put_float(blob, scale);
  for (double x : v) {
    require(std::isfinite(x), "nonfinite activation");
    blob.push_back(uint8_t(std::nearbyint((std::clamp(x, lo, hi) - lo) / scale)));
  }
  size_t pos = 0;
  const double stored_lo = get_float<double>(blob, pos),
               stored_scale = get_float<double>(blob, pos);
  Vec decoded;
  for (; pos < blob.size(); ++pos) {
    decoded.push_back(stored_lo + blob[pos] * stored_scale);
  }
  return {blob, decoded};
}
void report(const Vec& v, const Vec& bounds) {
  const auto result = encode(v, bounds);
  double total = 0, body = 0;
  size_t body_count = 0, outside = 0;
  for (size_t i = 0; i < v.size(); ++i) {
    const double e = std::pow(v[i] - result.second[i], 2);
    total += e;
    if (v[i] < 5) {
      body += e;
      ++body_count;
    }
    if (v[i] < bounds[0] || v[i] > bounds[1]) {
      ++outside;
    }
  }
  std::cout << "{\"mse_all\":" << total / v.size() << ",\"mse_body_x_lt_5\":" << body / body_count
            << ",\"outside_bounds\":" << outside
            << ",\"stored_bytes_including_metadata\":" << result.first.size() << '}';
}
int main() {
  try {
    Bounds observer;
    for (unsigned seed = 0; seed < 10; ++seed) {
      observer.observe(batch(seed, true));
    }
    observer.frozen = true;
    const auto frozen = observer.bounds;
    observer.observe({0, 1e6});
    require(frozen == observer.bounds, "frozen bounds changed");
    require(encode(Vec(4, 0), {0, 0}).second == Vec(4, 0), "zero encoding");
    require(encode({-100, 100}, {2, 2}).second == Vec(2, 2), "constant encoding");
    require(uadr(Vec(4, 0))[2] == 0 && quantile({0, 2}, .5) == 1, "statistics boundary");
    const auto calibration = batch(100, true), evaluation = batch(200, true),
               stats = uadr(batch(0));
    std::cout << std::setprecision(17)
              << "{\"kind\":\"independent_cpp_mechanism_no_training\",\"frozen_bounds\":";
    json_array(frozen);
    std::cout << ",\"regularizer_on_pre_activation\":{\"skew\":" << stats[0]
              << ",\"kurtosis\":" << stats[1] << ",\"penalty\":" << stats[2] << "},\"minmax\":";
    report(evaluation,
           {*std::min_element(calibration.begin(), calibration.end()),
            *std::max_element(calibration.begin(), calibration.end())});
    std::cout << ",\"percentile_ema\":";
    report(evaluation, frozen);
    std::cout << ",\"checks\":[\"frozen_bounds\",\"constant_zero\",\"quantile_interpolation\"]}\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
