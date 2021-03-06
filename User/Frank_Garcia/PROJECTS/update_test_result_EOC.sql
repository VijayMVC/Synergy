BEGIN TRAN

UPDATE 
	[180-SMAXODS-01].[SchoolNet].[dbo].[EOC_]

--SELECT
--	EOC.STUDENT_CODE
--	,STUD.ID_NBR
--	,STUD.SCH_YR
--	,EOC.school_year
SET
	--School = STUD.SCH_NBR
	--,Grade = STUD.GRDE
	--DOB = STUD.BIRTHDATE
	DOB = LEFT (STUD.BRTH_DT ,4) + '-' + SUBSTRING(CAST (STUD.BRTH_DT AS VARCHAR (20)) ,1,2) +'-'+ SUBSTRING(CAST (STUD.BRTH_DT AS VARCHAR (20)),7,2) 
	,last_name = STUD.LST_NME
	,first_name = STUD.FRST_NME
	--,MI = STUD.M_NME
	--STID = STUD.STATE_ID
	--,[District Number] = '001'
FROM
	[180-SMAXODS-01].[SchoolNet].[dbo].[EOC_] AS EOC
	LEFT JOIN
	[011-SYNERGYDB.APS.EDU.ACTD].[PR].[DBTSIS].[CE020_V] AS STUD
	ON EOC.[ID Number] = CAST (STUD.ID_NBR AS NVARCHAR (50))
	--ON LTRIM(RTRIM(EOC.FIRST_NAME)) = STUD.FRST_NME COLLATE Latin1_General_BIN
	--AND EOC.LAST_NAME   = STUD.LST_NME COLLATE Latin1_General_BIN
	--ON EOC.ID_NBR = CAST(STUD.ID_NBR AS NVARCHAR (50))
--LEFT JOIN
--	[046-WS02].db_STARS_History.dbo.Student AS STUD
--	ON EOC.[ID Number] = STUD.[STUDENT ID]

--WHERE
--	STUD.SY = (EOC.[School Year] + 1)
	--AND STUD.[DISTRICT CODE] = '001'
	--AND school IS NULL
--LEFT JOIN
--	[011-SYNERGYDB.APS.EDU.ACTD].[PR].[DBTSIS].[ST010_V] AS STUD
--	ON EOC.[ID Number] = CAST(STUD.[ID_NBR] AS NVARCHAR (50))
--	AND STUD.SCH_YR = (EOC.[School Year] + 1)
--	AND STUD.DST_NBR = '001'

WHERE EOC.first_name IS NULL
--ORDER BY school_year

ROLLBACK