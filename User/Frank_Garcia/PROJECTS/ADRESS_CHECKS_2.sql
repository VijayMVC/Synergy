BEGIN TRAN
SELECT
	

	CASE
	WHEN DWELLING.STR_NME LIKE 'PO %' THEN ('P. O.' + ' '+ SUBSTRING(DWELLING.STR_NME, 3,9))
	ELSE DWELLING.STR_NME END AS THUG
	--LTRIM (DWELLING.HSE_NBR)END AS STR_NME 
	
	,LTRIM (LTRIM (DWELLING.HSE_NBR) + ' ' + LTRIM (DWELLING.STR_NME)  + ' ' + LTRIM (DWELLING.STR_TAG) + ' ' + LTRIM (DWELLING.STR_DIR) + ' ' + LTRIM (DWELLING.CITY) + ' ' + DWELLING.[STATE] + ' ' + LTRIM (LEFT (DWELLING.ZIP_CD, 5)))
	AS ADDY_2
FROM DBTSIS.CE005_V AS DWELLING	
--WHERE 
--DWELLING.STR_NME LIKE 'PO %'
ORDER BY THUG
ROLLBACK