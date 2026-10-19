# Oracle ACE Product Usage — Submission Checklist

## What the project demonstrates

A SQL diagnostics and data-quality toolkit using Oracle AI Database 26ai's FreeSQL worksheet with the public HR sample schema. Twelve scripts were executed during a hands-on session on 19 October 2026; the exports and screenshots accompany the repository. The scripts cover data quality, referential integrity, hierarchical SQL, analytic SQL, and consolidated rule-based reporting.

## Before you submit to Oracle ACE

- [ ] Review and understand every SQL statement in `sql/`.
- [ ] Add **one meaningful enhancement of your own** (for example, a new rule for duplicate emails or an additional timeline test); document why you designed it, your actual test results, and screenshots.
- [ ] Update README and RESULTS_LOG to reflect **your** changes, not just the AI-assisted starter work.
- [ ] Check ACE Dashboard → Product Usage → Contributions for category, point values, evidence upload requirements, and approval state.
- [ ] Remove any data that is sensitive, company-specific, or unnecessarily identifying before committing.
- [ ] Confirm the new activity and evidence were created after ACE Apprentice acceptance, as required by the dashboard.
- [ ] Upload repository contents via GitHub, inspect the public rendering and hyperlinks, and copy the correct repository URL.
- [ ] Provide your name and submission date in the **private ACE portal's** documentation/evidence upload as required by the ACE dashboard; avoid publishing personal contact details or registration identifiers in public repo files.

## Suggested short ACE contribution description (adapt based on what you personally did)

> I performed a hands-on Oracle FreeSQL 26ai exercise using the public HR sample schema and validated a read-only SQL diagnostics toolkit. It covers workforce data quality, optional NULL relationships, referential-integrity checks, hierarchical reporting, job-history analysis, and a 12-control severity-based scorecard. I exported the results and captured execution screenshots. The scorecard returned 11 PASS, 1 REVIEW, and 0 FAIL statuses. The REVIEW item concerns an optional NULL department assignment. Initial scripts/docs were prepared with AI assistance; my documented hands-on testing and subsequent improvements are recorded in the repository.

**Do not claim ACE points, approval, originality, or authorship beyond work actually completed.**

## Evidence index

- `evidence/results/`: CSV exports, one for each script (session context redacted).
- `evidence/screenshots/`: actual worksheet execution screenshots (session context redacted).
- `docs/RESULTS_LOG.md`: complete findings and caveats.
- `docs/TEST_PLAN.md`: reproducibility information.
