USE Assessments
GO


SELECT * FROM

(
SELECT

	student_code AS ID_NBR
	,score_4 AS TEST_DT
	,school_code AS SCH_NBR
	,test_level_name AS GRDE
	,LTRIM(RTRIM(score_1)) AS SCORE_1
	,score_group_name AS LEVEL
	,TEST_SECTION_NAME AS TEST_SUB
	,ROW_NUMBER () OVER (PARTITION BY STUDENT_CODE ORDER BY TEST_DATE_CODE) AS RN
	FROM [dbo].[test_result_WAPT]
) AS T1
WHERE RN = 1
--AND ID_NBR  in ('980023220','980023282','980023300','980023301','980023406','980023410','980023260','980023367','980023288','980023231')
--AND ID_NBR != ''
--AND SCORE_1 != '01'
--AND ID_NBR = '970108507'
--AND ID_NBR IN ('980027801','980029643','980032024','980032055','980029375','980027102')
ORDER BY SCORE_1