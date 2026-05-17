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
