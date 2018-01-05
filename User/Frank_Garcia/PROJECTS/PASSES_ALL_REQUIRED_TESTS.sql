/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
      School
      ,COUNT ([Passed All Required Tests])AS 'Passed All Required Tests'
  FROM [SchoolNetDevelopment].[dbo].[Exit_Exam_Status]
  WHERE [Passed All Required Tests] = 'YES'
  GROUP BY 
	School
	ORDER BY School