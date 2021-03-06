BEGIN TRAN

--SELECT
--STUD.FULL_NME
----,STUD.LST_NME
--,EOC.LAST_NAME
----,STUD.FRST_NME
--,EOC.FIRST_NAME
--,STUD.SCH_NBR
--,EOC.school_code
--,EOC.student_code
--,STUD.ID_NBR
--,EOC.test_level_name
--,STUD.GRDE
----,LEFT (STUD.BRTH_DT ,4) + '-' + SUBSTRING(CAST (STUD.BRTH_DT AS VARCHAR (20)) ,1,2) +'-'+ SUBSTRING(CAST (STUD.BRTH_DT AS VARCHAR (20)),7,2) AS BOD
--,EOC.DOB
----,STUD.GRDE
----,STUD.SCH_NBR

UPDATE 
	[180-SMAXODS-01].[SchoolNet].[dbo].[TEST_RESULT_ACT]
SET
	school_CODE = STUD.SCH_NBR
	,test_level_name = STUD.GRDE
	--,DOB = STUD.BRTH_DT
	--DOB = LEFT (STUD.BRTH_DT ,4) + '-' + SUBSTRING(CAST (STUD.BRTH_DT AS VARCHAR (20)) ,1,2) +'-'+ SUBSTRING(CAST (STUD.BRTH_DT AS VARCHAR (20)),7,2) 
	--last_name = STUD.LST_NME
	--,first_name = STUD.FRST_NME
	--,MI = STUD.M_NME
	--STID = STUD.STATE_ID
--	--,[District Number] = '001'
FROM
	[180-SMAXODS-01].[SchoolNet].[dbo].[TEST_RESULT_ACT] AS EOC
	--LEFT JOIN
	--SMAXDBPROD.[PR].[DBTSIS].[CE020_V] AS STUD
	--ON EOC.[ID Number] = CAST (STUD.ID_NBR AS NVARCHAR (50))
	--ON LTRIM(RTRIM(EOC.FIRST_NAME)) = STUD.FRST_NME COLLATE Latin1_General_BIN
	--AND EOC.LAST_NAME   = STUD.LST_NME COLLATE Latin1_General_BIN
	--ON EOC.ID_NBR = CAST(STUD.ID_NBR AS NVARCHAR (50))
LEFT JOIN
	SMAXDBPROD.[PR].[DBTSIS].[ST010_V] AS STUD
	ON EOC.[student_code] = CAST(STUD.[ID_NBR] AS NVARCHAR (50))
	AND STUD.SCH_YR = (EOC.[School_Year] + 1)
	AND STUD.DST_NBR = '001'
--LEFT JOIN
--	[180-SMAXODS-01].[PR].[DBTSIS].[SY010_V] AS STUD
--	ON EOC.[ID NUMBER] = STUD.[ID_NBR]
	--WHERE EOC.School IS NULL
--LEFT JOIN
--	[046-WS02].db_STARS_History.dbo.STUDENT AS STUD
--	ON
--	EOC.[ID Number] = STUD.[ALTERNATE STUDENT ID]
--AND STUD.SY = EOC.SCH_YR + 1
--WHERE EOC.School < 200 AND EOC.School != '048'
WHERE LTRIM(RTRIM(EOC.school_code)) IS NULL OR school_code = ''

ROLLBACK