#include <rknn_api.h>

#include <algorithm>
#include <cstring>
#include <fstream>
#include <iostream>
#include <stdexcept>
#include <vector>

class RknnContext {
 public:
  explicit RknnContext(const std::vector<unsigned char>& model) {
    const int rc =
        rknn_init(&ctx_, const_cast<unsigned char*>(model.data()), model.size(), 0, nullptr);
    if (rc != RKNN_SUCC)
      throw std::runtime_error("rknn_init failed: " + std::to_string(rc));
  }
  ~RknnContext() {
    if (ctx_) {
      const int rc = rknn_destroy(ctx_);
      if (rc != RKNN_SUCC)
        std::cerr << "rknn_destroy: " << rc << '\n';
    }
  }
  rknn_context get() const {
    return ctx_;
  }

 private:
  rknn_context ctx_ = 0;
};
class RknnMem {
 public:
  RknnMem(rknn_context ctx, uint32_t bytes) : ctx_(ctx), mem_(rknn_create_mem(ctx, bytes)) {
    if (!mem_)
      throw std::runtime_error("rknn_create_mem failed");
  }
  ~RknnMem() {
    if (mem_) {
      const int rc = rknn_destroy_mem(ctx_, mem_);
      if (rc != RKNN_SUCC)
        std::cerr << "rknn_destroy_mem: " << rc << '\n';
    }
  }
  rknn_tensor_mem* get() const {
    return mem_;
  }

 private:
  rknn_context ctx_;
  rknn_tensor_mem* mem_ = nullptr;
};
static std::vector<unsigned char> read_all(const char* path) {
  std::ifstream f(path, std::ios::binary);
  if (!f)
    throw std::runtime_error("cannot open rknn model");
  return {std::istreambuf_iterator<char>(f), {}};
}
int main(int argc, char** argv) {
  if (argc != 2) {
    std::cerr << "usage: rknn_stride_binding model.rknn\n";
    return 64;
  }
  try {
    RknnContext ctx(read_all(argv[1]));
    rknn_input_output_num io{};
    if (rknn_query(ctx.get(), RKNN_QUERY_IN_OUT_NUM, &io, sizeof(io)) != RKNN_SUCC ||
        io.n_input != 1)
      throw std::runtime_error("expect one input");
    rknn_tensor_attr in{};
    in.index = 0;
    if (rknn_query(ctx.get(), RKNN_QUERY_INPUT_ATTR, &in, sizeof(in)) != RKNN_SUCC)
      throw std::runtime_error("query input attr failed");
    if (in.fmt != RKNN_TENSOR_NHWC || in.type != RKNN_TENSOR_UINT8 || in.n_dims != 4)
      throw std::runtime_error("exercise expects UINT8 NHWC input");
    // size_with_stride 是 Runtime 的物理缓冲区契约；不能用逻辑 size 或 H*W*C 代替。
    if (in.dims[0] != 1 || in.dims[1] != 4 || in.dims[2] != 6 || in.dims[3] != 3)
      throw std::runtime_error("unexpected model shape");
    RknnMem input(ctx.get(), in.size_with_stride);
    std::memset(input.get()->virt_addr, 0, in.size_with_stride);
    if (rknn_set_io_mem(ctx.get(), input.get(), &in) != RKNN_SUCC)
      throw std::runtime_error("bind input failed");
    // 输入源是紧凑 NHWC；逐行写入，使物理 padding 保持为零。
    std::vector<unsigned char> tight(in.dims[0] * in.dims[1] * in.dims[2] * in.dims[3]);
    for (size_t i = 0; i < tight.size(); ++i)
      tight[i] = static_cast<unsigned char>(i % 251);
    const uint32_t row_bytes = in.dims[2] * in.dims[3];
    const uint32_t stride_bytes = in.w_stride * in.dims[3];
    if (stride_bytes < row_bytes || in.size_with_stride < in.dims[0] * in.dims[1] * stride_bytes)
      throw std::runtime_error("invalid physical input stride");
    auto* input_bytes = static_cast<unsigned char*>(input.get()->virt_addr);
    for (uint32_t y = 0; y < in.dims[1]; ++y)
      std::memcpy(input_bytes + y * stride_bytes, tight.data() + y * row_bytes, row_bytes);
    rknn_tensor_attr out{};
    out.index = 0;
    if (io.n_output != 1 ||
        rknn_query(ctx.get(), RKNN_QUERY_OUTPUT_ATTR, &out, sizeof(out)) != RKNN_SUCC)
      throw std::runtime_error("query output attr failed");
    RknnMem output(ctx.get(), out.size_with_stride);
    if (rknn_set_io_mem(ctx.get(), output.get(), &out) != RKNN_SUCC)
      throw std::runtime_error("bind output failed");
    // rknn_run 的边界是端到端 Runtime 调用；若工具支持设备性能查询，应另行记录。
    if (rknn_run(ctx.get(), nullptr) != RKNN_SUCC)
      throw std::runtime_error("rknn_run failed");
    if (out.type != RKNN_TENSOR_UINT8 || out.fmt != RKNN_TENSOR_NHWC || out.w_stride < out.dims[2])
      throw std::runtime_error("unexpected Identity output contract");
    const auto* output_bytes = static_cast<const unsigned char*>(output.get()->virt_addr);
    const uint32_t output_row = out.dims[2] * out.dims[3],
                   output_stride = out.w_stride * out.dims[3];
    for (uint32_t y = 0; y < in.dims[1]; ++y)
      if (!std::equal(tight.begin() + y * row_bytes,
                      tight.begin() + (y + 1) * row_bytes,
                      output_bytes + y * output_stride))
        throw std::runtime_error("Identity output mismatch");
    std::cout << "bound input: logical=" << in.size << " physical=" << in.size_with_stride
              << " w_stride=" << in.w_stride << "\n";
    std::cout << "RKNN Identity stride correctness=PASS\n";
  } catch (const std::exception& e) {
    std::cerr << "ERROR: " << e.what() << '\n';
    return 1;
  }
}
