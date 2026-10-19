# Oracle ACE Product Usage — Submission Checklist

## What the project demonstrates

A SQL diagnostics and data-quality toolkit using Oracle AI Database 26ai's FreeSQL worksheet with the public HR sample schema. The original 12 SQL scripts and a supplemental DQ-005 script were executed during hands-on sessions on 19 October 2026; their exports and screenshots accompany the repository. The scripts cover data quality, referential integrity, hierarchical SQL, analytic SQL, and consolidated rule-based reporting.

## Before you submit to Oracle ACE

- [ ] Review and understand every SQL statement in `sql/`.
- [ ] Review the AI-assisted DQ-005 enhancement, understand and explain its rule, and accurately document your own testing and specific design decisions. If claiming independent code authorship, make and test a meaningful personal code change.
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

- `evidence/results/`: 12 baseline CSV exports plus two DQ-005 CSV exports (session context redacted).
- `evidence/screenshots/`: 12 baseline worksheet screenshots and two DQ-005 execution screenshots (session context redacted).
- `docs/RESULTS_LOG.md`: complete findings and caveats.
- `docs/TEST_PLAN.md`: reproducibility information.


## Supplemental DQ-005 evidence

- DQ-005 is a **separate 13th script**, not part of the original 12-control scorecard.
- The contributor executed both the public HR sample query (PASS / 0 duplicates) and the six-row synthetic positive case (REVIEW / 2 groups and 4 affected rows). Real screenshots demonstrate both.
- The two FreeSQL CSV exports are included; their results match the screenshots and have passed the merged-repository offline checks.
- The new SQL, synthetic test, and documentation were drafted with AI assistance. Do not describe them as independently authored without accurately describing personal modifications, understanding, and tests.
- DQ-005 does not confer an additional Oracle ACE point value automatically; assessment belongs to the ACE team.
