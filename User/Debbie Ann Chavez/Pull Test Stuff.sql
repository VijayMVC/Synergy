

SELECT 
	 PERFORMANCE_LEVEL, COUNT(*) AS COUNT_OF_STUDENTS
	FROM (

SELECT 
DISTINCT SIS_NUMBER, PERFORMANCE_LEVEL
/*
       SCHOOL
	   ,SYN.FIRST_NAME
       ,SYN.LAST_NAME
      -- ,ACCU.STUDENT_CODE
       ,SIS_NUMBER
       ,GRADE
	   ,TEST_NAME
      -- ,ACCU.TEST_SECTION_NAME
       ,PART_DESCRIPTION
       ,SCORE_DESCRIPTION
       ,PERFORMANCE_LEVEL
       ,TEST_SCORE
       --,ACCU.SCALED_SCORE
       ,CAST (ADMIN_DATE AS DATE) AS DATES
       ,ADMIN_DATE
       ,PART_NUMBER
*/

FROM
(
SELECT 
       ORG.ORGANIZATION_NAME AS SCHOOL
	   ,PERSON.FIRST_NAME
       ,PERSON.LAST_NAME
       ,SIS_NUMBER
       ,GRADE.VALUE_DESCRIPTION AS GRADE
	   ,TEST.TEST_NAME
      /*
	   ,CASE 
             WHEN PART.PART_DESCRIPTION = 'ELEMENTARY ALGEGRA' THEN 'Elementary Algebra'
             ELSE PART.PART_DESCRIPTION
       END AS PART_DESCRIPTION
	   */
	   ,PART_DESCRIPTION
       ,SCORE_DESCRIPTION
       ,STU_PART.PERFORMANCE_LEVEL
       ,SCORES.TEST_SCORE
       ,STUDENTTEST.ADMIN_DATE
       ,PART.PART_NUMBER
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

       INNER JOIN
       rev.EPC_STU AS Student
       ON Student.STUDENT_GU = StudentTest.STUDENT_GU

       INNER JOIN
       rev.REV_PERSON AS Person
       ON Person.PERSON_GU = StudentTest.STUDENT_GU

       INNER JOIN
       APS.PrimaryEnrollmentsAsOf(GETDATE()) AS Enroll
       ON
       StudentTest.STUDENT_GU = Enroll.STUDENT_GU

       INNER JOIN
       rev.REV_ORGANIZATION_YEAR AS OrgYear
       ON
       Enroll.ORGANIZATION_YEAR_GU = OrgYear.ORGANIZATION_YEAR_GU

       INNER JOIN
       rev.REV_ORGANIZATION AS Org
       ON
       OrgYear.ORGANIZATION_GU = Org.ORGANIZATION_GU

       LEFT JOIN
       APS.LookupTable('K12','Grade') AS GRADE
       ON
       Enroll.GRADE = GRADE.VALUE_CODE


WHERE
       TEST_NAME like '%NMAPA%'
	   AND ADMIN_DATE = '2016-04-01 00:00:00'
	   --AND PART_DESCRIPTION LIKE '%Science%'

       --AND SIS_NUMBER = '102785458'
       --AND SCORE_DESCRIPTION IN ('Raw','Scale')
       --AND TEST_NAME = 'EOC Music 9 12 V001'
       --AND ADMIN_DATE >= '2014-04-01 00:00:00'
       --AND SIS_NUMBER = '100021021'
) AS SYN

--ORDER BY SIS_NUMBER
/*
RIGHT JOIN
       [RDAVM.APS.EDU.ACTD].ASSESSMENTS.DBO.TEST_RESULT_ACCUPLACER AS ACCU
       ON SYN.SIS_NUMBER = ACCU.STUDENT_CODE
       AND SYN.PART_DESCRIPTION = ACCU.TEST_SECTION_NAME
       AND SYN.TEST_SCORE = ACCU.SCALED_SCORE
       AND CAST(SYN.ADMIN_DATE AS DATE) = ACCU.TEST_DATE_CODE

--WHERE ACCU.TEST_SECTION_NAME != 'ARITHMETIC'
--AND ACCU.STUDENT_CODE = '100010768'
--AND SIS_NUMBER IS NOT NULL
--and accu.test_section_name != 'Arithmetic'
ORDER BY SIS_NUMBER
--ORDER BY SIS_NUMBER, PART_DESCRIPTION, ADMIN_DATE
--ORDER BY SIS_NUMBER
--ORDER BY TEST_SCORE
*/
) AS T1

GROUP BY PERFORMANCE_LEVEL
ORDER BY PERFORMANCE_LEVEL
