-- Query 1: Top specialties by total Medicare spend
-- Covers all provider types (individuals + organizations)
-- Output used for: Tableau Sheet 1 (top-left bar chart)

SET @@dataset_id = 'cms';

SELECT
  provider_specialty,
  COUNT(DISTINCT provider_id)                                           AS unique_providers,
  ROUND(SUM(total_paid), 0)                                            AS total_paid,
  ROUND(SUM(total_paid) / (SELECT SUM(total_paid) FROM providers_clean) * 100, 2) AS pct_of_total
FROM providers_clean
GROUP BY provider_specialty
ORDER BY total_paid DESC
LIMIT 20;
