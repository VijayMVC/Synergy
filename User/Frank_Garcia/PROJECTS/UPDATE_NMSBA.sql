
UPDATE
	db_Logon.dbo.NMSBA1213StudentResults001
SET 
	db_Logon.dbo.NMSBA1213StudentResults001.NASISID = STARS.[ALTERNATE STUDENT ID]

FROM
	db_Logon.dbo.NMSBA1213StudentResults001 AS SBA
	LEFT JOIN
	[db_STARS_History].[dbo].[STUDENT] AS STARS
	ON
	SBA.rptStudID = [STARS].[STUDENT ID]
WHERE
	--STARS.[DISTRICT CODE] = '001'
	--AND	STARS.SY = '2011'
	 SBA.NASISID IS NULL
	



