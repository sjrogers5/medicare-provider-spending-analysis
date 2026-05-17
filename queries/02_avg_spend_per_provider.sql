-- Query 2: Average spend per provider by specialty
-- Filtered to individual physicians only (provider_type_code = 'I')
-- Excludes labs, ambulance companies, ASCs — compares apples to apples
-- Minimum 500 providers to exclude statistically insignificant specialties
-- Output used for: Tableau Sheet 3 (top-right bar chart)

SET @@dataset_id = 'cms';

SELECT
  CASE
    WHEN provider_specialty = 'Micrographic Dermatologic Surgery' THEN 'Mohs Surgery'
    ELSE provider_specialty
  END AS provider_specialty,
  COUNT(DISTINCT provider_id)                                                        AS unique_providers,
  ROUND(SUM(total_paid), 0)                                                          AS total_paid,
  ROUND(SUM(total_paid) / COUNT(DISTINCT provider_id), 0)                            AS avg_paid_per_provider,
  ROUND(SUM(total_paid) / (SELECT SUM(total_paid) FROM providers_clean
                            WHERE provider_type_code = 'I') * 100, 2)                AS pct_of_physician_spend
FROM providers_clean
WHERE provider_type_code = 'I'
GROUP BY provider_specialty
HAVING COUNT(DISTINCT provider_id) >= 500
ORDER BY avg_paid_per_provider DESC
LIMIT 10;
