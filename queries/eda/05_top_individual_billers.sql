-- EDA 5: Top 10 highest-billing individual providers
-- Sorted by total Medicare paid across all their procedures
-- Notable finding: top billers are concentrated in specific states and specialties
-- Arizona NPs dominate the top 5 — a potential payment integrity signal
SET @@dataset_id = 'cms';

SELECT
  provider_id,
  provider_specialty,
  provider_state,
  ROUND(SUM(total_paid), 0) AS provider_total_paid
FROM providers_clean
WHERE provider_type_code = 'I'
GROUP BY 1, 2, 3
ORDER BY provider_total_paid DESC
LIMIT 10;

/*
RESULTS (top 10 highest-billing individual providers):
provider_id | provider_specialty  | provider_state | provider_total_paid
------------|---------------------|----------------|--------------------
1255987475  | Nurse Practitioner  | AZ             | $135,258,784
1174182760  | Nurse Practitioner  | AZ             | $123,873,262
1700860715  | Podiatry            | AZ             | $91,262,648
1417543117  | Nurse Practitioner  | AZ             | $62,941,991
1225551484  | Nurse Practitioner  | AZ             | $49,920,484
1003053851  | Internal Medicine   | CA             | $43,170,235
1376521773  | Geriatric Medicine  | CT             | $41,743,309
1023311040  | General Practice    | NV             | $33,219,043
1174718134  | Internal Medicine   | CA             | $31,709,035
1811149685  | Family Practice     | CO             | $27,133,945

Payment integrity flag: 4 of the top 5 highest-billing individual providers in all
of Medicare Part B are Nurse Practitioners in Arizona, with the top biller at $135M.
For context, most large physician group practices bill far less than this per individual NPI.
Arizona has full NP practice authority — NPs can operate without physician oversight.
The most likely explanation is large-scale skilled nursing facility billing across
patient networks, but this concentration pattern is exactly what triggers OIG scrutiny.
*/
