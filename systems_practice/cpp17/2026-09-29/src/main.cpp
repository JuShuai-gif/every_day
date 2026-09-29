#include <cmath>
#include <iostream>
#include <limits>
#include <optional>
#include <stdexcept>
#include <string>
#include <type_traits>
#include <utility>

namespace {
// 配置拥有自己的字符串；构造成功才代表所有字段满足业务约束。
struct Config {
  std::string model;
  int batch;
  float threshold;

  Config(std::string name, int count, float score)
      : model(std::move(name)), batch(count), threshold(score) {
    if (model.empty() || batch < 1 || batch > 16 || !std::isfinite(threshold) || threshold < 0.0F ||
        threshold > 1.0F) {
      throw std::invalid_argument("invalid inference config");
    }
  }
};

using Slot = std::optional<Config>;
static_assert(std::is_nothrow_move_constructible_v<Config>);
static_assert(std::is_nothrow_swappable_v<Config>);
static_assert(noexcept(std::declval<Slot&>().swap(std::declval<Slot&>())));

void require(bool condition, const char* message) {
  if (!condition) {
    throw std::runtime_error(message);
  }
}

// 单线程事务：先构造候选，全部成功后才执行不抛异常的提交。
void publish(Slot& active, const std::string& model, int batch, float threshold) {
  Slot candidate(std::in_place, model, batch, threshold);
  active.swap(candidate);
  // candidate 此时保存旧配置，离开作用域时自动释放其字符串资源。
}

template <class Action>
void expect_invalid(Action action) {
  bool rejected = false;
  try {
    action();
  } catch (const std::invalid_argument&) {
    rejected = true;
  }
  require(rejected, "invalid config unexpectedly accepted");
}

void verify() {
  Slot active;
  require(!active.has_value(), "startup must have no config");
  bool missing = false;
  try {
    (void)active.value();
  } catch (const std::bad_optional_access&) {
    missing = true;
  }
  require(missing, "value() must reject empty slot");

  // 空状态下失败，不能发布半初始化配置。
  expect_invalid([&] {
    publish(active, "camera-v1", 0, 0.5F);
  });
  require(!active, "failed startup changed state");
  publish(active, "camera-v1", 1, 0.0F);
  require(active && active->batch == 1 && active->threshold == 0.0F, "lower boundary rejected");

  // 对照组：emplace 先销毁旧对象，再尝试构造新对象；失败后旧值已丢失。
  Slot destructive = active;
  expect_invalid([&] {
    destructive.emplace("camera-v2", 0, 0.5F);
  });
  require(!destructive, "failed emplace must leave empty optional");
  std::cout << "baseline: failed emplace leaves empty slot\n";

  int rejected = 0;
  auto reject_preserving_old = [&](const std::string& name, int batch, float score) {
    expect_invalid([&] {
      publish(active, name, batch, score);
    });
    require(
        active && active->model == "camera-v1" && active->batch == 1 && active->threshold == 0.0F,
        "failed transaction lost old config");
    ++rejected;
  };
  reject_preserving_old("", 1, 0.5F);
  reject_preserving_old("v2", 0, 0.5F);
  reject_preserving_old("v2", 17, 0.5F);
  reject_preserving_old("v2", 1, -0.01F);
  reject_preserving_old("v2", 1, 1.01F);
  reject_preserving_old("v2", 1, std::numeric_limits<float>::quiet_NaN());
  reject_preserving_old("v2", 1, std::numeric_limits<float>::infinity());
  std::cout << "transaction: " << rejected << " invalid updates preserve old config\n";

  publish(active, "camera-v2", 16, 1.0F);
  require(
      active && active->model == "camera-v2" && active->batch == 16 && active->threshold == 1.0F,
      "successful update not committed");
  active.reset();
  active.reset();
  require(!active, "reset must leave empty optional");
  std::cout << "PASS: empty access, failed startup, boundaries, commit, repeated reset\n";
}
}  // namespace

int main() {
  try {
    verify();
    return 0;
  } catch (const std::exception& error) {
    std::cerr << "FAIL: " << error.what() << '\n';
    return 1;
  }
}
