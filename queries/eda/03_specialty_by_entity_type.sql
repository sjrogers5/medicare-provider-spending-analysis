-- EDA 3: Top specialties by avg spend per provider, split by entity type
-- Mixing individual doctors and organizations in one ranking is misleading —
-- a clinical lab (org) will always dwarf a physician on avg spend.
-- This query shows both together so you can see why the split matters.
SET @@dataset_id = 'cms';

SELECT
  provider_specialty,
  provider_type_code,
  COUNT(DISTINCT provider_id)                                       AS unique_providers,
  ROUND(SUM(total_paid), 0)                                         AS total_paid,
  ROUND(SUM(total_paid) / COUNT(DISTINCT provider_id), 0)           AS avg_paid_per_provider,
  ROUND(SUM(total_paid) / SUM(SUM(total_paid)) OVER () * 100, 2)   AS pct_of_total_spend
FROM providers_clean
GROUP BY provider_specialty, provider_type_code
ORDER BY avg_paid_per_provider DESC
LIMIT 20;

/*
RESULTS (top 20 by avg spend per provider, mixed individuals + organizations):
provider_specialty                 | type | unique_providers | avg_paid_per_provider | pct_of_total
-----------------------------------|------|------------------|-----------------------|-------------
Clinical Laboratory                | O    | 3,074            | $2,396,145            | 7.86%
All Other Suppliers                | O    | 52               | $1,598,095            | 0.09%
Radiation Therapy Center           | O    | 25               | $1,063,291            | 0.03%
Ambulatory Surgical Center         | O    | 5,353            | $802,963              | 4.59%
Portable X-Ray Supplier            | O    | 281              | $718,540              | 0.22%
Micrographic Dermatologic Surgery  | I    | 357              | $584,491              | 0.22%
Ambulance Service Provider         | O    | 9,327            | $468,247              | 4.66%
Indep. Diagnostic Testing Facility | O    | 1,943            | $453,205              | 0.94%
Ophthalmology                      | I    | 17,001           | $426,213              | 7.73%
Portable X-Ray Supplier            | I    | 3                | $371,579              | 0.00%  <- noise
Rheumatology                       | I    | 4,906            | $368,944              | 1.93%
Hematology-Oncology                | I    | 8,676            | $322,646              | 2.99%
Nuclear Medicine                   | I    | 511              | $302,933              | 0.17%
Peripheral Vascular Disease        | I    | 56               | $275,048              | 0.02%  <- noise
Radiation Oncology                 | I    | 4,828            | $272,868              | 1.41%
Opioid Treatment Program           | O    | 842              | $255,516              | 0.23%
Medical Oncology                   | I    | 3,632            | $235,209              | 0.91%
Dermatology                        | I    | 12,160           | $224,383              | 2.91%
Clinical Cardiac Electrophysiology | I    | 2,458            | $203,527              | 0.53%
Slide Preparation Facility         | O    | 8                | $191,508              | 0.00%  <- noise

This is why filtering matters: mixing O and I providers inflates the top of the
ranking with facility-type entities. Rows marked "noise" have too few providers
to draw conclusions from.
*/
