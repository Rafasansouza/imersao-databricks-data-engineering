CREATE OR REFRESH STREAMING LIVE TABLE bitcoin
TBLPROPERTIES ("quality" = "bronze")
AS
SELECT
  *
FROM
  cloud_files(
    '/Volumes/lakehouse/raw/coinbase/coinbase/bitcoin_spot/',
    'json',
    map(
      'cloudFiles.includeExistingFiles', 'false',
      'cloudFiles.inferColumnTypes', 'true',
      'cloudFiles.schemaEvolutionMode', 'addNewColumns'
    )
  )