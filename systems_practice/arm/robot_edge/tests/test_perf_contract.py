"""Host tests for deadline accounting and reproducible assembly commands."""
import importlib.util
from pathlib import Path
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[1]


def load(name, filename):
    spec = importlib.util.spec_from_file_location(name, ROOT / "01_camera_resize/scripts" / filename)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


summary = load("summary", "summarize.py")
codegen = load("codegen", "inspect-build.py")


class PerformanceContract(unittest.TestCase):
    def summarize(self, content):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "samples.csv"
            path.write_text(content)
            return summary.summarize(path)["variants"]["baseline"]

    def csv(self, rows):
        return "variant,sample,iterations,batch_us,us_per_invocation,digest,work_units,budget_us,budget_exceeded\n" + rows

    def test_budget_and_work_units(self):
        result = self.summarize(self.csv(
            "baseline,0,1,8,8,123,4,10,0\n"
            "baseline,1,1,12,12,123,4,10,1\n"
        ))
        self.assertEqual(result["deadline_misses"], 1)
        self.assertEqual(result["deadline_miss_rate"], .5)
        self.assertEqual(result["work_units_per_second"], 400000)
        self.assertEqual(result["budget_status"], "OBSERVED_MISSES")

    def test_unset_budget_is_not_success(self):
        result = self.summarize(self.csv("baseline,0,1,8,8,123,4,0,0\n"))
        self.assertIsNone(result["deadline_misses"])
        self.assertIsNone(result["budget_us"])
        self.assertEqual(result["budget_status"], "NOT_SET")

    def test_batch_mean_deadline_is_marked(self):
        result = self.summarize(self.csv("baseline,0,2,16,8,123,4,10,0\n"))
        self.assertEqual(result["deadline_scope"], "batch_mean")

    def test_bad_indicators_and_mixed_workload(self):
        cases = [
            "baseline,0,1,12,12,123,4,10,0\n",
            "baseline,0,1,8,8,123,4,10,0\nbaseline,1,1,8,8,123,5,10,0\n",
            "baseline,0,1,8,8,123,4,nan,0\n",
        ]
        for rows in cases:
            with self.subTest(rows=rows), self.assertRaises(ValueError):
                self.summarize(self.csv(rows))

    def test_legacy_csv_does_not_invent_budget(self):
        result = self.summarize(
            "variant,sample,iterations,batch_us,us_per_invocation,digest\n"
            "baseline,0,1,8,8,123\n"
        )
        self.assertEqual(result["budget_status"], "NOT_RECORDED")

    def test_codegen_preserves_target_and_removes_dependency_writes(self):
        entry = {"arguments": ["cross-clang++", "-march=armv8-a", "-mtune=cortex-a55",
                               "-MD", "-MF", "old.d", "-MT", "old.o", "-c", "source.cpp",
                               "-o", "old.o"]}
        result = codegen.assembly_command(entry, Path("new.s"), "clang")
        self.assertIn("-march=armv8-a", result)
        self.assertIn("-mtune=cortex-a55", result)
        self.assertIn("-S", result)
        self.assertNotIn("old.o", result)
        self.assertNotIn("old.d", result)
        self.assertNotIn("-c", result)

    def test_shared_tools_stay_identical(self):
        for filename in ("summarize.py", "inspect-build.py"):
            copies = [p.read_bytes() for p in ROOT.glob("[0-9][0-9]_*/scripts/" + filename)]
            self.assertEqual(len(copies), 10)
            self.assertEqual(len(set(copies)), 1)


if __name__ == "__main__":
    unittest.main()
