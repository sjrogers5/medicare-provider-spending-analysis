# Medicare Provider Spending Analysis

**Tools:** BigQuery SQL · Tableau Public  
**Data:** CMS Medicare Physician & Other Practitioners by Provider and Service, 2023  
**Dashboard:** [View on Tableau Public](https://public.tableau.com/views/medicare-provider-spending-analysis/Dashboard1)

---

## Overview

This project explores $93.72 billion in Medicare Part B fee-for-service payments across 1.18 million providers in 2023. I wanted to understand where Medicare money actually goes — which specialties drive the most spend, what separates high-billing providers from average ones, and what patterns might look unusual from a payment integrity standpoint.

The dataset comes from CMS (Centers for Medicare & Medicaid Services) and covers every Part B fee-for-service claim submitted by physicians and suppliers in the US in 2023, aggregated by provider, procedure code, and place of service. One thing worth knowing upfront: this is fee-for-service Medicare only. Medicare Advantage, which now covers about 51% of Medicare enrollees, doesn't appear here at all.

---

## Dashboard

[View on Tableau Public](https://public.tableau.com/views/medicare-provider-spending-analysis/Dashboard1)

Four views:
- Top specialties by total Medicare spend
- Average spend per provider by specialty (individual physicians only)
- Drug vs. non-drug spend by specialty (100% stacked)
- Provider spend concentration: top 1% vs. bottom 99%

---

## Key Findings

**Spend is more concentrated than I expected.** The top 1% of providers — about 11,753 out of 1.18 million — account for 32% of all Medicare Part B spending. They average $2.56M per provider. The bottom 99% average $54K. That's a 47x gap.

**The highest-billing physician specialties are essentially drug-administration businesses.** Rheumatology, Hematology-Oncology, and Ophthalmology each direct 53-78% of their Medicare revenue toward drugs administered in the physician's office — biologics for rheumatoid arthritis, chemotherapy, anti-VEGF eye injections. One drug alone, Eylea (aflibercept), generated $2.35 billion from 3,193 ophthalmologists. That single procedure code explains most of why ophthalmology leads the per-provider rankings.

**Radiation Oncology is the exception.** It ranks among the highest-billing physician specialties but is 99% non-drug. The cost comes from equipment — linear accelerators, treatment planning, imaging. Two different mechanisms drive high specialist billing: drugs and technology. Knowing which one applies changes how you'd investigate an outlier.

**The primary care vs. specialist gap is structural.** Ophthalmologists average $426K per provider. Internists average $77K. Family practice physicians average $55K. This isn't fraud — it's how Medicare's fee schedule works. Procedures and drug administration pay more than cognitive, visit-based care. It's a well-documented policy tension.

**Arizona keeps showing up.** Four of the top five highest-billing individual providers in all of Medicare are Nurse Practitioners in Arizona. The top biller: $135 million from a single NPI. Arizona has full NP practice authority and a large Medicare-age population. The likely explanation is high-volume skilled nursing facility billing, but this kind of concentration is exactly what payment integrity analysts are paid to look at.

**One wound care product is a real outlier.** Procedure code Q4262 generated $834 million from 141 providers at $925.97 per square centimeter. That's $5.9 million per provider on average. Wound care billing is a documented Medicare fraud target, and this concentration pattern — very few providers, very high spend, very high unit price — matches what shows up in OIG audit reports.

---

## Market Context

**Medicare Advantage is taking over.** About 51% of Medicare beneficiaries are now in Medicare Advantage plans, up from roughly 30% a decade ago. MA is privately administered and doesn't show up in this dataset. The patients still in fee-for-service tend to be older and in areas with fewer MA options. The $93.72B here is a shrinking slice of total Medicare spending.

**Drug prices under Part B are a major policy fight.** The Inflation Reduction Act (2022) gave Medicare the authority to negotiate drug prices for the first time. The first drugs selected included several Part B drugs. The high per-provider billing in ophthalmology, rheumatology, and oncology is directly tied to this — those specialties depend on the spread between what they pay for drugs and what Medicare reimburses.

**Fee-for-service is what value-based care is trying to replace.** CMS has been pushing accountable care organizations and alternative payment models for over a decade — arrangements where providers are accountable for outcomes, not just volume. This dataset is the baseline those models are designed to move away from. Analysts who understand fee-for-service spend patterns are well-positioned to work on the transition.

**Payment integrity is a growing industry.** CMS contracts companies like Cotiviti and Optum to detect and recover improper Medicare payments. The outliers in this analysis — the Q4262 wound care concentration, the Arizona NP cluster — are the kinds of signals those companies are paid to find.

---

## What I Learned

### Technical

I built all the queries in BigQuery starting from a base view I created with renamed columns and calculated totals (avg paid × total services). From there, the analysis involved:

- Writing aggregation queries with GROUP BY, SUM, COUNT(DISTINCT), ROUND, and AVG across a 9.6M row dataset
- Filtering with WHERE to isolate individual physicians from organizations (provider_type_code = 'I') — a distinction that completely changes the specialty rankings
- Using HAVING to filter out specialties with too few providers, which removed noise from the top of the rankings
- Writing CASE WHEN logic to recode raw CMS codes (provider type codes, place of service codes) into readable labels
- Using window functions to calculate within-group percentages — specifically SUM() OVER (PARTITION BY specialty) to get drug spend as a share of each specialty's total, rather than a share of the grand total
- Connecting BigQuery exports to Tableau and building a multi-sheet dashboard with KPI tiles, sorted bar charts, 100% stacked bars with custom table calculations, and a concentration summary

### Healthcare

- How Medicare Part B works — what it covers, what it doesn't, and why physician-administered drugs show up in physician billing
- The difference between Medicare fee-for-service and Medicare Advantage, and why MA enrollment growth means this dataset is becoming less representative over time
- What an NPI is and how providers are identified in claims data
- Why facility-setting dollar amounts in this dataset are incomplete — they only show the physician fee, not the separate payment to the hospital
- What payment integrity means in practice — fraud, waste, and abuse detection — and how claims concentration patterns get flagged
- Why the primary care vs. specialist billing gap exists and why it keeps coming up in healthcare policy

---

## Repository Structure

```
medicare-provider-spending-analysis/
├── README.md
├── queries/
│   ├── 00_create_view.sql              # Run first — creates the base view
│   ├── dashboard/                      # Queries that feed the Tableau dashboard
│   │   ├── 01_specialty_total_spend.sql
│   │   ├── 02_avg_spend_per_provider.sql
│   │   ├── 03_drug_vs_nondrug_by_specialty.sql
│   │   └── 04_provider_concentration.sql
│   └── eda/                            # Exploratory queries
│       ├── 01_place_of_service.sql
│       ├── 02_individual_vs_organization.sql
│       ├── 03_specialty_by_entity_type.sql
│       ├── 04_drug_vs_nondrug_overall.sql
│       ├── 05_top_individual_billers.sql
│       ├── 06_geographic_analysis.sql
│       └── 07_top_procedures.sql
└── tableau_data/
    ├── 01_specialty_total_spend.csv
    ├── 02_physician_specialty_avg_per_provider.csv
    ├── 03_drug_vs_nondrug_by_specialty.csv
    ├── 06_concentration_summary.csv
    └── 07_kpi_summary.csv
```

---

## How to Reproduce

1. Download the [CMS 2023 Medicare Physician & Other Practitioners dataset](https://data.cms.gov/provider-summary-by-type-of-service/medicare-physician-other-practitioners/medicare-physician-other-practitioners-by-provider-and-service)
2. Load into BigQuery as `cms.medicare_data`
3. Run `queries/00_create_view.sql` to create the `providers_clean` view
4. Run the dashboard queries to generate exports
5. Connect the CSVs to Tableau

---

## Data Limitations

- FFS only — Medicare Advantage (~51% of beneficiaries) is not included
- Records with 10 or fewer beneficiaries are suppressed by CMS for privacy
- Facility-setting amounts show the physician fee only, not the facility's separate payment
- Dollar totals are calculated: avg paid per service × total services (the raw data has no pre-computed totals)
- Each provider gets one specialty label based on their majority of claims — providers who practice across multiple specialties get assigned to one
- High spending doesn't imply good or bad care — this is billing data, not outcomes data
