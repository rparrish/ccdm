-- !preview conn=conn <- dbConnect(duckdb("Data/ccdm_demo.db"))

-- DROP TABLE IF EXISTS patients;

CREATE OR REPLACE TEMP TABLE patients AS

SELECT * FROM read_csv_auto("Data/mimic-iv-demo/hosp/patients.csv.gz");



