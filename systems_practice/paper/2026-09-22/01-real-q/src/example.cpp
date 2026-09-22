#include "lesson.hpp"
using namespace lesson;
std::pair<double, Matrix> loss_grad(const Matrix& w,
                                    const Matrix& ref,
                                    const Matrix& xs,
                                    const Matrix& fisher) {
  Matrix grad(2, Vec(4, 0));
  double total = 0;
  for (const auto& x : xs) {
    Vec e = matvec(w, x), reference = matvec(ref, x);
    for (size_t r = 0; r < 2; ++r) {
      e[r] -= reference[r];
    }
    const auto fe = matvec(fisher, e);
    total += .5 * dot(e, fe) / xs.size();
    for (size_t r = 0; r < 2; ++r) {
      for (size_t c = 0; c < 4; ++c) {
        grad[r][c] += fe[r] * x[c] / xs.size();
      }
    }
  }
  return {total, grad};
}
Matrix inputs(unsigned seed) {
  Random rng(seed);
  Matrix xs;
  for (int i = 0; i < 64; ++i) {
    const double a = rng.normal(), b = rng.normal();
    xs.push_back({a, b, a + .2 * rng.normal(), b + .2 * rng.normal()});
  }
  return xs;
}
int main() {
  try {
    const Matrix ref = {{.37, -.61, .29, .83}, {-.44, .72, -.38, .57}};
    const Matrix fisher = {{2, 1}, {1, 1}};  // 人工 SPD；没有估计真实 NLL Fisher。
    const auto calib = inputs(1), evaluation = inputs(2);
    Matrix w = ref;
    for (auto& row : w) {
      for (size_t c = 0; c < 2; ++c) {
        row[c] = std::nearbyint(row[c] / .25) * .25;
      }
    }
    const auto initial = w;
    const auto before = loss_grad(w, ref, calib, fisher);
    double max_error = 0;
    for (size_t r = 0; r < 2; ++r) {
      for (size_t c = 2; c < 4; ++c) {
        auto plus = w, minus = w;
        plus[r][c] += 1e-6;
        minus[r][c] -= 1e-6;
        const double numerical = (loss_grad(plus, ref, calib, fisher).first -
                                  loss_grad(minus, ref, calib, fisher).first) /
                                 2e-6;
        max_error = std::max(max_error, std::abs(numerical - before.second[r][c]));
      }
    }
    require(max_error < 1e-8, "gradient check failed");
    // 一次实际 Adam 更新，仅操作尚未冻结的两列。
    size_t changed = 0;
    for (size_t r = 0; r < 2; ++r) {
      for (size_t c = 2; c < 4; ++c) {
        const double g = before.second[r][c], m = .1 * g, v = .001 * g * g;
        w[r][c] -= .025 * (m / (1 - .9)) / (std::sqrt(v / (1 - .999)) + 1e-8);
        changed += w[r][c] != initial[r][c];
      }
      require(w[r][0] == initial[r][0] && w[r][1] == initial[r][1], "locked column changed");
    }
    const double after = loss_grad(w, ref, calib, fisher).first;
    require(changed == 4 && std::isfinite(after), "Adam update failed");
    require(loss_grad(ref, ref, Matrix(1, Vec(4, 0)), fisher).first == 0, "zero loss boundary");
    std::cout << std::setprecision(17)
              << "{\"scope\":\"C++ scalar mechanism only; no GPTQ compensation, real NLL Fisher, "
                 "sliding transformer window, packed GEMM or full paper reproduction\","
              << "\"calibration_loss_before\":" << before.first
              << ",\"calibration_loss_after\":" << after
              << ",\"evaluation_loss_before\":" << loss_grad(initial, ref, evaluation, fisher).first
              << ",\"evaluation_loss_after\":" << loss_grad(w, ref, evaluation, fisher).first
              << ",\"max_gradient_check_error\":" << max_error
              << ",\"locked_columns_unchanged\":true,\"actual_updated_parameters\":" << changed
              << ",\"same_euclidean_norm_penalty\":{\"aligned\":"
              << .5 * dot({1, 1}, matvec(fisher, {1, 1}))
              << ",\"opposed\":" << .5 * dot({1, -1}, matvec(fisher, {1, -1})) << "}}\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
