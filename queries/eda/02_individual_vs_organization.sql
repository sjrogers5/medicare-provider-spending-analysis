-- EDA 2: Individual physicians vs. organizations/facilities
-- provider_type_code = 'I' → single person (doctor, NP, PA, PT, etc.)
-- provider_type_code = 'O' → facility entity (lab, ASC, ambulance company)
-- Key finding: orgs are 5% of entities but average 5x more spend per entity
SET @@dataset_id = 'cms';

SELECT
  CASE
    WHEN provider_type_code = 'I' THEN 'Individual Physician'
    WHEN provider_type_code = 'O' THEN 'Organization / Facility'
    ELSE 'Other'
  END                                                               AS entity_type,
  COUNT(DISTINCT provider_id)                                       AS unique_providers,
  ROUND(SUM(total_paid), 0)                                         AS total_paid,
  ROUND(SUM(total_paid) / COUNT(DISTINCT provider_id), 0)           AS avg_paid_per_provider,
  ROUND(SUM(total_paid) / SUM(SUM(total_paid)) OVER () * 100, 2)   AS pct_of_total_spend
FROM providers_clean
GROUP BY entity_type
ORDER BY total_paid DESC;

/*
RESULTS:
entity_type              | unique_providers | total_paid       | avg_paid_per_provider | pct_of_total_spend
-------------------------|------------------|------------------|-----------------------|-------------------
Individual Physician     | 1,113,396        | $73,412,447,116  | $65,936               | 78.33%
Organization / Facility  | 61,864           | $20,308,237,938  | $328,272              | 21.67%

Key insight: Organizations are only 5% of provider entities but average 5x more
spend per entity than individual physicians ($328K vs $66K). This is driven by
high-volume facilities — commercial labs, ambulance companies, surgical centers —
not because organizations bill higher rates per service. Always filter by
provider_type_code when doing physician-specific analysis.
*/
