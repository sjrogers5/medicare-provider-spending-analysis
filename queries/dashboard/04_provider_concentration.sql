-- DASHBOARD QUERY 4: Provider spend concentration — top 1% vs. bottom 99%
-- Powers: Tableau Sheet 6 (bottom-right — concentration summary card)
--
-- What it does:
--   Ranks ALL providers (individuals + organizations) into 100 equal-sized groups
--   by total Medicare spend using NTILE(100). Then compares the top group (percentile 1)
--   against the remaining 99 groups combined.
--
-- How NTILE works:
--   NTILE(100) splits the ranked list into 100 buckets of equal size.
--   With ~1.175M providers, each bucket = ~11,753 providers.
--   Percentile 1 = the top 11,753 highest-billing providers.
--   OVER (ORDER BY provider_total_paid DESC) sorts highest to lowest first,
--   so percentile 1 = top spenders (not bottom).
--
-- Key finding:
--   The top 1% of providers (~11,753) account for 32.2% of all Medicare Part B
--   spending, averaging $2.56M per provider vs. $54,640 for the bottom 99%.
--   This concentration is a core focus of Medicare payment integrity programs.

SET @@dataset_id = 'cms';

WITH provider_totals AS (
  SELECT
    provider_id,
    SUM(total_paid) AS provider_total_paid
  FROM providers_clean
  GROUP BY provider_id
),
ranked AS (
  SELECT
    provider_id,
    provider_total_paid,
    NTILE(100) OVER (ORDER BY provider_total_paid DESC) AS spend_percentile
  FROM provider_totals
)
SELECT
  CASE WHEN spend_percentile = 1 THEN 'Top 1%' ELSE 'Bottom 99%' END AS provider_group,
  COUNT(DISTINCT provider_id)                                          AS provider_count,
  ROUND(SUM(provider_total_paid), 0)                                   AS total_paid,
  ROUND(SUM(provider_total_paid) / (SELECT SUM(total_paid) FROM providers_clean) * 100, 2) AS pct_of_total_spend,
  ROUND(AVG(provider_total_paid), 0)                                   AS avg_paid_per_provider
FROM ranked
GROUP BY 1
ORDER BY 1 DESC;

/*
RESULTS:
provider_group | provider_count | total_paid       | pct_of_total_spend | avg_paid_per_provider
---------------|----------------|------------------|--------------------|----------------------
Top 1%         | 11,753         | $30,146,192,783  | 32.17%             | $2,564,979
Bottom 99%     | 1,163,507      | $63,574,492,271  | 67.83%             | $54,640

Key insight: The top 1% of providers bill at 47x the rate of the average provider
in the bottom 99%. This level of concentration is a primary focus of Medicare
payment integrity programs — audits and investigations are prioritized toward
high-volume, high-spend outliers.
*/
