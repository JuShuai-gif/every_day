#include <iomanip>
#include <iostream>

#include "quant.hpp"

namespace {
void test_primitives() {
  using namespace quant;
  // 所有有限half位模式往返；并检查常数与舍入中点。
  for (unsigned h = 0; h < 65536; ++h) {
    if ((h & 0x7c00U) != 0x7c00U) {
      require(to_half(from_half(uint16_t(h))) == h, "half roundtrip");
    }
  }
  require(to_half(1) == 0x3c00 && to_half(-2) == 0xc000 && to_half(65504) == 0x7bff,
          "half constants");
  require(to_half(1 + 1.0F / 2048) == 0x3c00 && to_half(1 + 3.0F / 2048) == 0x3c02,
          "half ties-even");
  for (int bits : {4, 8}) {
    const int limit = (1 << (bits - 1)) - 1;
    Packed p(bits, 2 * limit + 1);
    for (int i = -limit; i <= limit; ++i) {
      p.set(i + limit, i);
    }
    for (int i = -limit; i <= limit; ++i) {
      require(p.get(i + limit) == i, "signed packing roundtrip");
    }
    bool rejected = false;
    try {
      p.get(p.size);
    } catch (const std::exception&) {
      rejected = true;
    }
    require(rejected, "odd-tail logical bound");
  }
  require(quantize(0, 1, 4) == 0 && quantize(999, 1, 4) == 7 && quantize(-999, 1, 4) == -7,
          "saturation");
  for (int k : {1, 15, 16, 17, 65}) {
    Matrix a = generate(3, k, 8, true), w = generate(k, 5, 9, false);
    for (int wb : {4, 8}) {
      for (int ab : {4, 8, 16}) {
        Config cfg;
        cfg.wb = wb;
        cfg.ab = ab;
        cfg.smooth = true;
        cfg.outliers = std::min(1, k);
        const Model model = fit(w, a, cfg);
        const Batch batch = prepare(a, model);
        Matrix aq(a.rows, k), wq = reconstructed_weights(model);
        for (std::size_t i = 0; i < aq.data.size(); ++i) {
          aq.data[i] =
              ab == 16 ? from_half(batch.half[i]) : batch.codes.get(i) * model.activation_scale;
        }
        Matrix oracle = gemm(aq, wq);
        for (int m = 0; m < a.rows; ++m) {
          for (int n = 0; n < w.cols; ++n) {
            for (std::size_t o = 0; o < model.outlier.size(); ++o) {
              oracle(m, n) += from_half(batch.residual[m * model.outlier.size() + o]) *
                              from_half(model.residual_weights[o * w.cols + n]);
            }
          }
        }
        require(metrics(packed_gemm(batch, model), oracle).max_abs < 1e-3,
                "packed MAC vs independent dequant GEMM");
      }
    }
    Matrix zero_a(2, k), zero_w(k, 3);
    Config cfg;
    const Model zero = fit(zero_w, zero_a, cfg);
    require(metrics(forward(zero_a, zero), gemm(zero_a, zero_w)).max_abs == 0,
            "zero scale handling");
  }
  bool bad = false;
  try {
    Matrix invalid(-1, 4);
  } catch (const std::invalid_argument&) {
    bad = true;
  }
  require(bad, "negative dimension accepted");
  std::cout << "PASS half finite roundtrip/ties, signed INT4/8 packing, odd tails, K boundaries, "
               "zero scale, independent dequant GEMM\n";
}
}  // namespace
int main() {
  try {
    using namespace quant;
    test_primitives();
    Data data;
    const Matrix reference = gemm(data.evaluation, data.weights),
                 shift_target = gemm(data.shifted, data.weights);
    const Matrix ah = rounded_half(data.evaluation), wh = rounded_half(data.weights);
    const Metrics half_error = metrics(gemm(ah, wh), reference);
    std::cout << std::setprecision(9);
    std::cout << "BASELINE FP32 cpu_gemm_p50_ms=" << benchmark([&] {
      return gemm(data.evaluation, data.weights);
    }) << " input_weight_bytes="
              << (data.evaluation.data.size() + data.weights.data.size()) * 4 << '\n';
    std::cout << "BASELINE FP16_rounding_reference_expanded_FP32_accumulate nrmse="
              << half_error.nrmse << " cpu_gemm_p50_ms=" << benchmark([&] {
                   return gemm(ah, wh);
                 })
              << " input_weight_bytes="
              << (data.evaluation.data.size() + data.weights.data.size()) * 2 << '\n';
    const std::size_t half_bytes = (data.evaluation.data.size() + data.weights.data.size()) * 2;
    std::cout << "| Format | Method | NRMSE | MaxAbs | Cosine | Shift NRMSE | Clip fraction | W "
                 "payload B | Metadata B | A payload B | Total B | FP16/total | CPU packed GEMM "
                 "p50 ms | Alpha | Aclip | Wclip | QAT step | Train MSE before/after |\n"
              << "|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|--"
                 "-:|---|\n";
    for (const auto mode : {std::pair<int, int>{4, 4}, {4, 16}, {8, 8}, {8, 16}}) {
      for (const std::string method : {"absmax", "smoothquant", "calibrated", "outlier", "qat"}) {
        const Model model = build(data, mode.first, mode.second, method);
        const Batch batch = prepare(data.evaluation, model);
        const Metrics error = metrics(packed_gemm(batch, model), reference);
        const Metrics shifted = metrics(forward(data.shifted, model), shift_target);
        const Storage bytes = storage(model, batch);
        if (model.config.smooth) {
          Matrix a = data.evaluation, w = data.weights;
          for (int k = 0; k < model.k; ++k) {
            for (int m = 0; m < a.rows; ++m) {
              a(m, k) /= model.smooth[k];
            }
            for (int n = 0; n < w.cols; ++n) {
              w(k, n) *= model.smooth[k];
            }
          }
          require(metrics(gemm(a, w), reference).nrmse < 1e-6,
                  "SmoothQuant equivalence before rounding");
        }
        std::cout << "| W" << mode.first << "A" << mode.second << " | " << method << " | "
                  << error.nrmse << " | " << error.max_abs << " | " << error.cosine << " | "
                  << shifted.nrmse << " | "
                  << (batch.active ? double(batch.clipped) / batch.active : 0) << " | "
                  << bytes.weight_payload << " | " << bytes.weight_metadata << " | "
                  << bytes.activation_payload << " | " << bytes.total << " | "
                  << double(half_bytes) / bytes.total << " | " << benchmark([&] {
                       return packed_gemm(batch, model);
                     })
                  << " | " << (model.config.smooth ? model.config.alpha : -1) << " | "
                  << model.config.act_clip << " | " << model.config.weight_clip << " | "
                  << model.selected_step << " | " << model.train_before << " / "
                  << model.train_after << " |\n";
        if (method == "qat") {
          require(model.qat_steps == 40 && model.master_updates > 0,
                  "QAT must execute actual updates");
          std::cout << "QAT_TRACE W" << mode.first << "A" << mode.second
                    << " steps=" << model.qat_steps
                    << " changed_master_updates=" << model.master_updates
                    << " changed_final_packed_bytes=" << model.final_code_changes
                    << " train_last=" << model.train_last
                    << " selected_step=" << model.selected_step << '\n';
        }
      }
    }
    std::cout << "PASS 20 format/method comparisons; scales/checkpoints fitted without evaluation "
                 "samples; CPU only, Thor NOT validated\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
