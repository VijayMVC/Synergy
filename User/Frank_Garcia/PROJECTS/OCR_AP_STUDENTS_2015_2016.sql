SELECT DISTINCT 
	SIS_NUMBER
	,LAST_NAME
	,FIRST_NAME
	,RACE_1
	,RACE_2
	,HISPANIC_INDICATOR
	,SPED_STATUS
	,GENDER
	,ELL_STATUS
	,ACCESS_504
	,TWO_OR_MORE
	,GRADE
	,ORGANIZATION_NAME AS 'SCHOOL NAME'
	,SCHOOL_CODE AS 'SCHOOL CODE'
	--,TEST_NAME
FROM
(
SELECT 
	   ROW_NUMBER () OVER (PARTITION BY StudentTest.STUDENT_GU ORDER BY StudentTest.STUDENT_GU) AS RN
	   ,PERSON.FIRST_NAME
       ,PERSON.LAST_NAME
       ,CAST (Student.SIS_NUMBER AS INT) AS SIS_NUMBER
       ,STUDENTTEST.ADMIN_DATE
	   ,BS.RACE_1
	   ,CASE WHEN BS.RACE_2 IS NULL THEN '' ELSE BS.RACE_2
	   END AS RACE_2
	   ,CASE 
       WHEN (BS.Race_1 != '' AND BS.Race_2 != '') THEN 'Two or more races' 
       WHEN BS.Race_1 = 'White' AND BS.HISPANIC_INDICATOR = 'Y' THEN 'Hispanic' 
       ELSE BS.Race_1 END AS TWO_OR_MORE
	   ,BS.HISPANIC_INDICATOR
	   ,BS.SPED_STATUS
	   ,BS.GENDER
	   ,BS.ELL_STATUS
	   ,CASE WHEN SSY.ACCESS_504 IS NULL THEN '' ELSE SSY.ACCESS_504 
	   END AS ACCESS_504
	   ,GRADE.VALUE_DESCRIPTION AS GRADE
	   ,ORG.ORGANIZATION_NAME
	   ,SCH.SCHOOL_CODE
	   --,TEST_NAME
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
    rev.EPC_TEST AS TEST
    ON TEST.TEST_GU = StudentTest.TEST_GU

    INNER JOIN
    rev.EPC_STU AS Student
    ON Student.STUDENT_GU = StudentTest.STUDENT_GU

    INNER JOIN
    rev.REV_PERSON AS Person
    ON Person.PERSON_GU = StudentTest.STUDENT_GU

	JOIN
	APS.BasicStudentWithMoreInfo AS BS
	ON BS.STUDENT_GU = StudentTest.STUDENT_GU

	JOIN
	APS.EnrollmentsForYear ('BCFE2270-A461-4260-BA2B-0087CB8EC26A') ENR
	ON ENR.STUDENT_GU = StudentTest.STUDENT_GU

	JOIN
	rev.EPC_STU_SCH_YR AS SSY
	ON SSY.STUDENT_SCHOOL_YEAR_GU = ENR.STUDENT_SCHOOL_YEAR_GU

	JOIN
	rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') grade ON grade.VALUE_CODE = ENR.GRADE

	JOIN
	REV.REV_ORGANIZATION AS ORG
	ON ORG.ORGANIZATION_GU = ENR.ORGANIZATION_GU

	JOIN
	REV.EPC_SCH SCH
	ON SCH.ORGANIZATION_GU = ORG.ORGANIZATION_GU

	--JOIN

WHERE
1 = 1
	   AND TEST_NAME LIKE '%ap %'
	   AND ADMIN_DATE = '2016-05-01 00:00:00'
	   AND ENR.EXCLUDE_ADA_ADM IS NULL
	   AND SCORES.TEST_SCORE IN ('003','004','005') --- For students who passed the tests
       ----AND SCORE_DESCRIPTION IN ('Overall LP')
	   --AND TEST_SCORE != 'NA'
       --AND TEST_NAME = 'EOC Music 9 12 V001'
) AS T1
WHERE 1 = 1
AND RN = 1
--ORDER BY SIS_NUMBER,ADMIN_DATE, PART_DESCRIPTION, SCORE_DESCRIPTION
--where SIS_NUMBER = '102790268'
ORDER BY  SIS_NUMBER
--ORDER BY TEST_SCORE