-- EDA 7: Top 20 procedures by total Medicare spend
-- Covers individual physicians only
-- Mixes high-volume/low-cost (office visits) with low-volume/high-cost (drugs)
-- Key finding: a single wound care product (Q4262) from 141 providers = $834M
SET @@dataset_id = 'cms';

SELECT
  procedure_code,
  procedure_description,
  is_drug,
  COUNT(DISTINCT provider_id)                          AS unique_providers,
  ROUND(SUM(total_services), 0)                        AS total_services,
  ROUND(SUM(total_paid), 0)                            AS total_paid,
  ROUND(SUM(total_paid) / SUM(total_services), 2)      AS avg_paid_per_service
FROM providers_clean
WHERE provider_type_code = 'I'
GROUP BY 1, 2, 3
ORDER BY total_paid DESC
LIMIT 20;
