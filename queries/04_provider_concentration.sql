-- Query 4: Provider spend concentration — top 1% vs. bottom 99%
-- Uses NTILE(100) window function to rank all providers into 100 equal groups
-- by total Medicare spend, then compares the top group to the rest.
-- Output used for: Tableau Sheet 6 (bottom-right concentration chart)

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
  ROUND(SUM(provider_total_paid), 0)                                  AS total_paid,
  ROUND(SUM(provider_total_paid) / (SELECT SUM(total_paid) FROM providers_clean) * 100, 2) AS pct_of_total_spend,
  ROUND(AVG(provider_total_paid), 0)                                  AS avg_paid_per_provider
FROM ranked
GROUP BY 1
ORDER BY 1 DESC;
