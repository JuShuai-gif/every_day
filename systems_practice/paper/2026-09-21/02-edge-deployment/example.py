"""自定义分块 uint4 格式演示；不是 GGUF，也不调用作者部署代码。"""

import json
import math
import random
import struct

BLOCK = 256


def serialize(weights):
    if not weights:
        raise ValueError("权重不能为空")
    # 为演示明确规定：无法整除块长就整行回退 FP16。真实后端须查实际规则。
    if len(weights) % BLOCK:
        blob = struct.pack("<" + "e" * len(weights), *weights)
        return "fp16_fallback", blob, list(struct.unpack("<" + "e" * len(weights), blob))
    blob = bytearray()
    decoded = []
    for start in range(0, len(weights), BLOCK):
        group = weights[start:start + BLOCK]
        # 对称范围 [-7,7]，用 q+8 存入 nibble；每块含 FP32 scale。
        scale = max(abs(x) for x in group) / 7 or 1.0
        scale_bytes = struct.pack("<f", scale)
        scale = struct.unpack("<f", scale_bytes)[0]
        codes = [max(-7, min(7, round(x / scale))) + 8 for x in group]
        packed = bytes(codes[i] | (codes[i + 1] << 4) for i in range(0, BLOCK, 2))
        blob.extend(scale_bytes + packed)
    # 从实际字节流解码，不用量化前的浮点数组假充压缩产物。
    for offset in range(0, len(blob), 4 + BLOCK // 2):
        scale = struct.unpack("<f", blob[offset:offset + 4])[0]
        for byte in blob[offset + 4:offset + 4 + BLOCK // 2]:
            decoded.extend(((byte & 15) - 8, (byte >> 4) - 8))
        begin = len(decoded) - BLOCK
        decoded[begin:] = [q * scale for q in decoded[begin:]]
    return "custom_u4", bytes(blob), decoded


def main():
    rng = random.Random(21)
    width = 1024
    weights = [rng.uniform(-1, 1) for _ in range(width)]
    inputs = [rng.uniform(-1, 1) for _ in range(width)]
    reference = sum(w * x for w, x in zip(weights, inputs))
    target = width - math.floor(0.1 * width)
    aligned = target // BLOCK * BLOCK
    cases = []
    for name, kept in [("baseline", width), ("prune_target_10pct", target),
                       ("round_down_to_aligned_width", aligned)]:
        # 保留前缀仅为简化；没有实现 DepGraph 或重要性搜索。
        mode, blob, decoded = serialize(weights[:kept])
        assert len(decoded) == kept
        if mode == "custom_u4":
            assert len(blob) == kept // BLOCK * (4 + BLOCK // 2)
        else:
            assert len(blob) == kept * 2
        output = sum(w * x for w, x in zip(decoded, inputs[:kept]))
        pruned_reference = sum(w * x for w, x in zip(weights[:kept], inputs[:kept]))
        cases.append({"case": name, "kept_width": kept, "actual_pruned_fraction": 1 - kept / width,
                      "storage_mode": mode, "payload_and_scales_bytes": len(blob),
                      "abs_error_vs_original": abs(output - reference),
                      "abs_storage_error_vs_pruned_reference": abs(output - pruned_reference)})
    assert serialize([0.0] * BLOCK)[2] == [0.0] * BLOCK
    assert serialize([0.0] * (BLOCK - 1))[0] == "fp16_fallback"
    mode, _, exact = serialize([float(i % 15 - 7) for i in range(BLOCK)])
    assert mode == "custom_u4" and exact == [float(i % 15 - 7) for i in range(BLOCK)]
    assert cases[1]["payload_and_scales_bytes"] > cases[0]["payload_and_scales_bytes"]
    assert cases[2]["payload_and_scales_bytes"] < cases[0]["payload_and_scales_bytes"]
    print(json.dumps({"kind": "independent_custom_format_not_gguf",
                      "cases": cases,
                      "checks": ["zero_block", "unaligned_tail", "exact_nibble_roundtrip", "actual_byte_lengths"]},
                     indent=2, ensure_ascii=False, allow_nan=False))


if __name__ == "__main__":
    main()
