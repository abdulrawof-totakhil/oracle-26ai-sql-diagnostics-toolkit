-- CONTROL GROUP: ENV | Oracle FreeSQL 26ai | READ ONLY
-- Capture execution date, session schema, and the current Oracle version family.
-- Do NOT publish unredacted database or session identifiers.
SELECT
  TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS TZH:TZM') AS captured_at,
  SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS current_schema,
  SYS_CONTEXT('USERENV', 'SESSION_USER') AS session_user,
  'HR public sample dataset' AS dataset_scope
FROM DUAL;
