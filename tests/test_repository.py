"""Offline GitHub-ready artifact checks; does not execute Oracle SQL."""
from pathlib import Path
import csv
import re
import unittest

ROOT = Path(__file__).resolve().parents[1]
RESULTS = ROOT / "evidence" / "results"


def csvrows(basename):
    with (RESULTS / basename).open(encoding="utf-8-sig", newline="") as fh:
        return list(csv.DictReader(fh))


class TestRepository(unittest.TestCase):
    def test_complete_script_inventory(self):
        scripts = sorted((ROOT / "sql").glob("*.sql"))
        self.assertEqual(13, len(scripts))
        self.assertEqual([f"{i:02d}" for i in range(13)], [s.stem[:2] for s in scripts])
        self.assertEqual(14, len(list(RESULTS.glob("*_result.csv"))))
        self.assertEqual(14, len(list((ROOT / "evidence" / "screenshots").glob("*.png"))))

    def test_sql_is_structurally_read_only(self):
        for script in (ROOT / "sql").glob("*.sql"):
            lines = [line for line in script.read_text(encoding="utf-8-sig").splitlines()
                     if line.strip() and not line.strip().startswith("--")]
            sql = "\n".join(lines).lstrip().lower()
            with self.subTest(script=script.name):
                self.assertTrue(re.match(r"^(select|with)\b", sql), "Expected a SELECT or WITH query")
                self.assertFalse(re.search(r"\b(insert|update|delete|truncate|merge|alter|drop|create|grant|revoke)\b", sql), "Detected possible write verb")

    def test_summary_scorecard_matches_export(self):
        rows = csvrows("10_control_scorecard_result.csv")
        self.assertEqual(12, len(rows))
        self.assertEqual(11, sum(r["STATUS"] == "PASS" for r in rows))
        self.assertEqual(1, sum(r["STATUS"] == "REVIEW" for r in rows))
        self.assertEqual(0, sum(r["STATUS"] == "FAIL" for r in rows))
        review = [r for r in rows if r["STATUS"] == "REVIEW"]
        self.assertEqual("DQ-002", review[0]["CONTROL_ID"])
        self.assertEqual(1, int(review[0]["ISSUE_COUNT"]))

    def test_employee_count_reconciliation(self):
        profile = csvrows("02_workforce_profile_result.csv")[0]
        dq = csvrows("03_employee_data_quality_result.csv")[0]
        deps = csvrows("09_department_coverage_result.csv")
        geo = csvrows("11_geographical_distribution_result.csv")
        self.assertEqual(int(profile["EMPLOYEE_COUNT"]), int(dq["TOTAL_EMPLOYEES"]))
        assigned = sum(int(r["EMPLOYEE_COUNT"]) for r in deps)
        self.assertEqual(assigned + int(dq["MISSING_DEPARTMENT"]), int(profile["EMPLOYEE_COUNT"]))
        self.assertEqual(assigned, sum(int(r["EMPLOYEE_COUNT"]) for r in geo))

    def test_dq005_live_and_synthetic_evidence(self):
        # Both genuine FreeSQL CSV exports are required for the published enhancement.
        live = csvrows("12_duplicate_email_audit_result.csv")
        synth = csvrows("12_duplicate_email_synthetic_result.csv")
        self.assertEqual(1, len(live))
        self.assertEqual(1, len(synth))
        self.assertEqual("DQ-005", live[0]["CONTROL_ID"])
        self.assertEqual("PASS", live[0]["STATUS"])
        self.assertEqual(0, int(live[0]["DUPLICATE_GROUP_COUNT"]))
        self.assertEqual(0, int(live[0]["AFFECTED_EMPLOYEE_COUNT"]))
        self.assertEqual(0, int(live[0]["ISSUE_COUNT"]))
        self.assertEqual("REVIEW", synth[0]["STATUS"])
        self.assertEqual(2, int(synth[0]["DUPLICATE_GROUP_COUNT"]))
        self.assertEqual(4, int(synth[0]["AFFECTED_RECORDS"]))
        self.assertEqual(2, int(synth[0]["ISSUE_COUNT"]))

    def test_session_identity_redacted(self):
        rows=csvrows("00_session_context_result.csv")
        self.assertEqual("REDACTED",rows[0]["CURRENT_SCHEMA"])
        self.assertEqual("REDACTED",rows[0]["SESSION_USER"])


if __name__ == "__main__":
    unittest.main()
