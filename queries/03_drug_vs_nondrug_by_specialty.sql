-- Query 3: Drug vs. non-drug spend breakdown by specialty
-- Shows what proportion of each specialty's Medicare billing is drug-related
-- (drugs administered in-office billed under Part B vs. procedures/visits)
-- Output used for: Tableau Sheet 4 (bottom-left 100% stacked bar chart)

SET @@dataset_id = 'cms';

SELECT
  provider_specialty,
  is_drug,
  COUNT(DISTINCT provider_id)                                                              AS unique_providers,
  ROUND(SUM(total_paid), 0)                                                               AS total_paid,
  ROUND(SUM(total_paid) / SUM(SUM(total_paid)) OVER (PARTITION BY provider_specialty) * 100, 2) AS pct_of_specialty_spend
FROM providers_clean
WHERE provider_specialty IN (
  'Family Practice',
  'Hematology-Oncology',
  'Internal Medicine',
  'Medical Oncology',
  'Ophthalmology',
  'Radiation Oncology',
  'Rheumatology'
)
GROUP BY provider_specialty, is_drug
ORDER BY provider_specialty, is_drug;
