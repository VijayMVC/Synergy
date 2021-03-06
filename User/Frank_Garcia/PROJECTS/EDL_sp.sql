USE [db_DRA]
GO
/****** Object:  StoredProcedure [dbo].[test_resultEDL_sp]    Script Date: 04/21/2014 08:30:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER Procedure  [dbo].[test_resultEDL_sp] AS
--BEGIN TRAN
--USE
--db_DRA
--GO

TRUNCATE TABLE dbo.test_result_EDL

DECLARE @AssessmentWindow nvarchar(6)
SET @AssessmentWindow = 'Spring'

DECLARE @TestDate nvarchar(11)
SET @TestDate = '2014-11-01'

DECLARE @SchoolYear nvarchar(6)
SET @SchoolYear = '2013'

INSERT INTO dbo.test_result_EDL

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
	,'Not Applicable' AS score_group_name 
	,'NA' AS score_group_code
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
	,CAST
		(CASE
			WHEN FLD_HEADER = 'READING ENGAGEMENT' AND FLD_CATEGORY_SORTORDER = '1' THEN fld_Score_Sect1_1
			WHEN FLD_HEADER = 'READING ENGAGEMENT' AND FLD_CATEGORY_SORTORDER = '2' THEN fld_Score_Sect1_2
			WHEN FLD_HEADER = 'READING ENGAGEMENT' AND FLD_CATEGORY_SORTORDER = '3' THEN fld_Score_Sect1_3
			WHEN FLD_HEADER = 'ORAL READING' AND FLD_CATEGORY_SORTORDER = '1' THEN fld_Score_Sect2_1
			WHEN FLD_HEADER = 'ORAL READING' AND FLD_CATEGORY_SORTORDER = '2' THEN fld_Score_Sect2_2
			WHEN FLD_HEADER = 'ORAL READING' AND FLD_CATEGORY_SORTORDER = '3' THEN fld_Score_Sect2_3
			WHEN FLD_HEADER = 'ORAL READING FLUENCY' AND FLD_CATEGORY_SORTORDER = '1' THEN fld_Score_Sect2_1
			WHEN FLD_HEADER = 'ORAL READING FLUENCY' AND FLD_CATEGORY_SORTORDER = '2' THEN fld_Score_Sect2_2
			WHEN FLD_HEADER = 'ORAL READING FLUENCY' AND FLD_CATEGORY_SORTORDER = '3' THEN fld_Score_Sect2_3
			WHEN FLD_HEADER = 'PRINTED LANGUAGE CONCEPTS' AND FLD_CATEGORY_SORTORDER = '1' THEN fld_Score_Sect3_1
			WHEN FLD_HEADER = 'PRINTED LANGUAGE CONCEPTS' AND FLD_CATEGORY_SORTORDER = '2' THEN fld_Score_Sect3_2
			WHEN FLD_HEADER = 'PRINTED LANGUAGE CONCEPTS' AND FLD_CATEGORY_SORTORDER = '3' THEN fld_Score_Sect3_3
			WHEN FLD_HEADER = 'PRINTED LANGUAGE CONCEPTS' AND FLD_CATEGORY_SORTORDER = '4' THEN fld_Score_Sect3_4
			WHEN FLD_HEADER = 'PRINTED LANGUAGE CONCEPTS' AND FLD_CATEGORY_SORTORDER = '5' THEN fld_Score_Sect3_5
			WHEN FLD_HEADER = 'PRINTED LANGUAGE CONCEPTS' AND FLD_CATEGORY_SORTORDER = '6' THEN fld_Score_Sect3_6
			WHEN FLD_HEADER = 'PRINTED LANGUAGE CONCEPTS' AND FLD_CATEGORY_SORTORDER = '7' THEN fld_Score_Sect3_7
			WHEN FLD_HEADER = 'COMPREHENSION' AND FLD_CATEGORY_SORTORDER = '1' THEN fld_Score_Sect3_1
			WHEN FLD_HEADER = 'COMPREHENSION' AND FLD_CATEGORY_SORTORDER = '2' THEN fld_Score_Sect3_2
			WHEN FLD_HEADER = 'COMPREHENSION' AND FLD_CATEGORY_SORTORDER = '3' THEN fld_Score_Sect3_3
			WHEN FLD_HEADER = 'COMPREHENSION' AND FLD_CATEGORY_SORTORDER = '4' THEN fld_Score_Sect3_4
			WHEN FLD_HEADER = 'COMPREHENSION' AND FLD_CATEGORY_SORTORDER = '5' THEN fld_Score_Sect3_5
			WHEN FLD_HEADER = 'COMPREHENSION' AND FLD_CATEGORY_SORTORDER = '6' THEN fld_Score_Sect3_6
			WHEN FLD_HEADER = 'COMPREHENSION' AND FLD_CATEGORY_SORTORDER = '7' THEN fld_Score_Sect3_7
			ELSE
			''
		END AS NVARCHAR (50))
		AS
	score_4
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
	,'Total Correct' AS score_4_name
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
		distinct fld_ID_NBR AS student_code
		,@SchoolYear AS school_year
		,fld_TestLoc AS school_code
		,@TestDate AS test_date_code
		,'EDL' AS test_type_code
		,'EDL' AS test_type_name
		,QDD.test_section_code
		,QDD.fld_CategoryName AS test_section_name
		,fld_Score_Sect1_1
		,fld_Score_Sect1_2
		,fld_Score_Sect1_3
		,fld_Score_Sect2_1
		,fld_Score_Sect2_2
		,fld_Score_Sect2_3
		,fld_Score_Sect2_4
		,fld_Score_Sect3_1
		,fld_Score_Sect3_2
		,fld_Score_Sect3_3
		,fld_Score_Sect3_4
		,fld_Score_Sect3_5
		,fld_Score_Sect3_6
		,fld_Score_Sect3_7
		,fld_category_sortorder
		,fld_header_sortorder
		,fld_header
		,dra.fld_Level
		,fld_Total_Sect1
		,fld_Total_Sect2
		,fld_Total_Sect3
		,QDD.parent_test_section_code AS parent_test_section_code
		,'K' AS low_test_level_code
		,'05' AS high_test_level_code
		/*Pad the grade with a zero for grades less than 10th */
		,fld_GRDE AS test_level_name
		,'' AS version_code
		,'Score Group' AS score_group_label
		,fld_LST_NME AS last_name
		,fld_FRST_NME AS first_name
		/*concatenate the year, month and day--*/
		,SUBSTRING (CAST (fld_BRTH_DT AS NVARCHAR (10)), 1,4)+'-'+SUBSTRING (CAST (fld_BRTH_DT AS NVARCHAR (10)), 5,2)+'-'+SUBSTRING (CAST (fld_BRTH_DT AS NVARCHAR (10)), 7,8)  AS DOB
		,'' AS raw_score
		,'' AS scaled_score
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
		,'' AS score_scaled_name
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

	FROM results AS DRA
	INNER JOIN
	[Question_Dropdowns_EDL] AS QDD
	ON
	DRA.fld_Assessment_Used = QDD.fld_Assessment
	AND	DRA.fld_Level = QDD.fld_Level
	AND DRA.fld_story = QDD.fld_levelTitles
	
	WHERE
	fld_AssessmentWindow = @AssessmentW
	AND QDD.fld_score = '1'
	AND DRA.fld_Assessment_Used = 'EDL'
	--AND fld_Score_Sect1_3 IS NOT NULL
	)AS DRA

		--where student_code = '970087958'
		--order by fld_header_sortorder
		--,fld_category_sortorder
		
UNION

SELECT
	distinct student_code
	,school_year
	,school_code
	,test_date_code
	,test_type_code
	,test_type_name 
	,CASE
		WHEN some_score = 'fld_Total_Sect1' THEN '1'
		WHEN some_score = 'fld_Total_Sect2' THEN '2'
		WHEN some_score = 'fld_Total_Sect3' THEN '3'
		WHEN some_score = 'fld_performance_lvl' THEN '0.1'
	 END test_section_code
	,CASE
		WHEN some_score = 'fld_Total_Sect1' THEN 'Reading Engagement'
		WHEN some_score = 'fld_Total_Sect2' THEN 'Oral Reading/Fluency'
		WHEN some_score = 'fld_Total_Sect3' THEN 'Comprehension/Printed Language Concepts'
		WHEN some_score = 'fld_performance_lvl' THEN 'Overall Reading Proficiency'		
	 END  test_section_name 
	,CASE
		WHEN some_score = 'fld_Total_Sect1' THEN '0'
		WHEN some_score = 'fld_Total_Sect2' THEN '0'
		WHEN some_score = 'fld_Total_Sect3' THEN '0'
		WHEN some_score = 'fld_performance_lvl' THEN '0'
	 END parent_test_section_code 
	,low_test_level_code
	,high_test_level_code
	,test_level_name
	,version_code
	,CASE
		WHEN totals ='PRO' THEN 'Proficient'
		WHEN totals ='BS'  THEN 'Beginning Steps'
		WHEN totals = 'NP' THEN 'Nearing Proficient' 
		WHEN totals = 'ADV' THEN 'Advanced'
	 ELSE 'Not Applicable' 
	 END AS score_group_name 
	,CASE
		WHEN totals In ('PRO','BS','NP','ADV') THEN totals
	 ELSE'NA' 
	 END AS score_group_code
	,CASE 
		WHEN some_score = 'fld_performance_lvl' THEN 'Performance Level'
		ELSE 'Score Group' 
	 END AS score_group_label	
	 ,last_name
	,first_name
	, DOB
	,raw_score
	/*If the student didn't complete a test, set the scaled score to zero*/
	,scaled_score
	,nce_score
	,percentile_score
	,score_1
	,score_2
	,score_3
	,score_4
	,score_5
	,CASE 
	 WHEN some_score != 'fld_performance_lvl' THEN fld_Story
	 ELSE ''
	 END AS score_6
	,score_7
	,score_8
	,score_9
	,CASE 
		WHEN some_score != 'fld_performance_lvl' THEN fld_Level
		ELSE ''
	 END AS score_10
	,CASE
		WHEN fld_Assessment_used = 'DRA' AND some_score != 'fld_performance_lvl' THEN 'E'
		WHEN fld_Assessment_used = 'EDL' AND some_score != 'fld_performance_lvl' THEN 'S'
		ELSE ''
	END AS score_11
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
	,CASE
		WHEN some_score != 'fld_performance_lvl' THEN 'Story Name'
		ELSE ''
	 END AS score_6_name
	,score_7_name
	,score_8_name
	,score_9_name
	,CASE
		WHEN some_score != 'fld_performance_lvl' THEN 'Level' 
		ELSE ''
	 END AS score_10_name
	,CASE 
		WHEN some_score = 'fld_performance_lvl' THEN ''
		ELSE 'Language Version' 
	 END AS score_11_name
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
		distinct fld_ID_NBR AS student_code
		,'2013' AS school_year
		,fld_TestLoc AS school_code
		,'2014-01-01' AS test_date_code
		,'EDL' AS test_type_code
		,'EDL' AS test_type_name
		,'' AS test_section_code
		,'' AS test_section_name
		,fld_Score_Sect1_1
		,fld_Score_Sect1_2
		,fld_Score_Sect1_3
		,fld_Score_Sect2_1
		,fld_Score_Sect2_2
		,fld_Score_Sect2_3
		,fld_Score_Sect2_4
		,fld_Score_Sect3_1
		,fld_Score_Sect3_2
		,fld_Score_Sect3_3
		,fld_Score_Sect3_4
		,fld_Score_Sect3_5
		,fld_Score_Sect3_6
		,fld_Score_Sect3_7
		,fld_Assessment_used
		,dra.fld_Level
		,fld_Story
		,QDD.fld_Header_SortOrder
		,QDD.fld_Header
		,QDD.fld_Level_SortOrder
		--Cast before the pivot in case fields are different types
		,CAST (fld_Total_Sect1 AS NVARCHAR(50)) AS fld_Total_Sect1
		,CAST (fld_Total_Sect2 AS NVARCHAR(50)) AS fld_Total_Sect2
		,CAST (fld_Total_Sect3 AS NVARCHAR (50)) AS fld_Total_Sect3
		,fld_performance_lvl
		,'' AS parent_test_section_code
		,'K' AS low_test_level_code
		,'05' AS high_test_level_code
		/*Pad the grade with a zero for grades less than 10th */
		,fld_GRDE AS test_level_name
		,'' AS version_code
		,'' score_group_label
		,fld_LST_NME AS last_name
		,fld_FRST_NME AS first_name
		/*concatenate the year, month and day--*/
		,SUBSTRING (CAST (fld_BRTH_DT AS NVARCHAR (10)), 1,4)+'-'+SUBSTRING (CAST (fld_BRTH_DT AS NVARCHAR (10)), 5,2)+'-'+SUBSTRING (CAST (fld_BRTH_DT AS NVARCHAR (10)), 7,8)  AS DOB
		,'' AS raw_score
		,'' AS scaled_score
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
		,'' AS score_scaled_name
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

	FROM results AS DRA
	INNER JOIN
	[Question_Dropdowns_EDL] AS QDD
	ON
	DRA.fld_Assessment_Used = QDD.fld_Assessment
	AND	DRA.fld_Level = QDD.fld_Level
	AND DRA.fld_story = QDD.fld_levelTitles
	
	WHERE
	fld_AssessmentWindow = 'Winter' 
	AND DRA.fld_Assessment_Used = 'EDL'
	
	)AS DRA
UNPIVOT
(totals FOR some_score In
(	
		 fld_Total_Sect1
		,fld_Total_Sect2 
		,fld_Total_Sect3 
		,fld_performance_lvl
		
	) )as unpvt
		--where student_code = '970087958'

UNION

SELECT
	distinct student_code
	,school_year
	,school_code
	,test_date_code
	,test_type_code
	,test_type_name 
	,CASE
		WHEN some_score = 'fld_Total_Sect1' THEN '43'
		WHEN some_score = 'fld_Total_Sect2' THEN '45'
		WHEN some_score = 'fld_Total_Sect3' THEN '44'
	 END test_section_code
	,CASE
		WHEN some_score = 'fld_Total_Sect1' THEN 'Reading Engagement Total'
		WHEN some_score = 'fld_Total_Sect2' THEN 'Oral Reading/Fluency Total'
		WHEN some_score = 'fld_Total_Sect3' THEN 'Comprehension/Printed Language Concepts Total'
	 END  test_section_name 
	,CASE
		WHEN some_score = 'fld_Total_Sect1' THEN '1'
		WHEN some_score = 'fld_Total_Sect2' THEN '2'
		WHEN some_score = 'fld_Total_Sect3' THEN '3'
	 END parent_test_section_code 
	,low_test_level_code
	,high_test_level_code
	,test_level_name
	,version_code
	,'Not Applicable' AS score_group_name 
	,'NA' AS score_group_code
	,'Score Group' AS score_group_label	
	 ,last_name
	,first_name
	,DOB
	,raw_score
	/*If the student didn't complete a test, set the scaled score to zero*/
	,scaled_score
	,nce_score
	,percentile_score
	,score_1
	,score_2
	,score_3
	,totals AS score_4
	,score_5
	,score_6
	,score_7
	,fld_Total_Score_Text AS score_8
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
		distinct fld_ID_NBR AS student_code
		,'2013' AS school_year
		,fld_TestLoc AS school_code
		,'2014-01-01' AS test_date_code
		,'EDL' AS test_type_code
		,'EDL' AS test_type_name
		,'' AS test_section_code
		,'' AS test_section_name
		,fld_Score_Sect1_1
		,fld_Score_Sect1_2
		,fld_Score_Sect1_3
		,fld_Score_Sect2_1
		,fld_Score_Sect2_2
		,fld_Score_Sect2_3
		,fld_Score_Sect2_4
		,fld_Score_Sect3_1
		,fld_Score_Sect3_2
		,fld_Score_Sect3_3
		,fld_Score_Sect3_4
		,fld_Score_Sect3_5
		,fld_Score_Sect3_6
		,fld_Score_Sect3_7
		,fld_Assessment_used
		,dra.fld_Level
		,QDD.fld_Header_SortOrder
		,QDD.fld_Header
		,QDD.fld_Level_SortOrder
		,TOTALS.fld_Total_Score_Text
		--Cast before the pivot in case fields are different types
		,CAST (fld_Total_Sect1 AS NVARCHAR(50)) AS fld_Total_Sect1
		,CAST (fld_Total_Sect2 AS NVARCHAR(50)) AS fld_Total_Sect2
		,CAST (fld_Total_Sect3 AS NVARCHAR (50)) AS fld_Total_Sect3
		,fld_performance_lvl
		,'' AS parent_test_section_code
		,'K' AS low_test_level_code
		,'05' AS high_test_level_code
		/*Pad the grade with a zero for grades less than 10th */
		,fld_GRDE AS test_level_name
		,'' AS version_code
		,'' score_group_label
		,fld_LST_NME AS last_name
		,fld_FRST_NME AS first_name
		/*concatenate the year, month and day--*/
		,SUBSTRING (CAST (fld_BRTH_DT AS NVARCHAR (10)), 1,4)+'-'+SUBSTRING (CAST (fld_BRTH_DT AS NVARCHAR (10)), 5,2)+'-'+SUBSTRING (CAST (fld_BRTH_DT AS NVARCHAR (10)), 7,8)  AS DOB
		,'' AS raw_score
		,'' AS scaled_score
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
		,'' AS score_scaled_name
		,'' AS score_nce_name
		,'' AS score_percentile_name
		,'' AS score_1_name
		,'' AS score_2_name
		,'' AS score_3_name
		,'Total Correct' AS score_4_name
		,'' AS score_5_name
		,'' AS score_6_name
		,'' AS score_7_name
		,'Score Text' AS score_8_name
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

	FROM results AS DRA
	INNER JOIN
	[Question_Dropdowns_EDL] AS QDD
	ON
	DRA.fld_Assessment_Used = QDD.fld_Assessment
	AND	DRA.fld_Level = QDD.fld_Level
	AND DRA.fld_story = QDD.fld_levelTitles
	INNER JOIN
	CATEGORIES_DRA_TABLE AS CAT
	ON
	QDD.fld_CategoryName = CAT.fld_CategoryName
	INNER JOIN
	[Total_Scores_DRA] AS TOTALS
	ON
	DRA.fld_Level = TOTALS.fld_Level
	AND DRA.fld_Total_Sect1 = TOTALS.fld_Valid_Total_Score
	AND TOTALS.fld_Section_Number = '1'
	
	WHERE
	fld_AssessmentWindow = 'Winter' 
	AND DRA.fld_Assessment_Used = 'EDL'
	AND
	CASE
		WHEN DRA.fld_Story = 'BRIDGE-Amelia Earhart' THEN 'BRIDGE-Amelia Earhart'
		WHEN DRA.fld_Story = 'BRIDGE-Energy From the Sun' THEN 'BRIDGE-Energy From the Sun'
		WHEN DRA.fld_Story = 'BRIDGE-Hero' THEN 'BRIDGE-Hero'
		WHEN DRA.fld_Story = 'BRIDGE-Incredible Journeys' THEN 'BRIDGE-Incredible Journeys'
		WHEN DRA.fld_Story = 'BRIDGE-The Blasters' THEN 'BRIDGE-The Blasters'
		WHEN DRA.fld_Story = 'BRIDGE-The Flood' THEN 'BRIDGE-The Flood'
		WHEN DRA.fld_Story = 'BRIDGE-The Navajo Way' THEN 'BRIDGE-The Navajo Way'
		WHEN DRA.fld_Story = 'BRIDGE-What Carlos Wants' THEN 'BRIDGE-What Carlos Wants'
		ELSE 'none'
	END	= TOTALS.fld_Story		
	
	)AS DRA
UNPIVOT
(totals FOR some_score In
(fld_Total_Sect1
	) )as unpvt
		
		--where student_code = '970087958'

UNION

SELECT
	distinct student_code
	,school_year
	,school_code
	,test_date_code
	,test_type_code
	,test_type_name 
	,CASE
		WHEN some_score = 'fld_Total_Sect1' THEN '43'
		WHEN some_score = 'fld_Total_Sect2' THEN '45'
		WHEN some_score = 'fld_Total_Sect3' THEN '44'
	 END test_section_code
	,CASE
		WHEN some_score = 'fld_Total_Sect1' THEN 'Reading Engagement Total'
		WHEN some_score = 'fld_Total_Sect2' THEN 'Oral Reading/Fluency Total'
		WHEN some_score = 'fld_Total_Sect3' THEN 'Comprehension/Printed Language Concepts Total'
	 END  test_section_name 
	,CASE
		WHEN some_score = 'fld_Total_Sect1' THEN '1'
		WHEN some_score = 'fld_Total_Sect2' THEN '2'
		WHEN some_score = 'fld_Total_Sect3' THEN '3'
	 END parent_test_section_code 
	,low_test_level_code
	,high_test_level_code
	,test_level_name
	,version_code
	,'Not Applicable' AS score_group_name 
	,'NA' AS score_group_code
	,'Score Group' AS score_group_label	
	 ,last_name
	,first_name
	, DOB
	,raw_score
	/*If the student didn't complete a test, set the scaled score to zero*/
	,scaled_score
	,nce_score
	,percentile_score
	,score_1
	,score_2
	,score_3
	,totals AS score_4
	,score_5
	,score_6
	,score_7
	,fld_Total_Score_Text AS score_8
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
		distinct fld_ID_NBR AS student_code
		,'2013' AS school_year
		,fld_TestLoc AS school_code
		,'2014-01-01' AS test_date_code
		,'EDL' AS test_type_code
		,'EDL' AS test_type_name
		,'' AS test_section_code
		,'' AS test_section_name
		,fld_Score_Sect1_1
		,fld_Score_Sect1_2
		,fld_Score_Sect1_3
		,fld_Score_Sect2_1
		,fld_Score_Sect2_2
		,fld_Score_Sect2_3
		,fld_Score_Sect2_4
		,fld_Score_Sect3_1
		,fld_Score_Sect3_2
		,fld_Score_Sect3_3
		,fld_Score_Sect3_4
		,fld_Score_Sect3_5
		,fld_Score_Sect3_6
		,fld_Score_Sect3_7
		,fld_Assessment_used
		,dra.fld_Level
		,QDD.fld_Header_SortOrder
		,QDD.fld_Header
		,QDD.fld_Level_SortOrder
		,TOTALS.fld_Total_Score_Text
		--Cast before the pivot in case fields are different types
		,CAST (fld_Total_Sect1 AS NVARCHAR(50)) AS fld_Total_Sect1
		,CAST (fld_Total_Sect2 AS NVARCHAR(50)) AS fld_Total_Sect2
		,CAST (fld_Total_Sect3 AS NVARCHAR (50)) AS fld_Total_Sect3
		,fld_performance_lvl
		,'' AS parent_test_section_code
		,'K' AS low_test_level_code
		,'05' AS high_test_level_code
		/*Pad the grade with a zero for grades less than 10th */
		,fld_GRDE AS test_level_name
		,'' AS version_code
		,'' score_group_label
		,fld_LST_NME AS last_name
		,fld_FRST_NME AS first_name
		/*concatenate the year, month and day--*/
		,SUBSTRING (CAST (fld_BRTH_DT AS NVARCHAR (10)), 1,4)+'-'+SUBSTRING (CAST (fld_BRTH_DT AS NVARCHAR (10)), 5,2)+'-'+SUBSTRING (CAST (fld_BRTH_DT AS NVARCHAR (10)), 7,8)  AS DOB
		,'' AS raw_score
		,'' AS scaled_score
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
		,'' AS score_scaled_name
		,'' AS score_nce_name
		,'' AS score_percentile_name
		,'' AS score_1_name
		,'' AS score_2_name
		,'' AS score_3_name
		,'Total Correct' AS score_4_name
		,'' AS score_5_name
		,'' AS score_6_name
		,'' AS score_7_name
		,'Score Text' AS score_8_name
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

	FROM results AS DRA
	INNER JOIN
	[Question_Dropdowns_EDL] AS QDD
	ON
	DRA.fld_Assessment_Used = QDD.fld_Assessment
	AND	DRA.fld_Level = QDD.fld_Level
	AND DRA.fld_story = QDD.fld_levelTitles
	INNER JOIN
	CATEGORIES_DRA_TABLE AS CAT
	ON
	QDD.fld_CategoryName = CAT.fld_CategoryName
	INNER JOIN
	[Total_Scores_DRA] AS TOTALS
	ON
	DRA.fld_Level = TOTALS.fld_Level
	AND DRA.fld_Total_Sect2 = TOTALS.fld_Valid_Total_Score
	AND TOTALS.fld_Section_Number = '2'
	AND fld_Assessment_Used = 'DRA'
	AND
	CASE
		WHEN DRA.fld_Story = 'BRIDGE-Amelia Earhart' THEN 'BRIDGE-Amelia Earhart'
		WHEN DRA.fld_Story = 'BRIDGE-Energy From the Sun' THEN 'BRIDGE-Energy From the Sun'
		WHEN DRA.fld_Story = 'BRIDGE-Hero' THEN 'BRIDGE-Hero'
		WHEN DRA.fld_Story = 'BRIDGE-Incredible Journeys' THEN 'BRIDGE-Incredible Journeys'
		WHEN DRA.fld_Story = 'BRIDGE-The Blasters' THEN 'BRIDGE-The Blasters'
		WHEN DRA.fld_Story = 'BRIDGE-The Flood' THEN 'BRIDGE-The Flood'
		WHEN DRA.fld_Story = 'BRIDGE-The Navajo Way' THEN 'BRIDGE-The Navajo Way'
		WHEN DRA.fld_Story = 'BRIDGE-What Carlos Wants' THEN 'BRIDGE-What Carlos Wants'
		ELSE 'none'
	END	= TOTALS.fld_Story			
	WHERE
	fld_AssessmentWindow = 'Winter' 
	
	)AS DRA
UNPIVOT
(totals FOR some_score In
(	
		fld_Total_Sect2 
	) )as unpvt
		
		--where student_code = '970087958'
		

UNION

SELECT
	distinct student_code
	,school_year
	,school_code
	,test_date_code
	,test_type_code
	,test_type_name 
	,CASE
		WHEN some_score = 'fld_Total_Sect1' THEN '43'
		WHEN some_score = 'fld_Total_Sect2' THEN '45'
		WHEN some_score = 'fld_Total_Sect3' THEN '44'
	 END test_section_code
	,CASE
		WHEN some_score = 'fld_Total_Sect1' THEN 'Reading Engagement Total'
		WHEN some_score = 'fld_Total_Sect2' THEN 'Oral Reading/Fluency Total'
		WHEN some_score = 'fld_Total_Sect3' THEN 'Comprehension/Printed Language Concepts Total'
	 END  test_section_name 
	,CASE
		WHEN some_score = 'fld_Total_Sect1' THEN '1'
		WHEN some_score = 'fld_Total_Sect2' THEN '2'
		WHEN some_score = 'fld_Total_Sect3' THEN '3'
	 END parent_test_section_code 
	,low_test_level_code
	,high_test_level_code
	,test_level_name
	,version_code
	,'Not Applicable' AS score_group_name 
	,'NA' AS score_group_code
	,'Score Group' AS score_group_label	
	 ,last_name
	,first_name
	,DOB
	,raw_score
	/*If the student didn't complete a test, set the scaled score to zero*/
	,scaled_score
	,nce_score
	,percentile_score
	,score_1
	,score_2
	,score_3
	,totals AS score_4
	,score_5
	,score_6
	,score_7
	,fld_Total_Score_Text AS score_8
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
		distinct fld_ID_NBR AS student_code
		,'2013' AS school_year
		,fld_TestLoc AS school_code
		,'2014-01-01' AS test_date_code
		,'EDL' AS test_type_code
		,'EDL' AS test_type_name
		,'' AS test_section_code
		,'' AS test_section_name
		,fld_Score_Sect1_1
		,fld_Score_Sect1_2
		,fld_Score_Sect1_3
		,fld_Score_Sect2_1
		,fld_Score_Sect2_2
		,fld_Score_Sect2_3
		,fld_Score_Sect2_4
		,fld_Score_Sect3_1
		,fld_Score_Sect3_2
		,fld_Score_Sect3_3
		,fld_Score_Sect3_4
		,fld_Score_Sect3_5
		,fld_Score_Sect3_6
		,fld_Score_Sect3_7
		,fld_Assessment_used
		,dra.fld_Level
		,QDD.fld_Header_SortOrder
		,QDD.fld_Header
		,QDD.fld_Level_SortOrder
		,TOTALS.fld_Total_Score_Text
		--Cast before the pivot in case fields are different types
		,CAST (fld_Total_Sect1 AS NVARCHAR(50)) AS fld_Total_Sect1
		,CAST (fld_Total_Sect2 AS NVARCHAR(50)) AS fld_Total_Sect2
		,CAST (fld_Total_Sect3 AS NVARCHAR (50)) AS fld_Total_Sect3
		,fld_performance_lvl
		,'' AS parent_test_section_code
		,'K' AS low_test_level_code
		,'05' AS high_test_level_code
		/*Pad the grade with a zero for grades less than 10th */
		,fld_GRDE AS test_level_name
		,'' AS version_code
		,'' score_group_label
		,fld_LST_NME AS last_name
		,fld_FRST_NME AS first_name
		/*concatenate the year, month and day--*/
		,SUBSTRING (CAST (fld_BRTH_DT AS NVARCHAR (10)), 1,4)+'-'+SUBSTRING (CAST (fld_BRTH_DT AS NVARCHAR (10)), 5,2)+'-'+SUBSTRING (CAST (fld_BRTH_DT AS NVARCHAR (10)), 7,8)  AS DOB
		,'' AS raw_score
		,'' AS scaled_score
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
		,'' AS score_scaled_name
		,'' AS score_nce_name
		,'' AS score_percentile_name
		,'' AS score_1_name
		,'' AS score_2_name
		,'' AS score_3_name
		,'Total Correct' AS score_4_name
		,'' AS score_5_name
		,'' AS score_6_name
		,'' AS score_7_name
		,'Score Text' AS score_8_name
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

	FROM results AS DRA
	INNER JOIN
	[Question_Dropdowns_EDL] AS QDD
	ON
	DRA.fld_Assessment_Used = QDD.fld_Assessment
	AND	DRA.fld_Level = QDD.fld_Level
	AND DRA.fld_story = QDD.fld_levelTitles
	INNER JOIN
	CATEGORIES_DRA_TABLE AS CAT
	ON
	QDD.fld_CategoryName = CAT.fld_CategoryName
	INNER JOIN
	[Total_Scores_DRA] AS TOTALS
	ON
	DRA.fld_Level = TOTALS.fld_Level
	AND DRA.fld_Total_Sect3 = TOTALS.fld_Valid_Total_Score
	AND TOTALS.fld_Section_Number = '3'
	AND fld_Assessment_Used = 'EDL'
	AND
	CASE
		WHEN DRA.fld_Story = 'BRIDGE-Amelia Earhart' THEN 'BRIDGE-Amelia Earhart'
		WHEN DRA.fld_Story = 'BRIDGE-Energy From the Sun' THEN 'BRIDGE-Energy From the Sun'
		WHEN DRA.fld_Story = 'BRIDGE-Hero' THEN 'BRIDGE-Hero'
		WHEN DRA.fld_Story = 'BRIDGE-Incredible Journeys' THEN 'BRIDGE-Incredible Journeys'
		WHEN DRA.fld_Story = 'BRIDGE-The Blasters' THEN 'BRIDGE-The Blasters'
		WHEN DRA.fld_Story = 'BRIDGE-The Flood' THEN 'BRIDGE-The Flood'
		WHEN DRA.fld_Story = 'BRIDGE-The Navajo Way' THEN 'BRIDGE-The Navajo Way'
		WHEN DRA.fld_Story = 'BRIDGE-What Carlos Wants' THEN 'BRIDGE-What Carlos Wants'
		ELSE 'none'
	END	= TOTALS.fld_Story	
	WHERE
	fld_AssessmentWindow = 'Winter' 
	)AS DRA
UNPIVOT
(totals FOR some_score In (fld_Total_Sect3 ) )as unpvt
		--where student_code = '104634118'
		--where student_code = '970095940'

	ORDER BY TEST_SECTION_NAME	
		
--ROLLBACK
