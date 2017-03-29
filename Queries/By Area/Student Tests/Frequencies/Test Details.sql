
--SELECT 
--	 VALUE_DESCRIPTION AS GRADE, COUNT(*) AS COUNT_OF_STUDENTS
--	FROM (

SELECT 
	  --DISTINCT student.STUDENT_GU, 
	  GRD.VALUE_DESCRIPTION AS GRADE,
	  ORG.ORGANIZATION_NAME
	   ,PERSON.FIRST_NAME
       ,PERSON.LAST_NAME
       ,SIS_NUMBER
       ,TEST.TEST_NAME
	   ,PART.PART_DESCRIPTION
	   ,TEST.TEST_TYPE
	   ,TEST.TEST_GROUP
	   ,TEST.TEST_DEF_CODE
       ,SCORE_DESCRIPTION
	   ,LU.VALUE_DESCRIPTION AS PERFORMANCE_LEVEL
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

       INNER JOIN
       rev.EPC_STU AS Student
       ON Student.STUDENT_GU = StudentTest.STUDENT_GU

       INNER JOIN
       rev.REV_PERSON AS Person
       ON Person.PERSON_GU = StudentTest.STUDENT_GU

	   INNER JOIN 
	   APS.LookupTable('K12.TestInfo','PERFORMANCE_LEVELS') AS LU
	   ON
	   STU_PART.PERFORMANCE_LEVEL = LU.VALUE_CODE

	   --LEFT JOIN 
	   --APS.PrimaryEnrollmentDetailsAsOf(GETDATE()) AS PRIM
	   --ON
	   --PRIM.STUDENT_GU = Student.STUDENT_GU
	   INNER JOIN 
	   REV.REV_ORGANIZATION AS ORG
	   ON
	   StudentTest.ORGANIZATION_GU = ORG.ORGANIZATION_GU

	   INNER JOIN 
	   APS.LookupTable('K12','GRADE') AS GRD
	   ON
	   GRD.VALUE_CODE = StudentTest.GRADE

WHERE
       TEST_NAME LIKE '%SBA%'
	   AND ADMIN_DATE = '2016-10-01'
	   --AND PART_DESCRIPTION = @PART
       --AND SCORE_DESCRIPTION IN ('Scale')

--) AS T1
--GROUP BY VALUE_DESCRIPTION