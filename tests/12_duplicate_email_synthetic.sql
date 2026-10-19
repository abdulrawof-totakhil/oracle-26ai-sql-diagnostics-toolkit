-- DQ-005: Synthetic Duplicate Email Test
-- Read-only: six synthetic rows created by SELECT; no table changes.
-- Expected: 2 duplicate groups, 4 affected rows, 2 extra rows, REVIEW.
WITH sample_emails AS (
    SELECT 'admin@example.test' AS email FROM dual
    UNION ALL
    SELECT ' ADMIN@example.test ' FROM dual
    UNION ALL
    SELECT 'user@example.test' FROM dual
    UNION ALL
    SELECT 'USER@EXAMPLE.TEST' FROM dual
    UNION ALL
    SELECT 'unique@example.test' FROM dual
    UNION ALL
    SELECT CAST(NULL AS VARCHAR2(100)) FROM dual
),
normalized_emails AS (
    SELECT UPPER(TRIM(email)) AS normalized_email
    FROM sample_emails
),
duplicate_groups AS (
    SELECT normalized_email, COUNT(*) AS group_size
    FROM normalized_emails
    WHERE normalized_email IS NOT NULL
    GROUP BY normalized_email
    HAVING COUNT(*) > 1
)
SELECT
    COUNT(*) AS duplicate_group_count,
    NVL(SUM(group_size), 0) AS affected_records,
    NVL(SUM(group_size - 1), 0) AS issue_count,
    CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'REVIEW' END AS status
FROM duplicate_groups;
