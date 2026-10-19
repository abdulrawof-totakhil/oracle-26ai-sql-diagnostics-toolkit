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

## Local static/consistency verification

Run in a local Python 3 installation:

```bash
python -m unittest discover -s tests -v
```

The tests require only Python standard library. They validate artifacts and static SQL shape; they do **not** connect to Oracle or dynamically assess query correctness.

## Handling an error

Do not alter real data to make a test pass. Capture the query, Oracle error code, expected/actual outcome, and a revised test if necessary. Use a separate change in GitHub to preserve the project's history.
