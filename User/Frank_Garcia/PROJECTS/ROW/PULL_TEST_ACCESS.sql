

EXECUTE AS LOGIN='QueryFileUser'
GO

WITH ACCESS_SCORE AS
(
SELECT
	*
FROM
(
SELECT 
    STUDENT_ID AS SIS_NUMBER
    ,DTBL_STUDENTS.STUDENT_GRADUATION_COHORT
    --,TEST_NAME
    --,TEST_EXTERNAL_CODE AS TEST_WINDOW
    --,DTBL_SCHOOLS.SCHOOL_CODE
    --,TEST_STUDENT_GRADE
    ,LOCAL_SCHOOL_YEAR AS YEAR
    ,TEST_PRODUCT 
    ,TEST_SUBJECT AS CONTENT_AREA
    ,CONVERT(VARCHAR,DTBL_CALENDAR_DATES.DATE_VALUE,101) AS TEST_DATE
    ,TEST_SCORE_VALUE AS SCORE
    --,TEST_PRIMARY_RESULT AS PERFORMANCE_LEVEL
	--,SIS_SCHOOL_YEAR
    --,TEST_CLASS
    --,TEST_GROUP
    --,TEST_SUBGROUP
    --,TEST_ADMIN_PERIOD
FROM [VERSIFIT.APS.EDU.ACTD].K12INTEL.K12INTEL_DW.FTBL_TEST_SCORES
INNER JOIN [VERSIFIT.APS.EDU.ACTD].K12INTEL.K12INTEL_DW.DTBL_TESTS
ON DTBL_TESTS.TESTS_KEY = FTBL_TEST_SCORES.TESTS_KEY 
INNER JOIN [VERSIFIT.APS.EDU.ACTD].K12INTEL.K12INTEL_DW.DTBL_STUDENTS 
ON DTBL_STUDENTS.STUDENT_KEY = FTBL_TEST_SCORES.STUDENT_KEY 
INNER JOIN [VERSIFIT.APS.EDU.ACTD].K12INTEL.K12INTEL_DW.DTBL_SCHOOLS
ON DTBL_SCHOOLS.SCHOOL_KEY = FTBL_TEST_SCORES.SCHOOL_KEY
INNER JOIN [VERSIFIT.APS.EDU.ACTD].K12INTEL.K12INTEL_DW.DTBL_CALENDAR_DATES
ON DTBL_CALENDAR_DATES.CALENDAR_DATE_KEY= FTBL_TEST_SCORES.CALENDAR_DATE_KEY
INNER JOIN [VERSIFIT.APS.EDU.ACTD].K12INTEL.K12INTEL_DW.DTBL_SCHOOL_DATES
ON DTBL_SCHOOL_DATES.SCHOOL_DATES_KEY = FTBL_TEST_SCORES.SCHOOL_DATES_KEY 
WHERE TEST_PRODUCT = 'ACCESS'
--AND TEST_SUBGROUP IN ('TOT','Composite')
--AND LOCAL_SCHOOL_YEAR = '2015-2016'
--AND TEST_EXTERNAL_CODE = 'BEG'
--AND STUDENT_ID = '970051258'
) AS ST
PIVOT
	(MAX(SCORE) FOR CONTENT_AREA IN ([LITERACY],[ORAL],[READING],[SPEAKING],[COMPREHENSION],[OVERALL],[LISTENING])) AS UP1
)

, ACCESS_PL AS
(
SELECT
	*
FROM
(
SELECT 
    STUDENT_ID AS SIS_NUMBER
    ,DTBL_STUDENTS.STUDENT_GRADUATION_COHORT
    --,TEST_NAME
    --,TEST_EXTERNAL_CODE AS TEST_WINDOW
    --,DTBL_SCHOOLS.SCHOOL_CODE
    --,TEST_STUDENT_GRADE
    ,LOCAL_SCHOOL_YEAR AS YEAR
    ,TEST_PRODUCT 
    ,TEST_SUBJECT AS CONTENT_AREA
    ,CONVERT(VARCHAR,DTBL_CALENDAR_DATES.DATE_VALUE,101) AS TEST_DATE
    --,TEST_SCORE_VALUE AS SCORE
    ,TEST_PRIMARY_RESULT AS SCORE
	--,SIS_SCHOOL_YEAR
    --,TEST_CLASS
    --,TEST_GROUP
    --,TEST_SUBGROUP
    --,TEST_ADMIN_PERIOD
FROM [VERSIFIT.APS.EDU.ACTD].K12INTEL.K12INTEL_DW.FTBL_TEST_SCORES
INNER JOIN [VERSIFIT.APS.EDU.ACTD].K12INTEL.K12INTEL_DW.DTBL_TESTS
ON DTBL_TESTS.TESTS_KEY = FTBL_TEST_SCORES.TESTS_KEY 
INNER JOIN [VERSIFIT.APS.EDU.ACTD].K12INTEL.K12INTEL_DW.DTBL_STUDENTS 
ON DTBL_STUDENTS.STUDENT_KEY = FTBL_TEST_SCORES.STUDENT_KEY 
INNER JOIN [VERSIFIT.APS.EDU.ACTD].K12INTEL.K12INTEL_DW.DTBL_SCHOOLS
ON DTBL_SCHOOLS.SCHOOL_KEY = FTBL_TEST_SCORES.SCHOOL_KEY
INNER JOIN [VERSIFIT.APS.EDU.ACTD].K12INTEL.K12INTEL_DW.DTBL_CALENDAR_DATES
ON DTBL_CALENDAR_DATES.CALENDAR_DATE_KEY= FTBL_TEST_SCORES.CALENDAR_DATE_KEY
INNER JOIN [VERSIFIT.APS.EDU.ACTD].K12INTEL.K12INTEL_DW.DTBL_SCHOOL_DATES
ON DTBL_SCHOOL_DATES.SCHOOL_DATES_KEY = FTBL_TEST_SCORES.SCHOOL_DATES_KEY 
WHERE TEST_PRODUCT = 'ACCESS'
--AND TEST_SUBGROUP IN ('TOT','Composite')
--AND LOCAL_SCHOOL_YEAR = '2015-2016'
--AND TEST_EXTERNAL_CODE = 'BEG'
--AND STUDENT_ID = '970051258'
) AS ST
PIVOT
	(MAX(SCORE) FOR CONTENT_AREA IN ([LITERACY],[ORAL],[READING],[SPEAKING],[COMPREHENSION],[OVERALL],[LISTENING])) AS UP1
)

SELECT
	ACS.SIS_NUMBER
	,ACS.YEAR
	,ACS.TEST_DATE
	,ACS.LITERACY AS LIT_SCORE
	,APL.LITERACY AS LIT_PL
	,ACS.ORAL AS ORAL_SCORE
	,APL.ORAL AS ORAL_PL
	,ACS.READING AS READING_SCORE
	,APL.READING AS READING_PL
	,ACS.SPEAKING AS SPEAKING_SCORE
	,APL.SPEAKING AS SPEAKING_PL
	,ACS.LISTENING AS LISTENING_SCORE
	,APL.LISTENING AS LISTENING_PL
	,ACS.COMPREHENSION AS COMP_SCORE
	,APL.COMPREHENSION AS COMP_PL
	,ACS.OVERALL AS OVERALL_SCORE
	,APL.OVERALL AS OVERALL_PL
FROM

		OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
			'SELECT * FROM APS_identified_data_RELSW.csv'  
		)AS [FILE]

LEFT JOIN
REV.EPC_STU AS STU
ON STU.STATE_STUDENT_NUMBER = [FILE].STUDENT_ID
JOIN
	ACCESS_SCORE AS ACS
	ON ACS.SIS_NUMBER = STU.SIS_NUMBER
JOIN
	ACCESS_PL AS APL
	ON STU.SIS_NUMBER = APL.SIS_NUMBER
	AND ACS.[YEAR] = APL.[YEAR]
ORDER BY SIS_NUMBER, [YEAR]


REVERT
GO
