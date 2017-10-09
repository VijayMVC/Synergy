	--can take WAPT only once
	--ACCESS can be taken multiple years




EXECUTE AS LOGIN='QueryFileUser'
GO

with STUDENTCTE
AS
(

SELECT
	 [Student Last Name] as STUDENT_LAST_NAME,
	 [Student First Name] AS STUDENT_FIRST_NAME,
	 APS_ID as STUDENT_APS_ID

	 --ROWNUM, FIRSTNAME, LASTNAME, SISNUMBER, TESTNAME,  PERFLEVEL, TESTSCORE, ADMINDATE           
FROM
	OPENROWSET (
		'Microsoft.ACE.OLEDB.12.0', 
		'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
		'SELECT * from Lutheran_Family_Services_2016.csv')
INNER JOIN
	APS.BasicStudentWithMoreInfo BS
	ON BS.SIS_NUMBER = APS_ID
                ) 
--SELECT * FROM STUDENTCTE

,
TESTCTE
AS
(

SELECT 
	ROW_NUMBER () OVER (PARTITION BY SIS_NUMBER ORDER BY TEST_SCORE DESC) AS ROWNUM
	--,PERSON.FIRST_NAME
	--,PERSON.LAST_NAME
	,CAST (SIS_NUMBER AS INT) AS SIS_NUMBER
	,TEST.TEST_NAME
	,STU_PART.PERFORMANCE_LEVEL AS PL
	,SCORES.TEST_SCORE
	,STUDENTTEST.ADMIN_DATE
FROM
	rev.EPC_STU_TEST AS StudentTest

	JOIN
	rev.EPC_TEST_PART AS PART
	ON StudentTest.TEST_GU = PART.TEST_GU

	JOIN
	rev.EPC_STU_TEST_PART AS STU_PART
	ON PART.TEST_PART_GU = STU_PART.TEST_PART_GU
	AND STU_PART.STUDENT_TEST_GU = StudentTest.STUDENT_TEST_GU

    INNER JOIN
    rev.EPC_STU_TEST_PART_SCORE AS SCORES
    ON
    SCORES.STU_TEST_PART_GU = STU_PART.STU_TEST_PART_GU

    LEFT JOIN
    rev.EPC_TEST_SCORE_TYPE AS SCORET
    ON
    SCORET.TEST_GU = StudentTest.TEST_GU
    AND SCORES.TEST_SCORE_TYPE_GU = SCORET.TEST_SCORE_TYPE_GU

    LEFT JOIN
    rev.EPC_TEST_DEF_SCORE AS SCORETDEF
    ON
    SCORETDEF.TEST_DEF_SCORE_GU = SCORET.TEST_DEF_SCORE_GU

	LEFT JOIN
	rev.EPC_TEST AS TEST
	ON TEST.TEST_GU = StudentTest.TEST_GU

	LEFT OUTER JOIN
	rev.EPC_STU AS Student
	ON Student.STUDENT_GU = StudentTest.STUDENT_GU

	--INNER JOIN
	--rev.REV_PERSON AS Person
	--ON Person.PERSON_GU = StudentTest.STUDENT_GU

	LEFT JOIN
	APS.PrimaryEnrollmentsAsOf(GETDATE()) AS Enroll
	ON
	StudentTest.STUDENT_GU = Enroll.STUDENT_GU

	LEFT JOIN
	rev.REV_ORGANIZATION_YEAR AS OrgYear
	ON
	Enroll.ORGANIZATION_YEAR_GU = OrgYear.ORGANIZATION_YEAR_GU

	LEFT JOIN
	rev.REV_ORGANIZATION AS Org
	ON
	OrgYear.ORGANIZATION_GU = Org.ORGANIZATION_GU

	LEFT JOIN
	APS.LookupTable('K12','Grade') AS GradeLevel
	ON
	Enroll.GRADE = GradeLevel.VALUE_CODE


WHERE
1 = 1
        AND TEST.TEST_NAME LIKE '%ACCESS%'
		AND SCORE_DESCRIPTION IN ('Overall LP')

)
--select * from TESTCTE WHERE ROWNUM = 1
,
RESULTCTE
AS
(
SELECT 
	SIS_NUMBER,
	TEST_NAME,
	PL,
	TEST_SCORE,
	ADMIN_DATE
FROM TESTCTE
WHERE
 ROWNUM = 1
)

SELECT
	 
	STU.STUDENT_LAST_NAME,
	STU.STUDENT_FIRST_NAME,
	STU.STUDENT_APS_ID,
	RESULT.TEST_NAME,
	RESULT.PL,
	RESULT.TEST_SCORE,
	RESULT.ADMIN_DATE
	 --ROWNUM, FIRSTNAME, LASTNAME, SISNUMBER, TESTNAME,  PERFLEVEL, TESTSCORE, ADMINDATE           
FROM
	STUDENTCTE STU
LEFT OUTER JOIN
	RESULTCTE RESULT
	ON STU.STUDENT_APS_ID = RESULT.SIS_NUMBER
--WHERE
--	ROWNUM = 1
ORDER BY
	 STU.STUDENT_APS_ID

	REVERT
	GO