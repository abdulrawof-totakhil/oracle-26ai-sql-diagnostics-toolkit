-- CONTROL GROUP: EXCEPTIONS | Minimal identifiers only | READ ONLY
-- Returns actionable exceptions; an empty result means no matching findings.
-- A missing department and salary-band deviations require business review.
SELECT
  'DQ-002' AS control_id, 'REVIEW' AS disposition,
  e.employee_id, e.job_id, e.department_id,
  'Employee has no department; verify business rule' AS observation
FROM HR.EMPLOYEES e
WHERE e.department_id IS NULL
UNION ALL
SELECT
  'DQ-003', 'FAIL', e.employee_id, e.job_id, e.department_id,
  'Salary is missing, zero, or negative'
FROM HR.EMPLOYEES e
WHERE e.salary IS NULL OR e.salary <= 0
UNION ALL
SELECT
  'DQ-004', 'REVIEW', e.employee_id, e.job_id, e.department_id,
  'Hire date is in the future'
FROM HR.EMPLOYEES e
WHERE e.hire_date > TRUNC(SYSDATE)
UNION ALL
SELECT
  'RI-001', 'FAIL', e.employee_id, e.job_id, e.department_id,
  'Job reference does not exist'
FROM HR.EMPLOYEES e
WHERE NOT EXISTS (SELECT 1 FROM HR.JOBS j WHERE j.job_id = e.job_id)
UNION ALL
SELECT
  'RI-002', 'FAIL', e.employee_id, e.job_id, e.department_id,
  'Department reference does not exist'
FROM HR.EMPLOYEES e
WHERE e.department_id IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM HR.DEPARTMENTS d WHERE d.department_id = e.department_id
  )
UNION ALL
SELECT
  'RI-003', 'FAIL', e.employee_id, e.job_id, e.department_id,
  'Manager reference does not exist'
FROM HR.EMPLOYEES e
WHERE e.manager_id IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM HR.EMPLOYEES m WHERE m.employee_id = e.manager_id
  )
UNION ALL
SELECT
  'PAY-001', 'REVIEW', e.employee_id, e.job_id, e.department_id,
  'Salary outside the configured job range; assess exceptions'
FROM HR.EMPLOYEES e
JOIN HR.JOBS j ON j.job_id = e.job_id
WHERE e.salary IS NOT NULL
  AND (
    (j.min_salary IS NOT NULL AND e.salary < j.min_salary)
    OR (j.max_salary IS NOT NULL AND e.salary > j.max_salary)
  )
ORDER BY control_id, employee_id;
