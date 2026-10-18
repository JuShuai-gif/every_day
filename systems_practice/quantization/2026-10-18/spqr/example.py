"""原生SPQRUtil PTQ；自定义u4+FP32 scale/zero+稀疏替换导出，不是上游CUDA格式。"""
import argparse
import json
import math
from pathlib import Path
import statistics
import struct
import sys
import time


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--source', required=True)
    parser.add_argument('--output', default='build')
    args = parser.parse_args()
    sys.path.insert(0, str(Path(args.source).resolve()))
    import torch
    from spqr_engine import SPQRUtil
    torch.set_num_threads(1)
    torch.manual_seed(18)
    out = Path(args.output)
    out.mkdir(parents=True, exist_ok=True)
    n, k, group = 16, 64, 16
    weight = torch.randn(n, k) * 0.1
    weight[0, 3] = 3.0
    def samples(count, seed, shift=False):
        g = torch.Generator().manual_seed(seed)
        x = torch.randn(count, k, generator=g)
        x[:, 3] *= 12 if shift else 3
        return x
    calibration, tuning, evaluation, shifted = samples(64, 101), samples(32, 102), samples(31, 103), samples(31, 104, True)

    def metric(w, x):
        expected, actual = x @ weight.T, x @ w.T
        delta = actual - expected
        return {'nrmse': (delta.norm() / expected.norm().clamp_min(1e-12)).item(),
                'max_abs': delta.abs().max().item(),
                'cosine': torch.nn.functional.cosine_similarity(expected.flatten(), actual.flatten(), dim=0).item()}

    def export(result, path):
        saved = result.save_quant_dict
        codes = saved['quant_weights'].cpu().to(torch.int64).flatten().tolist()
        assert min(codes) >= 0 and max(codes) <= 15
        packed = bytes(codes[i] | (codes[i + 1] << 4) for i in range(0, len(codes), 2))
        scales = torch.cat(saved['quant_layer_scale'], dim=1).cpu().float()
        zeros = torch.cat(saved['quant_layer_zeros'], dim=1).cpu().float()
        mask = result.unstructured_outlier_mask.cpu().flatten()
        indices = mask.nonzero().flatten().tolist()
        sparse_values = saved['outliers_matrix'].to_dense().cpu().flatten()
        # 稀疏值是覆盖值，不是加性残差；非整数zero可能使dense的“零码”非零。
        payload = struct.pack('<4sIIII', b'SPQ4', n, k, group, len(indices)) + packed
        for tensor in [scales, zeros]:
            values = tensor.flatten().tolist()
            payload += struct.pack('<' + 'f' * len(values), *values)
        for i in indices:
            payload += struct.pack('<If', i, sparse_values[i].item())
        path.write_bytes(payload)
        return len(payload), len(indices), sum(c in (0, 15) for c in codes) / len(codes)

    def reload(path):
        raw = path.read_bytes()
        magic, rows, cols, gs, count = struct.unpack_from('<4sIIII', raw)
        assert (magic, rows, cols, gs) == (b'SPQ4', n, k, group)
        offset = 20
        packed = raw[offset:offset + n*k//2]; offset += len(packed)
        codes = torch.tensor([q for byte in packed for q in (byte & 15, byte >> 4)], dtype=torch.float32).reshape(n, k)
        meta = n * (k // group)
        scale = torch.tensor(struct.unpack_from('<' + 'f'*meta, raw, offset)).reshape(n, -1); offset += meta * 4
        zero = torch.tensor(struct.unpack_from('<' + 'f'*meta, raw, offset)).reshape(n, -1); offset += meta * 4
        dense = scale.repeat_interleave(group, dim=1) * (codes - zero.repeat_interleave(group, dim=1))
        for _ in range(count):
            idx, value = struct.unpack_from('<If', raw, offset); offset += 8
            assert idx < n*k
            dense.flatten()[idx] = value
        assert offset == len(raw)
        return dense

    results, candidates = [], []
    # 每个候选重建H；校准只拟合二阶统计，调参只看独立tuning。
    for label, threshold in [('no_outliers', float('inf')), ('spqr_02', 0.2), ('spqr_005', 0.05)]:
        layer = torch.nn.Linear(k, n, bias=False)
        with torch.no_grad():
            layer.weight.copy_(weight)
        util = SPQRUtil(layer)
        util.add_batch(calibration)
        start = time.perf_counter()
        result = util.quantize(bits=4, groupsize=group, blocksize=32, percdamp=0.01,
                               permutation_order='identity', outlier_relative_threshold=threshold,
                               simplified_outliers=False, perchannel=True, sym=False,
                               save_quantization=True, verbose=False,
                               qq_scale_bits=None, qq_zero_bits=None)
        quant_ms = 1e3 * (time.perf_counter() - start)
        path = out / (label + '.bin')
        byte_count, count, occupancy = export(result, path)
        decoded = reload(path)
        assert torch.allclose(decoded, result.weight, atol=2e-6, rtol=2e-6)
        record = {'method': label, 'file_bytes': byte_count, 'outliers': count, 'endpoint_code_fraction': occupancy,
                  'quantization_cpu_ms': quant_ms, 'tuning': metric(decoded, tuning)}
        candidates.append((record['tuning']['nrmse'], label, decoded, record))
    # 固定2KiB预算，仅用tuning选型；没有满足预算的候选时明确失败。
    eligible = [x for x in candidates if x[3]['file_bytes'] <= 2048]
    if not eligible:
        raise RuntimeError('No candidate satisfies 2048-byte budget')
    chosen = min(eligible, key=lambda x: x[0])[1]
    for _, label, decoded, record in candidates:
        record.update(evaluation=metric(decoded, evaluation), shifted=metric(decoded, shifted), chosen=label == chosen)
        results.append(record)
    absmax_scale = weight.abs().amax(dim=1, keepdim=True).clamp_min(1e-9) / 7
    absmax = (weight / absmax_scale).round().clamp(-7, 7) * absmax_scale
    half = weight.half().float()
    for label, w in [('fp32', weight), ('fp16_storage_fp32_compute', half), ('signed_absmax_int4', absmax)]:
        results.append({'method': label, 'evaluation': metric(w, evaluation), 'shifted': metric(w, shifted)})
    (out/'fp16.bin').write_bytes(struct.pack('<'+'e'*(n*k), *weight.flatten().tolist()))
    (out/'fp32.bin').write_bytes(struct.pack('<'+'f'*(n*k), *weight.flatten().tolist()))
    best = next(c[2] for c in candidates if c[1] == chosen)
    timings = {}
    for name, fn in [('fp32_matmul', lambda: evaluation @ weight.T),
                     ('decoded_fp32_matmul', lambda: evaluation @ best.T),
                     ('file_read_decode_matmul', lambda: evaluation @ reload(out/(chosen+'.bin')).T)]:
        for _ in range(5): fn()
        times = []
        for _ in range(21):
            start = time.perf_counter()
            for _ in range(10): fn()
            times.append((time.perf_counter()-start)*1e6/10)
        timings[name+'_batch_mean_p50_us'] = statistics.median(times)
    report = {'torch_version': torch.__version__, 'source_commit': '543d10e56f921e5eeb10d5f0aaaccd30b6662d0e',
              'shape_W': [n,k], 'shape_X_eval': [31,k], 'training': 'none; PTQ',
              'fp16_file_bytes': (out/'fp16.bin').stat().st_size, 'fp32_file_bytes': (out/'fp32.bin').stat().st_size,
              'results': results, 'timings': timings, 'scope': 'CPU FP32 matmul after decode, not native lowbit kernel'}
    print(json.dumps(report, indent=2, allow_nan=False))
    (out/'metrics.json').write_text(json.dumps(report, indent=2, allow_nan=False)+'\n')

if __name__ == '__main__':
    main()
