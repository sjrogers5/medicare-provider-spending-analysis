-- DASHBOARD QUERY 2: Avg spend per provider by specialty (physicians only)
-- Powers: Tableau Sheet 3 (top-right bar chart — "Avg spend per provider by specialty")
--
-- What it does:
--   Filters to individual physicians only (provider_type_code = 'I') to remove
--   labs, ambulance companies, and surgical centers from the comparison.
--   Requires >= 500 providers per specialty to exclude noise from rare specialties
--   (e.g. "Portable X-Ray Supplier" with 3 providers would otherwise rank near the top).
--
-- Key finding:
--   Ophthalmology, Rheumatology, and Hematology-Oncology lead — driven by
--   expensive drugs administered in-office and billed under Part B, not visit volume.
--   Radiation Oncology is the exception: high billing with almost zero drug spend,
--   driven entirely by expensive equipment and technical procedures.

SET @@dataset_id = 'cms';

SELECT
  CASE
    WHEN provider_specialty = 'Micrographic Dermatologic Surgery' THEN 'Mohs Surgery'
    ELSE provider_specialty
  END                                                                    AS provider_specialty,
  COUNT(DISTINCT provider_id)                                            AS unique_providers,
  ROUND(SUM(total_paid), 0)                                              AS total_paid,
  ROUND(SUM(total_paid) / COUNT(DISTINCT provider_id), 0)                AS avg_paid_per_provider,
  ROUND(SUM(total_paid) / (SELECT SUM(total_paid) FROM providers_clean
                            WHERE provider_type_code = 'I') * 100, 2)    AS pct_of_physician_spend
FROM providers_clean
WHERE provider_type_code = 'I'
GROUP BY provider_specialty
HAVING COUNT(DISTINCT provider_id) >= 500
ORDER BY avg_paid_per_provider DESC
LIMIT 10;

/*
RESULTS (top 10 individual physicians, >= 500 providers, sorted by avg):
provider_specialty                  | unique_providers | avg_paid_per_provider | total_paid      | pct_of_physician_spend
------------------------------------|------------------|-----------------------|-----------------|------------------------
Ophthalmology                       | 17,001           | $426,213              | $7,246,048,849  | 9.87%
Rheumatology                        | 4,906            | $368,944              | $1,810,040,290  | 2.47%
Hematology-Oncology                 | 8,676            | $322,646              | $2,799,274,155  | 3.81%
Nuclear Medicine                    | 511              | $302,933              | $154,798,820    | 0.21%
Radiation Oncology                  | 4,828            | $272,868              | $1,317,407,348  | 1.79%
Medical Oncology                    | 3,632            | $235,209              | $854,278,267    | 1.16%
Dermatology                         | 12,160           | $224,383              | $2,728,498,288  | 3.72%
Clinical Cardiac Electrophysiology  | 2,458            | $203,527              | $500,270,323    | 0.68%
Interventional Cardiology           | 4,410            | $189,142              | $834,118,083    | 1.14%
Interventional Pain Management      | 1,478            | $187,034              | $276,436,372    | 0.38%

Note: The HAVING >= 500 filter removes noise specialties with tiny provider counts
(e.g. "Portable X-Ray Supplier" with 3 providers averaged $371K — not meaningful).
Ophthalmology leads due to anti-VEGF drug injections (Eylea, Vabysmo) billed under Part B.
Radiation Oncology is the outlier: high billing driven by equipment/technology, not drugs.
*/
