#!/usr/bin/env python3
"""独立 NumPy 数值实验：真实打包、四种 GEMM、分离数据集、手写 STE 更新。非上游复现。"""
import argparse
import json
import struct
import time
from pathlib import Path
import numpy as np

GROUP = 16

def metric(y, ref):
    d = y.astype(np.float64) - ref
    return dict(nrmse=float(np.linalg.norm(d) / max(np.linalg.norm(ref), 1e-12)),
                max_abs=float(abs(d).max(initial=0)),
                cosine=float(np.vdot(y, ref) / max(np.linalg.norm(y) * np.linalg.norm(ref), 1e-12)))

def quant(x, bits, clip=1.0, fixed=None):
    if x.ndim != 2 or x.shape[1] == 0 or bits not in (4, 8):
        raise ValueError('requires nonempty rows and bits4/8')
    rows, k = x.shape
    z = np.pad(x, ((0, 0), (0, (-k) % GROUP))).reshape(rows, -1, GROUP)
    limit = (1 << (bits - 1)) - 1
    scale = np.maximum(abs(z).max(axis=-1) * clip / limit, 1e-8) if fixed is None else fixed
    raw = z / scale[..., None]
    q = np.clip(np.rint(raw), -limit, limit).astype(np.int8)
    deq = (q * scale[..., None]).reshape(rows, -1)[:, :k].astype(np.float32)
    valid = np.broadcast_to(np.arange(z.shape[1]*GROUP).reshape(1,-1) < k, (rows,z.shape[1]*GROUP)).reshape(z.shape)
    sat = float(((abs(raw) > limit) & valid).sum() / (rows*k))
    return q.reshape(rows, -1)[:, :k].copy(), scale.astype(np.float32), deq, sat

def pack(q, bits):
    flat = q.ravel()
    if bits == 8:
        return flat.tobytes()
    u = (flat.astype(np.int16) & 15).astype(np.uint8)
    if u.size % 2:
        u = np.append(u, np.uint8(0))
    return (u[::2] | (u[1::2] << 4)).tobytes()

def unpack(blob, shape, bits):
    u = np.frombuffer(blob, dtype=np.uint8)
    if bits == 4:
        v = np.stack((u & 15, u >> 4), axis=1).ravel().astype(np.int16)
        v[v >= 8] -= 16
    else:
        v = u.view(np.int8)
    return v[:np.prod(shape)].reshape(shape)

def grouped_gemm(aq, wq, sa, sw, ab):
    m, k = aq.shape
    n = len(wq)
    out = np.zeros((m, n), np.float32)
    for g, start in enumerate(range(0, k, GROUP)):
        end = min(k, start + GROUP)
        if ab == 16:
            # FP16存储，FP32积累；这里的NumPy乘法是CPU参考，不是GPU吞吐。
            dot = aq[:, start:end].astype(np.float32) @ wq[:, start:end].astype(np.float32).T
            out += dot * sw[:, g][None, :]
        else:
            dot = aq[:, start:end].astype(np.int32) @ wq[:, start:end].astype(np.int32).T
            out += dot.astype(np.float32) * sa[:, g][:, None] * sw[:, g][None, :]
    return out

def evaluate(x, w, s, wb, ab, clip=1.0, outliers=(), fixed=None):
    a = x / s
    ww = (w * s).copy()
    # 将离群通道从主体真正置零，另算高精度残差，避免重复贡献。
    residual = np.zeros((len(x), len(w)), np.float32)
    if len(outliers):
        residual = x[:,outliers].astype(np.float16).astype(np.float32) @ w[:,outliers].astype(np.float16).astype(np.float32).T
        a = a.copy(); a[:,outliers] = 0; ww[:,outliers] = 0
    wq, sw, _, ws = quant(ww, wb, clip, fixed=fixed)
    if ab == 16:
        aq = a.astype(np.float16); sa = np.empty((0,), np.float32); ass = 0.0
        abl = aq.astype('<f2').tobytes()
    else:
        aq, sa, _, ass = quant(a, ab, clip); abl = pack(aq, ab)
    wbl = pack(wq, wb)
    assert np.array_equal(unpack(wbl,wq.shape,wb),wq)
    out = grouped_gemm(aq, wq, sa, sw, ab) + residual
    sizes = dict(weights=len(wbl), weight_scales=sw.nbytes, activations=len(abl),
                 activation_scales=sa.nbytes, smooth_scales=s.nbytes,
                 outlier_weights=2*len(w)*len(outliers), outlier_activations=2*len(x)*len(outliers), outlier_indices=4*len(outliers))
    return out, sizes, (abl,wbl,sa,sw), dict(weight=ws, activation=ass)

def train_qat(train, tune, w, s, wb, ab, clip):
    # 固定校准scale；round的STE=1，clip区间外导数=0。更新真实浮点master权重。
    master = (w*s).copy(); initial = master.copy()
    _, fixed, _, _ = quant(master, wb, clip)
    a = train/s
    a = a.astype(np.float16).astype(np.float32) if ab == 16 else quant(a, ab, clip)[2]
    target = train @ w.T
    best = master.copy(); best_loss = float('inf'); logs=[]
    for step in range(81):
        _, _, qdw, _ = quant(master, wb, fixed=fixed)
        err = a @ qdw.T-target
        loss = float(np.mean(err*err))
        # 梯度只用train，checkpoint选择只用tune，最终eval完全不可见。
        check = evaluate(tune, master/s, s, wb, ab, clip, fixed=fixed)[0]
        tloss = float(np.mean((check-tune@w.T)**2))
        if tloss < best_loss:
            best_loss=tloss;best=master.copy()
        if step % 10 == 0:
            logs.append(dict(step=step,train_mse=loss,tune_mse=tloss,update_l2=float(np.linalg.norm(master-initial))))
        if step == 80:
            break
        grad = (2.0/err.size)*(err.T@a)
        bounds=np.repeat(fixed, GROUP, axis=1)[:,:w.shape[1]]*((1 << (wb-1))-1)
        master -= 0.03 * grad * (abs(master) <= bounds)
    assert np.linalg.norm(master-initial)>0
    return best/s, logs, fixed

def fixture(path, x, w, wb, ab):
    s=np.ones(x.shape[1],np.float32)
    y,_,(aa,ww,sa,sw),_=evaluate(x,w,s,wb,ab)
    header=struct.pack('<8I',0x51474D31,len(x),len(w),x.shape[1],wb,ab,GROUP,sw.shape[1])
    path.write_bytes(header+aa+ww+sa.astype('<f4').tobytes()+sw.astype('<f4').tobytes()+y.astype('<f4').tobytes())

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,default=Path(__file__).parent/'build');args=ap.parse_args();args.output.mkdir(parents=True,exist_ok=True)
    rng=np.random.default_rng(20261014);k,n=33,17
    w=rng.normal(0,.18,(n,k)).astype(np.float32)
    sets=[]
    for count in [64,64,32,31]:
        x=rng.normal(0,.6,(count,k)).astype(np.float32);x[:,3]*=12;sets.append(x)
    train,cal,tune,test=sets
    shifted=test.copy();shifted[:,7]*=20
    act=abs(cal).max(axis=0);weight=np.maximum(abs(w).max(axis=0),1e-6)
    result={'numpy':np.__version__,'shape':[31,33,17],'split_rows':dict(train=64,calibration=64,tune=32,eval=31), 'fp32_weight_bytes':w.nbytes,'fp16_weight_bytes':w.astype(np.float16).nbytes,'rows':[],'training':[]}
    s=(np.maximum(act,1e-6)**.5/weight**.5).astype(np.float32)
    assert np.allclose((test/s)@(w*s).T,test@w.T,atol=1e-5,rtol=1e-5)
    result['fp16_reference']=metric(test.astype(np.float16).astype(np.float32)@w.astype(np.float16).astype(np.float32).T,test@w.T)
    result['cpu_reference_timing_ms_p50']={}
    for name,fn in [('fp32_numpy_gemm',lambda:test@w.T),('fp16_storage_decode_then_fp32_numpy_gemm',lambda:test.astype(np.float16).astype(np.float32)@w.astype(np.float16).astype(np.float32).T)]:
        for _ in range(3):fn()
        samples=[]
        for _ in range(11):
            start=time.perf_counter_ns();fn();samples.append((time.perf_counter_ns()-start)/1e6)
        result['cpu_reference_timing_ms_p50'][name]=float(np.median(samples))
    for wb,ab in [(4,4),(4,16),(8,8),(8,16)]:
        search_start=time.perf_counter_ns()
        candidates=[]
        for alpha in [0.0,.25,.5,.75,1.0]:
            ss=(np.maximum(act,1e-6)**alpha/weight**(1-alpha)).astype(np.float32)
            for clip in [.85,.95,1.0]:
                y=evaluate(tune,w,ss,wb,ab,clip)[0]
                candidates.append((float(np.mean((y-tune@w.T)**2)),alpha,clip,ss))
        _,alpha,clip,chosen=min(candidates,key=lambda q:q[0])
        search_ms=(time.perf_counter_ns()-search_start)/1e6
        qat_start=time.perf_counter_ns()
        qw,logs,fixed=train_qat(train,tune,w,chosen,wb,ab,clip)
        result['training'].append(dict(mode=f'W{wb}A{ab}',logs=logs,offline_search_ms=search_ms,offline_qat_ms=(time.perf_counter_ns()-qat_start)/1e6))
        configs=[('absmax',w,np.ones(k,np.float32),1.0,()),('smooth',w,s,1.0,()),('outlier',w,s,1.0,(int(np.argmax(act)),)),('calibrated',w,chosen,clip,()),('qat',qw,chosen,clip,())]
        for name,ww,ss,cc,oi in configs:
            fs = fixed if name == 'qat' else None
            y,size,encoded,sat=evaluate(test,ww,ss,wb,ab,cc,oi,fixed=fs)
            # 真正落盘并核对码字，文件包含scale/索引等所有部署元数据。
            aa,wp,sa,sw=encoded
            payload=wp+sw.astype('<f4').tobytes()+ss.astype('<f4').tobytes()+np.asarray(oi,dtype='<u4').tobytes()+ww[:,oi].astype('<f2').tobytes()
            path=args.output/f'{name}-w{wb}a{ab}.bin';path.write_bytes(payload)
            assert path.stat().st_size==size['weights']+size['weight_scales']+size['smooth_scales']+size['outlier_weights']+size['outlier_indices']
            # 从实际文件重载，而不只验证打包前内存数组。
            saved=path.read_bytes();offset=len(wp)
            rw=unpack(saved[:offset],ww.shape,wb)
            rsw=np.frombuffer(saved[offset:offset+sw.nbytes],dtype='<f4').reshape(sw.shape);offset+=sw.nbytes
            rss=np.frombuffer(saved[offset:offset+ss.nbytes],dtype='<f4');offset+=ss.nbytes
            assert np.array_equal(rss,ss)
            rid=np.frombuffer(saved[offset:offset+4*len(oi)],dtype='<u4');offset+=4*len(oi)
            residual_w=np.frombuffer(saved[offset:],dtype='<f2').reshape(len(ww),len(oi))
            ra=np.frombuffer(aa,dtype='<f2').reshape(test.shape) if ab==16 else unpack(aa,test.shape,ab)
            restored=grouped_gemm(ra,rw,sa,rsw,ab)
            if len(rid):restored+=test[:,rid].astype(np.float16).astype(np.float32)@residual_w.astype(np.float32).T
            assert np.allclose(restored,y,atol=1e-6,rtol=1e-6)
            for _ in range(3):evaluate(test,ww,ss,wb,ab,cc,oi,fixed=fs)
            times=[]
            for _ in range(11):
                start=time.perf_counter_ns();evaluate(test,ww,ss,wb,ab,cc,oi,fixed=fs);times.append((time.perf_counter_ns()-start)/1e6)
            result['rows'].append(dict(mode=f'W{wb}A{ab}',method=name,selected_alpha=alpha if name in ('calibrated','qat') else None,clip=cc,error=metric(y,test@w.T),shift_error=metric(evaluate(shifted,ww,ss,wb,ab,cc,oi,fixed=fs)[0],shifted@w.T),storage=size,weight_file_bytes=path.stat().st_size,saturation=sat,cpu_quant_pack_gemm_ms_p50=float(np.median(times))))
    count=0
    for m,k,n in [(1,1,1),(3,15,5),(7,16,17),(17,17,19),(31,33,17),(2,65,3)]:
        for wb,ab in [(4,4),(4,16),(8,8),(8,16)]:
            x=rng.normal(size=(m,k)).astype(np.float32);ww=rng.normal(size=(n,k)).astype(np.float32)
            fixture(args.output/f'case-{count}.bin',x,ww,wb,ab);count+=1
    for wb,ab in [(4,4),(4,16),(8,8),(8,16)]:
        fixture(args.output/f'case-{count}.bin',np.zeros((3,17),np.float32),np.zeros((5,17),np.float32),wb,ab);count+=1
    # 符号、奇数nibble、全范围、坏shape；非零padding不能被当成有效K。
    q=np.arange(-7,8,dtype=np.int8).reshape(1,-1);assert np.array_equal(q,unpack(pack(q,4),q.shape,4))
    try:quant(np.empty((2,0)),4)
    except ValueError:pass
    else:raise AssertionError('empty K not rejected')
    result['fixture_count']=count;result['boundaries']='signed odd nibble, zero, K15/16/17/33/65, invalid K passed'
    print(json.dumps(result,indent=2))

if __name__=='__main__':main()
