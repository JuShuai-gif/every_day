"""在已有RKNN-Toolkit2的Linux环境转换；错误即停，不安装依赖。"""
from pathlib import Path
from importlib.metadata import version
from rknn.api import RKNN
root = Path(__file__).resolve().parent / 'build'
print('rknn-toolkit2', version('rknn-toolkit2'))
rknn = RKNN(verbose=True)
def check(code, name):
    if code != 0: raise RuntimeError('%s: %s' % (name, code))
try:
    check(rknn.config(target_platform='rk3588', mean_values=[[0, 0, 0]], std_values=[[1, 1, 1]]), 'config')
    check(rknn.load_onnx(model=str(root / 'tiny.onnx')), 'load_onnx')
    check(rknn.build(do_quantization=True, dataset=str(root / 'dataset.txt')), 'build')
    check(rknn.export_rknn(str(root / 'tiny.rknn')), 'export_rknn')
finally:
    rknn.release()
