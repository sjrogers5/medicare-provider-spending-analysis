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
