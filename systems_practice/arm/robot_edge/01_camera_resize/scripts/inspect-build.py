#!/usr/bin/env python3
"""Reproduce each translation unit as assembly using its saved CMake flags."""
import argparse
import hashlib
import json
from pathlib import Path
import shlex
import subprocess


def assembly_command(entry, output, compiler_kind):
    original = entry.get("arguments") or shlex.split(entry["command"])
    command = []
    index = 0
    while index < len(original):
        token = original[index]
        if token in ("-o", "-MF", "-MT", "-MQ"):
            index += 2
            continue
        if token in ("-c", "-MD", "-MMD", "-MP"):
            index += 1
            continue
        command.append(token)
        index += 1
    command += ["-S", "-o", str(output)]
    if compiler_kind == "clang":
        command += ["-Rpass=loop-vectorize", "-Rpass-missed=loop-vectorize"]
    elif compiler_kind == "gcc":
        command += ["-fopt-info-vec-optimized", "-fopt-info-vec-missed"]
    else:
        raise ValueError("Only Clang and GCC code-generation reports are supported")
    return command


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("build_dir", type=Path)
    parser.add_argument("output_dir", type=Path)
    args = parser.parse_args()
    entries = json.loads((args.build_dir / "compile_commands.json").read_text())
    if args.output_dir.exists() and any(args.output_dir.iterdir()):
        parser.error("output_dir must be absent or empty; preserve previous experiments")
    args.output_dir.mkdir(parents=True, exist_ok=True)
    output = args.output_dir.resolve()
    report = {"scope": "compiler_output_not_board_execution", "translation_units": []}
    for index, entry in enumerate(entries):
        original = entry.get("arguments") or shlex.split(entry["command"])
        version = subprocess.run(
            [original[0], "--version"], check=True, capture_output=True, text=True, timeout=20
        ).stdout
        kind = "clang" if "clang" in version.lower() else "gcc"
        assembly = output / (str(index) + "-" + Path(entry["file"]).stem + ".s")
        command = assembly_command(entry, assembly, kind)
        completed = subprocess.run(
            command, cwd=entry["directory"], capture_output=True, text=True, timeout=120
        )
        log = assembly.with_suffix(".remarks.txt")
        log.write_text(
            "$ " + shlex.join(command) + "\n" + version + completed.stdout + completed.stderr
            + "\nexit_status=" + str(completed.returncode) + "\n"
        )
        unit = {
            "source": entry["file"],
            "command": command,
            "compiler_version": version,
            "remarks": log.name,
            "exit_status": completed.returncode,
        }
        if completed.returncode == 0:
            unit.update({
                "assembly": assembly.name,
                "assembly_sha256": hashlib.sha256(assembly.read_bytes()).hexdigest(),
            })
        report["translation_units"].append(unit)
    failed = any(unit["exit_status"] != 0 for unit in report["translation_units"])
    report["status"] = "FAIL" if failed else "ASSEMBLY_GENERATED_NOT_BOARD_VERIFIED"
    (output / "index.json").write_text(json.dumps(report, indent=2) + "\n")
    print("codegen_record=" + str(output))
    raise SystemExit(1 if failed else 0)


if __name__ == "__main__":
    main()
