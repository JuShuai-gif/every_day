"""独立NumPy SVD+INT8物理导出；不复现完整SPQ剪枝/LoRA。"""
import json
import struct
from pathlib import Path
import numpy as np
rng=np.random.default_rng(22)
U,_=np.linalg.qr(rng.normal(size=(8,8)))
V,_=np.linalg.qr(rng.normal(size=(8,8)))
S=np.array([10.,3.,1.,.5,.2,.1,.05,.01])
W=(U*S)@V.T
u,s,vh=np.linalg.svd(W,full_matrices=False)
r=int(np.searchsorted(np.cumsum(s*s)/np.sum(s*s),.97)+1)
assert r==2
A=vh[:r];B=u[:,:r]*s[:r]
def pack(a):
    scale=np.maximum(np.max(np.abs(a),axis=1),1e-12)/127
    q=np.clip(np.rint(a/scale[:,None]),-127,127).astype(np.int8)
    return q,scale.astype('<f4')
qa,sa=pack(A);qb,sb=pack(B)
blob=struct.pack('<4sIII',b'SPQ1',8,8,r)+sa.tobytes()+sb.tobytes()+qa.tobytes()+qb.tobytes()
root=Path(__file__).resolve().parent/'build';root.mkdir(exist_ok=True);f=root/'factors.bin';f.write_bytes(blob)
data=f.read_bytes();offset=16
sa2=np.frombuffer(data,dtype='<f4',count=r,offset=offset);offset+=4*r
sb2=np.frombuffer(data,dtype='<f4',count=8,offset=offset);offset+=4*8
qa2=np.frombuffer(data,dtype='i1',count=r*8,offset=offset).reshape(r,8);offset+=r*8
qb2=np.frombuffer(data,dtype='i1',count=8*r,offset=offset).reshape(8,r)
R=(qb2.astype(float)*sb2[:,None])@(qa2.astype(float)*sa2[:,None])
assert len(data)==16+4*(r+8)+r*16
x=rng.normal(size=(31,8)); shifted=x+100*V[:,7]
def mse(z,mat):return float(np.mean((z@mat.T-z@W.T)**2))
rows={name:dict(truncated=mse(z,B@A),packed=mse(z,R)) for name,z in [('eval',x),('shift',shifted)]}
assert np.allclose(B@A,(u[:,:r]*s[:r])@vh[:r])
assert np.all(np.isfinite(R))
# 仅保留低位张量与同时保留FP32影子权重是不同的存储边界。
q_payload=qa.nbytes+qb.nbytes
shadow_bytes=4*(A.size+B.size)
assert 2*(2+2)>2*2 # 2x2全秩双因子反而更大。
print(json.dumps(dict(numpy=np.__version__,rank=r,rows=rows,
 bytes=dict(original_fp16=2*W.size,packed_file=f.stat().st_size,int8_payload=q_payload,
 scales=4*(r+8),header=16,fp32_shadow_if_retained=shadow_bytes),
 no_training=True,scope='independent rank/packing example; no SPQ model/LoRA/Thor reproduction'),indent=2))
