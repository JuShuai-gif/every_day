"""Fixture-only tests: no board access, network, taskset, perf or workload execution."""

import csv
import importlib.util
import json
import os
from pathlib import Path
import tempfile
import subprocess
import sys
import unittest


SCRIPTS = Path(__file__).resolve().parents[1] / "scripts"


def load(name, filename):
    spec = importlib.util.spec_from_file_location(name, SCRIPTS / filename)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


board = load("board_probe", "board_probe.py")
matrix = load("matrix_summary", "summarize-matrix.py")


class BoardProbeTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.root = Path(self.temporary.name)
        self.sys = self.root / "sys"
        self.proc = self.root / "proc"

    def tearDown(self):
        self.temporary.cleanup()

    def write(self, relative, content):
        path = self.root / relative
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(content)

    def cpu(self, cpu, midr=None, cluster=0):
        base = f"sys/devices/system/cpu/cpu{cpu}"
        self.write(base + "/topology/cluster_id", str(cluster))
        self.write(base + "/topology/physical_package_id", "0")
        if midr is not None:
            self.write(base + "/regs/identification/midr_el1", midr)

    def test_midr_nonstandard_numbering_offline_and_affinity(self):
        self.write("sys/devices/system/cpu/online", "0-1,3-4")
        self.cpu(0, "0x410fd0b0", 9)
        self.cpu(1, "0x410fd050", 7)
        self.cpu(2, "0x410fd0b0", 9)
        self.cpu(3, "0x410fd050", 7)
        self.cpu(4, "0x410fd0b0", 9)
        self.write("sys/firmware/devicetree/base/compatible", "vendor,board\0rockchip,rk3588\0")
        result = board.probe(self.sys, self.proc, affinity={0, 1, 2, 3, 4})
        self.assertEqual(result["eligible_cpus"], [0, 1, 3, 4])
        self.assertEqual(result["profiles"]["single_a76"], [0])
        self.assertEqual(result["profiles"]["cluster_a55"], [1, 3])
        self.assertEqual(result["profiles"]["cluster_a76"], [0, 4])
        self.assertTrue(result["identity"]["is_rk3588"])
        limited = board.probe(self.sys, self.proc, affinity={1, 2, 3})
        self.assertNotIn("single_a76", limited["profiles"])
        self.assertIn("single_a76", limited["unavailable_profiles"])

    def test_missing_midr_cpuinfo_fallback_and_unknown(self):
        self.write("sys/devices/system/cpu/online", "7-8")
        self.cpu(7, cluster=-1)
        self.cpu(8, cluster=-1)
        self.write("proc/cpuinfo", "processor : 7\nCPU implementer : 0x41\nCPU part : 0xd05\n\n"
                                  "processor : 8\nCPU implementer : 0x41\nCPU part : 0xd0c\n")
        result = board.probe(self.sys, self.proc, affinity={7, 8})
        self.assertEqual(result["profiles"], {"single_a55": [7]})
        self.assertEqual(result["cpus"][0]["identity_source"], "proc_cpuinfo")
        self.assertEqual(result["cpus"][1]["core"], "unknown")
        self.assertFalse(result["identity"]["is_rk3588"])
        self.assertIn("cluster_a55", result["unavailable_profiles"])

    def test_shared_cache_evidence_and_measurement_units(self):
        self.write("sys/devices/system/cpu/online", "1,3")
        for cpu in (1, 3):
            self.cpu(cpu, "0x410fd050", -1)
            base = f"sys/devices/system/cpu/cpu{cpu}/cache/index2"
            for key, value in {"level": "2", "type": "Unified", "size": "512K",
                               "coherency_line_size": "64", "shared_cpu_list": "1,3"}.items():
                self.write(base + "/" + key, value)
        self.write("sys/class/thermal/thermal_zone0/type", "soc-thermal")
        self.write("sys/class/thermal/thermal_zone0/temp", "42000")
        result = board.probe(self.sys, self.proc, affinity={1, 3})
        self.assertEqual(result["profiles"]["cluster_a55"], [1, 3])
        self.assertEqual(result["cpus"][0]["caches"][0]["size_bytes"], 512 * 1024)
        self.assertEqual(result["thermal"][0]["temperature_millicelsius"], 42000)

    def test_invalid_cpu_lists(self):
        for text in ("4-2", "-1", "1,a", "0-2000000"):
            with self.assertRaises(ValueError):
                board.cpu_list(text)

    def test_cluster_id_without_package_is_insufficient(self):
        self.write("sys/devices/system/cpu/online", "1,3")
        for cpu in (1, 3):
            self.cpu(cpu, "0x410fd050", 0)
            (self.sys / f"devices/system/cpu/cpu{cpu}/topology/physical_package_id").unlink()
        result = board.probe(self.sys, self.proc, affinity={1, 3})
        self.assertNotIn("cluster_a55", result["profiles"])

    def test_cli_fixture_affinity_on_non_linux_host(self):
        self.write("sys/devices/system/cpu/online", "7")
        self.cpu(7, "0x410fd050", 2)
        completed = subprocess.run(
            [sys.executable, "-B", str(SCRIPTS / "board_probe.py"), "--sys-root", str(self.sys),
             "--proc-root", str(self.proc), "--affinity", "7"],
            check=True, capture_output=True, text=True)
        self.assertEqual(json.loads(completed.stdout)["profiles"]["single_a55"], [7])

    def test_matrix_refuses_non_linux_without_creating_records(self):
        fake_bin = self.root / "bin"
        fake_bin.mkdir()
        uname = fake_bin / "uname"
        uname.write_text("#!/bin/sh\nprintf 'Darwin\\n'\n")
        uname.chmod(0o755)
        destination = self.root / "must-not-exist"
        env = dict(os.environ, PATH=str(fake_bin) + os.pathsep + os.environ.get("PATH", ""))
        completed = subprocess.run(
            ["bash", str(SCRIPTS / "run-matrix.sh"), "/no-binary", str(destination)],
            env=env, capture_output=True, text=True)
        self.assertEqual(completed.returncode, 2)
        self.assertIn("Linux/aarch64", completed.stderr)
        self.assertFalse(destination.exists())


class MatrixSummaryTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.root = Path(self.temporary.name)
        self.manifest = {"binary_sha256": "abc123", "repeats": 1, "samples": 2,
                         "seconds": 0, "iterations": 1, "budget_us": 10}
        self.probe = {"profiles": {"single_a55": [1], "single_a76": [0],
                                   "cluster_a55": [1, 3], "cluster_a76": [0, 4]},
                      "identity": {"is_rk3588": True}, "unavailable_profiles": {}}
        self.probe["cpus"] = [
            {"cpu": cpu, "core": "Cortex-A55" if cpu in (1, 3) else "Cortex-A76",
             "implementer": 0x41, "part": 0xD05 if cpu in (1, 3) else 0xD0B,
             "online": True, "allowed": True} for cpu in (0, 1, 3, 4)]
        self.write_json(self.root / "manifest.json", self.manifest)
        self.write_json(self.root / "probe-before.json", self.probe)
        for profile in matrix.PROFILES:
            self.write_trial(profile, [2.5, 7.5] if profile == "single_a76" else [5, 15])

    def tearDown(self):
        self.temporary.cleanup()

    def write_json(self, path, value):
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(json.dumps(value))

    def write_trial(self, profile, values, digest=99, status="COMPLETE", modes=matrix.MODES):
        directory = self.root / "runs" / profile / "repeat-1"
        self.write_json(directory / "status.json", {"status": status, "exit_code": 0,
                                                    "binary_sha256": "abc123",
                                                    "binary_sha256_after": "abc123",
                                                    "cpus": ",".join(map(str, self.probe["profiles"][profile]))})
        snapshot = dict(self.probe, affinity_cpus=self.probe["profiles"][profile],
                        eligible_cpus=self.probe["profiles"][profile])
        self.write_json(directory / "environment-before.json", snapshot)
        self.write_json(directory / "environment-after.json", snapshot)
        (directory / "stdout.log").write_text("correctness=PASS\n")
        with (directory / "samples.csv").open("w", newline="") as stream:
            writer = csv.writer(stream)
            writer.writerow(("variant", "sample", "iterations", "batch_us", "us_per_invocation",
                             "digest", "work_units", "budget_us", "budget_exceeded"))
            for mode in modes:
                for sample, value in enumerate(values):
                    writer.writerow((mode, sample, 1, value, value, digest, 8,
                                     self.manifest["budget_us"],
                                     int(self.manifest["budget_us"] > 0 and value > self.manifest["budget_us"])))

    def test_deadlines_and_paired_single_core_ratio(self):
        result = matrix.summarize(self.root)
        self.assertEqual(result["status"], "COMPLETE")
        metrics = result["profiles"]["single_a55"]["stages"]["optimized"]
        self.assertEqual(metrics["deadline_misses"], 1)
        self.assertEqual(metrics["deadline_miss_rate"], .5)
        self.assertEqual(metrics["p50_us"], 5)
        self.assertEqual(metrics["p99_us"], 15)
        self.assertEqual(result["single_core_speed_ratios"]["optimized"]["median_ratio"], 2)
        self.assertEqual(result["acceptance_status"], "not_evaluated")

    def test_zero_budget_is_unset_not_pass(self):
        self.manifest["budget_us"] = 0
        self.write_json(self.root / "manifest.json", self.manifest)
        for profile in matrix.PROFILES:
            self.write_trial(profile, [5, 15])
        metrics = matrix.summarize(self.root)["profiles"]["single_a55"]["stages"]["baseline"]
        self.assertIsNone(metrics["deadline_misses"])
        self.assertEqual(metrics["deadline_status"], "unset")

    def test_invalid_partial_and_noncomparable_data_not_pass(self):
        self.write_trial("single_a55", [5, 15], status="INTERRUPTED")
        result = matrix.summarize(self.root)
        self.assertEqual(result["status"], "FAILED")
        self.assertFalse(result["single_core_speed_ratios"]["baseline"]["pairs"])
        self.write_trial("single_a55", [5, 15], modes=("optimized",))
        self.assertEqual(matrix.summarize(self.root)["status"], "FAILED")
        self.write_trial("single_a55", [5, 15], digest=100)
        result = matrix.summarize(self.root)
        self.assertNotEqual(result["status"], "COMPLETE")
        self.assertFalse(result["single_core_speed_ratios"]["baseline"]["pairs"])
        self.assertTrue(result["single_core_speed_ratios"]["baseline"]["rejected_pairs"])

    def test_shrunk_affinity_changed_identity_and_hash_are_invalid(self):
        trial = self.root / "runs/cluster_a55/repeat-1"
        snapshot = json.loads((trial / "environment-after.json").read_text())
        snapshot["affinity_cpus"] = [1]
        snapshot["eligible_cpus"] = [1]
        self.write_json(trial / "environment-after.json", snapshot)
        self.assertEqual(matrix.summarize(self.root)["status"], "FAILED")
        self.write_trial("cluster_a55", [5, 15])
        snapshot = json.loads((trial / "environment-before.json").read_text())
        snapshot["cpus"][1]["part"] = 0xD0B
        self.write_json(trial / "environment-before.json", snapshot)
        self.assertEqual(matrix.summarize(self.root)["status"], "FAILED")
        self.write_trial("cluster_a55", [5, 15])
        status = json.loads((trial / "status.json").read_text())
        status["binary_sha256_after"] = "changed"
        self.write_json(trial / "status.json", status)
        self.assertEqual(matrix.summarize(self.root)["status"], "FAILED")

    def test_empty_profile_set_is_unavailable(self):
        self.probe["profiles"] = {}
        self.write_json(self.root / "probe-before.json", self.probe)
        self.assertEqual(matrix.summarize(self.root)["status"], "UNAVAILABLE")

    def test_budget_mismatch_rejects_trial(self):
        self.manifest["budget_us"] = 20
        self.write_json(self.root / "manifest.json", self.manifest)
        result = matrix.summarize(self.root)
        self.assertEqual(result["status"], "FAILED")
        self.assertEqual(len(result["invalid_trials"]), 4)

    def test_perf_unsupported_exit_zero_is_not_complete(self):
        path = self.root / "perf.csv"
        path.write_text("<not supported>,,cycles,0,0\n10,,instructions,100,100\n")
        self.assertFalse(matrix.valid_perf(path, "cycles,instructions"))
        path.write_text("123,,cycles,100,100\n456,,instructions,100,100\n")
        self.assertTrue(matrix.valid_perf(path, "cycles,instructions"))

    def test_perf_complete_without_evidence_is_not_accepted(self):
        destination = self.root / "perf/single_a55/baseline/status.json"
        self.write_json(destination, {"status": "COMPLETE", "events": "cycles", "cpus": "1",
                                      "successful_attempt": 1})
        result = matrix.summarize(self.root)
        self.assertEqual(result["perf_statuses"][0]["status"], "INVALID")
        self.assertEqual(result["perf_coverage"]["status"], "UNAVAILABLE")

    def test_unexpected_perf_mode_cannot_fill_coverage(self):
        for profile, mode in (("single_a55", "extra_mode"), ("unknown_profile", "baseline")):
            destination = self.root / "perf" / profile / mode / "status.json"
            self.write_json(destination, {"status": "COMPLETE", "events": "cycles", "cpus": "1",
                                          "successful_attempt": 1})
        result = matrix.summarize(self.root)
        self.assertEqual(len(result["perf_statuses"]), 2)
        self.assertTrue(all(record["status"] == "INVALID" for record in result["perf_statuses"]))
        self.assertTrue(all("unexpected perf profile or mode" in record["error"]
                            for record in result["perf_statuses"]))
        self.assertEqual(result["perf_coverage"]["valid_profiles_and_stages"], 0)
        self.assertEqual(result["perf_coverage"]["planned_profiles_and_stages"], 12)
        self.assertEqual(result["perf_coverage"]["status"], "UNAVAILABLE")


if __name__ == "__main__":
    unittest.main()
