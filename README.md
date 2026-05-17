# Medicare Provider Spending Analysis

**Tools:** BigQuery SQL · Tableau Public  
**Data:** CMS Medicare Physician & Other Practitioners by Provider and Service, 2023  
**Dashboard:** [View on Tableau Public](https://public.tableau.com/views/medicare-provider-spending-analysis/Dashboard1)

---

## Overview

An exploratory analysis of $93.72 billion in Medicare Part B fee-for-service spending across 1.18 million providers in 2023. The goal was to understand where Medicare money goes, which specialties and providers drive the most spend, and what patterns might be worth flagging from a payment integrity perspective.

The data comes from CMS (Centers for Medicare & Medicaid Services) and covers every Medicare Part B fee-for-service claim submitted by physicians and suppliers in the US in 2023, aggregated by provider, procedure code, and place of service. One important caveat: this dataset covers fee-for-service Medicare only — Medicare Advantage (now ~51% of Medicare enrollees) is not included.

---

## Dashboard

[View interactive dashboard on Tableau Public →](https://public.tableau.com/views/medicare-provider-spending-analysis/Dashboard1)

The dashboard includes four views:
- Top specialties by total Medicare spend (% of $93.72B)
- Average spend per provider by specialty (individual physicians only, sorted descending)
- Drug vs. non-drug spend breakdown by specialty (100% stacked proportional bars)
- Provider spend concentration: top 1% vs. bottom 99%

---

## Key Findings

### 1. Spend is highly concentrated at the top
The top 1% of providers — about 11,753 out of 1.18 million — account for **32.2% of all Medicare Part B spending**, billing at roughly 47x the rate of the average provider. The top 1% averaged $2.56M per provider compared to $54,640 for the bottom 99%. This kind of concentration is exactly what Medicare payment integrity programs look for when prioritizing audits and investigations.

### 2. Drug administration is the primary driver of high-billing specialties
The three highest-billing physician specialties — Ophthalmology ($426K avg/provider), Rheumatology ($369K), and Hematology-Oncology ($323K) — all derive 53–78% of their Medicare revenue from drugs administered in the physician's office and billed under Part B. These are not high-volume visit practices. They are practices where expensive drugs like anti-VEGF eye injections, biologic infusions for rheumatoid arthritis, and chemotherapy run through the physician's billing.

A single drug, **Eylea (aflibercept)**, generated $2.35 billion from only 3,193 ophthalmologists in 2023 — at $687 per milligram with typical monthly dosing for macular degeneration. This single procedure code directly explains why ophthalmology is the highest-billing physician specialty by average spend despite not being the largest specialty by provider count.

### 3. Radiation Oncology reveals a second billing mechanism
Radiation Oncology bills at $273K per provider but is 99% non-drug. Unlike other high-billing specialties, its cost comes entirely from expensive equipment and technical procedures — linear accelerators, treatment planning, imaging. This matters analytically: it shows that two separate mechanisms drive high specialist billing. Knowing which mechanism applies to a specialty changes how you'd investigate anomalies in that specialty's billing.

### 4. Primary care vs. specialist billing gap is structural
Ophthalmologists bill 5.5x more per physician than internists on average ($426K vs. $77K) despite there being five times fewer of them. Family practice physicians average $55K. This gap is not explained by fraud — it reflects how Medicare's fee schedule values procedures and drug administration over cognitive, evaluation-based care. This imbalance is a well-documented policy tension that has driven interest in value-based payment models.

### 5. Nurse Practitioners are now a major force in Medicare billing
With 174,677 NPs generating $5.69B in Part B claims, nurse practitioners represent the largest provider count of any specialty in the top 10 by total spend. Their growing presence in Medicare billing reflects both expanding state practice authority laws and a broader shift toward NPs filling primary care gaps, particularly in rural and underserved areas.

### 6. Arizona shows anomalous high-volume billing patterns
Four of the top five highest-billing individual providers in all of Medicare Part B are Nurse Practitioners in Arizona, with the single highest biller logging $135 million — more than most hospital systems. Arizona has full NP practice authority (no physician oversight required) and a large Medicare-age retirement population. The most likely explanation is large-scale skilled nursing facility billing, where NPs conduct daily nursing home visits across patient networks. Whether this reflects legitimate high-volume practice or a fraud, waste, and abuse pattern is exactly the question a payment integrity analyst would be asked to investigate.

### 7. One wound care product is a significant payment integrity signal
Procedure code Q4262 (wound care membrane) generated **$834 million from only 141 providers** — averaging $5.9 million per provider at $925.97 per unit. Wound care billing is a documented Medicare fraud target area. This level of spend from this few providers at this price point is the kind of concentration pattern that triggers OIG audits and Cotiviti/Optum payment integrity reviews.

### 8. Office-based care dominates — but facility comparisons are tricky
Nearly 70% of Medicare Part B spend ($65.2B) occurs in office settings vs. 30.5% ($28.5B) in facility settings. However, facility-setting dollar amounts in this dataset only reflect the physician's professional fee — Medicare pays the hospital or ASC separately, and that payment is not captured here. Comparing office and facility costs directly is misleading without accounting for this.

---

## Market Context

Understanding Medicare Part B data requires knowing what's happening in the broader market:

**Medicare Advantage is taking over.** About 51% of Medicare beneficiaries were enrolled in Medicare Advantage plans as of 2024, up from roughly 30% a decade ago. MA is privately administered and does not appear in this dataset at all. The patients remaining in fee-for-service tend to be older, sicker, and in areas with fewer MA plan options. The $93.72B analyzed here represents a shrinking portion of total Medicare spending each year.

**Drug prices under Part B are a major policy battleground.** The Inflation Reduction Act (2022) gave Medicare the authority to negotiate drug prices for the first time. The first wave of drugs selected for negotiation in 2023 included several Part B drugs. The high per-provider spend in ophthalmology, rheumatology, and oncology is directly tied to this policy fight — drug price negotiation directly compresses the revenue model of specialties that depend on physician-administered biologics.

**Fee-for-service is what value-based care is replacing.** CMS has been pushing Alternative Payment Models (APMs) and accountable care organizations (ACOs) for over a decade — arrangements where providers are accountable for patient outcomes rather than volume of services. The fee-for-service data in this project is the baseline those models are designed to disrupt. Analysts who understand FFS spend patterns are well-positioned to work on the transition.

**Payment integrity is a growing industry.** CMS spends billions annually on programs to detect and recover improper Medicare payments. Companies like Cotiviti, Optum, and Conduent are contracted to audit claims, flag anomalies, and recover overpayments. The concentration patterns identified in this analysis — the Q4262 wound care outlier, the Arizona NP billing cluster — are exactly the signals these companies are paid to find.

---

## What I Learned

### Technical skills
- Writing multi-step SQL in BigQuery using CTEs (Common Table Expressions) to break complex logic into readable steps
- Using window functions — specifically `NTILE()` for percentile ranking and `SUM() OVER (PARTITION BY)` for within-group percentage calculations — and understanding when each is appropriate
- Recognizing when a query needs to be simplified vs. when complexity is justified by the analytical question
- Connecting BigQuery exports to Tableau and building a multi-sheet dashboard with 100% stacked bars, table calculations, and custom formatting
- Understanding why data needs to be cleaned before visualization — filtering noise specialties with too few providers, handling the organization vs. individual distinction, accounting for place-of-service differences

### Healthcare industry knowledge
- How Medicare Part B fee-for-service works, including the difference between what's billed, what's allowed, and what's paid — and why those three numbers are different
- Why physician-administered drugs appear in Part B billing (the provider buys the drug and administers it in-office — Medicare reimburses both the drug and the administration fee)
- The structural difference between facility and office settings in Medicare claims data — and why mixing them in comparisons leads to misleading conclusions
- What NPI numbers are and how providers are identified in claims data
- The difference between Medicare FFS and Medicare Advantage, and why MA enrollment growth is shrinking the FFS dataset over time
- What payment integrity means in healthcare — fraud, waste, and abuse detection — and how claims data is used to flag outliers for audit
- Why the primary care vs. specialist billing gap exists and why it's a persistent policy issue

---

## Repository Structure

```
medicare-provider-spending-analysis/
├── README.md
├── queries/
│   ├── 00_create_view.sql              # Run this first — creates the base view
│   ├── dashboard/                      # Queries that feed the Tableau dashboard
│   │   ├── 01_specialty_total_spend.sql
│   │   ├── 02_avg_spend_per_provider.sql
│   │   ├── 03_drug_vs_nondrug_by_specialty.sql
│   │   └── 04_provider_concentration.sql
│   └── eda/                            # Exploratory queries run during analysis
│       ├── 01_place_of_service.sql
│       ├── 02_individual_vs_organization.sql
│       ├── 03_specialty_by_entity_type.sql
│       ├── 04_drug_vs_nondrug_overall.sql
│       ├── 05_top_individual_billers.sql
│       ├── 06_geographic_analysis.sql
│       └── 07_top_procedures.sql
└── tableau_data/                       # CSVs exported from BigQuery, used in Tableau
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
4. Run dashboard queries 01–04 to generate the Tableau data exports
5. Connect CSVs to Tableau and replicate the dashboard layout

---

## Data Limitations

- **FFS only:** Excludes Medicare Advantage (~51% of Medicare beneficiaries). The dataset represents a shrinking portion of total Medicare over time.
- **Privacy suppression:** Records with ≤10 beneficiaries are excluded by CMS — rare procedures are underrepresented.
- **Facility payments are incomplete:** In facility settings, this dataset shows only the physician's professional fee, not the separate facility payment to the hospital.
- **Dollar amounts are calculated:** The raw data contains averages per service, not totals. Totals are computed as `avg_paid_per_service × total_services`.
- **One specialty per provider:** CMS assigns a single specialty per NPI based on the provider's majority of claims. Multi-specialty providers are labeled by their dominant billing pattern.
- **No quality signal:** High spending does not imply good or bad care. This analysis is about billing patterns and spend distribution, not outcomes.
