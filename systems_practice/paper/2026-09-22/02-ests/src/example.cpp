#include "lesson.hpp"
using namespace lesson;
using Layers = std::vector<Matrix>;
double js(const Vec& p, const Vec& q) {
  require(!p.empty() && p.size() == q.size(), "distribution shape");
  require(std::abs(std::accumulate(p.begin(), p.end(), 0.0) - 1) < 1e-9 &&
              std::abs(std::accumulate(q.begin(), q.end(), 0.0) - 1) < 1e-9,
          "distribution sum");
  double result = 0;
  for (size_t i = 0; i < p.size(); ++i) {
    require(std::isfinite(p[i]) && std::isfinite(q[i]) && p[i] >= 0 && q[i] >= 0,
            "distribution value");
    const double m = (p[i] + q[i]) / 2;
    if (p[i]) {
      result += .5 * p[i] * std::log2(p[i] / m);
    }
    if (q[i]) {
      result += .5 * q[i] * std::log2(q[i] / m);
    }
  }
  return result;
}
std::vector<int> allocate(const Vec& scores, int budget, int experts = 6, int active = 2) {
  require(!scores.empty() && active > 0 && experts >= active, "invalid capacities");
  for (double s : scores) {
    require(std::isfinite(s) && s >= 0, "invalid score");
  }
  const int layers = int(scores.size());
  require(budget >= layers * active && budget <= layers * experts, "impossible budget");
  Vec c(scores.size(), active);
  double left = budget - layers * active;
  while (left > 1e-10) {
    std::vector<size_t> free;
    double total = 0;
    for (size_t i = 0; i < c.size(); ++i) {
      if (c[i] < experts - 1e-10) {
        free.push_back(i);
        total += scores[i];
      }
    }
    require(!free.empty(), "no free capacity");
    double used = 0;
    for (size_t i : free) {
      const double add =
          std::min(experts - c[i], left * (total ? scores[i] / total : 1.0 / free.size()));
      c[i] += add;
      used += add;
    }
    require(used > 0, "allocator stalled");
    left -= used;
  }
  std::vector<int> integer;
  for (double v : c) {
    integer.push_back(int(std::floor(v + 1e-10)));
  }
  int remaining = budget - std::accumulate(integer.begin(), integer.end(), 0);
  std::vector<size_t> order(c.size());
  std::iota(order.begin(), order.end(), 0);
  std::stable_sort(order.begin(), order.end(), [&](size_t a, size_t b) {
    return c[a] - integer[a] > c[b] - integer[b];
  });
  for (size_t i : order) {
    if (remaining && integer[i] < experts) {
      ++integer[i];
      --remaining;
    }
  }
  require(remaining == 0 && std::accumulate(integer.begin(), integer.end(), 0) == budget,
          "budget conservation");
  for (int v : integer) {
    require(v >= active && v <= experts, "capacity bounds");
  }
  return integer;
}
double infer(const Matrix& experts, const Matrix& router, const Vec& x) {
  const auto logits = matvec(router, x);
  std::vector<size_t> order(logits.size());
  std::iota(order.begin(), order.end(), 0);
  std::stable_sort(order.begin(), order.end(), [&](size_t a, size_t b) {
    return logits[a] > logits[b];
  });
  const double a = std::exp(logits[order[0]] - logits[order[0]]),
               b = std::exp(logits[order[1]] - logits[order[0]]);
  return (a * dot(experts[order[0]], x) + b * dot(experts[order[1]], x)) / (a + b);
}
Bytes payload(const Layers& w, const Layers& r) {
  Bytes b;
  for (const auto* data : {&w, &r}) {
    for (const auto& layer : *data) {
      for (const auto& row : layer) {
        for (double v : row) {
          put_float(b, float(v));
        }
      }
    }
  }
  return b;
}
int main() {
  try {
    const Matrix target = {
        {.5, .2, .1, .1, .05, .05}, {.2, .2, .2, .15, .15, .1}, {.7, .1, .05, .05, .05, .05}};
    Vec scores;
    for (const auto& row : target) {
      scores.push_back(js(Vec(6, 1.0 / 6), row));
    }
    const auto capacities = allocate(scores, 12);
    for (const Vec& s : {scores, Vec{0, 0, 0}, Vec{100, 0, 0}, Vec{1, 1, 1}}) {
      for (int budget = 6; budget <= 18; ++budget) {
        allocate(s, budget);
      }
    }
    int rejected = 0;
    for (int budget : {5, 19}) {
      try {
        allocate(scores, budget);
      } catch (const std::runtime_error&) {
        ++rejected;
      }
    }
    require(rejected == 2 && js({1, 0}, {0, 1}) == 1 && js({1, 0}, {1, 0}) == 0, "boundary checks");
    Random rng(9);
    Layers weights(3, Matrix(6, Vec(2))), router = weights;
    for (auto* data : {&weights, &router}) {
      for (auto& layer : *data) {
        for (auto& row : layer) {
          for (auto& v : row) {
            v = 2 * rng.uniform() - 1;
          }
        }
      }
    }
    Layers kept(3), routes(3);
    std::vector<std::vector<int>> ids(3);
    for (size_t l = 0; l < 3; ++l) {
      std::vector<int> order(6);
      std::iota(order.begin(), order.end(), 0);
      std::stable_sort(order.begin(), order.end(), [&](int a, int b) {
        return target[l][a] > target[l][b];
      });
      for (int j = 0; j < capacities[l]; ++j) {
        const int old = order[j];
        ids[l].push_back(old);
        kept[l].push_back(weights[l][old]);
        routes[l].push_back(router[l][old]);
      }
      // 物理裁剪和路由行映射同步，避免新专家编号指向旧 router。
      for (size_t j = 0; j < ids[l].size(); ++j) {
        require(kept[l][j] == weights[l][ids[l][j]] && routes[l][j] == router[l][ids[l][j]],
                "expert ID remap");
      }
    }
    const auto full = payload(weights, router), pruned = payload(kept, routes);
    require(full.size() == 288 && pruned.size() == 192, "physical FP32 bytes");
    size_t pos = 0;
    for (const auto* data : {&kept, &routes}) {
      for (const auto& layer : *data) {
        for (const auto& row : layer) {
          for (double v : row) {
            require(get_float<float>(pruned, pos) == float(v), "FP32 byte roundtrip");
          }
        }
      }
    }
    Random eval(91);
    double mse = 0;
    for (int i = 0; i < 64; ++i) {
      const Vec x = {eval.normal(), eval.normal()};
      for (size_t l = 0; l < 3; ++l) {
        mse +=
            std::pow(infer(weights[l], router[l], x) - infer(kept[l], routes[l], x), 2) / (3 * 64);
      }
    }
    std::cout << std::setprecision(17)
              << "{\"scope\":\"independent C++ scalar example; no recovery SFT, MXFP4, language "
                 "metric, or hardware speedup\",\"js_scores\":";
    json_array(scores);
    std::cout << ",\"capacities\":";
    json_array(capacities);
    std::cout << ",\"retained_original_ids\":[";
    for (size_t l = 0; l < 3; ++l) {
      if (l) {
        std::cout << ',';
      }
      json_array(ids[l]);
    }
    std::cout << "],\"full_fp32_payload_bytes\":" << full.size()
              << ",\"pruned_fp32_payload_bytes\":" << pruned.size()
              << ",\"active_experts_per_token_before_after\":[2,2],\"synthetic_output_mse\":" << mse
              << ",\"capacity_cases_passed\":52,\"invalid_budgets_rejected\":2}\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
