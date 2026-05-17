-- EDA 6: Geographic spending patterns by state
-- Uses avg_standardized_per_service to enable fair state-to-state comparison
-- Standardized payments remove geographic wage adjustments (e.g. Manhattan vs. rural Alabama)
-- so differences reflect true practice patterns, not cost-of-living
-- Excludes military postal codes (AA, AE, AP) and unknown territories (XX, ZZ)
SET @@dataset_id = 'cms';

SELECT
  provider_state,
  COUNT(DISTINCT provider_id)                                        AS unique_providers,
  ROUND(SUM(total_services), 0)                                      AS total_services,
  ROUND(SUM(total_paid), 0)                                          AS total_paid,
  ROUND(SUM(total_standardized) / SUM(total_services), 2)            AS avg_standardized_per_service
FROM providers_clean
WHERE provider_type_code = 'I'
  AND provider_state NOT IN ('ZZ', 'XX', 'AA', 'AE', 'AP')
GROUP BY provider_state
ORDER BY avg_standardized_per_service DESC
LIMIT 20;

/*
RESULTS (top 20 states by avg standardized payment per service):
state | unique_providers | total_services  | total_paid       | avg_standardized_per_service
------|------------------|-----------------|------------------|-----------------------------
AS    | 1                | 86              | $5,989           | $75.05  <- territory, noise
FM    | 1                | 497             | $34,067          | $66.43  <- territory, noise
MP    | 24               | 11,864          | $660,950         | $59.04  <- territory, noise
VI    | 158              | 138,308         | $6,840,256       | $50.17  <- territory, noise
HI    | 3,819            | 3,558,311       | $166,923,041     | $46.30
DC    | 3,622            | 4,299,406       | $215,832,024     | $46.02
NH    | 6,568            | 6,290,424       | $283,615,841     | $44.84
WV    | 6,549            | 6,731,791       | $284,616,486     | $44.21
MA    | 34,210           | 40,315,166      | $1,835,866,841   | $43.52
VT    | 2,631            | 2,048,292       | $86,958,477      | $43.38
MT    | 4,348            | 4,853,496       | $206,136,647     | $43.21
AZ    | 22,934           | 58,886,693      | $2,491,128,474   | $42.95
OH    | 44,949           | 46,318,797      | $1,907,302,397   | $42.95
MI    | 37,775           | 39,302,633      | $1,646,598,557   | $42.63
CT    | 15,897           | 16,929,663      | $764,506,272     | $42.56
IN    | 23,313           | 32,251,579      | $1,255,195,623   | $40.98
SD    | 4,088            | 4,922,370       | $192,851,561     | $40.15
WI    | 23,142           | 19,900,498      | $766,480,056     | $40.01
CA    | 88,511           | 198,137,457     | $8,391,303,749   | $39.55
PA    | 55,120           | 76,030,785      | $2,994,279,685   | $39.48

Territories (AS, FM, MP, VI) top the list but have 1-158 providers — statistical noise.
After removing them, geographic variation is narrower than expected (~$46 to ~$39).
Standardization removes wage differences so this reflects true practice pattern variation.
Arizona stands out not for highest per-service cost but for volume: 58.9M services
from 22,934 providers vs. Massachusetts's 40.3M from 34,210 — consistent with the
high-billing NP outlier pattern identified in query 05.
*/
