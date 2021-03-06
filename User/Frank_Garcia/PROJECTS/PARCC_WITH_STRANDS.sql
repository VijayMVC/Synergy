USE [Assessments]
GO
/****** Object:  StoredProcedure [dbo].[test_result_Iowa_sp]    Script Date: 12/7/2015 3:58:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--ALTER procedure [dbo].[test_result_Iowa_sp] AS
/****
 
 * $LastChangedBy: Terri Christiansen
 * $LastChangedDate: 5/16/2013 $
 *
 * Request By: SchoolNet
 * InitialRequestDate: 
 * 
 * Initial Request:
 * SchoolNet
 * Tables Referenced:  Experiment with a Standardized test layout.
	In this case, IOWA 
****/



--TRUNCATE TABLE dbo.test_result_PARCC_SUB_CLAIMS

DECLARE @SCHOOL_YEAR VARCHAR(50) = '2014-2015'
DECLARE @TEST_DATE VARCHAR (50) = '2015-01-01'

--INSERT INTO dbo.test_result_IAAT
/* This requires a pivot, so experiment with syntax */


SELECT
	   --[student_code]
    --  ,[school_year]
    --  ,[school_code]
    --  ,[test_date_code]
    --  ,[test_type_code]
    --  ,[test_type_name]
    DISTINCT [test_section_code]
     ,[test_section_name]
      ,[parent_test_section_code]
      --,[low_test_level_code]
      --,[high_test_level_code]
      --,[test_level_name]
      --,[version_code]
      --,[score_group_name]
      --,[score_group_code]
      --,[score_group_label]
      --,[last_name]
      --,[first_name]
      --,[DOB]
      --,[raw_score]
      --,[scaled_score]
      --,[nce_score]
      --,[percentile_score]
      --,[score_1]
      --,[score_2]
      --,[score_3]
      --,[score_4]
      --,[score_5]
      --,[score_6]
      --,[score_7]
      --,[score_8]
      --,[score_9]
      --,[score_10]
      --,[score_11]
      --,[score_12]
      --,[score_13]
      --,[score_14]
      --,[score_15]
      --,[score_16]
      --,[score_17]
      --,[score_18]
      --,[score_19]
      --,[score_20]
      --,[score_21]
      --,[score_raw_name]
      --,[score_scaled_name]
      --,[score_nce_name]
      --,[score_percentile_name]
      --,[score_1_name]
      --,[score_2_name]
      --,[score_3_name]
      --,[score_4_name]
      --,[score_5_name]
      --,[score_6_name]
      --,[score_7_name]
      --,[score_8_name]
      --,[score_9_name]
      --,[score_10_name]
      --,[score_11_name]
      --,[score_12_name]
      --,[score_13_name]
      --,[score_14_name]
      --,[score_15_name]
      --,[score_16_name]
      --,[score_17_name]
      --,[score_18_name]
      --,[score_19_name]
      --,[score_20_name]
      --,[score_21_name]

FROM
(

SELECT
	student_code 
	,school_year
	,school_code
	,test_date_code
	,test_type_code
	,test_type_name
	,test_section_code
	,test_section_name
	,parent_test_section_code
	,low_test_level_code
	,high_test_level_code
	,test_level_name
	,version_code
	,score_group_name 
	,score_group_code
	,score_group_label
	,last_name
	,first_name
	,DOB
	,raw_score
	,scaled_score
	,nce_score
	,percentile_score
	,score_1
	,score_2
	,score_3
	,score_4
	,score_5
	,score_6
	,score_7
	,score_8
	,score_9
	,score_10
	,score_11
	,score_12
	,score_13
	,score_14
	,score_15
	,score_16
	,score_17
	,score_18
	,score_19
	,score_20
	,score_21
	,score_raw_name
	,score_scaled_name
	,score_nce_name
	,score_percentile_name
	,score_1_name
	,score_2_name
	,score_3_name
	,score_4_name
	,score_5_name
	,score_6_name
	,score_7_name
	,score_8_name
	,score_9_name
	,score_10_name
	,score_11_name
	,score_12_name
	,score_13_name
	,score_14_name
	,score_15_name
	,score_16_name
	,score_17_name
	,score_18_name
	,score_19_name
	,score_20_name
	,score_21_name
 FROM
	(SELECT
		STUD.student_code  AS student_code
		,STUD.school_year AS school_year
		,RIGHT(schnumb,3) AS school_code
		,@TEST_DATE AS test_date_code
		,'PARCC' test_type_code
		,'PARCC' AS test_type_name
		,CASE 
			WHEN testCode = 'ELA09' THEN 'ELA09' 
			WHEN testCode = 'ELA10' THEN 'ELA10' 
			WHEN testCode = 'ELA11' THEN 'ELA11' 
			WHEN testCode = 'ALG01' THEN 'ALG01' 
			WHEN testCode = 'ALG02' THEN 'ALG02' 
			WHEN testCode = 'GEO01' THEN 'GEO01' 
			WHEN testCode IN ('ELA03','ELA04','ELA05','ELA06','ELA07','ELA08') THEN 'ELA'
			WHEN testCode IN ('MAT03','MAT04','MAT05','MAT06','MAT07','MAT08') THEN 'MAT'
			WHEN testCode = 'MAT1I' THEN 'PARCCINT1_MATH'
			WHEN testCode = 'MAT2I' THEN 'PARCCINT2_MATH'
			WHEN testCode = 'MAT3I' THEN 'PARCCINT3_MATH'
		END AS test_section_code
		,CASE 
			WHEN testCode = 'ELA09' THEN 'ELA09' 
			WHEN testCode = 'ELA10' THEN 'ELA10' 
			WHEN testCode = 'ELA11' THEN 'ELA11' 
			WHEN testCode = 'ALG01' THEN 'ALG01' 
			WHEN testCode = 'ALG02' THEN 'ALG02' 
			WHEN testCode = 'GEO01' THEN 'GEO01' 
			WHEN testCode IN ('ELA03','ELA04','ELA05','ELA06','ELA07','ELA08') THEN 'ELA'
			WHEN testCode IN ('MAT03','MAT04','MAT05','MAT06','MAT07','MAT08') THEN 'MATH'
			WHEN testCode = 'MAT1I' THEN 'PARCCINT1_MATH'
			WHEN testCode = 'MAT2I' THEN 'PARCCINT2_MATH'
			WHEN testCode = 'MAT3I' THEN 'PARCCINT3_MATH'
		END AS test_section_name

		--,CASE 
		--	WHEN testCode = 'English Language Arts 9th Grade' THEN 'ELA9' 
		--	WHEN testCode = 'English Language Arts 10th Grade' THEN 'ELA10' 
		--	WHEN testCode = 'English Language Arts 11th Grade' THEN 'ELA11' 
		--	WHEN testCode = 'Algebra 1' THEN 'ALG1_MATH' 
		--	WHEN testCode = 'Algebra 2' THEN 'ALG2_MATH' 
		--	WHEN testCode = 'Geometry' THEN 'GEOM_MATH' 
		--	WHEN testCode = 'Integrated Math 1' THEN 'INT1_MATH'
		--	WHEN testCode = 'Integrated Math 2' THEN 'INT1_MATH'
		--	WHEN testCode = 'Integrated Math 3' THEN 'INT1_MATH'
		--END parent_test_section_code

		,'0' AS parent_test_section_code
		,'03' AS low_test_level_code
		,'12' AS high_test_level_code
		/*Pad the grade with a zero for grades less than 10th */
		,STUD.GRADE AS test_level_name
		,'' AS version_code
		,CASE
			WHEN PL = '1' THEN 'Did not yet meet expectations'
			WHEN PL = '2' THEN 'Partially met expectations'
			WHEN PL = '3' THEN 'Aproached expectations'
			WHEN PL = '4' THEN 'Met expectations'
			WHEN PL = '5' THEN 'Exceeded expectations'
		END AS score_group_name
		,PL AS score_group_code 
		,'Performance Level' AS score_group_label
		,last AS last_name
		,First AS first_name
		,STUD.dob AS DOB
		--,[Overall Exam Score] AS raw_score
		--Need the following four for percentile score
		,SS AS scaled_score
		,'' AS raw_score
		,'' AS nce_score
		,'' AS percentile_score
		,'' AS score_1
		,'' AS score_2
		,'' AS score_3
		,'' AS score_4
		,'' AS score_5
		,'' AS score_6
		,'' AS score_7
		,'' AS score_8
		,'' AS score_9
		,'' AS score_10
		,'' AS score_11
		,'' AS score_12
		,'' AS score_13
		,'' AS score_14
		,'' AS score_15
		,'' AS score_16
		,'' AS score_17
		,'' AS score_18
		,'' AS score_19
		,'' AS score_20
		,'' AS score_21
		,'' AS score_raw_name
		,'Scaled Score' AS score_scaled_name
		,'' AS score_nce_name
		,'' AS score_percentile_name
		,'' AS score_1_name
		,'' AS score_2_name
		,'' AS score_3_name
		,'' AS score_4_name
		,'' AS score_5_name
		,'' AS score_6_name
		,'' AS score_7_name
		,'' AS score_8_name
		,'' AS score_9_name
		,'' AS score_10_name
		,'' AS score_11_name
		,'' AS score_12_name
		,'' AS score_13_name
		,'' AS score_14_name
		,'' AS score_15_name
		,'' AS score_16_name
		,'' AS score_17_name
		,'' AS score_18_name
		,'' AS score_19_name
		,'' AS score_20_name
		,'' AS score_21_name

	FROM [PARCC_SUB-CLAIMS] AS PARCC
	LEFT JOIN
	allstudents_ALL AS STUD
	ON PARCC.StID = STUD.state_id
	WHERE STUD.school_year = LEFT(@SCHOOL_YEAR,4)
) AS T1
)AS T2
/*proficiency_level is the column name we used in the main select) 
test_section_name will return the original column headers  */
		
UNION

SELECT
	student_code 
	,school_year
	,school_code
	,test_date_code
	,test_type_code
	,test_type_name
	,test_section_code
	,test_section_name
	,parent_test_section_code
	,low_test_level_code
	,high_test_level_code
	,test_level_name
	,version_code
	,score_group_name 
	,score_group_code
	,score_group_label
	,last_name
	,first_name
	,DOB
	,raw_score
	,scaled_score
	,nce_score
	,percentile_score
	,score_1
	,score_2
	,score_3
	,score_4
	,score_5
	,score_6
	,score_7
	,score_8
	,score_9
	,score_10
	,score_11
	,score_12
	,score_13
	,score_14
	,score_15
	,score_16
	,score_17
	,score_18
	,score_19
	,score_20
	,score_21
	,score_raw_name
	,score_scaled_name
	,score_nce_name
	,score_percentile_name
	,score_1_name
	,score_2_name
	,score_3_name
	,score_4_name
	,score_5_name
	,score_6_name
	,score_7_name
	,score_8_name
	,score_9_name
	,score_10_name
	,score_11_name
	,score_12_name
	,score_13_name
	,score_14_name
	,score_15_name
	,score_16_name
	,score_17_name
	,score_18_name
	,score_19_name
	,score_20_name
	,score_21_name
FROM
(

SELECT
	student_code 
	,school_year
	,school_code
	,test_date_code
	,test_type_code
	,test_type_name
	,test_section_code
	,test_section_name
	,parent_test_section_code
	,low_test_level_code
	,high_test_level_code
	,test_level_name
	,version_code
	,score_group_name 
	,score_group_code
	,score_group_label
	,last_name
	,first_name
	,DOB
	,raw_score
	,scaled_score
	,nce_score
	,percentile_score
	,score_1
	,score_2
	,score_3
	,score_4
	,score_5
	,score_6
	,score_7
	,score_8
	,score_9
	,score_10
	,score_11
	,score_12
	,score_13
	,score_14
	,score_15
	,score_16
	,score_17
	,score_18
	,score_19
	,score_20
	,score_21
	,score_raw_name
	,score_scaled_name
	,score_nce_name
	,score_percentile_name
	,score_1_name
	,score_2_name
	,score_3_name
	,score_4_name
	,score_5_name
	,score_6_name
	,score_7_name
	,score_8_name
	,score_9_name
	,score_10_name
	,score_11_name
	,score_12_name
	,score_13_name
	,score_14_name
	,score_15_name
	,score_16_name
	,score_17_name
	,score_18_name
	,score_19_name
	,score_20_name
	,score_21_name
 FROM
	(SELECT
		STUD.student_code  AS student_code
		,STUD.school_year AS school_year
		,RIGHT(schnumb,3) AS school_code
		,@TEST_DATE AS test_date_code
		,'PARCC' test_type_code
		,'PARCC' AS test_type_name
		,'ELA_11_READ' AS test_section_code
		,'ELA READING' AS test_section_name
		,'ELA11' AS parent_test_section_code
		,'03' AS low_test_level_code
		,'12' AS high_test_level_code
		/*Pad the grade with a zero for grades less than 10th */
		,STUD.GRADE AS test_level_name
		,'' AS version_code
		,CASE
			WHEN PL = '1' THEN 'Did not yet meet expectations'
			WHEN PL = '2' THEN 'Partially met expectations'
			WHEN PL = '3' THEN 'Aproached expectations'
			WHEN PL = '4' THEN 'Met expectations'
			WHEN PL = '5' THEN 'Exceeded expectations'
		END AS score_group_name
		,PL AS score_group_code 
		,'Performance Level' AS score_group_label
		,last AS last_name
		,First AS first_name
		,STUD.dob AS DOB
		--,[Overall Exam Score] AS raw_score
		--Need the following four for percentile score
		,SS AS scaled_score
		,'' AS raw_score
		,'' AS nce_score
		,'' AS percentile_score
		,'' AS score_1
		,'' AS score_2
		,'' AS score_3
		,'' AS score_4
		,'' AS score_5
		,'' AS score_6
		,'' AS score_7
		,'' AS score_8
		,'' AS score_9
		,'' AS score_10
		,'' AS score_11
		,'' AS score_12
		,'' AS score_13
		,'' AS score_14
		,'' AS score_15
		,'' AS score_16
		,'' AS score_17
		,'' AS score_18
		,'' AS score_19
		,'' AS score_20
		,'' AS score_21
		,'' AS score_raw_name
		,'Scaled Score' AS score_scaled_name
		,'' AS score_nce_name
		,'' AS score_percentile_name
		,'' AS score_1_name
		,'' AS score_2_name
		,'' AS score_3_name
		,'' AS score_4_name
		,'' AS score_5_name
		,'' AS score_6_name
		,'' AS score_7_name
		,'' AS score_8_name
		,'' AS score_9_name
		,'' AS score_10_name
		,'' AS score_11_name
		,'' AS score_12_name
		,'' AS score_13_name
		,'' AS score_14_name
		,'' AS score_15_name
		,'' AS score_16_name
		,'' AS score_17_name
		,'' AS score_18_name
		,'' AS score_19_name
		,'' AS score_20_name
		,'' AS score_21_name

	FROM [PARCC_SUB-CLAIMS] AS PARCC
	LEFT JOIN
	allstudents_ALL AS STUD
	ON PARCC.StID = STUD.state_id
	WHERE STUD.school_year = LEFT(@SCHOOL_YEAR,4)
) AS T1
)AS T2




















--UNION
--/****
 
--Parent for Iowa */

--SELECT
--	[Student ID]  AS student_code
--	,[Academic Year] AS school_year
--	,[School Code] AS school_code
--	,@TEST_DATE AS test_date_code
--	,CASE 
--		WHEN Form = 'IAAT Form A' THEN 'FormA' 
--		WHEN Form = 'IAAT Form B' THEN 'FormB'
--		END test_type_code
--	,Form AS test_type_name
--	,CASE
--		WHEN Form = 'IAAT Form A' THEN	'A01' 
--		WHEN Form = 'IAAT Form B' THEN	'B01' 
--	 END test_section_code
--	,
--	 CASE
--		WHEN Form = 'IAAT Form A' THEN 'IAAT Form A' 
--		WHEN Form = 'IAAT Form B' THEN 'IAAT Form B' 
--	 END test_section_name
--	,'0' AS parent_test_section_code
--	,'06' AS low_test_level_code
--	,'12' AS high_test_level_code
--	/*Pad the grade with a zero for grades less than 10th */
--	,RIGHT('0'+ CONVERT(VARCHAR,Grade),2) AS test_level_name
--	,'' AS version_code
--	,[Overall Exam Performance Level Text] AS score_group_name
--	,CASE 
--		WHEN Form = 'IAAT Form A' THEN 'A' + CAST([Overall Exam Performance Level] AS nvarchar) 
--		WHEN Form = 'IAAT Form B' THEN 'B' + CAST([Overall Exam Performance Level] AS nvarchar) 
--	END score_group_code
--	,'Overall Exam Performance Level Text' AS score_group_label
--	,Lastname AS last_name
--	,Firstname AS first_name
--	,DOB AS DOB
--	,[Overall Exam Score (0-60)] AS raw_score
--	,'' AS scaled_score
--	,'' AS nce_score
--	,[Overall Exam Percent] AS percentile_score
--	,'' AS score_1
--	,'' AS score_2
--	,'' AS score_3
--	,'' AS score_4
--	,'' AS score_5
--	,'' AS score_6
--	,'' AS score_7
--	,'' AS score_8
--	,'' AS score_9
--	,'' AS score_10
--	,'' AS score_11
--	,'' AS score_12
--	,'' AS score_13
--	,'' AS score_14
--	,'' AS score_15
--	,'' AS score_16
--	,'' AS score_17
--	,'' AS score_18
--	,'' AS score_19
--	,'' AS score_20
--	,'' AS score_21
--	,'Raw Score (0-60)' AS score_raw_name
--	,'' AS score_scaled_name
--	,'' AS score_nce_name
--	,'Percent' AS score_percentile_name
--	,'' AS score_1_name
--	,'' AS score_2_name
--	,'' AS score_3_name
--	,'' AS score_4_name
--	,'' AS score_5_name
--	,'' AS score_6_name
--	,'' AS score_7_name
--	,'' AS score_8_name
--	,'' AS score_9_name
--	,'' AS score_10_name
--	,'' AS score_11_name
--	,'' AS score_12_name
--	,'' AS score_13_name
--	,'' AS score_14_name
--	,'' AS score_15_name
--	,'' AS score_16_name
--	,'' AS score_17_name
--	,'' AS score_18_name
--	,'' AS score_19_name
--	,'' AS score_20_name
--	,'' AS score_21_name

--FROM [IAAT] AS IAAT
--WHERE Lastname IS NOT NULL
--AND SCH_YR = @SCHOOL_YEAR
----WHERE [Student ID] IN (146532)
--ORDER BY student_code