-- Oracle AI Database 26ai | SQL Diagnostics and Data Quality Toolkit
-- Control ID: DQ-005 | Duplicate Email Audit
-- Scope: Public HR sample schema, Oracle FreeSQL
-- Operation: READ ONLY | No employee emails are returned
-- Definition: email values equal after TRIM and UPPER are potential duplicates.
-- Excludes NULL/blank emails, already covered by DQ-001.
-- REVIEW requires business-rule confirmation; shared emails may be legitimate.

WITH normalized_emails AS (
    SELECT UPPER(TRIM(email)) AS normalized_email
    FROM HR.EMPLOYEES
    WHERE email IS NOT NULL
),
duplicate_groups AS (
    SELECT normalized_email, COUNT(*) AS group_size
    FROM normalized_emails
    WHERE normalized_email IS NOT NULL
    GROUP BY normalized_email
    HAVING COUNT(*) > 1
),
summary AS (
    SELECT COUNT(*) AS duplicate_group_count,
           NVL(SUM(group_size), 0) AS affected_employee_count,
           NVL(SUM(group_size - 1), 0) AS extra_duplicate_rows
    FROM duplicate_groups
)
SELECT
    TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS TZH:TZM') AS captured_at,
    'DQ-005' AS control_id,
    'DATA QUALITY' AS category,
    'MEDIUM' AS severity,
    duplicate_group_count,
    affected_employee_count,
    extra_duplicate_rows AS issue_count,
    CASE WHEN duplicate_group_count = 0 THEN 'PASS' ELSE 'REVIEW' END AS status,
    'Email duplicates after TRIM and UPPER (business review)' AS finding
FROM summary;
