-- EDA 6: Geographic spending patterns by state
-- Uses avg_standardized_per_service to enable fair state-to-state comparison
-- Standardized payments remove geographic wage adjustments (e.g. Manhattan vs. rural Alabama)
-- so differences reflect true practice patterns, not cost-of-living
-- Excludes military postal codes (AA, AE, AP) and unknown territories (XX, ZZ)
SET @@dataset_id = 'cms';

SELECT
  provider_state,
  COUNT(DISTINCT provider_id)                                        AS unique_providers,
  ROUND(SUM(total_services), 0)                                      AS total_services,
  ROUND(SUM(total_paid), 0)                                          AS total_paid,
  ROUND(SUM(total_standardized) / SUM(total_services), 2)            AS avg_standardized_per_service
FROM providers_clean
WHERE provider_type_code = 'I'
  AND provider_state NOT IN ('ZZ', 'XX', 'AA', 'AE', 'AP')
GROUP BY provider_state
ORDER BY avg_standardized_per_service DESC
LIMIT 20;
