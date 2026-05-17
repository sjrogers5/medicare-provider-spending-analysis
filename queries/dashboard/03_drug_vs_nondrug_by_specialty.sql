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

/*
RESULTS:
provider_specialty    | is_drug | unique_providers | total_paid      | pct_of_specialty_spend
----------------------|---------|------------------|-----------------|------------------------
Family Practice       | true    | 35,093           | $456,030,542    | 10.45%
Family Practice       | false   | 78,505           | $3,905,917,930  | 89.55%
Hematology-Oncology   | true    | 2,851            | $1,797,682,736  | 64.22%
Hematology-Oncology   | false   | 8,672            | $1,001,591,418  | 35.78%
Internal Medicine     | true    | 26,445           | $579,042,307    | 8.45%
Internal Medicine     | false   | 88,681           | $6,277,343,625  | 91.55%
Medical Oncology      | true    | 928              | $546,692,643    | 63.99%
Medical Oncology      | false   | 3,631            | $307,585,624    | 36.01%
Ophthalmology         | true    | 4,098            | $3,839,730,264  | 52.99%
Ophthalmology         | false   | 17,000           | $3,406,318,585  | 47.01%
Radiation Oncology    | true    | 277              | $8,657,095      | 0.66%
Radiation Oncology    | false   | 4,828            | $1,308,750,252  | 99.34%
Rheumatology          | true    | 2,732            | $1,408,251,171  | 77.80%
Rheumatology          | false   | 4,906            | $401,789,119    | 22.20%

Key insight: Rheumatology (77.8% drug) and Hematology-Oncology (64.2% drug) are
essentially drug-administration businesses billed through physician offices.
Radiation Oncology (0.66% drug) is the opposite — high billing from equipment alone.
Primary care (Internal Medicine 8.45%, Family Practice 10.45%) is almost entirely non-drug.
*/
