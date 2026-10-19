# Execution Results and Technical Review

**Execution evidence date:** 19 October 2026 (FreeSQL timestamp shown in UTC on CSV exports).  
**Environment:** Oracle FreeSQL, 26ai worksheet, public HR sample schema.  
**Method:** Read-only SQL executed in the browser. Actual results exported as CSV; screenshots also included.  
**Review status:** Automated local consistency checks passed; full enterprise-grade security or correctness audit is not claimed.

| Script | Observed result | Interpretation |
| --- | --- | --- |
| 00 — Session context | Query returned one row with timestamp and current environment information | Guest schema/session identifiers redacted in public artifacts. |
| 01 — Schema inventory | 7 valid tables, 19 valid indexes | Only selected HR object types visible through `ALL_OBJECTS`. |
| 02 — Workforce profile | 107 employees, 11 staffed departments, 19 job types, 1 without manager | One top-level manager without a manager can be legitimate. |
| 03 — Data quality | 0 missing emails, 1 missing department, 0 invalid salaries, 0 future hire dates | One **REVIEW** item; don't classify as a constraint violation without business validation. |
| 04 — Employee exception details | One row: DQ-002, missing department | Exception record requires business-rule confirmation. |
| 05 — Salary-band audit | 19 job types, 0 out-of-policy-range salaries in the complete CSV | Job ranges are sample business definitions. |
| 06 — Referential integrity | 8 checks, 0 orphan records | Tests allow legitimate optional NULL references. |
| 07 — Organization hierarchy | 107 employee hierarchy rows | Uses hierarchical SQL, produces identifiers-only paths. |
| 08 — Job-history timeline | 10 rows with `OK` under implemented `LAG()` check | Does not exhaustively detect nested overlaps. |
| 09 — Department coverage | 27 departments: 11 staffed and 16 unstaffed; 106 assigned employees | Employee assignments reconcile with one NULL department. |
| 10 — Control scorecard | 12 controls: **11 PASS / 1 REVIEW / 0 FAIL** | PASS means no matching issue under that rule, not a universal health guarantee. |
| 11 — Geographic distribution | 14 countries with locations; 106 employees across 4 countries | Sum matches department-assigned employees (107 − 1). |

## Review item DQ-002

The SQL detects a NULL `HR.EMPLOYEES.DEPARTMENT_ID`. The column can legitimately be NULL under HR sample rules. The record is preserved; no update or delete was performed. The issue is documented as REVIEW, not FAIL.

## Cross-validation

- Headcount baseline: `107`.
- Department-assigned employees: `106`.
- Difference: `1` unassigned, consistent with DQ-002.
- Geographic employee count: `106`, matching department-assigned employees.
- Detailed RI controls: `8 × 0 orphans`, consistent with the selected scorecard RI checks.
- Scorecard: 12 rows, statuses `11 / 1 / 0`.

## Privacy and evidence treatment

The raw FreeSQL session identifier appeared in the original session-context CSV/screenshot. The *public distribution* replaces those values with `REDACTED`; source SQL remains provided for reproducibility. Public HR employee IDs are sample-only. Never substitute employer, customer, or production data.

## Evidence completeness

- Baseline: 12 SQL scripts, 12 CSV outputs, and 12 screenshot captures: present.
- Supplemental DQ-005: 1 SQL script, 2 CSV outputs, and 2 screenshots: present.
- AI-assisted starter code: acknowledged in README.
- Independently designed user enhancement: **TO DO** (implement, execute, screenshot, and document before ACE submission).
- Final ACE approval/points: **NOT YET CONFIRMED**.


## Added control — DQ-005 (19 October 2026)

Two user-supplied FreeSQL screenshots confirm the **duplicate-email normalization logic** was executed after the original 12-control snapshot. The new control is separate from that historical scorecard:

| Execution | Duplicate groups | Affected records | Extra rows | Status |
| --- | ---: | ---: | ---: | --- |
| Public HR sample (`sql/12_duplicate_email_audit.sql`) | 0 | 0 | 0 | PASS |
| In-memory positive test (`tests/12_duplicate_email_synthetic.sql`) | 2 | 4 | 2 | REVIEW |

Method: `UPPER(TRIM(email))`, group by the normalized value, exclude NULL/blank results, and report group totals without publishing employee email values. The synthetic test uses six inline `SELECT` rows and makes **no** database changes. Both contributor-supplied FreeSQL CSV exports have been added under `evidence/results/` and agree with the screenshot values; offline test evidence checks pass.

The `11 PASS / 1 REVIEW / 0 FAIL` finding remains the **original 12-control scorecard**, not a recomputed 13-control scorecard.
