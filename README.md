# Oracle AI Database 26ai — SQL Diagnostics & Data Quality Toolkit

[![Static checks](https://img.shields.io/badge/validation-static_checks-blue)](#testing-and-reproducibility)
![SQL](https://img.shields.io/badge/language-Oracle_SQL-red)
![Safety](https://img.shields.io/badge/queries-read--only-green)

An **Oracle SQL diagnostic toolkit** demonstrated against the **public Human Resources (HR) sample schema** using the Oracle FreeSQL 26ai worksheet. It includes **13 read-only SQL scripts**, an unchanged **12-control status scorecard**, real CSV results captured on **19 October 2026**, and accompanying execution screenshots.

> **Scope:** Sample-schema data quality and referential diagnostics, not Oracle instance monitoring, production compliance certification, an automated production deployment, or a comprehensive database health check.

## What it demonstrates

- Inventory accessible HR database objects and report schema-level metadata.
- Summarize the workforce (employees, staffed departments, assigned job types, and hire dates).
- Audit missing HR data, salary-range exceptions, and optional NULL relationships.
- Check eight referential-integrity relationships with read-only joins and `NOT EXISTS`.
- Trace organizational reporting paths with `CONNECT BY NOCYCLE`.
- Compare job-history periods with the `LAG()` analytic function.
- Produce a single, severity-tagged 12-control status scorecard.
- Reconcile department-level and geography-level employee counts.

## Verified demonstration snapshot

| Observation | Captured value |
| --- | ---: |
| HR sample employees | 107 |
| Employees with an assigned department | 106 |
| HR tables / indexes reported | 7 / 19 |
| Salary-band job groups returned | 19 |
| Referential checks with zero orphans | 8 / 8 |
| Job-history rows | 10 (all `OK` under the implemented rule) |
| Departments listed | 27 (11 staffed; 16 unstaffed) |
| Summary scorecard | **11 PASS, 1 REVIEW, 0 FAIL** |

**Review item DQ-002:** one HR sample employee has a NULL `DEPARTMENT_ID`. This is a **business-rule review**, not automatically an integrity failure. Sample schema counts may vary by installation or change over time.


## New enhancement: DQ-005 duplicate-email audit

`sql/12_duplicate_email_audit.sql` checks for multiple HR employee email values that match after `UPPER(TRIM(email))`. It is **read-only**, ignores NULL/blank email values, returns **counts only**, and classifies matching groups as **REVIEW**, subject to the application's business rules. This is a stand-alone control: **the original 12-control scorecard and its saved 11 PASS / 1 REVIEW / 0 FAIL snapshot are unchanged**.

Two real Oracle FreeSQL executions on 19 October 2026 were reviewed from user-supplied screenshots:

- Public HR sample: **0 duplicate groups, 0 affected employees, 0 extra rows → PASS**.
- In-memory synthetic input with capitalization/space variants: **2 duplicate groups, 4 affected rows, 2 extra rows → REVIEW**.

Both FreeSQL screenshot captures and **the two corresponding CSV exports supplied by the contributor** are included in `evidence/`. The CSV values match the displayed screenshot results and passed the offline consistency test. See [DQ-005 design and evidence](docs/DQ_005_ENHANCEMENT.md). The SQL and documentation are AI-assisted; the contributor ran both exercises and should accurately describe any personally designed modifications.

## Repository layout

```text
sql/                         13 read-only .sql files (00–12)
evidence/results/            12 baseline CSV exports + 2 DQ-005 CSV exports
evidence/screenshots/        12 baseline screenshots + 2 DQ-005 captures
docs/RESULTS_LOG.md          Audited findings and caveats
docs/TEST_PLAN.md            Reproduction and manual test steps
docs/DQ_005_ENHANCEMENT.md   DQ-005 design, tests and contribution history
docs/ACE_SUBMISSION.md       Contribution evidence and submission guidance
tests/test_repository.py     Offline structure and consistency checks
tests/12_duplicate_email_synthetic.sql   In-memory positive test query
.github/workflows/           CI for offline static checks
```

## Getting started (Oracle FreeSQL)

1. Open [Oracle FreeSQL](https://freesql.com/) and choose the 26ai SQL worksheet with the **Human Resources (HR)** sample schema.
2. Start with `sql/00_session_context.sql`; paste the **complete SQL** into the editor.
3. Use **Run Statement (▶)** and review the **Query Result**, not a partial Run Script selection.
4. Work through scripts `01`–`12` in order. The additional script `12` is an independent enhancement. Script `10_control_scorecard.sql` is the summary demonstration.
5. Record fresh results. Use the existing `evidence/` directory only as an example execution captured on 19 October 2026.
6. Do not publish credentials, session tokens, database identifiers, or confidential enterprise data.

All scripts are intended as `SELECT`-only queries; they need access to the HR sample objects. They do **not** require DBA privileges and they do not modify the database.

## Testing and reproducibility

No Oracle database connection is needed for the local tests:

```bash
python -m unittest discover -s tests -v
```

The checks validate file inventory, selected sample-data consistency, column headers, and that the SQL sources start with read-only queries. **Offline tests do not substitute for executing SQL in Oracle Database.** See [the test plan](docs/TEST_PLAN.md). The DQ-005 CSV test requires both new exports and passes in the reviewed merged project.

## Limitations

- The scorecard reports **conditions matched by specific SQL rules**, not a guarantee that all data is valid. No reference to Oracle ACE points or approval is implied.
- NULL departments are permitted by the HR sample schema; they are handled as review items rather than failures.
- The `LAG()` timeline comparison considers the immediately preceding interval. Fully nested overlaps can require additional interval tests.
- `CONNECT BY NOCYCLE` avoids infinite loops but is not by itself a proof of an acyclic organization.
- `ALL_OBJECTS` reflects accessible HR objects of selected types; it is **not** the full database inventory.
- Public sample IDs are shown in some demonstration files; real staff or customer information must not be used.

## Contribution and provenance

The initial SQL toolkit and documentation were prepared with **AI assistance**. The included result exports and screenshots reflect a **hands-on Oracle FreeSQL run performed by the project contributor**, not independently reproduced by the assistant. Review all scripts, document design decisions, and add an independently tested improvement before claiming substantial personal development work. A GitHub commit or ACE review does not automatically award points.

See [ACE submission checklist](docs/ACE_SUBMISSION.md). Keep personally identifying membership information in **private ACE submissions**, not public repository files.

## Licensing

No open-source license has been selected for this copy. The repository owner can add a license (for example, MIT) after deciding how they want others to use the code. Third-party sample data and Oracle trademarks retain their own terms.
