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
