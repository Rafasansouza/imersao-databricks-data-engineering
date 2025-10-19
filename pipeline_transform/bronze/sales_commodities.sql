CREATE OR REFRESH STREAMING LIVE TABLE lakehouse.bronze.sales_commodities
TBLPROPERTIES ("quality" = "bronze")
AS
SELECT
  *,
  current_timestamp() AS ingestion_ts_utc
FROM STREAM(lakehouse.raw_public.sales_commodities);