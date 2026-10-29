import argparse,pathlib,sys
p=argparse.ArgumentParser();p.add_argument('--onnx-only',action='store_true');p.add_argument('--output',default='build/tiny.rknn');a=p.parse_args();pathlib.Path('build').mkdir(exist_ok=True)
try:
 import onnx
 from onnx import helper,TensorProto
 x=helper.make_tensor_value_info('input',TensorProto.FLOAT,[1,3,4,4]); y=helper.make_tensor_value_info('output',TensorProto.FLOAT,[1,3,4,4]); m=helper.make_model(helper.make_graph([helper.make_node('Relu',['input'],['output'])],'tiny',[x],[y]),opset_imports=[helper.make_operatorsetid('',13)]); onnx.save(m,'build/tiny.onnx'); print('ONNX_WRITTEN build/tiny.onnx')
except Exception as e: print('ONNX_UNAVAILABLE',type(e).__name__,e); sys.exit(2)
if not a.onnx_only:
 try:
  from rknn.api import RKNN
  r=RKNN(verbose=True); assert r.config(target_platform=['rk3588'])==0; assert r.load_onnx(model='build/tiny.onnx')==0; assert r.build(do_quantization=False)==0; assert r.export_rknn(a.output)==0; r.release(); print('RKNN_WRITTEN',a.output)
 except Exception as e: print('RKNN_UNVERIFIED',type(e).__name__,e); sys.exit(3)
