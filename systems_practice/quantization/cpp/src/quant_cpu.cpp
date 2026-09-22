#include <chrono>

#include "lesson.hpp"
using namespace lesson;
using Floats = std::vector<float>;
struct Shape {
  size_t n, k, group;
  size_t groups() const {
    return (k + group - 1) / group;
  }
};
void validate(Shape s) {
  require(s.n > 0 && s.k > 0 && s.group > 0 && s.n <= 4096 && s.k <= 4096 && s.group <= s.k,
          "unsupported shape");
}
struct Packed {
  Shape shape;
  Floats scale, zero;
  std::vector<int> codes;
};
Bytes encode(const Packed& p) {
  validate(p.shape);
  const auto s = p.shape;
  require(p.scale.size() == s.n * s.groups() && p.zero.size() == p.scale.size() &&
              p.codes.size() == s.n * s.k,
          "metadata shape");
  Bytes bytes = {'Q', '4', 'C', '1'};
  put(bytes, s.n, 4);
  put(bytes, s.k, 4);
  put(bytes, s.group, 4);
  for (size_t i = 0; i < p.scale.size(); ++i) {
    require(std::isfinite(p.scale[i]) && p.scale[i] > 0 && std::isfinite(p.zero[i]) &&
                p.zero[i] >= -2147483648.0f && p.zero[i] <= 2147483520.0f &&
                std::nearbyint(p.zero[i]) == p.zero[i],
            "invalid affine metadata");
    put_float(bytes, p.scale[i]);
    put_float(bytes, p.zero[i]);
  }
  const auto body = pack_u4(p.codes);
  bytes.insert(bytes.end(), body.begin(), body.end());
  return bytes;
}
Packed decode(const Bytes& bytes) {
  size_t pos = 0;
  require(get(bytes, pos, 4) == 0x31433451, "wrong Q4C1 magic");
  Shape s{size_t(get(bytes, pos, 4)), size_t(get(bytes, pos, 4)), size_t(get(bytes, pos, 4))};
  validate(s);
  require(bytes.size() == 16 + s.n * s.groups() * 8 + (s.n * s.k + 1) / 2, "binary size mismatch");
  Packed p{s, {}, {}, {}};
  for (size_t i = 0; i < s.n * s.groups(); ++i) {
    p.scale.push_back(get_float<float>(bytes, pos));
    p.zero.push_back(get_float<float>(bytes, pos));
  }
  p.codes = unpack_u4(Bytes(bytes.begin() + pos, bytes.end()), s.n * s.k);
  require(encode(p) == bytes, "noncanonical binary record");
  return p;
}
Floats restore(const Packed& p) {
  Floats w(p.shape.n * p.shape.k);
  const auto s = p.shape;
  for (size_t i = 0; i < w.size(); ++i) {
    const size_t g = (i / s.k) * s.groups() + (i % s.k) / s.group;
    w[i] = (p.codes[i] - p.zero[g]) * p.scale[g];
  }
  return w;
}
Packed quantize(Shape s, const Floats& w, const Floats& scale, const Floats& zero) {
  validate(s);
  require(w.size() == s.n * s.k && scale.size() == s.n * s.groups() && zero.size() == scale.size(),
          "quantization shape");
  Packed p{s, scale, zero, {}};
  for (size_t i = 0; i < w.size(); ++i) {
    const size_t g = (i / s.k) * s.groups() + (i % s.k) / s.group;
    require(
        std::isfinite(w[i]) && std::isfinite(scale[g]) && scale[g] > 0 && std::isfinite(zero[g]),
        "quantization nonfinite/scale");
    const double q = std::nearbyint(double(w[i]) / scale[g] + zero[g]);
    p.codes.push_back(int(std::clamp(q, 0.0, 15.0)));
  }
  encode(p);
  return p;
}
// 实际 C++ FP32 标量累加；本基线不是 packed GEMM，也不代表上游 BLAS 吞吐。
Floats linear(const Floats& x, const Floats& w, size_t m, Shape s) {
  require(x.size() == m * s.k && w.size() == s.n * s.k, "linear shape");
  Floats y(m * s.n, 0);
  for (size_t row = 0; row < m; ++row) {
    for (size_t out = 0; out < s.n; ++out) {
      float acc = 0;
      for (size_t k = 0; k < s.k; ++k) {
        acc += x[row * s.k + k] * w[out * s.k + k];
      }
      y[row * s.n + out] = acc;
    }
  }
  return y;
}
void metrics(const Floats& y, const Floats& ref) {
  require(y.size() == ref.size() && !y.empty(), "metrics shape");
  double error = 0, norm = 0, ynorm = 0, cross = 0, maximum = 0;
  for (size_t i = 0; i < y.size(); ++i) {
    require(std::isfinite(y[i]) && std::isfinite(ref[i]), "nonfinite output");
    const double d = double(y[i]) - ref[i];
    error += d * d;
    norm += double(ref[i]) * ref[i];
    ynorm += double(y[i]) * y[i];
    cross += double(ref[i]) * y[i];
    maximum = std::max(maximum, std::abs(d));
  }
  std::cout << "{\"nrmse\":" << std::sqrt(error) / std::max(1e-30, std::sqrt(norm))
            << ",\"max_abs\":" << maximum << ",\"cosine\":";
  if (norm > 0 && ynorm > 0) {
    std::cout << cross / std::sqrt(norm * ynorm);
  } else {
    std::cout << "null";
  }
  std::cout << '}';
}
Floats half_round(Floats v) {
  for (auto& x : v) {
    x = float(from_half(half_bits(x)));
  }
  return v;
}
Floats absmax(const Floats& w, Shape s) {
  Floats out(w.size());
  for (size_t r = 0; r < s.n; ++r) {
    float peak = 0;
    for (size_t c = 0; c < s.k; ++c) {
      peak = std::max(peak, std::abs(w[r * s.k + c]));
    }
    const float scale = peak > 0 ? peak / 7 : 1;
    for (size_t c = 0; c < s.k; ++c) {
      out[r * s.k + c] =
          float(std::clamp(std::nearbyint(double(w[r * s.k + c]) / scale), -7.0, 7.0)) * scale;
    }
  }
  return out;
}
volatile double benchmark_sink = 0;
void benchmark(const Floats& x, const Floats& w, size_t m, Shape s) {
  using Clock = std::chrono::steady_clock;
  for (int i = 0; i < 10; ++i) {
    const auto y = linear(x, w, m, s);
    benchmark_sink += y[i % y.size()];
  }
  Vec samples;
  for (int i = 0; i < 50; ++i) {
    const auto start = Clock::now();
    const auto y = linear(x, w, m, s);
    const auto stop = Clock::now();
    benchmark_sink += y[i % y.size()];
    samples.push_back(std::chrono::duration<double, std::micro>(stop - start).count());
  }
  std::sort(samples.begin(), samples.end());
  std::cout << "{\"p50_us\":" << samples[24] << ",\"p95_us\":" << samples[47]
            << ",\"warmup\":10,\"samples\":50}";
}
Floats read_values(std::istream& in, size_t count) {
  Floats out(count);
  for (auto& v : out) {
    require(bool(in >> v) && std::isfinite(v), "truncated/nonfinite tensor text");
  }
  return out;
}
void run(const std::string& input, const std::string& artifact) {
  std::ifstream in(input);
  require(bool(in), "cannot open tensor bridge");
  std::string magic;
  Shape s{};
  size_t m = 0;
  int offset = 0;
  require(bool(in >> magic >> s.n >> s.k >> s.group >> m >> offset) && magic == "QINPUT1" &&
              (offset == 0 || offset == 1),
          "invalid bridge header");
  validate(s);
  require(m > 0 && m <= 4096, "invalid batch");
  const auto original = read_values(in, s.n * s.k), native = read_values(in, s.n * s.k),
             rtn = read_values(in, s.n * s.k), scales = read_values(in, s.n * s.groups());
  auto zeros = read_values(in, s.n * s.groups());
  if (offset) {
    for (auto& z : zeros) {
      z = -z;
    }
  }
  const auto evaluation = read_values(in, m * s.k), shifted = read_values(in, m * s.k);
  std::string trailing;
  require(!(in >> trailing), "trailing bridge data");
  const auto p = quantize(s, native, scales, zeros);
  const auto bytes = encode(p);
  save(artifact, bytes);
  const auto reload = load(artifact);
  require(reload == bytes, "disk bytes changed");
  const auto decoded = restore(decode(reload));
  double max_decode_error = 0;
  for (size_t i = 0; i < native.size(); ++i) {
    const size_t g = (i / s.k) * s.groups() + (i % s.k) / s.group;
    const double error = std::abs(double(decoded[i]) - native[i]);
    max_decode_error = std::max(max_decode_error, error);
    // AWQ 原生半精度 QDQ 有一次 FP16 舍入；严格小于半步，避免错误码被容忍。
    require(error <= std::min(.25 * scales[g],
                              .002 * std::max(std::abs(double(native[i])), double(scales[g]))) +
                         1e-7,
            "native weights not on declared grid");
  }
  const auto w16 = half_round(original), abs = absmax(original, s);
  size_t endpoint = 0;
  for (int q : p.codes) {
    endpoint += q == 0 || q == 15;
  }
  std::cout << std::setprecision(17)
            << "{\"status\":\"cpp_backend_passed\",\"format\":\"independent_Q4C1_not_upstream_"
               "backend\",\"fp32_weight_bytes\":"
            << original.size() * 4 << ",\"fp16_weight_bytes\":" << original.size() * 2
            << ",\"u4_payload_bytes\":" << (original.size() + 1) / 2
            << ",\"affine_bytes\":" << scales.size() * 8
            << ",\"header_bytes\":16,\"file_bytes\":" << reload.size()
            << ",\"max_native_decode_error\":" << max_decode_error
            << ",\"endpoint_fraction\":" << double(endpoint) / p.codes.size()
            << ",\"comparisons\":{";
  const std::vector<std::string> labels = {
      "fp16_storage_fp32_accumulation", "independent_absmax", "upstream_rtn", "native_decoded"};
  const std::vector<Floats> weights = {w16, abs, rtn, decoded};
  for (int split = 0; split < 3; ++split) {
    if (split) {
      std::cout << ',';
    }
    const auto x = split == 0 ? evaluation : split == 1 ? shifted : Floats(m * s.k, 0);
    const auto ref = linear(x, original, m, s);
    const auto x16 = half_round(x);
    std::cout << '"'
              << (split == 0   ? "evaluation"
                  : split == 1 ? "shifted"
                               : "zero_input")
              << "\":{";
    for (size_t j = 0; j < weights.size(); ++j) {
      if (j) {
        std::cout << ',';
      }
      std::cout << '"' << labels[j] << "\":";
      metrics(linear(x16, weights[j], m, s), ref);
    }
    std::cout << '}';
  }
  std::cout << "},\"cpu_scalar_decoded_linear\":";
  benchmark(half_round(evaluation), decoded, m, s);
  std::cout << ",\"timing_scope\":\"C++ scalar FP32 allocation+GEMM; excludes decode/IO/training; "
               "no BLAS/GPU/NPU/board claim\",\"thor_verified\":false}\n";
}
template <class F>
void rejects(F fn) {
  bool rejected = false;
  try {
    fn();
  } catch (const std::runtime_error&) {
    rejected = true;
  }
  require(rejected, "invalid input accepted");
}
void self_test() {
  // 已知字节独立检验：不能仅让编码器和解码器互相认可同一个错误。
  require(pack_u4({1, 2, 15}) == Bytes({0x21, 0x0f}), "nibble byte order");
  for (const auto& codes : {std::vector<int>{},
                            std::vector<int>{0},
                            std::vector<int>{15},
                            std::vector<int>{0, 1, 7, 15, 3}}) {
    require(unpack_u4(pack_u4(codes), codes.size()) == codes, "u4 roundtrip");
  }
  rejects([] {
    pack_u4({-1});
  });
  rejects([] {
    pack_u4({16});
  });
  rejects([] {
    unpack_u4({0xf1}, 1);
  });
  rejects([] {
    unpack_u4({}, 1);
  });
  Bytes f;
  put_float(f, 1.0f);
  require(f == Bytes({0, 0, 128, 63}), "IEEE LE bytes");
  require(half_bits(1) == 0x3c00 && half_bits(-2) == 0xc000 && half_bits(65504) == 0x7bff &&
              half_bits(std::ldexp(1.0, -24)) == 1,
          "FP16 known values");
  require(half_bits(1 + std::ldexp(1.0, -11)) == 0x3c00 &&
              half_bits(1 + 3 * std::ldexp(1.0, -11)) == 0x3c02,
          "FP16 ties even");
  for (unsigned bits = 0; bits < 65536; ++bits) {
    if (((bits >> 10) & 31) != 31) {
      require(half_bits(from_half(uint16_t(bits))) == bits, "exhaustive finite FP16 roundtrip");
    }
  }
  rejects([] {
    half_bits(std::numeric_limits<double>::infinity());
  });
  for (const Shape s : {Shape{1, 1, 1},
                        Shape{3, 33, 16},
                        Shape{8, 33, 33},
                        Shape{32, 128, 128},
                        Shape{64, 128, 128}}) {
    Packed p{s, Floats(s.n * s.groups(), .125f), Floats(s.n * s.groups(), 8), {}};
    for (size_t i = 0; i < s.n * s.k; ++i) {
      p.codes.push_back(int(i % 16));
    }
    const auto bytes = encode(p);
    const auto back = decode(bytes);
    require(back.codes == p.codes && restore(back) == restore(p), "group/tail roundtrip");
    require(quantize(s, restore(p), p.scale, p.zero).codes == p.codes, "grid recovery");
    auto bad = bytes;
    bad.pop_back();
    rejects([&] {
      decode(bad);
    });
    bad = bytes;
    bad[0] = 'X';
    rejects([&] {
      decode(bad);
    });
    bad = bytes;
    bad.push_back(0);
    rejects([&] {
      decode(bad);
    });
    p.scale[0] = 0;
    rejects([&] {
      encode(p);
    });
    p.scale[0] = std::numeric_limits<float>::quiet_NaN();
    rejects([&] {
      encode(p);
    });
  }
  require(linear({1, 2, 3}, {1, 0, -1, 2, 1, 0}, 1, {2, 3, 3}) == Floats({-2, 4}),
          "known matrix product");
  require(absmax(Floats(6, 0), {2, 3, 3}) == Floats(6, 0), "zero absmax");
  std::cout << "{\"status\":\"cpp_self_test_passed\",\"group_shapes\":5,\"finite_fp16_patterns\":"
               "63488,\"native_quantizer_run\":false,\"checks\":[\"known_bytes\",\"odd_tail\","
               "\"invalid_code\",\"truncation\",\"wrong_magic\",\"trailing_bytes\",\"invalid_"
               "scale\",\"FP16_ties_even\",\"known_GEMM\",\"zero_row\"]}\n";
}
// 合成网格数据只检查文件协议/磁盘往返/数值与计时管线，不冒充任何上游算法。
void integration_test(const std::string& directory) {
  const std::vector<Shape> shapes = {{64, 128, 128}, {32, 128, 128}, {8, 33, 33}, {8, 33, 16}};
  for (size_t test = 0; test < shapes.size(); ++test) {
    const auto s = shapes[test];
    const size_t m = 4;
    Packed p{s, Floats(s.n * s.groups(), .125f), Floats(s.n * s.groups(), 8), {}};
    for (size_t i = 0; i < s.n * s.k; ++i) {
      p.codes.push_back(i < s.k ? 8 : int(i % 16));
    }
    const auto w = restore(p);
    Floats x(m * s.k);
    for (size_t i = 0; i < x.size(); ++i) {
      x[i] = float(int(i % 7) - 3) / 8;
    }
    const std::string base = directory + "/synthetic-" + std::to_string(test);
    std::ofstream out(base + ".txt");
    require(bool(out), "fixture output");
    const int offset = test == 2 ? 1 : 0;
    out << "QINPUT1 " << s.n << ' ' << s.k << ' ' << s.group << ' ' << m << ' ' << offset << '\n';
    auto zero = p.zero;
    if (offset) {
      for (auto& z : zero) {
        z = -z;
      }
    }
    for (const Floats* values :
         std::initializer_list<const Floats*>{&w, &w, &w, &p.scale, &zero, &x, &x}) {
      for (float v : *values) {
        out << std::setprecision(9) << v << ' ';
      }
      out << '\n';
    }
    out.close();
    require(bool(out), "fixture write failed");
    run(base + ".txt", base + ".q4");
    const auto artifact = decode(load(base + ".q4"));
    require(restore(artifact) == w, "integration weights changed");
    require(linear(x, restore(artifact), m, s) == linear(x, w, m, s), "integration output changed");
  }
}
int main(int argc, char** argv) {
  try {
    if (argc == 2 && std::string(argv[1]) == "--self-test") {
      self_test();
    } else if (argc == 3 && std::string(argv[1]) == "--integration-test") {
      integration_test(argv[2]);
    } else {
      require(argc == 3, "usage: quant_cpu --self-test | INPUT.txt OUTPUT.q4");
      run(argv[1], argv[2]);
    }
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
