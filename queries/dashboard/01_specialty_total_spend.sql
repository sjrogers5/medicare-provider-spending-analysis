-- DASHBOARD QUERY 1: Top specialties by total spend
-- Powers: Tableau Sheet 1 (top-left bar chart — "Top specialties by total spend")
--
-- What it does:
--   Groups all providers (individuals + organizations) by specialty and sums
--   total Medicare payments. Calculates each specialty's share of the $93.72B total.
--
-- Design note:
--   Includes organizations (labs, ASCs, ambulance companies) alongside physicians.
--   Clinical Laboratory ranks #1 because large commercial labs (Quest, LabCorp)
--   process enormous test volumes — not because individual doctors bill more.
--   For physician-only comparisons, see EDA query 03 or dashboard query 02.

SET @@dataset_id = 'cms';

SELECT
  provider_specialty,
  COUNT(DISTINCT provider_id)                                           AS unique_providers,
  ROUND(SUM(total_paid), 0)                                            AS total_paid,
  ROUND(SUM(total_paid) / (SELECT SUM(total_paid) FROM providers_clean) * 100, 2) AS pct_of_total
FROM providers_clean
GROUP BY provider_specialty
ORDER BY total_paid DESC
LIMIT 20;

/*
RESULTS (top 20 by total paid):
provider_specialty                  | unique_providers | total_paid      | pct_of_total
------------------------------------|------------------|-----------------|-------------
Clinical Laboratory                 | 3,103            | $7,365,997,003  | 7.86%
Ophthalmology                       | 17,001           | $7,246,048,849  | 7.73%
Internal Medicine                   | 88,700           | $6,856,385,932  | 7.32%
Nurse Practitioner                  | 174,677          | $5,693,291,796  | 6.07%
Ambulance Service Provider          | 9,332            | $4,368,020,105  | 4.66%
Family Practice                     | 78,513           | $4,361,948,473  | 4.65%
Ambulatory Surgical Center          | 5,353            | $4,298,258,798  | 4.59%
Diagnostic Radiology                | 31,552           | $3,588,171,849  | 3.83%
Cardiology                          | 19,399           | $3,485,495,792  | 3.72%
Physical Therapist in Private Prac. | 73,457           | $3,310,404,027  | 3.53%
Hematology-Oncology                 | 8,676            | $2,799,274,155  | 2.99%
Dermatology                         | 12,160           | $2,728,498,288  | 2.91%
Physician Assistant                 | 94,996           | $2,340,701,429  | 2.50%
Orthopedic Surgery                  | 20,699           | $2,116,115,611  | 2.26%
Emergency Medicine                  | 47,234           | $1,886,945,102  | 2.01%
Rheumatology                        | 4,906            | $1,810,040,290  | 1.93%
Podiatry                            | 15,193           | $1,549,738,042  | 1.65%
Mass Immunizer Roster Biller        | 28,317           | $1,495,738,695  | 1.60%
Radiation Oncology                  | 4,828            | $1,317,407,348  | 1.41%
Nephrology                          | 9,172            | $1,272,839,888  | 1.36%

Note: Top 10 specialties account for ~54% of all Medicare Part B FFS spending.
Clinical Laboratory ranks #1 because large commercial labs (Quest, LabCorp) process
enormous test volumes — not because individual doctors bill more.
*/
