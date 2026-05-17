-- EDA 4: Drug vs. non-drug split across all individual physicians
-- is_drug = 'Y' means the procedure code is a physician-administered drug
-- billed under Medicare Part B (e.g. chemotherapy, biologics, eye injections)
-- These drugs are a key driver of high per-provider spend in certain specialties
SET @@dataset_id = 'cms';

SELECT
  is_drug,
  COUNT(DISTINCT provider_id)                                       AS unique_providers,
  ROUND(SUM(total_paid), 0)                                         AS total_paid,
  ROUND(SUM(total_paid) / SUM(SUM(total_paid)) OVER () * 100, 2)   AS pct_of_total,
  ROUND(SUM(total_services), 0)                                     AS total_services,
  ROUND(SUM(total_paid) / COUNT(DISTINCT provider_id), 0)           AS avg_paid_per_provider
FROM providers_clean
WHERE provider_type_code = 'I'
GROUP BY is_drug
ORDER BY total_paid DESC;
