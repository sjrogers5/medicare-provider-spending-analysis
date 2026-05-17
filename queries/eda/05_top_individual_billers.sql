-- EDA 5: Top 10 highest-billing individual providers
-- Sorted by total Medicare paid across all their procedures
-- Notable finding: top billers are concentrated in specific states and specialties
-- Arizona NPs dominate the top 5 — a potential payment integrity signal
SET @@dataset_id = 'cms';

SELECT
  provider_id,
  provider_specialty,
  provider_state,
  ROUND(SUM(total_paid), 0) AS provider_total_paid
FROM providers_clean
WHERE provider_type_code = 'I'
GROUP BY 1, 2, 3
ORDER BY provider_total_paid DESC
LIMIT 10;
