
SELECT
	NA.[Student Name]
	,NA.[Perm id]
	,NA.[Ethnic Code]
	,NA.[Grade]
	,NA.[School]
	,NA.[Tribal Community]
	,NA.[506]
	,NA.[Cert Indian Blood]
	,NA.[DateSigned]
	,NA.[Address]
	,NA.[City, State Zip]
	,NA.[Phone]
	,PARCC.TEST_SCORE
	,PARCC.PART_DESCRIPTION AS TEST_NAME
       ,CASE WHEN PL = 'PART' THEN 'Partially met expectations'
		     WHEN PL = 'METX' THEN 'Met expectations'
			 WHEN PL = 'APEX' THEN 'Approached expectations'
			 WHEN PL = 'DNME' THEN 'Did not yet meet expectations'
			 WHEN PL = 'EXEX' THEN 'Exceeded expectations'
	   END AS PERFORMANCE_LEVEL
FROM

(
SELECT DISTINCT * FROM
(
SELECT 
	   ROW_NUMBER () OVER (PARTITION BY SIS_NUMBER ORDER BY TEST_SCORE DESC) AS RN
	   ,PERSON.FIRST_NAME
       ,PERSON.LAST_NAME
       ,CAST (SIS_NUMBER AS INT) AS SIS_NUMBER
       ,TEST.TEST_NAME
	   ,PART.PART_DESCRIPTION
	   ,TEST.TEST_LEVEL
	   ,TEST.TEST_FORM
	   ,'' AS SCHOOL_YEAR
	   ,'' AS TEST_DESCRIPTION
	   ,TEST.TEST_TYPE
	   ,TEST.TEST_GROUP
	   ,TEST.TEST_DEF_CODE
       --,PART.PART_DESCRIPTION
       ,SCORE_DESCRIPTION
       ,STU_PART.PERFORMANCE_LEVEL AS PL
       ,SCORES.TEST_SCORE
       ,STUDENTTEST.ADMIN_DATE
       ,PART.PART_NUMBER
	   ,TST_GRPYT.TEST_REQ_MIN_SCORE
	   ,TST_GRPY.TEST_GROUP_NAME
	   ,DEF_GRPYT.TEST_ATTEMPTS_MIN
	   ,GRPYT_PL.PERFORMANCE_LEVEL
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

	   LEFT JOIN
	   REV.EPC_GRAD_REQ_DEF_TST_GRPYT AS TST_GRPYT
	   ON
	   TEST.TEST_GU = TST_GRPYT.TEST_GU
	   AND PART.TEST_PART_GU = TST_GRPYT.TEST_PART_GU
	   
	   LEFT JOIN
	   REV.EPC_GRAD_REQ_DEF_TST_GRPY AS TST_GRPY
	   ON 
	   TST_GRPY.GRAD_REQ_DEF_TST_GRPY_GU = TST_GRPYT.GRAD_REQ_DEF_TST_GRPY_GU

	   LEFT JOIN
	   REV.EPC_GRAD_REQ_DEF_GRPYT_REQ AS DEF_GRPYT
	   ON
	   DEF_GRPYT.TEST_GU = TEST.TEST_GU
	   AND DEF_GRPYT.GRAD_REQ_DEF_TST_GRPTY_GU = TST_GRPYT.GRAD_REQ_DEF_TST_GRPTY_GU

	   LEFT JOIN
	   REV.EPC_GRAD_REQ_DEF_GRPYT_PL AS GRPYT_PL
	   ON GRPYT_PL.GRAD_REQ_DEF_TST_GRPTY_GU = DEF_GRPYT.GRAD_REQ_DEF_TST_GRPTY_GU



WHERE
1 = 1
       --AND TEST_NAME = 'WAPT'
	   --AND PART_DESCRIPTION LIKE '%PARCC%'
	   AND TEST_NAME IN ('PARCC HS Geometry','PARCC HS Algebra II','PARCC MS Math 06-08')
       --AND TEST_NAME  = 'PARCC MS Math 06-08'
       --AND SCORE_DESCRIPTION IN ('Overall LP')
	   --AND TEST_SCORE != 'NA'
       --AND TEST_NAME = 'EOC Music 9 12 V001'
) AS T1
WHERE RN = 1
) AS PARCC

		RIGHT OUTER JOIN
		OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\SynTempSSIS\Files\TempQuery\;',
			'SELECT * from 2015_2016_Native_American_students_062716.csv' 
		)AS [NA]
		ON
		PARCC.[SIS_NUMBER] = NA.[Perm ID]
--ORDER BY SIS_NUMBER,ADMIN_DATE, PART_DESCRIPTION, SCORE_DESCRIPTION
--where SIS_NUMBER = '102790268'
ORDER BY  SIS_NUMBER

--ORDER BY TEST_SCORE