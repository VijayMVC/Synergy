/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
	  [SY]
      ,[Period]
      ,[DISTRICT CODE]
      ,[LOCATION CODE]
      ,[SCHOOL YEAR DATE]
      ,[STUDENT ID]
      ,[ALTERNATE STUDENT ID]
      ,[MIDDLE INITIAL]
      ,[CURRENT GRADE LEVEL]
      ,[BIRTHDATE]
      ,[GENDER CODE]
      ,[REPEATING LAST YEAR]
      ,[LEP/ELL ELIGIBILITY]
      ,[GRADE 9 ENTRY DATE]
      ,[LAST NAME LONG]
      ,[FIRST NAME LONG]
      ,[HISPANIC INDICATOR]
  FROM [db_STARS_History].[dbo].[STUDENT]
  where ([student id] = '102794807' or [alternate student id] = '102794807')
  --WHERE SY = '2015'
  --WHERE [first NAME LONG] = 'michael' -- AND [FIRST NAME LONG]  = 'GLEN' ---and 
  --and BIRTHDATE = '1998-10-29' 
  --AND SY = '2015'
  ----WHERE [LAST NAME LONG] LIKE 'WEBB%' AND [CURRENT GRADE LEVEL] = '04'  AND SY > '2012'
  --ORDER BY [FIRST NAME LONG]
 ORDER BY SY, [LAST NAME LONG], [FIRST NAME LONG]
  --WHERE sy = '2015'