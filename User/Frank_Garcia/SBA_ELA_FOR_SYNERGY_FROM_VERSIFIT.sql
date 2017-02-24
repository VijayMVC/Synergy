SELECT 
    STUDENT_ID AS SIS_NUMBER
    ,TEST_NAME
    ,'SPRING' AS TEST_WINDOW
    ,DTBL_SCHOOLS.SCHOOL_CODE
    ,TEST_STUDENT_GRADE AS GRADE
    ,YEAR_VALUE AS YEAR
    --,TEST_PRODUCT 
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
	--,FTBL_TEST_SCORES.TESTS_KEY
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
AND TEST_PRODUCT = 'SBA-NM'
AND TEST_NAME = 'SBA-NM SLA'
--AND TEST_SUBGROUP IN ('TOT','Composite')
AND LOCAL_SCHOOL_YEAR = '2015-2016'
AND TEST_RAW_SCORE IS NOT NULL
--AND TEST_STUDENT_GRADE IN ('03','04','05')  ---ES 
--AND TEST_STUDENT_GRADE IN ('06','07','08')  ---MS
AND TEST_STUDENT_GRADE IN ('11','H2','H3')  ---HS
--AND STUDENT_ID = '980002497'
AND TEST_SCORE_VALUE IS NOT NULL

ORDER BY SIS_NUMBER