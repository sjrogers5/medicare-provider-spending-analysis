# Medicare Provider Spending Analysis

**Tools:** BigQuery (SQL) · Tableau Public  
**Data:** CMS Medicare Physician & Other Practitioners by Provider and Service, 2023  
**Dashboard:** [View on Tableau Public](https://public.tableau.com/views/medicare-provider-spending-analysis/Dashboard1)

---

## Project Overview

An end-to-end analysis of $93.72 billion in Medicare Part B fee-for-service spending across 1.18 million providers in 2023. Built to practice healthcare analytics skills and demonstrate SQL analysis and data visualization for portfolio purposes.

The dataset comes from the Centers for Medicare & Medicaid Services (CMS) and covers every Medicare Part B fee-for-service claim submitted by physicians and suppliers in the US in 2023 — aggregated by provider, procedure code, and place of service.

---

## Key Findings

### 1. Spend is highly concentrated
The top 1% of providers (~11,753 out of 1.18M) account for **32.2% of all Medicare Part B spending** — billing at roughly 47x the rate of the average provider below them. The top 1% averaged $2.56M per provider vs. $54,640 for the bottom 99%.

### 2. Drug administration drives high-billing specialties
The three highest-billing physician specialties — Rheumatology ($369K avg/provider), Hematology-Oncology ($323K), and Ophthalmology ($426K) — direct 53–78% of their Medicare billing toward drugs administered in-office. A single drug, **Eylea (aflibercept)**, generated $2.35B from only 3,193 ophthalmologists — directly explaining why ophthalmology is the highest-billing physician specialty by average spend.

### 3. Radiation Oncology reveals a second billing mechanism
Radiation Oncology bills at $273K per provider but is 99.3% non-drug. Its high spend is driven entirely by expensive equipment and technical procedures — not drug administration. This distinguishes two separate mechanisms behind high specialist billing: **drugs** and **technology**.

### 4. A single wound care product is a payment integrity flag
Procedure code Q4262 (wound care membrane) generated **$834M from only 141 providers** — $5.9M per provider on average at $925.97 per unit. This level of concentration from this few providers at this price point matches the pattern that triggers OIG audits and Medicare payment integrity reviews.

### 5. Arizona shows anomalous volume patterns
Four of the top five highest-billing individual providers in all of Medicare are Nurse Practitioners in Arizona, with the single highest biller logging $135M. Arizona has full NP practice authority and a large Medicare population, but this concentration warrants scrutiny as a potential fraud, waste, and abuse signal.

---

## Dashboard

[![Dashboard Preview](https://public.tableau.com/static/images/me/medicare-provider-spending-analysis/Dashboard1/1.png)](https://public.tableau.com/views/medicare-provider-spending-analysis/Dashboard1)

[View interactive dashboard on Tableau Public →](https://public.tableau.com/views/medicare-provider-spending-analysis/Dashboard1)

**Dashboard includes:**
- KPI tiles: total spend, unique providers, avg per provider, top 1% concentration
- Top specialties by total spend (% of $93.72B)
- Avg spend per provider by specialty (individual physicians only)
- Drug vs. non-drug spend breakdown by specialty (100% stacked)
- Provider spend concentration: top 1% vs. bottom 99%

---

## Repository Structure

```
medicare-provider-spending-analysis/
├── README.md
├── queries/
│   ├── 00_create_view.sql          # Base view creation — run first
│   ├── 01_specialty_total_spend.sql
│   ├── 02_avg_spend_per_provider.sql
│   ├── 03_drug_vs_nondrug_by_specialty.sql
│   └── 04_provider_concentration.sql
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
4. Run queries 01–04 to generate the analysis outputs
5. Export results as CSV and connect to Tableau

---

## Data Limitations

- **FFS only:** Excludes Medicare Advantage (~51% of Medicare beneficiaries as of 2024). This dataset represents a shrinking share of total Medicare over time.
- **Privacy suppression:** Records with ≤10 beneficiaries are excluded by CMS, meaning rare procedures are underrepresented.
- **Facility payments are partial:** When services occur in hospital settings, this dataset shows only the physician's professional fee — not the facility fee paid separately to the hospital.
- **Dollar amounts are calculated:** Raw data contains averages per service, not totals. Totals are computed as `avg_paid × total_services`.
- **Specialty assignment:** CMS assigns one specialty per provider based on the majority of their claims. Providers who practice across multiple specialties are labeled by their dominant billing pattern.
- **No quality signal:** High spending does not imply good or bad care. This analysis is about billing patterns, not outcomes.

---

## About

Built as a portfolio project while transitioning into healthcare analytics. Analysis focuses on identifying spend concentration, specialty-level billing patterns, and payment integrity signals using publicly available CMS data.
