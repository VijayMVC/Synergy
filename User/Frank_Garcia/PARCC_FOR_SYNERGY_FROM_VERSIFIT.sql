SELECT
	SIS_NUMBER
	,TEST_NAME
	,SCHOOL_CODE
	,GRADE
	,TEST_DATE
	,SCALED_SCORE
	,CASE WHEN PERFORMANCE_LEVEL = 'Did Not Yet Meet Expectations' THEN 'DNME'
	      WHEN PERFORMANCE_LEVEL = 'Approached Expectations' THEN 'APEX'
		  WHEN PERFORMANCE_LEVEL = 'Partially Met Expectations' THEN 'PART'
		  WHEN PERFORMANCE_LEVEL = 'Met Expectations' THEN 'METX'
		  WHEN PERFORMANCE_LEVEL = 'Exceeded Expectations' THEN 'EXEX'
	END AS PERFORMANCE_LEVEL
	,SIS_SCHOOL_YEAR AS SCH_YR
FROM
(
SELECT
	ROW_NUMBER () OVER (PARTITION BY STUDENT_ID ORDER BY STUDENT_ID, TEST_SCORE_VALUE DESC) AS RN
    ,STUDENT_ID AS SIS_NUMBER
    ,TEST_NAME
    ,'' AS TEST_WINDOW
    ,DTBL_SCHOOLS.SCHOOL_CODE
    ,TEST_STUDENT_GRADE AS GRADE
    ,YEAR_VALUE AS YEAR
    ,TEST_SUBJECT AS CONTENT_AREA
    ,CONVERT (CHAR(10), DTBL_CALENDAR_DATES.DATE_VALUE,126) AS TEST_DATE
    ,CAST(TEST_SCORE_VALUE AS INT) AS SCALED_SCORE
	,CAST(TEST_RAW_SCORE AS INT) AS RAW_SCORE
    ,TEST_PRIMARY_RESULT AS PERFORMANCE_LEVEL
    --,TEST_NAME
	,SIS_SCHOOL_YEAR
    ,TEST_CLASS
    ,TEST_GROUP
    ,TEST_SUBGROUP
    ,TEST_ADMIN_PERIOD
	,TEST_VENDOR
FROM K12INTEL_DW.FTBL_TEST_SCORES
INNER JOIN K12INTEL_DW.DTBL_TESTS
ON DTBL_TESTS.TESTS_KEY = FTBL_TEST_SCORES.TESTS_KEY 

INNER JOIN K12INTEL_DW.DTBL_STUDENTS 
ON DTBL_STUDENTS.STUDENT_KEY = FTBL_TEST_SCORES.STUDENT_KEY 

INNER JOIN K12INTEL_DW.DTBL_SCHOOLS
ON DTBL_SCHOOLS.SCHOOL_KEY = FTBL_TEST_SCORES.SCHOOL_KEY

INNER JOIN K12INTEL_DW.DTBL_CALENDAR_DATES
ON DTBL_CALENDAR_DATES.CALENDAR_DATE_KEY= FTBL_TEST_SCORES.CALENDAR_DATE_KEY

INNER JOIN K12INTEL_DW.DTBL_SCHOOL_DATES
ON DTBL_SCHOOL_DATES.SCHOOL_DATES_KEY = FTBL_TEST_SCORES.SCHOOL_DATES_KEY 

WHERE 1 = 1
--AND TEST_NAME LIKE 'PARCC%'
AND TEST_VENDOR = 'PARCC'
--AND TEST_GROUP = 'Algebra I'
--AND TEST_GROUP = 'Algebra II'
--AND TEST_GROUP = 'ELA'
--AND TEST_NAME = 'PARCC Grade 09 � English Language Arts � Overall'
--AND TEST_GROUP = 'PARCC Grade 10 � English Language Arts � Reading'
--AND TEST_GROUP = 'PARCC Grade 09 � English Language Arts � Reading'
--AND TEST_NAME IN ('PARCC Grade 03 � English Language Arts � Overall','PARCC Grade 04 � English Language Arts � Overall','PARCC Grade 05 � English Language Arts � Overall','PARCC Grade 06 � English Language Arts � Overall','PARCC Grade 07 � English Language Arts � Overall')
--AND TEST_NAME LIKE 'PARCC Grade 03%'
--AND TEST_GROUP = 'Geometry'
--AND TEST_GROUP = 'Integrated Mathematics'
--AND TEST_GROUP = 'Integrated Mathematics II'
--AND TEST_GROUP = 'Mathematics'
AND (TEST_NAME LIKE 'PARCC GRADE 03%'
OR TEST_NAME LIKE 'PARCC GRADE 04%'
OR TEST_NAME LIKE 'PARCC GRADE 05%')
AND TEST_NAME LIKE '%MATH%'
AND TEST_CLASS = 'COMPONENT'
--AND DTBL_CALENDAR_DATES.DATE_VALUE = '2016-04-01'
AND LOCAL_SCHOOL_YEAR = '2015-2016'
--AND TEST_RAW_SCORE IS NOT NULL
--AND TEST_SCORE_VALUE IS NOT NULL
) AS T1

WHERE 
1 = 1
AND RN = 1
--AND SIS_NUMBER = '100062983'
--ORDER BY SCALED_SCORE
order by SIS_NUMBER
