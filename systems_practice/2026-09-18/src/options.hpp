#pragma once

#include <stdexcept>
#include <string>
#include <vector>

namespace practice {
enum class Variant { Baseline, Async, Optimized };
inline const char* name(Variant value) {
  switch (value) {
    case Variant::Baseline:
      return "baseline";
    case Variant::Async:
      return "async";
    case Variant::Optimized:
      return "optimized";
  }
  throw std::invalid_argument("unknown variant");
}
struct Options {
  std::vector<Variant> variants{Variant::Optimized};
  bool profile = false;
  bool sweep = false;
};
inline Options parse_options(const std::vector<std::string>& args) {
  Options options;
  if (args.empty()) {
    return options;
  }
  if (args.size() == 1 && args[0] == "--sweep") {
    options.variants = {Variant::Baseline, Variant::Async, Variant::Optimized};
    options.sweep = true;
    return options;
  }
  if (args.size() != 2 || (args[0] != "--variant" && args[0] != "--profile")) {
    throw std::invalid_argument(
        "usage: ptx_pool [--variant baseline|async|optimized|all] "
        "[OR --profile baseline|async|optimized OR --sweep]");
  }
  options.profile = args[0] == "--profile";
  options.variants.clear();
  for (const auto value : {Variant::Baseline, Variant::Async, Variant::Optimized}) {
    if (args[1] == name(value) || (!options.profile && args[1] == "all")) {
      options.variants.push_back(value);
    }
  }
  if (options.variants.empty()) {
    throw std::invalid_argument("invalid variant; profiling requires exactly one variant");
  }
  return options;
}
}  // namespace practice
