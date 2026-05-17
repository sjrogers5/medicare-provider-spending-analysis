-- EDA 4: Drug vs. non-drug split across all individual physicians
-- is_drug = 'Y' means the procedure code is a physician-administered drug
-- billed under Medicare Part B (e.g. chemotherapy, biologics, eye injections)
-- These drugs are a key driver of high per-provider spend in certain specialties
SET @@dataset_id = 'cms';

SELECT
  is_drug,
  COUNT(DISTINCT provider_id)                                       AS unique_providers,
  ROUND(SUM(total_paid), 0)                                         AS total_paid,
  ROUND(SUM(total_paid) / SUM(SUM(total_paid)) OVER () * 100, 2)   AS pct_of_total,
  ROUND(SUM(total_services), 0)                                     AS total_services,
  ROUND(SUM(total_paid) / COUNT(DISTINCT provider_id), 0)           AS avg_paid_per_provider
FROM providers_clean
WHERE provider_type_code = 'I'
GROUP BY is_drug
ORDER BY total_paid DESC;

/*
RESULTS (individual physicians only):
is_drug | unique_providers | total_paid       | pct_of_total | total_services    | avg_paid_per_provider
--------|------------------|------------------|--------------|-------------------|-----------------------
false   | 1,113,310        | $61,277,258,198  | 83.47%       | 1,114,685,457     | $55,041
true    | 180,776          | $12,135,188,918  | 16.53%       | 870,622,727       | $67,128

Key insight: Drug billing represents 16.5% of total individual physician Medicare
spend but is concentrated in a small subset of providers (180K out of 1.1M).
Providers who DO bill drugs average slightly more per provider ($67K vs $55K)
because drug-administering specialties are inherently high-billing.
The real story is in the specialty-level breakdown (see query 03 in dashboard).
*/
