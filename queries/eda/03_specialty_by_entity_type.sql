-- EDA 3: Top specialties by avg spend per provider, split by entity type
-- Mixing individual doctors and organizations in one ranking is misleading —
-- a clinical lab (org) will always dwarf a physician on avg spend.
-- This query shows both together so you can see why the split matters.
SET @@dataset_id = 'cms';

SELECT
  provider_specialty,
  provider_type_code,
  COUNT(DISTINCT provider_id)                                       AS unique_providers,
  ROUND(SUM(total_paid), 0)                                         AS total_paid,
  ROUND(SUM(total_paid) / COUNT(DISTINCT provider_id), 0)           AS avg_paid_per_provider,
  ROUND(SUM(total_paid) / SUM(SUM(total_paid)) OVER () * 100, 2)   AS pct_of_total_spend
FROM providers_clean
GROUP BY provider_specialty, provider_type_code
ORDER BY avg_paid_per_provider DESC
LIMIT 20;
