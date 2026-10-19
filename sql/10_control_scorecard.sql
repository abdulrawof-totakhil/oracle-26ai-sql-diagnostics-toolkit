-- CONTROL GROUP: SCORECARD | PRIMARY ACE DEMONSTRATION
-- 12 independent read-only checks with severity, issue count and disposition.
-- PASS means no matching issues under the rule; not a guarantee of data quality.
-- REVIEW means investigate a potentially legitimate exception.
WITH controls AS (
  SELECT 'DQ-001' control_id, 'DATA QUALITY' category, 'HIGH' severity,
         'FAIL' on_issue, 'Missing required employee email' finding,
         COUNT(*) issue_count FROM HR.EMPLOYEES WHERE email IS NULL
  UNION ALL
  SELECT 'DQ-002', 'DATA QUALITY', 'MEDIUM', 'REVIEW',
         'Employee without department (nullable by design)',
         COUNT(*) FROM HR.EMPLOYEES WHERE department_id IS NULL
  UNION ALL
  SELECT 'DQ-003', 'DATA QUALITY', 'HIGH', 'FAIL',
         'Non-positive or missing salary',
         COUNT(*) FROM HR.EMPLOYEES WHERE salary IS NULL OR salary <= 0
  UNION ALL
  SELECT 'DQ-004', 'DATA QUALITY', 'MEDIUM', 'REVIEW',
         'Future employee hire date',
         COUNT(*) FROM HR.EMPLOYEES WHERE hire_date > TRUNC(SYSDATE)
  UNION ALL
  SELECT 'RI-001', 'REFERENTIAL', 'HIGH', 'FAIL',
         'Employee job reference missing', COUNT(*)
  FROM HR.EMPLOYEES e
  WHERE NOT EXISTS (SELECT 1 FROM HR.JOBS j WHERE j.job_id = e.job_id)
  UNION ALL
  SELECT 'RI-002', 'REFERENTIAL', 'HIGH', 'FAIL',
         'Employee department reference missing', COUNT(*)
  FROM HR.EMPLOYEES e
  WHERE e.department_id IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM HR.DEPARTMENTS d WHERE d.department_id = e.department_id)
  UNION ALL
  SELECT 'RI-003', 'REFERENTIAL', 'HIGH', 'FAIL',
         'Employee manager reference missing', COUNT(*)
  FROM HR.EMPLOYEES e
  WHERE e.manager_id IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM HR.EMPLOYEES m WHERE m.employee_id = e.manager_id)
  UNION ALL
  SELECT 'PAY-001', 'COMPENSATION', 'MEDIUM', 'REVIEW',
         'Employee salary outside job policy range', COUNT(*)
  FROM HR.EMPLOYEES e JOIN HR.JOBS j ON j.job_id = e.job_id
  WHERE e.salary IS NOT NULL
    AND ((j.min_salary IS NOT NULL AND e.salary < j.min_salary)
      OR (j.max_salary IS NOT NULL AND e.salary > j.max_salary))
  UNION ALL
  SELECT 'PAY-002', 'COMPENSATION', 'HIGH', 'FAIL',
         'Job has min salary larger than max salary', COUNT(*)
  FROM HR.JOBS j
  WHERE j.min_salary IS NOT NULL AND j.max_salary IS NOT NULL
    AND j.min_salary > j.max_salary
  UNION ALL
  SELECT 'HIST-001', 'HISTORY', 'HIGH', 'FAIL',
         'Job history start date after end date', COUNT(*)
  FROM HR.JOB_HISTORY WHERE start_date > end_date
  UNION ALL
  SELECT 'ORG-001', 'HIERARCHY', 'HIGH', 'FAIL',
         'Employee is recorded as own manager', COUNT(*)
  FROM HR.EMPLOYEES WHERE employee_id = manager_id
  UNION ALL
  SELECT 'GEO-001', 'GEOGRAPHY', 'MEDIUM', 'FAIL',
         'Department location reference missing', COUNT(*)
  FROM HR.DEPARTMENTS d
  WHERE d.location_id IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM HR.LOCATIONS l WHERE l.location_id = d.location_id)
)
SELECT
  TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS TZH:TZM') AS captured_at,
  control_id,
  category,
  severity,
  issue_count,
  CASE WHEN issue_count = 0 THEN 'PASS' ELSE on_issue END AS status,
  finding
FROM controls
ORDER BY CASE WHEN issue_count > 0 THEN 0 ELSE 1 END,
         CASE severity WHEN 'HIGH' THEN 1 ELSE 2 END,
         control_id;
