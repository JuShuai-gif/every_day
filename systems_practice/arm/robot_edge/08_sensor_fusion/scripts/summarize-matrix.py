#!/usr/bin/env python3
"""Validate and summarize comparable CPU-affinity experiments; no energy inference."""

import argparse
import csv
import json
import math
from pathlib import Path
import statistics


PROFILES = ("single_a55", "single_a76", "cluster_a55", "cluster_a76")
MODES = ("baseline", "stage1", "optimized")


def valid_perf(path, events):
    """perf may exit zero while reporting unsupported/un-counted events."""
    remaining = set(events.split(","))
    with Path(path).open(newline="") as stream:
        for row in csv.reader(stream):
            if not row or row[0].startswith("#") or len(row) < 3:
                continue
            event = row[2].strip()
            matched = {name for name in remaining
                       if event == name or event.endswith("/" + name + "/")}
            if matched:
                try:
                    finite(row[0].strip())
                except ValueError:
                    return False
                remaining -= matched
    return not remaining


def quantile(values, fraction):
    values = sorted(values)
    return values[max(0, math.ceil(len(values) * fraction) - 1)]


def finite(value, positive=False):
    number = float(value)
    if not math.isfinite(number) or (number <= 0 if positive else number < 0):
        raise ValueError("invalid numeric metric")
    return number


def validate_topology(initial, snapshot, profile, requested):
    expected = sorted(initial["profiles"][profile])
    if not expected or sorted(requested) != expected:
        raise ValueError("recorded CPU set differs from initial profile")
    if sorted(snapshot["affinity_cpus"]) != expected or sorted(snapshot["eligible_cpus"]) != expected:
        raise ValueError("actual CPU affinity/online set differs from requested profile")
    initial_cpus = {cpu["cpu"]: cpu for cpu in initial["cpus"]}
    actual_cpus = {cpu["cpu"]: cpu for cpu in snapshot["cpus"]}
    core = "Cortex-A55" if profile.endswith("a55") else "Cortex-A76"
    for cpu_id in expected:
        before, after = initial_cpus[cpu_id], actual_cpus[cpu_id]
        if (not after["online"] or not after["allowed"] or before["core"] != core or
                any(before.get(key) != after.get(key) for key in ("implementer", "part", "core"))):
            raise ValueError("CPU online state or verified core identity changed")


def read_run(directory, manifest, probe, profile):
    status = json.loads((directory / "status.json").read_text())
    if status.get("status") != "COMPLETE" or status.get("exit_code") != 0:
        raise ValueError("trial did not complete successfully")
    if (status.get("binary_sha256") != manifest["binary_sha256"] or
            status.get("binary_sha256_after") != manifest["binary_sha256"]):
        raise ValueError("binary hash differs from manifest")
    requested = [int(value) for value in status["cpus"].split(",")]
    for filename in ("environment-before.json", "environment-after.json"):
        snapshot = json.loads((directory / filename).read_text())
        validate_topology(probe, snapshot, profile, requested)
    if "correctness=PASS" not in (directory / "stdout.log").read_text().splitlines():
        raise ValueError("missing explicit correctness pass")
    budget = finite(manifest["budget_us"])
    groups = {}
    with (directory / "samples.csv").open(newline="") as stream:
        for row in csv.DictReader(stream):
            mode = row["variant"]
            if mode not in MODES or int(row["iterations"]) != 1:
                raise ValueError("invalid mode or iterations; matrix requires single invocation samples")
            duration = finite(row["us_per_invocation"], positive=True)
            batch = finite(row["batch_us"], positive=True)
            if not math.isclose(batch, duration, rel_tol=1e-8, abs_tol=1e-8):
                raise ValueError("batch duration disagrees with single invocation")
            if "budget_us" in row and finite(row["budget_us"]) != budget:
                raise ValueError("CSV deadline differs from manifest")
            missed = budget > 0 and duration > budget
            if "budget_exceeded" in row and int(row["budget_exceeded"]) != int(missed):
                raise ValueError("CSV deadline classification disagrees with measured duration")
            work = finite(row["work_units"], positive=True) if "work_units" in row else None
            digest = int(row["digest"])
            if digest < 0:
                raise ValueError("negative digest")
            groups.setdefault(mode, []).append({"sample": int(row["sample"]), "us": duration,
                                                "digest": digest, "work_units": work})
    if set(groups) != set(MODES):
        raise ValueError("trial is missing one or more measured stages")
    for rows in groups.values():
        if len(rows) < int(manifest["samples"]) or sorted(r["sample"] for r in rows) != list(range(len(rows))):
            raise ValueError("missing, duplicated, or insufficient samples")
        if len({(r["digest"], r["work_units"]) for r in rows}) != 1:
            raise ValueError("trial semantic output or work unit count is unstable")
    if len({len(rows) for rows in groups.values()}) != 1:
        raise ValueError("different sample counts across stages")
    return groups


def summarize(root):
    root = Path(root)
    manifest = json.loads((root / "manifest.json").read_text())
    probe = json.loads((root / "probe-before.json").read_text())
    repeats = int(manifest["repeats"])
    if repeats < 1 or int(manifest["samples"]) < 1:
        raise ValueError("invalid matrix experiment counts")
    budget = finite(manifest["budget_us"])
    result = {"schema_version": 1, "status": "COMPLETE", "manifest": manifest,
              "identity": probe.get("identity"), "profiles": {}, "invalid_trials": [],
              "unavailable_profiles": probe.get("unavailable_profiles", {}),
              "single_core_speed_ratios": {}, "acceptance_status": "not_evaluated",
              "notes": ["latencies are one complete workload invocation, not per-message deadlines",
                        "each repetition is retained; pooled percentiles do not replace round variation",
                        "no power meter data: no efficiency or energy claim",
                        "COMPLETE means benchmark trials completed; perf coverage is reported separately",
                        "measurement completion is not an industrial SLA pass"]}
    valid_runs = {}
    for profile in PROFILES:
        if profile not in probe.get("profiles", {}):
            result["status"] = "PARTIAL" if result["status"] != "FAILED" else "FAILED"
            continue
        collected = {mode: [] for mode in MODES}
        per_round = {mode: [] for mode in MODES}
        for repetition in range(1, repeats + 1):
            directory = root / "runs" / profile / f"repeat-{repetition}"
            if not (directory / "status.json").exists():
                if result["status"] != "FAILED":
                    result["status"] = "PARTIAL"
                result["invalid_trials"].append({"profile": profile, "repeat": repetition,
                                                 "reason": "missing trial status"})
                continue
            try:
                groups = read_run(directory, manifest, probe, profile)
                valid_runs[(profile, repetition)] = groups
            except (OSError, ValueError, KeyError, TypeError) as error:
                result["status"] = "FAILED"
                result["invalid_trials"].append({"profile": profile, "repeat": repetition,
                                                 "reason": str(error)})
                continue
            for mode, rows in groups.items():
                values = [row["us"] for row in rows]
                collected[mode].extend(rows)
                per_round[mode].append({"repeat": repetition, "samples": len(values),
                                        "p50_us": quantile(values, .5),
                                        "p95_us": quantile(values, .95),
                                        "p99_us": quantile(values, .99), "max_us": max(values)})
        stages = {}
        for mode, rows in collected.items():
            if not rows:
                continue
            values = [row["us"] for row in rows]
            stable = len({(r["digest"], r["work_units"]) for r in rows}) == 1
            if not stable:
                result["status"] = "FAILED"
                result["invalid_trials"].append({"profile": profile, "mode": mode,
                                                 "reason": "semantic output differs between repetitions"})
            misses = sum(value > budget for value in values) if budget > 0 else None
            work = rows[0]["work_units"]
            stages[mode] = {"samples": len(values), "valid_repetitions": len(per_round[mode]),
                            "p50_us": quantile(values, .5), "p95_us": quantile(values, .95),
                            "p99_us": quantile(values, .99), "max_us": max(values),
                            "deadline_budget_us": budget if budget > 0 else None,
                            "deadline_misses": misses,
                            "deadline_miss_rate": misses / len(values) if misses is not None else None,
                            "deadline_status": "unset" if misses is None else
                                               "met_in_samples" if misses == 0 else "exceeded",
                            "semantic_output_stable": stable, "per_round": per_round[mode],
                            "work_units_per_s": work * len(values) * 1e6 / sum(values)
                                                if work is not None else None}
        result["profiles"][profile] = {"cpus": probe["profiles"][profile],
                                        "evidence": probe.get("profile_evidence", {}).get(profile),
                                        "stages": stages}

    # Pair only the same repetition, executable and semantic workload. Never compare disjoint rounds.
    for mode in MODES:
        ratios = []
        rejected = []
        for repetition in range(1, repeats + 1):
            a55 = valid_runs.get(("single_a55", repetition), {}).get(mode)
            a76 = valid_runs.get(("single_a76", repetition), {}).get(mode)
            if not a55 or not a76:
                continue
            left, right = a55[0], a76[0]
            if (left["digest"], left["work_units"]) != (right["digest"], right["work_units"]):
                rejected.append({"repeat": repetition, "reason": "different output or workload size"})
                result["status"] = "FAILED"
                result["invalid_trials"].append({"profile": "single_a55_vs_single_a76", "mode": mode,
                                                 "repeat": repetition,
                                                 "reason": "cross-core output or workload size differs"})
                continue
            ratios.append({"repeat": repetition,
                           "a55_p50_over_a76_p50": quantile([r["us"] for r in a55], .5) /
                                                   quantile([r["us"] for r in a76], .5)})
        result["single_core_speed_ratios"][mode] = {
            "pairs": ratios, "rejected_pairs": rejected,
            "median_ratio": statistics.median(item["a55_p50_over_a76_p50"] for item in ratios)
                            if ratios else None}
    if not any(p["stages"] for p in result["profiles"].values()):
        result["status"] = "FAILED" if result["invalid_trials"] else "UNAVAILABLE"
    perf_statuses = []
    expected_perf_pairs = {(profile, mode) for profile in PROFILES
                           if profile in probe.get("profiles", {}) for mode in MODES}
    completed_perf_pairs = set()
    for path in sorted((root / "perf").glob("*/*/status.json")):
        try:
            record = json.loads(path.read_text())
            profile = path.parents[1].name
            mode = path.parent.name
            if (profile, mode) not in expected_perf_pairs:
                raise ValueError("unexpected perf profile or mode")
            if record.get("status") == "COMPLETE":
                attempt = int(record["successful_attempt"])
                metadata = json.loads((path.parent / f"attempt-{attempt}-status.json").read_text())
                if (attempt < 1 or metadata["exit_code"] != 0 or metadata["post_probe_exit_code"] != 0 or
                        any(metadata[key] != manifest["binary_sha256"] for key in
                            ("binary_sha256", "binary_sha256_after")) or
                        metadata["cpus"] != record["cpus"] or metadata["events"] != record["events"]):
                    raise ValueError("perf execution identity or completion evidence differs")
                for suffix in ("before", "after"):
                    snapshot = json.loads((path.parent / f"attempt-{attempt}-{suffix}.json").read_text())
                    validate_topology(probe, snapshot, profile,
                                      [int(value) for value in record["cpus"].split(",")])
                if not valid_perf(path.parent / f"attempt-{attempt}.csv", record["events"]):
                    raise ValueError("perf counter data is unsupported or incomplete")
                completed_perf_pairs.add((profile, mode))
            perf_statuses.append({"profile": profile, "mode": path.parent.name, **record})
        except (OSError, ValueError, KeyError, TypeError) as error:
            perf_statuses.append({"path": str(path), "status": "INVALID", "error": str(error)})
    result["perf_statuses"] = perf_statuses
    planned = len(expected_perf_pairs)
    completed = len(completed_perf_pairs)
    result["perf_coverage"] = {"planned_profiles_and_stages": planned, "valid_profiles_and_stages": completed,
                               "status": "COMPLETE" if planned > 0 and planned == completed else
                                         "PARTIAL" if completed > 0 else "UNAVAILABLE"}
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("directory", type=Path, nargs="?")
    parser.add_argument("--output", type=Path)
    parser.add_argument("--check-perf", type=Path)
    parser.add_argument("--events")
    parser.add_argument("--check-topology", type=Path)
    parser.add_argument("--initial-probe", type=Path)
    parser.add_argument("--profile")
    parser.add_argument("--cpus")
    args = parser.parse_args()
    if args.check_perf:
        if not args.events:
            parser.error("--check-perf requires --events")
        raise SystemExit(0 if valid_perf(args.check_perf, args.events) else 1)
    if args.check_topology:
        if not args.initial_probe or args.profile not in PROFILES or not args.cpus:
            parser.error("--check-topology requires --initial-probe, --profile and --cpus")
        validate_topology(json.loads(args.initial_probe.read_text()),
                          json.loads(args.check_topology.read_text()), args.profile,
                          [int(value) for value in args.cpus.split(",")])
        return
    if not args.directory or not args.output:
        parser.error("directory and --output are required")
    report = summarize(args.directory)
    args.output.write_text(json.dumps(report, indent=2, ensure_ascii=False) + "\n")
    print("matrix_status=" + report["status"] + " summary=" + str(args.output))


if __name__ == "__main__":
    main()
