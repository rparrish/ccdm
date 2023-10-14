-- !preview conn=conn <- dbConnect(duckdb("Data/ccdm_demo.db"))


CREATE OR REPLACE  TABLE encounters AS

SELECT
*

FROM admissions a
INNER JOIN patients p
    ON p.subject_id = a.subject_id

