#!/usr/bin/env python3
"""拉取选定方法的浅仓库和少量真实源码；不安装、不运行第三方代码。"""
import argparse
import datetime
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import tempfile

BASE = Path(__file__).resolve().parent
PRACTICE = BASE.parent
MAX_SOURCE_BYTES = 2 * 1024 * 1024


def git(args, cwd=None, binary=False):
    env = os.environ.copy()
    # 不进入交互认证，不拉LFS模型，也不自动执行submodule或安装脚本。
    env.update(GIT_TERMINAL_PROMPT="0", GIT_LFS_SKIP_SMUDGE="1")
    result = subprocess.run(["git"] + args, cwd=cwd, env=env,
                            stdout=subprocess.PIPE, stderr=subprocess.PIPE, timeout=30)
    if result.returncode:
        raise RuntimeError(result.stderr.decode("utf-8", "replace")[-8000:].strip())
    return result.stdout if binary else result.stdout.decode("utf-8", "strict").strip()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("method", help="catalog.json中的方法id，例如awq/gptq/hqq")
    parser.add_argument("--record", required=True, help="新的source.json路径，必须位于systems_practice内")
    args = parser.parse_args()
    catalog = json.loads((BASE / "catalog.json").read_text())
    methods = {item["id"]: item for item in catalog["methods"]}
    if args.method not in methods:
        parser.error("unknown method: " + args.method)
    item = methods[args.method]
    if not re.fullmatch(r"https://github\.com/[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+\.git", item["repository"]):
        parser.error("only credential-free public GitHub repository URLs are accepted")
    for relative in item["paths"]:
        path = Path(relative)
        if path.is_absolute() or ".." in path.parts:
            parser.error("source path must stay inside the repository")
    record_path = Path(args.record).resolve()
    if PRACTICE not in record_path.parents:
        parser.error("record must be inside systems_practice")
    record_path.parent.mkdir(parents=True, exist_ok=True)
    # x模式避免覆盖历史运行，即使前次失败也保留原始记录。
    try:
        output = record_path.open("x", encoding="utf-8")
    except FileExistsError:
        parser.error("record already exists; choose a new session/record filename")
    cache = PRACTICE / ".tmp" / "quant_sources"
    cache.mkdir(parents=True, exist_ok=True)
    work = Path(tempfile.mkdtemp(prefix=item["id"] + "-", dir=str(cache)))
    repo = work / "repo"
    snapshot = work / "source"
    state = {
        "method": item["id"], "repository": item["repository"],
        "requested_ref": "default branch HEAD (resolved commit recorded after clone)",
        "retrieved_at_utc": datetime.datetime.now(datetime.timezone.utc).isoformat(),
        "commit": None, "cache": str(work.relative_to(PRACTICE)),
        "status": "failed", "source_read": False, "example_run": False,
        "files": [], "errors": [],
        "note": "Downloaded bytes do not establish that an agent read the implementation or ran an example."
    }
    try:
        # 只拉浅层元数据；按文件lazy-fetch blob，避免全量仓库/模型下载。
        git(["clone", "--depth=1", "--filter=blob:none", "--single-branch",
             "--no-checkout", item["repository"], str(repo)])
        state["commit"] = git(["rev-parse", "HEAD"], cwd=repo)
        commit = state["commit"]
        for relative in item["paths"]:
            try:
                spec = commit + ":" + relative
                size = int(git(["cat-file", "-s", spec], cwd=repo))
                if size > MAX_SOURCE_BYTES:
                    raise RuntimeError("source file exceeds 2 MiB budget")
                content = git(["show", spec], cwd=repo, binary=True)
                content.decode("utf-8", "strict")
                target = snapshot / relative
                target.parent.mkdir(parents=True, exist_ok=True)
                target.write_bytes(content)
                state["files"].append({
                    "path": relative, "bytes": len(content),
                    "sha256": hashlib.sha256(content).hexdigest(),
                    "local_source": str(target.relative_to(PRACTICE)),
                    "permalink": item["repository"][:-4] + "/blob/" + commit + "/" + relative
                })
            except (RuntimeError, ValueError, UnicodeError, subprocess.TimeoutExpired) as error:
                state["errors"].append({"path": relative, "reason": str(error)})
        code = [f for f in state["files"] if Path(f["path"]).suffix in
                (".py", ".cpp", ".cc", ".cu", ".hpp", ".h", ".cuh")]
        if code:
            state["status"] = "partial" if state["errors"] else "fetched"
        else:
            state["errors"].append({"reason": "No implementation source obtained; README alone is insufficient."})
    except (RuntimeError, OSError, subprocess.TimeoutExpired) as error:
        state["errors"].append({"reason": str(error)})
    finally:
        with output:
            json.dump(state, output, ensure_ascii=False, indent=2)
            output.write("\n")
    print(json.dumps({"status": state["status"], "method": item["id"],
                      "commit": state["commit"], "record": str(record_path),
                      "source_files": len(state["files"])}, ensure_ascii=False))
    return 0 if state["status"] == "fetched" else 2


if __name__ == "__main__":
    sys.exit(main())
