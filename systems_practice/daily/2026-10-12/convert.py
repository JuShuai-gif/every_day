#!/usr/bin/env python3
"""Linux RKNN-Toolkit2: 生成小ONNX并转换，无权重下载；不安装依赖。"""
import argparse
import importlib.metadata
from pathlib import Path
import numpy as np
import onnx
from onnx import helper, TensorProto, numpy_helper


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--onnx-only', action='store_true')
    args = parser.parse_args()
    root = Path(__file__).resolve().parent / 'build'
    root.mkdir(exist_ok=True)
    weights = np.array([[.25, -.5, .75], [-.25, .5, .25]], dtype=np.float32).reshape(2, 3, 1, 1)
    bias = np.array([.125, -.125], dtype=np.float32)
    graph = helper.make_graph([helper.make_node('Conv', ['input', 'W', 'B'], ['output'], kernel_shape=[1, 1])],
        'stride_contract', [helper.make_tensor_value_info('input', TensorProto.FLOAT, [1, 3, 3, 5])],
        [helper.make_tensor_value_info('output', TensorProto.FLOAT, [1, 2, 3, 5])],
        [numpy_helper.from_array(weights, 'W'), numpy_helper.from_array(bias, 'B')])
    model = helper.make_model(graph, opset_imports=[helper.make_opsetid('', 13)], ir_version=8)
    onnx.checker.check_model(model)
    onnx.save(model, root / 'tiny.onnx')
    y, x, c = np.indices((3, 5, 3))
    raw = ((y * 17 + x * 11 + c * 53) % 256).astype(np.float32)
    normalized = (raw - 127.5) / 127.5
    # ONNX参考使用NCHW；板端提交使用NHWC，由Runtime转换。
    input_nchw = normalized.transpose(2, 0, 1)[None].copy()
    expected = np.einsum('oc,nchw->nohw', weights[:, :, 0, 0], input_nchw) + bias[None, :, None, None]
    np.save(root / 'input_nchw.npy', input_nchw)
    np.save(root / 'expected_nchw.npy', expected)
    from onnx.reference import ReferenceEvaluator
    actual = ReferenceEvaluator(model).run(None, {'input': input_nchw})[0]
    np.testing.assert_allclose(actual, expected, atol=1e-6, rtol=1e-6)
    print('ONNX reference PASS shape', actual.shape, 'onnx', onnx.__version__, 'numpy', np.__version__)
    if args.onnx_only:
        return
    from rknn.api import RKNN
    print('rknn-toolkit2', importlib.metadata.version('rknn-toolkit2'))
    rknn = RKNN(verbose=True)
    def check(rc, stage):
        if rc != 0:
            raise RuntimeError('%s rc=%s' % (stage, rc))
    try:
        # 唯一预处理位置为C++/数据生成；转换器不再减均值除方差。
        check(rknn.config(mean_values=[[0, 0, 0]], std_values=[[1, 1, 1]], target_platform='rk3588'), 'config')
        check(rknn.load_onnx(model=str(root / 'tiny.onnx')), 'load_onnx')
        check(rknn.build(do_quantization=False), 'build')
        check(rknn.export_rknn(str(root / 'tiny.rknn')), 'export')
    finally:
        rknn.release()  # Python API释放无返回码；C++清理返回码单独检查。
    print('conversion PASS; board run still required')

if __name__ == '__main__':
    main()
