"""生成小Conv和32个合成校准样本；不下载权重。"""
from pathlib import Path
import numpy as np
import onnx
from onnx import helper, numpy_helper, TensorProto

root = Path(__file__).resolve().parent / 'build'
root.mkdir(exist_ok=True)
w = np.array([[.5, -.25, .125], [-.125, .5, .25]], dtype=np.float32).reshape(2, 3, 1, 1)
b = np.array([.1, -.2], dtype=np.float32)
graph = helper.make_graph([helper.make_node('Conv', ['x', 'w', 'b'], ['y'], kernel_shape=[1, 1])],
    'tiny_head', [helper.make_tensor_value_info('x', TensorProto.FLOAT, [1, 3, 4, 5])],
    [helper.make_tensor_value_info('y', TensorProto.FLOAT, [1, 2, 4, 5])],
    [numpy_helper.from_array(w, 'w'), numpy_helper.from_array(b, 'b')])
model = helper.make_model(graph, opset_imports=[helper.make_opsetid('', 13)])
model.ir_version = 8
onnx.checker.check_model(model)
onnx.save(model, root / 'tiny.onnx')
rng = np.random.default_rng(20260929)
paths = []
for i in range(32):
    # Toolkit2默认四维校准npy按NHWC；Runtime端输入另声明NCHW。
    x = rng.uniform(0, 1, (1, 4, 5, 3)).astype(np.float32)
    if i == 0: x.fill(0)
    if i == 1: x.fill(1)
    path = root / ('calib_%02d.npy' % i)
    np.save(path, x)
    paths.append(str(path))
(root / 'dataset.txt').write_text('\n'.join(paths) + '\n')
print('ONNX checked; 32 NHWC calibration samples; evaluation uses separate deterministic frames')
