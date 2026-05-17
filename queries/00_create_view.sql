-- Medicare Provider Spending Analysis
-- Step 0: Create the base view
-- Run this first before any other queries.
-- Dataset: CMS Medicare Physician & Other Practitioners by Provider and Service, 2023

CREATE OR REPLACE VIEW cms.providers_clean AS
SELECT
  Rndrng_NPI                    AS provider_id,
  Rndrng_Prvdr_Last_Org_Name    AS provider_last_or_org_name,
  Rndrng_Prvdr_First_Name       AS provider_first_name,
  Rndrng_Prvdr_Crdntls          AS provider_credentials,
  Rndrng_Prvdr_Ent_Cd           AS provider_type_code,       -- 'I' = Individual, 'O' = Organization
  Rndrng_Prvdr_City             AS provider_city,
  Rndrng_Prvdr_State_Abrvtn     AS provider_state,
  Rndrng_Prvdr_RUCA             AS rural_urban_code,
  Rndrng_Prvdr_Type             AS provider_specialty,
  Rndrng_Prvdr_Mdcr_Prtcptg_Ind AS accepts_medicare,
  HCPCS_Cd                      AS procedure_code,
  HCPCS_Desc                    AS procedure_description,
  HCPCS_Drug_Ind                AS is_drug,                  -- 'Y' = drug administered by physician
  Place_Of_Srvc                 AS place_of_service,         -- 'F' = Facility, 'O' = Office
  Tot_Benes                     AS total_patients,
  Tot_Srvcs                     AS total_services,
  Avg_Sbmtd_Chrg                AS avg_billed_per_service,
  Avg_Mdcr_Alowd_Amt            AS avg_allowed_per_service,
  Avg_Mdcr_Pymt_Amt             AS avg_paid_per_service,
  Avg_Mdcr_Stdzd_Amt            AS avg_standardized_per_service,
  ROUND(Avg_Mdcr_Pymt_Amt * Tot_Srvcs, 2)   AS total_paid,
  ROUND(Avg_Mdcr_Alowd_Amt * Tot_Srvcs, 2)  AS total_allowed,
  ROUND(Avg_Mdcr_Stdzd_Amt * Tot_Srvcs, 2)  AS total_standardized,
  CASE
    WHEN Place_Of_Srvc = 'F' THEN 'Facility'
    WHEN Place_Of_Srvc = 'O' THEN 'Office'
    ELSE 'Other'
  END AS place_of_service_label
FROM cms.medicare_data;
