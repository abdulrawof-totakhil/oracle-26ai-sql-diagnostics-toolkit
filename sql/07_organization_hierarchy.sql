-- CONTROL GROUP: ORG | Hierarchical query | READ ONLY
-- NOCYCLE prevents looping if the source contains a reporting cycle.
-- A reporting path shows IDs only, to minimize unnecessary personal data.
SELECT
  LEVEL AS reporting_depth,
  e.employee_id,
  e.manager_id,
  e.department_id,
  SYS_CONNECT_BY_PATH(TO_CHAR(e.employee_id), '/') AS reporting_path
FROM HR.EMPLOYEES e
START WITH e.manager_id IS NULL
CONNECT BY NOCYCLE PRIOR e.employee_id = e.manager_id
ORDER SIBLINGS BY e.employee_id;
