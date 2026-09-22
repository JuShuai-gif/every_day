"""只读查询编译目标；不把宏解析结果当成部署机器能力检测。"""

import json
import platform
import subprocess
import sys


def query(args):
    # 使用参数列表，保留命令、退出码与错误；没有编译器时明确失败。
    try:
        result = subprocess.run(args, capture_output=True, text=True, check=False)
        return {"command": args, "exit_code": result.returncode,
                "stdout": result.stdout, "stderr": result.stderr}
    except OSError as error:
        return {"command": args, "exit_code": 127,
                "stdout": "", "stderr": str(error)}


def main():
    version = query(["clang++", "--version"])
    target = query(["clang++", "-dumpmachine"])
    macros = query(["clang++", "-dM", "-E", "-x", "c++", "/dev/null"])
    names = ["__aarch64__", "__ARM_NEON", "__ARM_FEATURE_DOTPROD",
             "__ARM_FEATURE_FP16_VECTOR_ARITHMETIC",
             "__ARM_FEATURE_MATMUL_INT8", "__ARM_FEATURE_SVE",
             "__ARM_FEATURE_SVE2", "__ARM_NEON_SVE_BRIDGE"]
    definitions = {}
    for line in macros["stdout"].splitlines():
        parts = line.split(maxsplit=2)
        if len(parts) == 3 and parts[0] == "#define":
            definitions[parts[1]] = parts[2]

    # null 表示当前编译目标未定义；查询失败时不能解读为不支持。
    selected = ({name: definitions.get(name) for name in names}
                if macros["exit_code"] == 0 else None)
    report = {
        "process_environment": {"os": platform.system(),
                                "release": platform.release(),
                                "machine": platform.machine()},
        "compiler_version": version,
        "compiler_target": target,
        "macro_query": macros,
        "selected_compiler_macros": selected,
        "scope": "compiler defaults only; no target-board runtime feature detection",
        "arm_compute_kernel_executed": False,
        "performance_measured": False,
    }
    print(json.dumps(report, ensure_ascii=False, indent=2))
    return 0 if all(r["exit_code"] == 0 for r in (version, target, macros)) else 2


if __name__ == "__main__":
    sys.exit(main())
