# Test Plan and Reproduction Guide

## Preconditions

- Oracle FreeSQL 26ai worksheet with HR sample objects accessible.
- No production database access is needed.
- No credentials or private datasets should be uploaded to this repository.

## Browser execution

1. Open one `.sql` file in a local text editor.
2. Copy the full statement to the FreeSQL worksheet.
3. Execute **Run Statement (▶)** once; using partial Run Script input can create `Unknown Command` errors.
4. Check output is readable and has the expected column headers.
5. Save the full CSV to `evidence/results/<script_basename>_result.csv` and a screenshot to `evidence/screenshots/<script_basename>.png`.
6. For multiple-row outputs, review the complete CSV rather than only the viewport.
7. Record exceptions as **PASS**, **REVIEW**, or **FAIL** as defined by the specific control.

## Suggested manual test matrix

| Test | Expected (public HR snapshot used in this repository) |
| --- | --- |
| 00 | One row; schema or session details may vary |
| 01 | Accessible HR tables and indexes grouped by status |
| 02 | One summary row; 107 employees in reference snapshot |
| 03 | One summary row; one missing department in reference snapshot |
| 04 | One DQ-002 review item in reference snapshot |
| 05 | Review every job group for out-of-range salaries |
| 06 | Eight relationship counts, all zero in reference snapshot |
| 07 | Reporting paths do not loop under `NOCYCLE` |
| 08 | 10 history records; all `OK` in reference snapshot |
| 09 | 27 departments, 11 staffed in reference snapshot |
| 10 | 12 controls; 11 PASS, 1 REVIEW in reference snapshot |
| 11 | Geographic employee sum = 106 in reference snapshot |
| 12 | No normalized duplicate emails found in public HR sample (PASS) |
| Synthetic DQ-005 | Six inline sample values; 2 groups, 4 affected records, 2 extra rows (REVIEW) |

## Local static/consistency verification

Run in a local Python 3 installation:

```bash
python -m unittest discover -s tests -v
```

The tests require only Python standard library. They validate artifacts and static SQL shape; they do **not** connect to Oracle or dynamically assess query correctness.

## Handling an error

Do not alter real data to make a test pass. Capture the query, Oracle error code, expected/actual outcome, and a revised test if necessary. Use a separate change in GitHub to preserve the project's history.


## DQ-005 supplemental verification

1. Execute `sql/12_duplicate_email_audit.sql` against the public HR sample. Save a CSV and screenshot.
2. Execute `tests/12_duplicate_email_synthetic.sql` in the same FreeSQL worksheet. The synthetic rows exist only in the query and **do not create or update tables**. Save a separate CSV and screenshot.
3. Compare the outputs against the expected values in `docs/DQ_005_ENHANCEMENT.md`.
4. Re-run `python -m unittest discover -s tests -v`. The DQ-005 CSV test requires both saved CSV exports; it passes in the reviewed merged project.
5. Review privacy and provenance before committing. New scripts are AI-assisted and both exercises were performed by the contributor.
