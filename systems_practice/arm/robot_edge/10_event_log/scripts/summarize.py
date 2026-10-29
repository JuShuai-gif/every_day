#!/usr/bin/env python3
"""Aggregate raw latency, work-unit throughput and explicit invocation deadlines."""
import argparse
import csv
import json
import math
from pathlib import Path
import statistics


def quantile(values, p):
    ordered = sorted(values)
    return ordered[max(0, math.ceil(p * len(ordered)) - 1)]


def summarize(path):
    groups = {}
    with path.open(newline="") as stream:
        for row in csv.DictReader(stream):
            latency = float(row["us_per_invocation"])
            if not math.isfinite(latency) or latency <= 0:
                raise ValueError("nonpositive/nonfinite latency")
            if int(row["iterations"]) < 1:
                raise ValueError("invalid iteration count")
            groups.setdefault(row["variant"], []).append(row)
    if not groups:
        raise ValueError("CSV contains no samples")
    result = {
        "source_csv": str(path.resolve()),
        "hardware_claim": "see_environment_record",
        "metric": "microseconds_per_invocation; batch mean when iterations > 1",
        "variants": {},
    }
    for name, rows in groups.items():
        values = [float(row["us_per_invocation"]) for row in rows]
        metrics = {
            "samples": len(rows),
            "iterations": sorted({int(row["iterations"]) for row in rows}),
            "p50_us": quantile(values, .50),
            "p95_us": quantile(values, .95),
            "p99_us": quantile(values, .99),
            "max_us": max(values),
            "mean_us": statistics.mean(values),
            "digest_stable": len({r["digest"] for r in rows}) == 1,
        }
        # Historical six-column CSV remains readable; absent budgets are never PASS.
        if "work_units" in rows[0]:
            units = {float(r["work_units"]) for r in rows}
            budgets = {float(r["budget_us"]) for r in rows}
            if len(units) != 1 or len(budgets) != 1:
                raise ValueError("mixed workload or budget within variant")
            unit, budget = units.pop(), budgets.pop()
            if not math.isfinite(unit) or unit <= 0 or not math.isfinite(budget) or budget < 0:
                raise ValueError("invalid work units/budget")
            misses = sum(value > budget for value in values) if budget > 0 else None
            for row, value in zip(rows, values):
                if int(row["budget_exceeded"]) != int(budget > 0 and value > budget):
                    raise ValueError("inconsistent deadline indicator")
            metrics.update({
                "work_units_per_invocation": unit,
                "work_units_per_second": unit * 1e6 / statistics.mean(values),
                "budget_us": budget if budget > 0 else None,
                "deadline_misses": misses,
                "deadline_miss_rate": misses / len(rows) if misses is not None else None,
                "deadline_scope": "invocation" if metrics["iterations"] == [1] else "batch_mean",
                "budget_status": "NOT_SET" if misses is None else ("OBSERVED_MISSES" if misses else "NO_OBSERVED_MISSES"),
            })
        else:
            metrics["budget_status"] = "NOT_RECORDED"
        result["variants"][name] = metrics
    if "baseline" in result["variants"]:
        reference = result["variants"]["baseline"]
        for metrics in result["variants"].values():
            metrics["baseline_over_variant_p50"] = reference["p50_us"] / metrics["p50_us"]
    return result


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("csv", type=Path)
    parser.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()
    report = summarize(args.csv)
    args.output.write_text(json.dumps(report, indent=2, ensure_ascii=False) + "\n")
    print("summary_json=" + str(args.output))


if __name__ == "__main__":
    main()
