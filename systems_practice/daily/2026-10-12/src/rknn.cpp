#include <rknn_api.h>

#include <algorithm>
#include <chrono>
#include <cmath>
#include <fstream>
#include <iostream>
#include <string>

#include "input.hpp"

void check(int rc, const char* name) {
  if (rc != RKNN_SUCC) {
    throw std::runtime_error(std::string(name) + " rc=" + std::to_string(rc));
  }
}
struct Context {
  rknn_context handle = 0;
  ~Context() {
    if (handle) {
      const int rc = rknn_destroy(handle);
      if (rc != RKNN_SUCC) {
        std::cerr << "rknn_destroy rc=" << rc << '\n';
      }
    }
  }
  Context() = default;
  Context(const Context&) = delete;
  Context& operator=(const Context&) = delete;
};
struct Output {
  rknn_context ctx;
  rknn_output value{};
  bool acquired = false;
  explicit Output(rknn_context c) : ctx(c) {
    value.want_float = 1;
  }
  Output(const Output&) = delete;
  Output& operator=(const Output&) = delete;
  ~Output() {
    if (acquired) {
      const int rc = rknn_outputs_release(ctx, 1, &value);
      if (rc != RKNN_SUCC) {
        std::cerr << "outputs_release rc=" << rc << '\n';
      }
    }
  }
  void release() {
    check(rknn_outputs_release(ctx, 1, &value), "outputs_release");
    acquired = false;
  }
};
int main(int argc, char** argv) {
  try {
    if (argc != 2) {
      throw std::invalid_argument("usage: rknn_input model.rknn");
    }
    std::ifstream file(argv[1], std::ios::binary | std::ios::ate);
    const auto length = file.tellg();
    if (!file || length <= 0 || static_cast<std::uint64_t>(length) > UINT32_MAX) {
      throw std::runtime_error("invalid model length");
    }
    std::vector<char> model(static_cast<std::size_t>(length));
    file.seekg(0);
    if (!file.read(model.data(), length)) {
      throw std::runtime_error("short model read");
    }
    Context ctx;
    check(
        rknn_init(&ctx.handle, model.data(), static_cast<std::uint32_t>(model.size()), 0, nullptr),
        "init");
    rknn_sdk_version version{};
    check(rknn_query(ctx.handle, RKNN_QUERY_SDK_VERSION, &version, sizeof(version)), "version");
    std::cout << "api=" << version.api_version << " driver=" << version.drv_version << '\n';
    rknn_input_output_num count{};
    check(rknn_query(ctx.handle, RKNN_QUERY_IN_OUT_NUM, &count, sizeof(count)), "io_num");
    if (count.n_input != 1 || count.n_output != 1) {
      throw std::runtime_error("expected single IO");
    }
    rknn_tensor_attr in{}, out{};
    check(rknn_query(ctx.handle, RKNN_QUERY_INPUT_ATTR, &in, sizeof(in)), "input_attr");
    check(rknn_query(ctx.handle, RKNN_QUERY_OUTPUT_ATTR, &out, sizeof(out)), "output_attr");
    const bool input_shape =
        in.n_dims == 4 && in.dims[0] == 1 &&
        ((in.fmt == RKNN_TENSOR_NCHW && in.dims[1] == 3 && in.dims[2] == 3 && in.dims[3] == 5) ||
         (in.fmt == RKNN_TENSOR_NHWC && in.dims[1] == 3 && in.dims[2] == 5 && in.dims[3] == 3));
    if (!input_shape || in.n_elems != 45 || out.n_dims != 4 || out.fmt != RKNN_TENSOR_NCHW ||
        out.dims[0] != 1 || out.dims[1] != 2 || out.dims[2] != 3 || out.dims[3] != 5 ||
        out.n_elems != 30) {
      throw std::runtime_error(
          "model shape/layout contract changed; refuse implicit reinterpretation");
    }
    std::cout << "input type=" << in.type << " fmt=" << in.fmt << " size=" << in.size
              << " size_with_stride=" << in.size_with_stride << '\n';
    const auto frame = lesson::make_frame(3, 5, 13);
    const auto expected = lesson::oracle(frame);
    std::vector<double> host_times;
    for (int trial = 0; trial < 25; ++trial) {
      const auto start = std::chrono::steady_clock::now();
      auto input = lesson::fused(frame);
      rknn_input input_desc{};
      input_desc.type = RKNN_TENSOR_FLOAT32;
      input_desc.fmt = RKNN_TENSOR_NHWC;
      input_desc.size = static_cast<std::uint32_t>(input.size() * sizeof(float));
      input_desc.buf = input.data();
      input_desc.pass_through = 0;  // Runtime可转换布局/类型，不冒充零拷贝native输入。
      check(rknn_inputs_set(ctx.handle, 1, &input_desc), "inputs_set");
      check(rknn_run(ctx.handle, nullptr), "run");
      Output result(ctx.handle);
      check(rknn_outputs_get(ctx.handle, 1, &result.value, nullptr), "outputs_get");
      result.acquired = true;
      if (!result.value.buf || result.value.size < expected.size() * sizeof(float)) {
        throw std::runtime_error("short output");
      }
      const auto* data = static_cast<const float*>(result.value.buf);
      float max_error = 0;
      for (std::size_t i = 0; i < expected.size(); ++i) {
        if (!std::isfinite(data[i])) {
          throw std::runtime_error("nonfinite output");
        }
        max_error = std::max(max_error, std::abs(data[i] - expected[i]));
      }
      if (max_error > 0.005F) {
        throw std::runtime_error("float RKNN max_abs exceeds 0.005");
      }
      result.release();
      const auto end = std::chrono::steady_clock::now();
      if (trial >= 5) {
        host_times.push_back(std::chrono::duration<double, std::micro>(end - start).count());
      }
      if (trial == 24) {
        std::cout << "PASS max_abs=" << max_error << "\n";
      }
    }
    std::sort(host_times.begin(), host_times.end());
    std::cout << "host_preprocess_set_run_get_check_release_us P50=" << host_times[10]
              << " P95=" << host_times[18] << " samples=20; not NPU kernel time\n";
    rknn_perf_run perf{};
    const int perf_rc = rknn_query(ctx.handle, RKNN_QUERY_PERF_RUN, &perf, sizeof(perf));
    if (perf_rc == RKNN_SUCC) {
      std::cout << "SDK_last_run_duration_us=" << perf.run_duration << '\n';
    } else {
      std::cerr << "PERF_RUN unavailable rc=" << perf_rc << '\n';
    }
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
