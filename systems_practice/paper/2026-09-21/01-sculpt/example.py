"""独立机制示例：无网络、无框架、无模型训练；不是完整 SCULPT。"""

import json
import math
import random
import struct


def quantile(values, p):
    if not values or not 0 <= p <= 1:
        raise ValueError("分位数需要非空输入和合法概率")
    ordered = sorted(values)
    index = (len(ordered) - 1) * p
    lo, hi = math.floor(index), math.ceil(index)
    return ordered[lo] + (ordered[hi] - ordered[lo]) * (index - lo)


class StableBounds:
    def __init__(self):
        self.bounds = None
        self.step = 0
        self.frozen = False

    def observe(self, post_activation):
        # 输入已经过 ReLU；分位数不在预激活上计算。
        if self.frozen:
            return
        pair = [quantile(post_activation, p) for p in (0.001, 0.999)]
        alpha = 0.2 / (1 + 0.1 * self.step)  # 演示参数，非作者默认值
        if self.bounds is None:
            self.bounds = pair
        else:
            self.bounds = [(1 - alpha) * a + alpha * b
                           for a, b in zip(self.bounds, pair)]
        self.step += 1


def uadr(values):
    # 只计算统计正则，没有反向传播或权重更新；输入是层的预激活输出。
    mean = sum(values) / len(values)
    variance = sum((x - mean) ** 2 for x in values) / len(values)
    z = [(x - mean) / math.sqrt(variance + 1e-8) for x in values]
    skew = sum(x ** 3 for x in z) / len(z)
    kurtosis = sum(x ** 4 for x in z) / len(z)
    penalty = 0.01 * max(0, skew) ** 2 + 0.01 * max(0, kurtosis - 3) ** 2
    return {"skew": skew, "kurtosis": kurtosis, "penalty": penalty}


def encode_u8(values, bounds):
    # 自定义 uint8 + FP64 范围头；非框架量化格式，不是整数推理 kernel。
    lo, hi = bounds
    if hi < lo:
        raise ValueError("范围倒置")
    scale = (hi - lo) / 255 if hi > lo else 1.0
    clipped = [max(lo, min(hi, x)) for x in values]
    payload = bytes(max(0, min(255, round((x - lo) / scale))) for x in clipped)
    blob = struct.pack("<dd", lo, scale) + payload
    offset, stored_scale = struct.unpack("<dd", blob[:16])
    decoded = [offset + q * stored_scale for q in blob[16:]]
    return blob, decoded


def batch(seed):
    rng = random.Random(seed)
    # 人工稀有离群值；用于展示裁剪损失与量化步长之间的取舍。
    return [rng.gauss(0, 1) for _ in range(3999)] + [30.0]


def report(values, bounds):
    blob, decoded = encode_u8(values, bounds)
    errors = [(a - b) ** 2 for a, b in zip(values, decoded)]
    body = [e for x, e in zip(values, errors) if x < 5]
    return {"mse_all": sum(errors) / len(errors),
            "mse_body_x_lt_5": sum(body) / len(body),
            "outside_bounds": sum(x < bounds[0] or x > bounds[1] for x in values),
            "stored_bytes_including_metadata": len(blob)}


def main():
    observer = StableBounds()
    for seed in range(10):
        observer.observe([max(0, x) for x in batch(seed)])
    observer.frozen = True
    frozen = tuple(observer.bounds)
    observer.observe([0, 1000000])
    assert tuple(observer.bounds) == frozen
    # 基线校准与最终评估用不同种子；超参数预先固定，评估不调参。
    calibration = [max(0, x) for x in batch(100)]
    evaluation = [max(0, x) for x in batch(200)]
    assert encode_u8([0.0] * 4, (0, 0))[1] == [0.0] * 4
    assert encode_u8([-100.0, 100.0], (2, 2))[1] == [2.0, 2.0]
    assert uadr([0.0] * 4)["penalty"] == 0
    assert quantile([0, 2], 0.5) == 1
    result = {"kind": "independent_mechanism_demo_no_training",
              "frozen_bounds": frozen, "regularizer_on_pre_activation": uadr(batch(0)),
              "minmax": report(evaluation, (min(calibration), max(calibration))),
              "percentile_ema": report(evaluation, frozen),
              "checks": ["frozen_bounds", "constant_zero", "quantile_interpolation"]}
    print(json.dumps(result, indent=2, ensure_ascii=False, allow_nan=False))


if __name__ == "__main__":
    main()
