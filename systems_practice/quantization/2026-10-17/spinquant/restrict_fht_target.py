"""仅在忽略缓存的副本中固定扩展目标，不下载/安装/构建。"""
from pathlib import Path
import sys
root=Path(sys.argv[1]).resolve()
allowed=Path(__file__).resolve().parents[3]/'.tmp'
if allowed not in root.parents:
    raise SystemExit('FHT source must be under systems_practice/.tmp')
f=root/'setup.py'
s=f.read_text()
start=s.index('    cc_flag = []')
end=s.index('    # HACK:',start)
replacement='    if CUDA_HOME is None:\n        raise RuntimeError("CUDA13+ required for Thor sm_110")\n    _, bare_metal_version = get_cuda_bare_metal_version(CUDA_HOME)\n    if bare_metal_version < Version("13.0"):\n        raise RuntimeError("CUDA13+ required for Thor sm_110")\n    cc_flag = ["-gencode", "arch=compute_110,code=sm_110"]\n\n'
backup=root/'setup.py.before-sm110'
if backup.exists():
    raise SystemExit('Backup exists; inspect previous patch before retry')
backup.write_text(s)
f.write_text(s[:start]+replacement+s[end:])
print('Patched only cc_flag; build and runtime remain unverified')
