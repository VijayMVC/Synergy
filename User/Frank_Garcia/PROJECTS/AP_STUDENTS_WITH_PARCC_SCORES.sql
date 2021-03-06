/****** Script for SelectTopNRows command from SSMS  ******/
--SELECT
--	   [SCHOOL_CODE]
--      ,[SCHOOL_NAME]
--      ,[SIS_NUMBER]
--      ,[FIRST_NAME]
--      ,[LAST_NAME]
--      ,[MIDDLE_NAME]
--      ,[COURSE_ID]
--      ,[COURSE_TITLE]
--      ,[SECTION_ID]
--      ,[TERM_CODE]
--      ,[FIRST_NAME_1]
--      ,[LAST_NAME_1]
--      ,[GRADE_LEVEL]
--      ,[Race1]
--      ,[Race2]
--      ,[Race3]
--      ,[Race4]
--      ,[Race5]
--      ,[HISPANIC_INDICATOR]
--      ,[GENDER]
--      ,[ELA 11 2015-2016]
--      ,[ELA 11 READING]
--      ,[ELA 11 WRITING]
--      ,[ALGEBRA 1]
--      ,[ALGEBRA 2]
--      ,[GEOMETRY]
--      ,[ELA 09]
--      ,[ELA 10]
--      ,[ELA 11 2014-2015]

	  UPDATE [TRASH_AP Students w PARCC scores 042516]
	  SET 
	  [ELA 10 2015-2016] = summativeScaleScore
	  ,[ELA 10 PL 2015-2016] = summativePerformanceLevel
	  --[GEOMETRY 2015-2016] = summativeScaleScore
	  --,[GEOMETRY PL 2015-2016] = summativePerformanceLevel
	  --[ALGEBRA 2 2015-2016] = summativeScaleScore
	  --,[ALGEBRA 2 PL 2015-2016] = summativePerformanceLevel
	  --[ALGEBRA 1 2015-2016] = PPF.summativeScaleScore
	  --,[ALGEBRA 1 PL 2015-2016] = PPF.summativePerformanceLevel
	  --[ELA 10 2014-205] = PPF.summativeScaleScore
	  --,[ELA 10 PL 2014-2015] = PPF.summativePerformanceLevel
	  --[GEOMETRY 2014-2015] = PPF.summativeScaleScore
	  --,[GEOMETRY PL 2014-2015] = PPF.summativePerformanceLevel
	  --[ALGEBRA 2 2014-2015] = PPF.summativeScaleScore
	  --,[ALGEBRA 2 PL 2014-2015] = PPF.summativePerformanceLevel
	  --,[ELA 11 READING 2015-2016] = PPF.summativeReadingScaleScore
	  --,[ELA 11 WRITING 2015-2016] = PPF.summativeWritingScaleScore
	  --,[ELA 11 PL 2015-2016] = summativePerformanceLevel
  FROM [Assessments].[dbo].[TRASH_AP Students w PARCC scores 042516] AS AP
  LEFT JOIN
  PARCC_PEARSON_FILE AS PPF
  ON AP.STATE_ID = PPF.stateStudentIdentifier

  WHERE PPF.testCode = 'ELA10' AND PPF.assessmentYear = '2015-2016'