-- CONTROL GROUP: META | READ ONLY | No DBA privileges required
-- ALL_OBJECTS shows accessible objects, not the whole database inventory.
SELECT
  owner,
  object_type,
  status,
  COUNT(*) AS object_count
FROM ALL_OBJECTS
WHERE owner = 'HR'
  AND object_type IN ('TABLE', 'VIEW', 'INDEX', 'PROCEDURE', 'FUNCTION', 'TRIGGER')
GROUP BY owner, object_type, status
ORDER BY object_type, status;
