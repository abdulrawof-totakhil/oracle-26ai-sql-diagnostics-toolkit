-- CONTROL GROUP: ORG | Department-level aggregation only | READ ONLY
-- Unstaffed departments are informational; not necessarily a failure.
SELECT
  d.department_id,
  d.department_name,
  COUNT(e.employee_id) AS employee_count,
  ROUND(AVG(e.salary), 2) AS average_salary,
  SUM(CASE WHEN e.employee_id IS NOT NULL AND e.manager_id IS NULL
      THEN 1 ELSE 0 END) AS no_manager_count,
  CASE WHEN COUNT(e.employee_id) = 0 THEN 'UNSTAFFED' ELSE 'STAFFED' END
    AS department_status
FROM HR.DEPARTMENTS d
LEFT JOIN HR.EMPLOYEES e ON e.department_id = d.department_id
GROUP BY d.department_id, d.department_name
ORDER BY employee_count DESC, d.department_id;
