#pragma once
#include <algorithm>
#include <chrono>
#include <cmath>
#include <cstdint>
#include <cstring>
#include <limits>
#include <numeric>
#include <stdexcept>
#include <string>
#include <utility>
#include <vector>

namespace quant {
constexpr int kGroup = 16;
struct Matrix {
  int rows, cols;
  std::vector<float> data;
  static std::size_t count(int r, int c) {
    if (r < 1 || c < 1 || r > 4096 || c > 4096) {
      throw std::invalid_argument("matrix dimensions must be 1..4096");
    }
    return std::size_t(r) * c;
  }
  Matrix(int r, int c) : rows(r), cols(c), data(count(r, c)) {
  }
  float& operator()(int r, int c) {
    return data[std::size_t(r) * cols + c];
  }
  float operator()(int r, int c) const {
    return data[std::size_t(r) * cols + c];
  }
};
inline void require(bool condition, const char* message) {
  if (!condition) {
    throw std::runtime_error(message);
  }
}

// IEEE binary16，round-to-nearest-even；CPU 用真实16位存储而非声称float是A16。
inline uint16_t to_half(float value) {
  uint32_t bits;
  std::memcpy(&bits, &value, sizeof(bits));
  const uint32_t sign = (bits >> 16) & 0x8000U;
  const uint32_t exp = (bits >> 23) & 255U;
  uint32_t mant = bits & 0x7fffffU;
  if (exp == 255U) {
    return uint16_t(sign | 0x7c00U | (mant ? 0x200U : 0U));
  }
  const int e = int(exp) - 127 + 15;
  if (e >= 31) {
    return uint16_t(sign | 0x7c00U);
  }
  if (e < -10) {
    return uint16_t(sign);
  }
  const int shift = e <= 0 ? 14 - e : 13;
  if (e <= 0) {
    mant |= 0x800000U;
  }
  uint32_t kept = mant >> shift;
  const uint32_t rest = mant & ((1U << shift) - 1U);
  const uint32_t halfway = 1U << (shift - 1);
  kept += rest > halfway || (rest == halfway && (kept & 1U));
  return uint16_t(sign | (e <= 0 ? kept : (uint32_t(e) << 10) + kept));
}
inline float from_half(uint16_t value) {
  const uint32_t sign = uint32_t(value & 0x8000U) << 16;
  const int exp = (value >> 10) & 31;
  uint32_t mant = value & 1023U, bits;
  if (exp == 0) {
    if (mant == 0) {
      bits = sign;
    } else {
      int e = -14;
      while ((mant & 1024U) == 0) {
        mant <<= 1;
        --e;
      }
      bits = sign | (uint32_t(e + 127) << 23) | ((mant & 1023U) << 13);
    }
  } else if (exp == 31) {
    bits = sign | 0x7f800000U | (mant << 13);
  } else {
    bits = sign | (uint32_t(exp - 15 + 127) << 23) | (mant << 13);
  }
  float result;
  std::memcpy(&result, &bits, sizeof(result));
  return result;
}
struct Packed {
  int bits = 8;
  std::size_t size = 0;
  std::vector<uint8_t> bytes;
  Packed() = default;
  Packed(int b, std::size_t count) : bits(b), size(count), bytes((count * b + 7) / 8, 0) {
    require(b == 4 || b == 8, "only INT4/INT8 supported");
  }
  int get(std::size_t index) const {
    require(index < size, "packed read outside logical length");
    const int v = bits == 4 ? (bytes.at(index / 2) >> ((index % 2) * 4)) & 15 : bytes.at(index);
    return v >= (1 << (bits - 1)) ? v - (1 << bits) : v;
  }
  void set(std::size_t index, int value) {
    require(index < size, "packed index outside logical length");
    const int limit = (1 << (bits - 1)) - 1;
    require(value >= -limit && value <= limit, "signed symmetric range exceeded");
    if (bits == 4) {
      const int shift = int(index % 2) * 4;
      bytes.at(index / 2) =
          uint8_t((bytes.at(index / 2) & ~(15 << shift)) | ((value & 15) << shift));
    } else {
      bytes.at(index) = uint8_t(value & 255);
    }
  }
};
inline int quantize(float value, float scale, int bits) {
  const int limit = (1 << (bits - 1)) - 1;
  require(std::isfinite(value) && scale > 0 && std::isfinite(scale), "invalid quantizer input");
  // 明确采用最近整数、半值远离零；不得与half的ties-even混淆。
  return int(std::max(float(-limit), std::min(float(limit), std::round(value / scale))));
}
inline Matrix gemm(const Matrix& a, const Matrix& w) {
  require(a.cols == w.rows, "GEMM dimension mismatch");
  Matrix y(a.rows, w.cols);
  for (int m = 0; m < a.rows; ++m) {
    for (int n = 0; n < w.cols; ++n) {
      float sum = 0;
      for (int k = 0; k < a.cols; ++k) {
        sum += a(m, k) * w(k, n);
      }
      y(m, n) = sum;
    }
  }
  return y;
}
inline Matrix rounded_half(const Matrix& input) {
  Matrix output = input;
  for (float& v : output.data) {
    v = from_half(to_half(v));
  }
  return output;
}
struct Metrics {
  double nrmse, max_abs, cosine, mse;
};
inline Metrics metrics(const Matrix& actual, const Matrix& reference) {
  require(actual.rows == reference.rows && actual.cols == reference.cols, "metric shape mismatch");
  double error = 0, ref2 = 0, actual2 = 0, dot = 0, maximum = 0;
  for (std::size_t i = 0; i < actual.data.size(); ++i) {
    require(std::isfinite(actual.data[i]) && std::isfinite(reference.data[i]), "nonfinite GEMM");
    const double x = actual.data[i], r = reference.data[i], d = x - r;
    error += d * d;
    ref2 += r * r;
    actual2 += x * x;
    dot += r * x;
    maximum = std::max(maximum, std::abs(d));
  }
  return {std::sqrt(error / std::max(ref2, 1e-30)),
          maximum,
          dot / std::sqrt(std::max(ref2 * actual2, 1e-30)),
          error / actual.data.size()};
}
inline Matrix generate(int rows, int cols, uint32_t seed, bool activation) {
  Matrix result(rows, cols);
  for (int r = 0; r < rows; ++r) {
    for (int c = 0; c < cols; ++c) {
      seed = seed * 1664525U + 1013904223U;
      float v = (float((seed >> 8) & 65535U) / 32768.0F - 1.0F);
      if (activation && (c == 0 || c == 31)) {
        v *= 24;
      }
      result(r, c) = activation ? v : v * 0.35F;
    }
  }
  return result;
}
struct Data {
  Matrix weights, train, calibration, validation, evaluation, shifted;
  Data()
      : weights(generate(65, 19, 11, false)),
        train(generate(48, 65, 101, true)),
        calibration(generate(48, 65, 202, true)),
        validation(generate(32, 65, 303, true)),
        evaluation(generate(32, 65, 404, true)),
        shifted(evaluation) {
    // 只用于外推风险报告，绝不用于挑scale或checkpoint。
    for (int m = 0; m < shifted.rows; ++m) {
      shifted(m, 4) *= 30;
    }
  }
};
struct Config {
  int wb = 4, ab = 4;
  bool smooth = false;
  float alpha = 0.5F, act_clip = 1, weight_clip = 1;
  int outliers = 0;
};
struct Model {
  Config config;
  int k = 0, n = 0, groups = 0;
  Packed weights;
  std::vector<float> scales, smooth, latent;
  std::vector<int> outlier;
  std::vector<uint16_t> residual_weights;
  float activation_scale = 1;
  double validation_mse = 0, train_before = 0, train_after = 0;
  int qat_steps = 0, selected_step = 0;
  double train_last = 0;
  std::size_t master_updates = 0, final_code_changes = 0;
};
inline bool is_outlier(const Model& model, int k) {
  return std::find(model.outlier.begin(), model.outlier.end(), k) != model.outlier.end();
}
inline void pack_weights(Model& model) {
  for (int k = 0; k < model.k; ++k) {
    for (int n = 0; n < model.n; ++n) {
      model.weights.set(std::size_t(k) * model.n + n,
                        is_outlier(model, k) ? 0
                                             : quantize(model.latent[k * model.n + n],
                                                        model.scales[(k / kGroup) * model.n + n],
                                                        model.config.wb));
    }
  }
}
inline Model fit(const Matrix& w, const Matrix& calibration, Config cfg) {
  require(w.rows == calibration.cols, "calibration K mismatch");
  require((cfg.wb == 4 || cfg.wb == 8) && (cfg.ab == 4 || cfg.ab == 8 || cfg.ab == 16),
          "invalid format");
  require(cfg.outliers >= 0 && cfg.outliers <= w.rows && cfg.act_clip > 0 && cfg.act_clip <= 1 &&
              cfg.weight_clip > 0 && cfg.weight_clip <= 1 && cfg.alpha >= 0 && cfg.alpha <= 1,
          "invalid quantization configuration");
  for (float v : w.data) {
    require(std::isfinite(v), "nonfinite weight");
  }
  for (float v : calibration.data) {
    require(std::isfinite(v), "nonfinite calibration input");
  }
  Model model;
  model.config = cfg;
  model.k = w.rows;
  model.n = w.cols;
  model.groups = (model.k + kGroup - 1) / kGroup;
  model.weights = Packed(cfg.wb, w.data.size());
  model.scales.assign(model.groups * model.n, 1);
  model.smooth.assign(model.k, 1);
  model.latent = w.data;
  std::vector<float> amax(model.k, 0), wmax(model.k, 0);
  for (int k = 0; k < model.k; ++k) {
    for (int m = 0; m < calibration.rows; ++m) {
      amax[k] = std::max(amax[k], std::abs(calibration(m, k)));
    }
    for (int n = 0; n < model.n; ++n) {
      wmax[k] = std::max(wmax[k], std::abs(w(k, n)));
    }
    if (cfg.smooth) {
      // 等价变换 A'=A/s, W'=sW：将激活离群难度迁移到权重侧。
      const float s = std::pow(std::max(amax[k], 1e-8F), cfg.alpha) /
                      std::pow(std::max(wmax[k], 1e-8F), 1 - cfg.alpha);
      model.smooth[k] = std::clamp(s, 0.01F, 100.0F);
    }
  }
  std::vector<int> order(model.k);
  std::iota(order.begin(), order.end(), 0);
  std::stable_sort(order.begin(), order.end(), [&](int a, int b) {
    return amax[a] > amax[b];
  });
  model.outlier.assign(order.begin(), order.begin() + std::min(cfg.outliers, model.k));
  for (int k : model.outlier) {
    for (int n = 0; n < model.n; ++n) {
      model.residual_weights.push_back(to_half(w(k, n)));
    }
  }
  for (int k = 0; k < model.k; ++k) {
    for (int n = 0; n < model.n; ++n) {
      model.latent[k * model.n + n] = is_outlier(model, k) ? 0 : w(k, n) * model.smooth[k];
    }
  }
  const int qmax = (1 << (cfg.wb - 1)) - 1;
  for (int g = 0; g < model.groups; ++g) {
    for (int n = 0; n < model.n; ++n) {
      float maximum = 0;
      for (int k = g * kGroup; k < std::min(model.k, (g + 1) * kGroup); ++k) {
        maximum = std::max(maximum, std::abs(model.latent[k * model.n + n]));
      }
      model.scales[g * model.n + n] =
          maximum == 0 ? 1 : std::max(maximum * cfg.weight_clip / qmax, 1e-8F);
    }
  }
  float maximum = 0;
  for (int m = 0; m < calibration.rows; ++m) {
    for (int k = 0; k < model.k; ++k) {
      if (!is_outlier(model, k)) {
        maximum = std::max(maximum, std::abs(calibration(m, k) / model.smooth[k]));
      }
    }
  }
  if (cfg.ab != 16) {
    model.activation_scale =
        maximum == 0 ? 1 : std::max(maximum * cfg.act_clip / ((1 << (cfg.ab - 1)) - 1), 1e-8F);
  }
  pack_weights(model);
  return model;
}
struct Batch {
  int m = 0, k = 0;
  Packed codes;
  std::vector<uint16_t> half, residual;
  std::size_t clipped = 0, active = 0;
};
inline Batch prepare(const Matrix& a, const Model& model) {
  require(a.cols == model.k, "input K mismatch");
  Batch batch;
  batch.m = a.rows;
  batch.k = a.cols;
  if (model.config.ab == 16) {
    batch.half.resize(a.data.size());
  } else {
    batch.codes = Packed(model.config.ab, a.data.size());
  }
  for (int m = 0; m < a.rows; ++m) {
    for (int k = 0; k < a.cols; ++k) {
      require(std::isfinite(a(m, k)), "nonfinite activation");
      const bool residual = is_outlier(model, k);
      const float v = residual ? 0 : a(m, k) / model.smooth[k];
      const std::size_t idx = std::size_t(m) * a.cols + k;
      if (model.config.ab == 16) {
        batch.half[idx] = to_half(v);
        require(std::isfinite(from_half(batch.half[idx])), "FP16 activation overflow");
      } else {
        const int limit = (1 << (model.config.ab - 1)) - 1;
        if (!residual) {
          ++batch.active;
          batch.clipped += std::abs(v) > limit * model.activation_scale;
        }
        batch.codes.set(idx, quantize(v, model.activation_scale, model.config.ab));
      }
    }
    for (int k : model.outlier) {
      const uint16_t h = to_half(a(m, k));
      require(std::isfinite(from_half(h)), "FP16 outlier overflow");
      batch.residual.push_back(h);
    }
  }
  return batch;
}
inline Matrix packed_gemm(const Batch& a, const Model& model) {
  Matrix result(a.m, model.n);
  for (int m = 0; m < a.m; ++m) {
    for (int n = 0; n < model.n; ++n) {
      float sum = 0;
      for (int g = 0; g < model.groups; ++g) {
        int32_t integer = 0;
        float real = 0;
        for (int k = g * kGroup; k < std::min(model.k, (g + 1) * kGroup); ++k) {
          const int qw = model.weights.get(k * model.n + n);
          if (model.config.ab == 16) {
            real += from_half(a.half[m * model.k + k]) * qw;
          } else {
            integer += a.codes.get(m * model.k + k) * qw;
          }
        }
        sum += (model.config.ab == 16 ? real : integer * model.activation_scale) *
               model.scales[g * model.n + n];
      }
      for (std::size_t o = 0; o < model.outlier.size(); ++o) {
        sum += from_half(a.residual[m * model.outlier.size() + o]) *
               from_half(model.residual_weights[o * model.n + n]);
      }
      result(m, n) = sum;
    }
  }
  return result;
}
inline Matrix forward(const Matrix& a, const Model& model) {
  return packed_gemm(prepare(a, model), model);
}
inline Matrix reconstructed_weights(const Model& model) {
  Matrix w(model.k, model.n);
  for (int k = 0; k < model.k; ++k) {
    for (int n = 0; n < model.n; ++n) {
      w(k, n) = model.weights.get(k * model.n + n) * model.scales[(k / kGroup) * model.n + n];
    }
  }
  return w;
}
inline Model calibrate(const Data& data, int wb, int ab, int outliers) {
  const Matrix target = gemm(data.validation, data.weights);
  Config cfg;
  cfg.wb = wb;
  cfg.ab = ab;
  cfg.outliers = outliers;
  Model best = fit(data.weights, data.calibration, cfg);
  double score = metrics(forward(data.validation, best), target).mse;
  // 调参只使用独立validation；评估集没有进入这个函数的计算。
  for (float alpha : {0.0F, 0.25F, 0.5F, 0.75F, 1.0F}) {
    for (float ac : {1.0F, 0.95F, 0.9F}) {
      for (float wc : {1.0F, 0.95F}) {
        cfg.smooth = true;
        cfg.alpha = alpha;
        cfg.act_clip = ab == 16 ? 1 : ac;
        cfg.weight_clip = wc;
        Model candidate = fit(data.weights, data.calibration, cfg);
        const double loss = metrics(forward(data.validation, candidate), target).mse;
        if (loss < score) {
          score = loss;
          best = std::move(candidate);
        }
      }
    }
  }
  best.validation_mse = score;
  return best;
}
inline Model qat(const Data& data, Model model) {
  const Matrix target = gemm(data.train, data.weights), valid = gemm(data.validation, data.weights);
  const Batch input = prepare(data.train, model);
  Matrix x(data.train.rows, model.k);
  for (std::size_t i = 0; i < x.data.size(); ++i) {
    x.data[i] = model.config.ab == 16 ? from_half(input.half[i])
                                      : input.codes.get(i) * model.activation_scale;
  }
  // 固定校准出的量化器，保存FP32 master weights；前向仍经过真实round/clip/pack。
  const int limit = (1 << (model.config.wb - 1)) - 1;
  for (int k = 0; k < model.k; ++k) {
    for (int n = 0; n < model.n; ++n) {
      const float bound = limit * model.scales[(k / kGroup) * model.n + n];
      model.latent[k * model.n + n] = std::clamp(model.latent[k * model.n + n], -bound, bound);
    }
  }
  pack_weights(model);
  const double before = metrics(packed_gemm(input, model), target).mse;
  const auto initial_codes = model.weights.bytes;
  std::size_t updates = 0;
  Model best = model;
  double best_score = metrics(forward(data.validation, model), valid).mse;
  for (int step = 1; step <= 40; ++step) {
    const Matrix prediction = packed_gemm(input, model);
    for (int k = 0; k < model.k; ++k) {
      if (is_outlier(model, k)) {
        continue;
      }
      double diagonal = 1e-6;
      for (int m = 0; m < x.rows; ++m) {
        diagonal += double(x(m, k)) * x(m, k);
      }
      for (int n = 0; n < model.n; ++n) {
        double gradient = 0;
        for (int m = 0; m < x.rows; ++m) {
          gradient += (prediction(m, n) - target(m, n)) * x(m, k);
        }
        const float bound = limit * model.scales[(k / kGroup) * model.n + n];
        float& master = model.latent[k * model.n + n];
        // STE在裁剪区内导数为1；对角预条件梯度下降后投影回量化范围。
        if (std::abs(master) <= bound) {
          const float next = std::clamp(master - float(0.08 * gradient / diagonal), -bound, bound);
          updates += next != master;
          master = next;
        }
      }
    }
    pack_weights(model);
    const double score = metrics(forward(data.validation, model), valid).mse;
    if (score < best_score) {
      best_score = score;
      best = model;
      best.selected_step = step;
    }
  }
  best.qat_steps = 40;
  best.validation_mse = best_score;
  best.master_updates = updates;
  best.train_last = metrics(packed_gemm(input, model), target).mse;
  for (std::size_t i = 0; i < initial_codes.size(); ++i) {
    best.final_code_changes += initial_codes[i] != model.weights.bytes[i];
  }
  best.train_before = before;
  best.train_after = metrics(packed_gemm(input, best), target).mse;
  return best;
}
inline Model build(const Data& data, int wb, int ab, const std::string& method) {
  Config cfg;
  cfg.wb = wb;
  cfg.ab = ab;
  if (method == "absmax") {
    return fit(data.weights, data.calibration, cfg);
  }
  if (method == "smoothquant") {
    cfg.smooth = true;
    return fit(data.weights, data.calibration, cfg);
  }
  if (method == "calibrated") {
    return calibrate(data, wb, ab, 0);
  }
  if (method == "outlier") {
    return calibrate(data, wb, ab, 2);
  }
  if (method == "qat") {
    return qat(data, calibrate(data, wb, ab, 2));
  }
  throw std::invalid_argument("unknown quantization method");
}
struct Storage {
  std::size_t weight_payload, weight_metadata, activation_payload, total;
};
inline Storage storage(const Model& m, const Batch& a) {
  const std::size_t wp = m.weights.bytes.size() + m.residual_weights.size() * 2;
  const std::size_t meta = m.scales.size() * 4 + m.smooth.size() * 4 + m.outlier.size() * 4 + 4;
  const std::size_t ap = a.codes.bytes.size() + a.half.size() * 2 + a.residual.size() * 2;
  // 部署tensor和scale预算，非vector容量、训练master、C++对象或分配器开销。
  return {wp, meta, ap, wp + meta + ap};
}
inline double median_ms(std::vector<double> v) {
  std::sort(v.begin(), v.end());
  return v[(v.size() - 1) / 2];
}
template <class F>
double benchmark(F operation) {
  volatile float sink = 0;
  for (int i = 0; i < 3; ++i) {
    const Matrix y = operation();
    sink += y.data[0];
  }
  std::vector<double> times;
  for (int i = 0; i < 20; ++i) {
    const auto start = std::chrono::steady_clock::now();
    const Matrix y = operation();
    times.push_back(
        std::chrono::duration<double, std::milli>(std::chrono::steady_clock::now() - start)
            .count());
    sink += y.data[0];
  }
  (void)sink;
  return median_ms(times);
}
}  // namespace quant
