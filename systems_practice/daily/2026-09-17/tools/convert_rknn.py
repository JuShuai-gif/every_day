#!/usr/bin/env python3
"""在受支持 Linux x86_64 转换机运行；不在 Mac 上伪造 .rknn 产物。"""
from rknn.api import RKNN

rknn = RKNN(verbose=True)
assert rknn.load_onnx(model="stride_contract.onnx") == 0
# Identity 图不用 INT8 校准；真实视觉模型必须替换为代表性校准集并单独验精度。
assert rknn.build(do_quantization=False) == 0
assert rknn.export_rknn("stride_contract.rknn") == 0
rknn.release()
