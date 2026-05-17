-- EDA 1: Spend by place of service (Office vs. Facility)
-- Office = physician's own clinic, full payment in this dataset
-- Facility = hospital/ASC, this dataset only shows the physician fee —
-- the facility's separate payment to the hospital is NOT included
SET @@dataset_id = 'cms';

SELECT
  place_of_service_label,
  COUNT(DISTINCT provider_id)                                         AS unique_providers,
  ROUND(SUM(total_paid), 0)                                          AS total_paid,
  ROUND(SUM(total_paid) / SUM(SUM(total_paid)) OVER () * 100, 2)    AS pct_of_total
FROM providers_clean
GROUP BY place_of_service_label
ORDER BY total_paid DESC;

/*
RESULTS:
place_of_service_label | unique_providers | total_paid       | pct_of_total
-----------------------|------------------|------------------|-------------
Office                 | 826,413          | $65,176,465,919  | 69.54%
Facility               | 584,842          | $28,544,219,135  | 30.46%

Key insight: Nearly 70% of Medicare Part B spend happens in physician offices,
not hospitals. Part B was designed for outpatient physician services — this split
reflects that. Important caveat: facility-setting amounts here show ONLY the
physician fee. Medicare pays hospitals separately, and that payment is not in
this dataset. Never compare office vs. facility dollar amounts directly.
*/
