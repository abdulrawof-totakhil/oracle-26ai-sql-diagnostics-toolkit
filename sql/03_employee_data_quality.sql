-- CONTROL GROUP: DQ | Direct continuation of validated exercise 02
-- DQ-002 is REVIEW only: a NULL department can be legitimate in HR.
SELECT
  COUNT(*) AS total_employees,
  SUM(CASE WHEN email IS NULL THEN 1 ELSE 0 END) AS missing_email,
  SUM(CASE WHEN department_id IS NULL THEN 1 ELSE 0 END) AS missing_department,
  SUM(CASE WHEN salary IS NULL OR salary <= 0 THEN 1 ELSE 0 END) AS invalid_salary,
  SUM(CASE WHEN hire_date > TRUNC(SYSDATE) THEN 1 ELSE 0 END) AS future_hire_date
FROM HR.EMPLOYEES;
