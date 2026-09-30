"""独立标量状态反馈实验；非作者GRU/训练代码，不报告模型任务精度。"""
import json
import math
import struct


def quant(x, bits):
    # 对称有符号网格；舍入采用Python nearest-even，端点饱和。
    step = 1.0 / (2 ** (bits - 1) - 1)
    return max(-1.0, min(1.0, round(x / step) * step))


def trajectory(inputs, feedback):
    q, e, writes, result = 0.0, 0.0, 0, []
    step = 1.0 / 7
    for x in inputs:
        h = q + x
        compensated = h + (e if feedback else 0)
        new = quant(compensated, 4)
        if feedback:
            e = max(-step, min(step, compensated - new))
        writes += new != q
        q = new
        result.append(q)
    return result, writes, e


def main():
    # 60次同向微小增量均低于半步；总期望0.6且未饱和。
    x = [0.01] * 60
    reference = [(i + 1) * 0.01 for i in range(len(x))]
    naive, nw, _ = trajectory(x, False)
    ef, ew, residual = trajectory(x, True)
    assert nw == 0 and ew > 0
    assert abs(ef[-1] + residual - reference[-1]) < 1e-12
    assert max(abs(a - b) for a, b in zip(ef, reference)) <= 1 / 14 + 1e-12
    zero, _, _ = trajectory([0] * 60, True)
    assert not any(zero)
    alternating, _, _ = trajectory([0.01, -0.01] * 30, True)
    assert alternating[-1] == 0
    assert quant(9, 4) == 1 and quant(-9, 4) == -1
    assert quant(0.5 / 7, 4) == 0  # ties to even
    # 演示真实nibble编码；残差以FP32存储，必须计算这4字节开销。
    code = int(round(ef[-1] * 7)) & 15
    packed = bytes([code])
    storage = packed + struct.pack('<f', residual)
    decoded = packed[0] & 15
    decoded = decoded - 16 if decoded >= 8 else decoded
    assert abs(decoded / 7 - ef[-1]) < 1e-12
    report = {"steps": 60, "reference_final": reference[-1], "naive_final": naive[-1],
              "feedback_final": ef[-1], "feedback_residual": residual, "naive_writes": nw,
              "feedback_writes": ew, "naive_rmse": math.sqrt(sum((a-b)**2 for a,b in zip(naive,reference))/60),
              "feedback_rmse": math.sqrt(sum((a-b)**2 for a,b in zip(ef,reference))/60),
              "one_state_actual_payload_bytes": len(storage),
              "logical_bits_per_state_plus_residual": 36,
              "training_updates": 0, "scope": "scalar recurrence, no GRU/task/hardware performance"}
    print(json.dumps(report, indent=2))

if __name__ == '__main__':
    main()
