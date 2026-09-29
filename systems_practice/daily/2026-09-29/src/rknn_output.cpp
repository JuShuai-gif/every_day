#include <rknn_api.h>

#include <algorithm>
#include <chrono>
#include <cstring>
#include <fstream>
#include <iostream>
#include <iterator>
#include <limits>
#include <string>

#include "contract.hpp"

void checked(int status, const char* api) {
  if (status != RKNN_SUCC) {
    throw std::runtime_error(std::string(api) + ": " + std::to_string(status));
  }
}
void cleanup(int status, const char* api) noexcept {
  if (status != RKNN_SUCC) {
    std::cerr << "cleanup failure " << api << ": " << status << '\n';
  }
}
class Context {
 public:
  explicit Context(const char* path) {
    std::ifstream f(path, std::ios::binary);
    require(f.good(), "cannot open RKNN model");
    std::vector<char> bytes((std::istreambuf_iterator<char>(f)), {});
    require(!bytes.empty() && bytes.size() <= std::numeric_limits<std::uint32_t>::max(),
            "model size");
    checked(rknn_init(&ctx_, bytes.data(), static_cast<std::uint32_t>(bytes.size()), 0, nullptr),
            "rknn_init");
  }
  ~Context() noexcept {
    cleanup(rknn_destroy(ctx_), "rknn_destroy");
  }
  Context(const Context&) = delete;
  Context& operator=(const Context&) = delete;
  rknn_context get() const {
    return ctx_;
  }

 private:
  rknn_context ctx_ = 0;
};
using Clock = std::chrono::steady_clock;
struct Sample {
  std::vector<float> y;
  double wall_us;
  double run_call_us;
};
Sample infer(rknn_context ctx,
             std::vector<float>& x,
             const rknn_tensor_attr& attr,
             bool want_float) {
  auto start = Clock::now();
  rknn_input in{};
  in.index = 0;
  in.buf = x.data();
  in.size = static_cast<std::uint32_t>(x.size() * sizeof(float));
  in.type = RKNN_TENSOR_FLOAT32;
  in.fmt = RKNN_TENSOR_NCHW;
  in.pass_through = 0;
  checked(rknn_inputs_set(ctx, 1, &in), "rknn_inputs_set");
  auto run_start = Clock::now();
  checked(rknn_run(ctx, nullptr), "rknn_run");
  auto run_end = Clock::now();
  std::vector<float> y;
  {
    rknn_output out{};
    out.index = 0;
    out.want_float = want_float;
    out.is_prealloc = 0;
    checked(rknn_outputs_get(ctx, 1, &out, nullptr), "rknn_outputs_get");
    OutputLease lease([&]() noexcept {
      cleanup(rknn_outputs_release(ctx, 1, &out), "rknn_outputs_release");
    });
    require(out.buf != nullptr, "empty output");
    if (want_float) {
      require(out.size >= attr.n_elems * sizeof(float), "short FP32 output");
      const auto* data = static_cast<const float*>(out.buf);
      y.assign(data, data + attr.n_elems);
    } else {
      y = decode(
          static_cast<const std::int8_t*>(out.buf), attr.n_elems, out.size, attr.scale, attr.zp);
    }
    // 必须先复制/解码，再释放Runtime内存；返回的是自有vector。
  }
  return {std::move(y),
          std::chrono::duration<double, std::micro>(Clock::now() - start).count(),
          std::chrono::duration<double, std::micro>(run_end - run_start).count()};
}
void report(const char* label, std::vector<double> x) {
  std::sort(x.begin(), x.end());
  std::cout << label << " p50_us=" << x[x.size() / 2] << " p95_us=" << x[(x.size() * 95) / 100]
            << '\n';
}
int main(int argc, char** argv) {
  try {
    require(argc == 2, "usage: rknn_output tiny.rknn");
    Context context(argv[1]);
    const auto ctx = context.get();
    rknn_sdk_version version{};
    checked(rknn_query(ctx, RKNN_QUERY_SDK_VERSION, &version, sizeof(version)), "SDK version");
    std::cout << "runtime=" << version.api_version << " driver=" << version.drv_version << '\n';
    rknn_input_output_num io{};
    checked(rknn_query(ctx, RKNN_QUERY_IN_OUT_NUM, &io, sizeof(io)), "IO count");
    require(io.n_input == 1 && io.n_output == 1, "only tiny one-input one-output model supported");
    rknn_tensor_attr in{}, out{};
    checked(rknn_query(ctx, RKNN_QUERY_INPUT_ATTR, &in, sizeof(in)), "input attr");
    checked(rknn_query(ctx, RKNN_QUERY_OUTPUT_ATTR, &out, sizeof(out)), "output attr");
    require(in.n_dims == 4 && in.n_elems == 60, "unexpected input shape");
    const bool nchw = in.fmt == RKNN_TENSOR_NCHW && in.dims[0] == 1 && in.dims[1] == 3 &&
                      in.dims[2] == 4 && in.dims[3] == 5;
    const bool nhwc = in.fmt == RKNN_TENSOR_NHWC && in.dims[0] == 1 && in.dims[1] == 4 &&
                      in.dims[2] == 5 && in.dims[3] == 3;
    require(nchw || nhwc, "input dimensions mismatch");
    // 拒绝未实现布局/精度，不把NC1HWC2或FP16重新解释成int8。
    require(out.n_dims == 4 && out.n_elems == 40 && out.fmt == RKNN_TENSOR_NCHW &&
                out.dims[0] == 1 && out.dims[1] == 2 && out.dims[2] == 4 && out.dims[3] == 5,
            "requires logical NCHW output");
    require(out.type == RKNN_TENSOR_INT8 && out.qnt_type == RKNN_TENSOR_QNT_AFFINE_ASYMMETRIC,
            "requires affine INT8 output; inspect converter report");
    std::cout << "output scale=" << out.scale << " zero=" << out.zp << " bytes=" << out.size
              << '\n';
    std::vector<double> raw_time, float_time, calls;
    double max_conversion_error = 0, max_model_error = 0;
    for (unsigned i = 0; i < 120; ++i) {
      auto x = input(i % 16);
      Sample raw, fp;
      // 交替顺序降低热漂移偏差；每个版本都提交并取回同一帧。
      if (i % 2 == 0) {
        raw = infer(ctx, x, out, false);
        fp = infer(ctx, x, out, true);
      } else {
        fp = infer(ctx, x, out, true);
        raw = infer(ctx, x, out, false);
      }
      auto expected = oracle(x);
      for (std::size_t j = 0; j < expected.size(); ++j) {
        require(std::isfinite(raw.y[j]) && std::isfinite(fp.y[j]), "nonfinite result");
        const double conversion = std::abs(raw.y[j] - fp.y[j]);
        const double model = std::abs(raw.y[j] - expected[j]);
        max_conversion_error = std::max(max_conversion_error, conversion);
        max_model_error = std::max(max_model_error, model);
        require(conversion <= std::max(1e-6F, out.scale * 1e-4F),
                "raw vs automatic dequantization mismatch");
        require(model <= 0.03, "model max_abs exceeds fixed synthetic acceptance threshold 0.03");
      }
      if (i >= 20) {
        raw_time.push_back(raw.wall_us);
        float_time.push_back(fp.wall_us);
        calls.push_back(raw.run_call_us);
      }
    }
    std::cout << "PASS max_conversion_error=" << max_conversion_error
              << " max_model_error=" << max_model_error << '\n';
    report("host input-set + run + get + decode/copy + release raw", raw_time);
    report("host input-set + run + get + copy + release float", float_time);
    report("host rknn_run call (NOT NPU device time)", calls);
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
