-- CONTROL GROUP: HIST | Analytic function detects overlapping HR job ranges.
-- A history entry starting on prior_end_date is flagged for business review.
WITH history_ordered AS (
  SELECT
    employee_id,
    job_id,
    start_date,
    end_date,
    LAG(end_date) OVER (
      PARTITION BY employee_id ORDER BY start_date, end_date, job_id
    ) AS previous_end_date
  FROM HR.JOB_HISTORY
)
SELECT
  employee_id,
  job_id,
  TO_CHAR(start_date, 'YYYY-MM-DD') AS start_date,
  TO_CHAR(end_date, 'YYYY-MM-DD') AS end_date,
  CASE
    WHEN start_date > end_date THEN 'INVALID_RANGE'
    WHEN previous_end_date IS NOT NULL
         AND start_date <= previous_end_date THEN 'REVIEW_OVERLAP'
    ELSE 'OK'
  END AS timeline_check
FROM history_ordered
ORDER BY employee_id, start_date, end_date;
