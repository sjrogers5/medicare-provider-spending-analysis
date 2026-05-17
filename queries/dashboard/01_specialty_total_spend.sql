-- DASHBOARD QUERY 1: Top specialties by total spend
-- Powers: Tableau Sheet 1 (top-left bar chart — "Top specialties by total spend")
--
-- What it does:
--   Groups all providers (individuals + organizations) by specialty and sums
--   total Medicare payments. Calculates each specialty's share of the $93.72B total.
--
-- Design note:
--   Includes organizations (labs, ASCs, ambulance companies) alongside physicians.
--   Clinical Laboratory ranks #1 because large commercial labs (Quest, LabCorp)
--   process enormous test volumes — not because individual doctors bill more.
--   For physician-only comparisons, see EDA query 03 or dashboard query 02.

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
