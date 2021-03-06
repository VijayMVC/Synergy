/****** Script for SelectTopNRows command from SSMS  ******/

SELECT
	DISTINCT 
	[Student Test ID]
	,STU1.first_name
	,STU1.last_name
	,[Test Date]
	,[SY 2016]
	,[Location #]
	,[School Name]
	,[Grade Level]
	,[Student ID]
	,STU2.first_name AS FIRST_NAME_2
	,STU2.last_name AS LAST_NAME_2
	,[ADC APS Math]
	,[ADC APS Reading]
	,[ADC APS Science]
	,[ADC APS Social Studies]
	,[ADC APS Writing]
	,[Test Type]
FROM
(
SELECT 
	   [Student Test ID]
	   ,STU.FIRST_NAME
	   ,STU.last_name
      ,[Test Date]
      ,[SY 2016]
      ,[Location #]
      ,[School Name]
      ,[Grade Level]
      ,[Student ID]
      ,[ADC APS Reading]
      ,[ADC APS Math]
      ,[ADC APS Writing]
      ,[ADC APS Science]
      ,[ADC APS Social Studies]
      ,[Test Type]
  FROM [Assessments].[dbo].[ADC_STUDENT_TESTS]

  LEFT JOIN
  ALLSTUDENTS AS STU
  ON STU.student_code = [Student Test ID]

  WHERE [Student Test ID] != [Student ID]
  --AND STU.school_code = [Location #]
  ) AS STU1
  LEFT JOIN
  ALLSTUDENTS AS STU2
  ON STU2.student_code = [Student ID]
  --AND STU.school_code = [Location #]
  
  ORDER BY STU1.first_name