-- !preview conn=conn <- dbConnect(duckdb("Data/ccdm_demo.db"))

-- DROP TABLE IF EXISTS admissions;

CREATE OR REPLACE TEMP TABLE admissions AS

SELECT * FROM read_csv_auto("Data/mimic-iv-demo/hosp/admissions.csv.gz");



