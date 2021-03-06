/****** Script for SelectTopNRows command from SSMS  ******/
SELECT DISTINCT [SIS ID (by StateID, DOB, Last Name)]
      ,[SIS ID (by State ID + DOB)]
      ,[SIS ID (by State ID)]
      ,[DistrictCode]
      ,[DistrictName]
      ,[Grade]
      ,[LocationID]
      ,[SchoolName]
      ,[StudentID]
      ,[LastName]
      ,[FirstName]
      ,[MI]
      ,[DOB]
      ,[Math_Spring]
      ,[Math_Spring_SS]
      ,[Math_Fall]
      ,[Math_Fall_SS]
      ,[MathPF]
      ,[Reading_Spring]
      ,[Reading_Spring_SS]
      ,[Reading_Fall]
      ,[Reading_Fall_SS]
      ,[ReadingPF]
      ,[Science_Spring]
      ,[Science_Spring_SS]
      ,[SciencePF]
      ,[CompositePF]
      ,[FALL Combo]
      ,[Fall Math]
      ,[Fall Reading]
      ,[Field30]
      ,[High Math]
      ,[Math +11]
      ,[High Read]
      ,[Read +11]
      ,[Field35]
      ,[High Combo]
      ,[SPED]
      ,[ELL]
      ,[FR RED]
      ,[ETHNICITY]
      ,[HISPANIC]
      ,OPENENROLL.ID_NBR
      ,OPENENROLL.SCH_NBR
  FROM [SchoolNetDevelopment].[dbo].[NMSBA_Fall_2012_ALL] AS NMSBA_FALL_2012
  LEFT JOIN
	[180-SMAXODS-01].PR.APS.OpenEnrollments AS OPENENROLL
	ON
	(NMSBA_FALL_2012.[SIS ID (by State ID + DOB)] = CAST (OPENENROLL.ID_NBR AS VARCHAR (9)))
	or
	(NMSBA_FALL_2012.[SIS ID (by StateID, DOB, Last Name)] = CAST (OPENENROLL.ID_NBR AS VARCHAR (9)))

ORDER BY NMSBA_FALL_2012.[SIS ID (by State ID + DOB)]	
