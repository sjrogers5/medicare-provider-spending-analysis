-- EDA 7: Top 20 procedures by total Medicare spend
-- Covers individual physicians only
-- Mixes high-volume/low-cost (office visits) with low-volume/high-cost (drugs)
-- Key finding: a single wound care product (Q4262) from 141 providers = $834M
SET @@dataset_id = 'cms';

SELECT
  procedure_code,
  procedure_description,
  is_drug,
  COUNT(DISTINCT provider_id)                          AS unique_providers,
  ROUND(SUM(total_services), 0)                        AS total_services,
  ROUND(SUM(total_paid), 0)                            AS total_paid,
  ROUND(SUM(total_paid) / SUM(total_services), 2)      AS avg_paid_per_service
FROM providers_clean
WHERE provider_type_code = 'I'
GROUP BY 1, 2, 3
ORDER BY total_paid DESC
LIMIT 20;

/*
RESULTS (top 20 procedures by total Medicare paid, individual physicians):
code   | description                              | drug  | providers | total_services | total_paid      | avg_per_service
-------|------------------------------------------|-------|-----------|----------------|-----------------|----------------
99214  | Office visit 30-39 min                   | false | 479,505   | 99,336,985     | $8,231,995,685  | $82.87
99213  | Office visit 20-29 min                   | false | 457,138   | 70,163,894     | $4,123,015,208  | $58.76
J0178  | Aflibercept (Eylea) injection, 1mg       | true  | 3,193     | 3,421,435      | $2,350,558,554  | $687.01
99232  | Subsequent hospital care (moderate)      | false | 177,380   | 34,797,543     | $2,143,369,921  | $61.60
99233  | Subsequent hospital care (longer)        | false | 128,815   | 21,652,123     | $2,026,932,450  | $93.61
99215  | Office visit 40-54 min                   | false | 145,525   | 11,126,713     | $1,340,802,620  | $120.50
99204  | New patient office visit 45-59 min       | false | 227,063   | 11,396,179     | $1,280,903,852  | $112.40
99223  | Initial hospital care (moderate)         | false | 139,579   | 9,474,003      | $1,266,499,374  | $133.68
99285  | ED visit, high complexity                | false | 61,345    | 8,497,101      | $1,163,810,118  | $136.97
J9271  | Pembrolizumab (Keytruda) 1mg             | true  | 1,841     | 27,083,045     | $1,154,350,197  | $42.62
97110  | Therapeutic exercise, per 15 min         | false | 79,997    | 63,753,552     | $1,150,859,342  | $18.05
G0439  | Annual wellness visit (subsequent)       | false | 105,852   | 9,739,283      | $1,145,161,241  | $117.58
J2777  | Faricimab (Vabysmo) 0.1mg               | true  | 2,036     | 33,436,399     | $966,562,246    | $28.91
99309  | Nursing facility care (moderate/day)     | false | 28,091    | 12,273,087     | $924,351,602    | $75.32
97530  | Therapeutic activities                   | false | 62,716    | 36,069,479     | $911,620,535    | $25.27
99291  | Critical care, first 30-74 min           | false | 71,287    | 5,325,958      | $902,770,789    | $169.50
J0897  | Denosumab (Prolia) 1mg                  | true  | 10,057    | 48,034,893     | $875,043,253    | $18.22
Q4262  | Wound care membrane, per sq cm           | true  | 141       | 900,953        | $834,254,090    | $925.97
92014  | Eye exam, established patient            | false | 35,415    | 9,315,489      | $782,563,365    | $84.01
97112  | Neuromuscular reeducation, per 15 min    | false | 61,939    | 29,111,650     | $630,148,816    | $21.65

Key findings:
- 99214 (office visit) = #1 by total spend at $8.2B — wins on volume (99M services), not price
- J0178 (Eylea) = $2.35B from only 3,193 providers — directly explains ophthalmology's high avg billing
- Q4262 (wound care membrane) = $834M from 141 providers at $925.97/sq cm — payment integrity flag
- J9271 (Keytruda) and J2777 (Vabysmo) confirm drug concentration in oncology and ophthalmology
*/
