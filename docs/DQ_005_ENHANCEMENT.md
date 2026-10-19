# DQ-005 — Normalized Employee Email Duplicate Detection

## Objective

Add a read-only, sample-schema data-quality control that identifies possible duplicate email values after **trimming ordinary surrounding spaces** and **uppercasing**. This is useful where email uniqueness should be verified but direct email disclosure is unnecessary. Business owners must determine whether duplicates should be permitted.

## Query design

- Source: public `HR.EMPLOYEES` sample table.
- Normalize values using `UPPER(TRIM(email))`.
- Ignore `NULL` and effectively blank values; missing-email checking is covered by `DQ-001`.
- Group normalized values; keep only groups with `COUNT(*) > 1`.
- Report `DUPLICATE_GROUP_COUNT`, `AFFECTED_EMPLOYEE_COUNT`, and `ISSUE_COUNT` (extra duplicate rows beyond the first in each group).
- Return `PASS` if there are no duplicate groups; otherwise `REVIEW`.
- The SQL reveals **counts only**, not raw addresses, and performs no writes.

## Actual test observations (19 October 2026)

Both values below were verified from user-supplied Oracle FreeSQL screenshots.

| Exercise | Duplicate groups | Affected rows | Extra rows | Status | File |
| --- | ---: | ---: | ---: | --- | --- |
| Public HR sample | 0 | 0 | 0 | PASS | `evidence/screenshots/12_duplicate_email_audit.png` |
| Six synthetic emails | 2 | 4 | 2 | REVIEW | `evidence/screenshots/12_duplicate_email_synthetic.png` |

The synthetic case contains pairs that differ by case and surrounding spaces, plus one unique value and one NULL. It uses inline `SELECT` rows and does not modify an existing table.

### Verified CSV evidence

The contributor supplied the following CSV exports from their Oracle FreeSQL executions:

1. `evidence/results/12_duplicate_email_audit_result.csv` — HR sample: 0 groups, 0 affected, 0 issues, `PASS`.
2. `evidence/results/12_duplicate_email_synthetic_result.csv` — synthetic case: 2 groups, 4 affected, 2 issues, `REVIEW`.

The values match the execution screenshots provided by the contributor. A combined-repository offline test verified the expected headers, rows, and values; **it did not independently execute Oracle SQL**. Keep the original screenshots and CSVs together for traceable evidence.

## Limitations

- `TRIM` in this SQL removes ordinary surrounding spaces; tabs and more complicated Unicode whitespace normalization are outside scope.
- Case folding and data collations can require application-specific review.
- Duplicate groups may be permitted by business rules, so findings are tagged `REVIEW` rather than automatically `FAIL`.
- A zero-row anomaly in one sample snapshot is not a guarantee of unique emails in any other database.
- This supplemental control does not change the archived baseline 12-control scorecard or its prior outcome.

## Provenance

Draft SQL and documentation were created with AI assistance. The repository contributor executed the HR and synthetic FreeSQL exercises and supplied screenshots. Claims of original individual design should be limited to decisions or modifications actually made and tested by the contributor.

## GitHub second commit

Suggested commit message: `Add DQ-005 duplicate-email diagnostic and positive test`

The enhancement patch includes the SQL, both supplied FreeSQL CSV exports, two screenshots, documentation, and tests. Merge the patch contents into the existing repository root, confirm there are 13 SQL scripts and 14 CSVs, then review privacy, commit the changes, and inspect the GitHub Actions result.
