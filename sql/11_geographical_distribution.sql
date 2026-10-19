-- CONTROL GROUP: GEO | Public sample HR geography | READ ONLY
-- Aggregation avoids publishing row-level personally identifying data.
SELECT
  r.region_name,
  c.country_name,
  COUNT(DISTINCT l.location_id) AS location_count,
  COUNT(DISTINCT d.department_id) AS department_count,
  COUNT(DISTINCT e.employee_id) AS employee_count
FROM HR.REGIONS r
JOIN HR.COUNTRIES c ON c.region_id = r.region_id
LEFT JOIN HR.LOCATIONS l ON l.country_id = c.country_id
LEFT JOIN HR.DEPARTMENTS d ON d.location_id = l.location_id
LEFT JOIN HR.EMPLOYEES e ON e.department_id = d.department_id
GROUP BY r.region_name, c.country_name
HAVING COUNT(DISTINCT l.location_id) > 0
ORDER BY employee_count DESC, r.region_name, c.country_name;
