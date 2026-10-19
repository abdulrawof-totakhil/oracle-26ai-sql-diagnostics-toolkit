
-- Oracle ACE Project
-- Exercise 02: Workforce Profile
-- Operation: READ ONLY

SELECT
    COUNT(*) AS employee_count,
    COUNT(DISTINCT department_id) AS staffed_departments,
    COUNT(DISTINCT job_id) AS assigned_job_types,
    SUM(CASE
        WHEN manager_id IS NULL THEN 1
        ELSE 0
    END) AS without_manager,
    TO_CHAR(MIN(hire_date), 'YYYY-MM-DD') AS earliest_hire,
    TO_CHAR(MAX(hire_date), 'YYYY-MM-DD') AS latest_hire
FROM HR.EMPLOYEES;
