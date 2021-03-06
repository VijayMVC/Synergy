--SELECT
--[ID Number]
--,School
--,[Algebra I 7 12 V001]
--,[Algebra II 10 12 V002]
--,[Biology 9 12 V002]
--,[Biology 9 12 V003]
--,[Chemistry 9 12 V002]
--,[Chemistry 9 12 V003]
--,[Economics 9 12 V001]
--,[English Language Arts III Reading 11 11 V001]
--,[English Language Arts III Reading 11 11 V002]
--,[English Language Arts III Writing 11 11 V001]
--,[English Language Arts III Writing 11 11 V002]
--,[English Language Arts IV Reading 12 12 V001]
--,[English Language Arts IV Writing 12 12 V001]
--,[Health Education 6 12 V001]
--,[New Mexico History 7 12 V001]
--,[NM History 7 12 V001]
--,[Social Studies 6 6 V001]
--,[Spanish Language Arts III Reading 11 11 V001]
--,[Spanish Language Arts III Writing 11 11 V001]
--,[US Government Comprehensive 9 12 V001]
--,[US Government Comprehensive 9 12 V002]
--,[US History 9 12 V001]
--,[US History 9 12 V002]
--,[World History And Geography 9 12 V001]

--FROM

--(
SELECT
*
FROM
(
SELECT [District Number]
      ,[ID Number]
      ,[Test ID]
      ,[Subtest]
      --,[School Year]
--,CASE	
--	WHEN SUBTEST = 'Algebra I 7 12 V001' THEN Score2 END AS 'PASS/FAIL_Algebra I 7 12 V001'
--	,CASE WHEN SUBTEST = 'English Language Arts III Writing 11 11 V001' THEN SCORE2 END AS 'PASS/FAIL_English Language Arts III Writing 11 11 V001'
--	,CASE	
--	WHEN SUBTEST = 'Algebra I 7 12 V002' THEN Score2 END AS 'PASS/FAIL_Algebra I 7 12 V002'

	,[School]
      ,[Grade]
      --,[Score1]
      ,[Score2]
      ,[DOB]
      ,[last_name]
      ,[first_name]
      --,[SCH_YR]
      ,[full_name]
      --,[assessment_id]
  FROM [SchoolNet].[dbo].[EOC_]
  ) AS T1
  pivot
  (max([SCORE2]) FOR SUBTEST IN ([Algebra I 7 12 V001],[Algebra II 10 12 V002],[Biology 9 12 V002],[Biology 9 12 V003],[Chemistry 9 12 V002],[Chemistry 9 12 V003],[Economics 9 12 V001],[English Language Arts III Reading 11 11 V001],[English Language Arts III Reading 11 11 V002],[English Language Arts III Writing 11 11 V001],[English Language Arts III Writing 11 11 V002],[English Language Arts IV Reading 12 12 V001],[English Language Arts IV Writing 12 12 V001],[Health Education 6 12 V001],[New Mexico History 7 12 V001],[NM History 7 12 V001],[Social Studies 6 6 V001],[Spanish Language Arts III Reading 11 11 V001],[Spanish Language Arts III Writing 11 11 V001],[US Government Comprehensive 9 12 V001],[US Government Comprehensive 9 12 V002],[US History 9 12 V001],[US History 9 12 V002],[World History And Geography 9 12 V001])) AS UP1
--) AS T2 
--where [ID Number] = '100016526'
 ORDER BY [ID Number]