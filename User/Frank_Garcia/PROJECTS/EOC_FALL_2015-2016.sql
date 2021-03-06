USE
Assessments
--BEGIN TRAN

INSERT INTO EOC_

SELECT
	[District Number]
	,[ID Number]
	,[Test ID]
	,Subtest
	,[School Year]
	,[Test Date]
	,School
	,Grade
	,Score1
	,CASE 
		WHEN CS.cut_score IS NULL OR CS.cut_score = '' THEN 'NO CUT SCORE'
		ELSE
		CASE
		WHEN Score1 < CS.cut_score THEN 'FAIL'
		ELSE 'PASS'
		END
	END AS Score2
	,Score3
	,DOB
	,last_name
	,first_name
	,SCH_YR
	,full_name
	,T1.assessment_id
	,CASE 
		WHEN Subtest LIKE '%ALGEBRA%' OR Subtest LIKE '%GEOMETRY%' OR Subtest LIKE '%PRE-CALC%' OR Subtest LIKE '%FINANCIAL%' THEN 'MATH'
		WHEN Subtest LIKE '%ENGLISH%' OR Subtest LIKE '%ELA %' THEN 'ELA'
		WHEN Subtest LIKE '%NEW MEXICO%' OR Subtest LIKE '%US%' OR Subtest LIKE '%WORLD%' OR Subtest LIKE '%ECON%' THEN 'SS'
		WHEN Subtest LIKE '%CHEMISTRY%' OR Subtest LIKE '%PHYSICS%' OR Subtest LIKE '%BIOLOGY%' THEN 'SCI'
	END AS Content
FROM
(
SELECT 
	  '001' AS 'District Number'
      ,[StudentID] AS 'ID Number'
	  ,'EOC' AS 'Test ID'
	  ,Subtest
	  ,[School Year]
	  ,[Test Date]
	  ,[School Code] AS 'School'
	  ,STUD.grade_code AS 'Grade'
	  ,[Raw Score] AS 'Score1'
	  ,'' AS 'Score2'
	  ,'' AS 'Score3'
	  ,STUD.DOB
	  ,STUD.last_name
	  ,STUD.first_name
	  ,[School Year] AS 'SCH_YR'
	  ,Student AS full_name
	  ,CASE
			WHEN Subtest = '2015-2016 Winter EOC Algebra I 7 12 V003' THEN '9000'
			WHEN Subtest = '2015-2016 Winter EOC Algebra II 9 12 V006' THEN '9001'
			WHEN Subtest = '2015-2016 Winter EOC Biology 9 12 V007' THEN '9002'
			WHEN Subtest = '2015-2016 Winter EOC Chemistry 9 12 V008' THEN '9003'
			WHEN Subtest LIKE '2015-2016 Winter EOC Driver%' THEN '9004'
			WHEN Subtest = '2015-2016 Winter EOC Economics 9 12 V004' THEN '9005'
			WHEN Subtest = '2015-2016 Winter EOC ELA III Reading 9 12 V006' THEN '9006'
			WHEN Subtest = '2015-2016 Winter EOC ELA IV Reading 9 12 V003' THEN '9007'
			WHEN Subtest = '2015-2016 Winter EOC ELA III Writing 9 12 V006' THEN '9008'
			WHEN Subtest = '2015-2016 Winter EOC ELA IV Writing 9 12 V003' THEN '9009'
			WHEN Subtest = '2015-2016 Winter EOC Financial Literacy 9 12 V003' THEN '9010'
			WHEN Subtest = '2015-2016 Winter EOC Geometry 9 12 V003' THEN '9011'
			WHEN Subtest = '2015-2016 Winter EOC Health 9 12 V002' THEN '9012'
			WHEN Subtest = '2015-2016 Winter EOC New Mexico History 9 12 V004' THEN '9013'
			WHEN Subtest = '2015-2016 Winter EOC Physics 9 12 V003' THEN '9014'
			WHEN Subtest = '2015-2016 Winter EOC Pre-Calculus 9 12 V004' THEN '9015'
			WHEN Subtest = '2015-2016 Winter EOC US Government Comprehensive 9 12 V005' THEN '9016'
			WHEN Subtest = '2015-2016 Winter EOC US History 9 12 V007' THEN '9017'
			WHEN Subtest = '2015-2016 Winter EOC World History and Geography 9 12 V003' THEN '9018'
	  END AS assessment_id
	  ,'' AS 'Content'
  FROM [Assessments].[dbo].[EOC_2015-2016_Winter] AS EOC
  LEFT JOIN
  ALLSTUDENTS AS STUD
  ON EOC.StudentID = STUD.student_code
) AS T1
LEFT JOIN
EoC_Cut_Scores AS CS
ON T1.assessment_id = CS.assessment_id

ORDER BY assessment_id
--ROLLBACK
--  ALTER TABLE [EOC_]
--ALTER COLUMN [Subtest] VARCHAR (100)