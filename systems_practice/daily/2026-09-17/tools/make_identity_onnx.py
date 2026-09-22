#!/usr/bin/env python3
"""生成最小 UINT8 NHWC Identity ONNX；需要目标转换机已安装 onnx，不下载模型。"""
import onnx
from onnx import TensorProto, helper

# 小双相机图像裁块 [N,H,W,C]，仅用于验证转换与输入缓冲区契约。
x = helper.make_tensor_value_info("images", TensorProto.UINT8, [1, 4, 6, 3])
y = helper.make_tensor_value_info("images_out", TensorProto.UINT8, [1, 4, 6, 3])
node = helper.make_node("Identity", ["images"], ["images_out"])
model = helper.make_model(helper.make_graph([node], "stride_contract", [x], [y]), opset_imports=[helper.make_opsetid("", 13)])
onnx.checker.check_model(model)
onnx.save(model, "stride_contract.onnx")
