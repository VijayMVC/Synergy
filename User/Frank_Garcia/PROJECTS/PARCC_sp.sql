USE [Assessments]
GO
/****** Object:  StoredProcedure [dbo].EXECUTE [test_result_PARCC_sp]    Script Date: 10/16/2015 10:44:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[test_result_PARCC_sp] AS
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
	In this case, PARCC
****/



TRUNCATE TABLE dbo.test_result_PARCC

DECLARE @SCHOOL_YEAR VARCHAR(50) = '2014-2015'
DECLARE @TEST_DATE VARCHAR (50) = '2015-04-01'

INSERT INTO dbo.test_result_PARCC
/* This requires a pivot, so experiment with syntax */
SELECT
	   [student_code]
      ,[school_year]
      ,[school_code]
      ,[test_date_code]
      ,[test_type_code]
      ,[test_type_name]
      ,[test_section_code]
      ,[test_section_name]
      ,[parent_test_section_code]
      ,[low_test_level_code]
      ,[high_test_level_code]
      ,[test_level_name]
      ,[version_code]
      ,[score_group_name]
      ,[score_group_code]
      ,[score_group_label]
      ,[last_name]
      ,[first_name]
      ,[DOB]
      ,[raw_score]
      ,[scaled_score]
      ,[nce_score]
      ,[percentile_score]
      ,[score_1]
      ,[score_2]
      ,[score_3]
      ,[score_4]
      ,[score_5]
      ,[score_6]
      ,[score_7]
      ,[score_8]
      ,[score_9]
      ,[score_10]
      ,[score_11]
      ,[score_12]
      ,[score_13]
      ,[score_14]
      ,[score_15]
      ,[score_16]
      ,[score_17]
      ,[score_18]
      ,[score_19]
      ,[score_20]
      ,[score_21]
      ,[score_raw_name]
      ,[score_scaled_name]
      ,[score_nce_name]
      ,[score_percentile_name]
      ,[score_1_name]
      ,[score_2_name]
      ,[score_3_name]
      ,[score_4_name]
      ,[score_5_name]
      ,[score_6_name]
      ,[score_7_name]
      ,[score_8_name]
      ,[score_9_name]
      ,[score_10_name]
      ,[score_11_name]
      ,[score_12_name]
      ,[score_13_name]
      ,[score_14_name]
      ,[score_15_name]
      ,[score_16_name]
      ,[score_17_name]
      ,[score_18_name]
      ,[score_19_name]
      ,[score_20_name]
      ,[score_21_name]

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
		,RIGHT(SchoolNum,3) AS school_code
		,@TEST_DATE AS test_date_code
		,'PARCC' test_type_code
		,'PARCC' AS test_type_name
		,CASE 
			WHEN Subtest = 'English Language Arts 9th Grade' THEN 'PARCCELA9' 
			WHEN Subtest = 'English Language Arts 10th Grade' THEN 'PARCCELA10' 
			WHEN Subtest = 'English Language Arts 11th Grade' THEN 'PARCCELA11' 
			WHEN Subtest = 'Algebra 1' THEN 'PARCCALG1_MATH' 
			WHEN Subtest = 'Algebra 2' THEN 'PARCCALG2_MATH' 
			WHEN Subtest = 'Geometry' THEN 'PARCCGEOM_MATH' 
			WHEN Subtest = 'Integrated Math 1' THEN 'PARCCINT1_MATH'
			WHEN Subtest = 'Integrated Math 2' THEN 'PARCCINT1_MATH'
			WHEN Subtest = 'Integrated Math 3' THEN 'PARCCINT1_MATH'
		END AS test_section_code
		,CASE 
			WHEN Subtest = 'English Language Arts 9th Grade' THEN 'ELA 9' 
			WHEN Subtest = 'English Language Arts 10th Grade' THEN 'ELA 10' 
			WHEN Subtest = 'English Language Arts 11th Grade' THEN 'ELA 11' 
			WHEN Subtest = 'Algebra 1' THEN 'ALG 1' 
			WHEN Subtest = 'Algebra 2' THEN 'ALG II' 
			WHEN Subtest = 'Geometry' THEN 'GEOM' 
			WHEN Subtest = 'Integrated Math 1' THEN 'INT MATH 1'
			WHEN Subtest = 'Integrated Math 2' THEN 'INT MATH 2'
			WHEN Subtest = 'Integrated Math 3' THEN 'INT MATH 3'
		END AS test_section_name

		--,CASE 
		--	WHEN Subtest = 'English Language Arts 9th Grade' THEN 'ELA9' 
		--	WHEN Subtest = 'English Language Arts 10th Grade' THEN 'ELA10' 
		--	WHEN Subtest = 'English Language Arts 11th Grade' THEN 'ELA11' 
		--	WHEN Subtest = 'Algebra 1' THEN 'ALG1_MATH' 
		--	WHEN Subtest = 'Algebra 2' THEN 'ALG2_MATH' 
		--	WHEN Subtest = 'Geometry' THEN 'GEOM_MATH' 
		--	WHEN Subtest = 'Integrated Math 1' THEN 'INT1_MATH'
		--	WHEN Subtest = 'Integrated Math 2' THEN 'INT1_MATH'
		--	WHEN Subtest = 'Integrated Math 3' THEN 'INT1_MATH'
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
		,PARCC.StudentID
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

	FROM [Preliminary_2015_PARCC] AS PARCC
	LEFT JOIN
	allstudents_ALL AS STUD
	ON PARCC.StudentID = STUD.state_id
	AND STUD.school_year = '2014'
	WHERE SCH_YR = @SCHOOL_YEAR
	--WHERE [Student ID] IN (146532)
) AS T1
/*proficiency_level is the column name we used in the main select) 
test_section_name will return the original column headers  */
--UNPIVOT (scaled_score FOR test_section_name IN (
--		 [SSREAD]
--		,[SSWRITE]

UNION

SELECT
	stud.student_code AS student_code 
	,STUD.school_year AS school_year
	,RIGHT(SchoolNum,3) AS school_code
	,@TEST_DATE AS test_date_code
	,'PARCC' AS test_type_code
	,'PARCC' AS test_type_name
	,'ELA_READ' AS test_section_code
	,'ELA 11 READING' AS test_section_name
	,'PARCCELA11' AS parent_test_section_code
	,'03' AS low_test_level_code
	,'12' AS high_test_level_code
	,STUD.GRADE AS test_level_name
	,'' AS version_code
	,CASE
		WHEN ReadingPF = '0' THEN 'FAIL'
		WHEN ReadingPF = '1' THEN 'PASS'
	END AS score_group_name
	,CASE
		WHEN ReadingPF = '0' THEN 'F'
		WHEN ReadingPF = '1' THEN 'P'
	END AS score_group_code 
	,'Performance Level' AS score_group_label
	,First AS last_name
	,last AS first_name
	,STUD.dob AS DOB
	,'' AS raw_score
	,SSRead AS scaled_score
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
	FROM [Preliminary_2015_PARCC] AS PARCC
	LEFT JOIN
	allstudents_ALL AS STUD
	ON PARCC.StudentID = STUD.state_id
	AND STUD.school_year = '2014'
	WHERE SCH_YR = @SCHOOL_YEAR
	AND Subtest = 'English Language Arts 11th Grade'


UNION

SELECT
	stud.student_code AS student_code 
	,STUD.school_year AS school_year
	,RIGHT(SchoolNum,3) AS school_code
	,@TEST_DATE AS test_date_code
	,'PARCC' AS test_type_code
	,'PARCC' AS test_type_name
	,'ELA_WRITE' AS test_section_code
	,'ELA 11 WRITING' AS test_section_name
	,'PARCCELA11' AS parent_test_section_code
	,'03' AS low_test_level_code
	,'12' AS high_test_level_code
	,STUD.GRADE AS test_level_name
	,'' AS version_code
	,CASE
		WHEN ReadingPF = '0' THEN 'FAIL'
		WHEN ReadingPF = '1' THEN 'PASS'
	END AS score_group_name
	,CASE
		WHEN ReadingPF = '0' THEN 'F'
		WHEN ReadingPF = '1' THEN 'P'
	END AS score_group_code 
	,'Performance Level' AS score_group_label
	,First AS last_name
	,last AS first_name
	,STUD.dob AS DOB
	,'' AS raw_score
	,SSWrite AS scaled_score
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
	FROM [Preliminary_2015_PARCC] AS PARCC
	LEFT JOIN
	allstudents_ALL AS STUD
	ON PARCC.StudentID = STUD.state_id
	AND STUD.school_year = '2014'
	WHERE SCH_YR = @SCHOOL_YEAR
	AND Subtest = 'English Language Arts 11th Grade'

) AS PARCC
WHERE student_code IS NOT NULL
ORDER BY test_level_name