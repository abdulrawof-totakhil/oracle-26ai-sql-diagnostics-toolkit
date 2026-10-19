-- CONTROL GROUP: PAY | Configured ranges and observed assignments
-- A range exception is not automatically a payroll mistake.
SELECT
  j.job_id,
  j.job_title,
  j.min_salary AS policy_min_salary,
  j.max_salary AS policy_max_salary,
  COUNT(e.employee_id) AS employee_count,
  SUM(CASE
        WHEN e.employee_id IS NOT NULL AND e.salary IS NOT NULL
         AND ((j.min_salary IS NOT NULL AND e.salary < j.min_salary)
           OR (j.max_salary IS NOT NULL AND e.salary > j.max_salary))
        THEN 1 ELSE 0 END) AS outside_policy_range,
  ROUND(AVG(e.salary), 2) AS average_salary
FROM HR.JOBS j
LEFT JOIN HR.EMPLOYEES e ON e.job_id = j.job_id
GROUP BY j.job_id, j.job_title, j.min_salary, j.max_salary
ORDER BY outside_policy_range DESC, j.job_id;
