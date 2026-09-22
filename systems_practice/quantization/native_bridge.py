"""上游训练 API 与 C++ 后端之间的文本张量传输。"""
import json
import os
from pathlib import Path
import subprocess


def evaluate_cpp(directory, original, quantized, rtn, scales, zeros, evaluation,
                 shifted, group_size, offset_convention=False):
    directory = Path(directory)
    directory.mkdir(parents=True, exist_ok=True)
    executable = Path(os.environ['QUANT_CPP'])
    n, k = original.shape
    m = evaluation.shape[0]
    # float32 文本只是交换格式；部署二进制全部由 C++ 写出、重载和校验。
    path = directory / 'cpp-input.txt'
    with path.open('w') as stream:
        stream.write(f'QINPUT1 {n} {k} {group_size} {m} {int(offset_convention)}\n')
        for tensor in (original, quantized, rtn, scales, zeros, evaluation, shifted):
            stream.write(' '.join(format(value, '.17g') for value in
                                  tensor.detach().float().cpu().reshape(-1).tolist()) + '\n')
    completed = subprocess.run([str(executable), str(path), str(directory / 'linear.q4')],
                               check=False, text=True, capture_output=True)
    if completed.returncode:
        raise RuntimeError("C++ backend failed: " + completed.stderr.strip())
    result = json.loads(completed.stdout)
    (directory / 'cpp-result.json').write_text(completed.stdout)
    return result
