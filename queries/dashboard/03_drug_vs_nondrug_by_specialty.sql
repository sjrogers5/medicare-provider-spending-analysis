-- DASHBOARD QUERY 3: Drug vs. non-drug spend breakdown by specialty
-- Powers: Tableau Sheet 4 (bottom-left — 100% stacked bar chart)
--
-- What it does:
--   For 7 selected specialties, calculates what percentage of each specialty's
--   total Medicare billing comes from physician-administered drugs (is_drug = 'Y')
--   vs. procedures, office visits, and other services (is_drug = 'N').
--
-- How the window function works:
--   SUM(SUM(total_paid)) OVER (PARTITION BY provider_specialty) gives the
--   specialty-level total so we can compute drug% within each specialty.
--   Without PARTITION BY, we'd get % of grand total instead of % within specialty.
--
-- Key finding:
--   Rheumatology (78% drug) and Hematology-Oncology (64% drug) derive most of their
--   Medicare revenue from biologics and chemotherapy administered in the office.
--   Radiation Oncology (1% drug) proves the opposite mechanism — cost driven by
--   equipment, not drugs. Internal Medicine and Family Practice are <11% drug.

SET @@dataset_id = 'cms';

SELECT
  provider_specialty,
  is_drug,
  COUNT(DISTINCT provider_id)                                                              AS unique_providers,
  ROUND(SUM(total_paid), 0)                                                               AS total_paid,
  ROUND(SUM(total_paid) / SUM(SUM(total_paid)) OVER (PARTITION BY provider_specialty) * 100, 2) AS pct_of_specialty_spend
FROM providers_clean
WHERE provider_type_code = 'I'
  AND provider_specialty IN (
    'Family Practice',
    'Hematology-Oncology',
    'Internal Medicine',
    'Medical Oncology',
    'Ophthalmology',
    'Radiation Oncology',
    'Rheumatology'
  )
GROUP BY provider_specialty, is_drug
ORDER BY provider_specialty, is_drug DESC;
