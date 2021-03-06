

WITH FALL_2015_DIB AS
(
SELECT 
    STUDENT_ID AS SIS_NUMBER
    ,TEST_SCORE_VALUE AS SCORE
    ,TEST_PRIMARY_RESULT AS PERFORMANCE_LEVEL
FROM [VERSIFIT.APS.EDU.ACTD].K12INTEL.K12INTEL_DW.FTBL_TEST_SCORES AS TS
INNER JOIN [VERSIFIT.APS.EDU.ACTD].K12INTEL.K12INTEL_DW.DTBL_TESTS AS TSTS
ON TSTS.TESTS_KEY = TS.TESTS_KEY 
INNER JOIN [VERSIFIT.APS.EDU.ACTD].K12INTEL.K12INTEL_DW.DTBL_STUDENTS AS STUDS
ON STUDS.STUDENT_KEY = TS.STUDENT_KEY 
INNER JOIN [VERSIFIT.APS.EDU.ACTD].K12INTEL.K12INTEL_DW.DTBL_SCHOOLS AS SCH
ON SCH.SCHOOL_KEY = TS.SCHOOL_KEY
INNER JOIN [VERSIFIT.APS.EDU.ACTD].K12INTEL.K12INTEL_DW.DTBL_CALENDAR_DATES CD
ON CD.CALENDAR_DATE_KEY= TS.CALENDAR_DATE_KEY
INNER JOIN [VERSIFIT.APS.EDU.ACTD].K12INTEL.K12INTEL_DW.DTBL_SCHOOL_DATES SD
ON SD.SCHOOL_DATES_KEY = TS.SCHOOL_DATES_KEY 
WHERE TEST_PRODUCT = 'DIBELS Next'
AND TEST_SUBGROUP IN ('TOT','Composite')
AND LOCAL_SCHOOL_YEAR = '2015-2016'
AND TEST_EXTERNAL_CODE = 'BEG'
)

,SPRING_2016_DIB AS
(
SELECT 
    STUDENT_ID AS SIS_NUMBER
    ,TEST_SCORE_VALUE AS SCORE
    ,TEST_PRIMARY_RESULT AS PERFORMANCE_LEVEL
FROM [VERSIFIT.APS.EDU.ACTD].K12INTEL.K12INTEL_DW.FTBL_TEST_SCORES AS TS
INNER JOIN [VERSIFIT.APS.EDU.ACTD].K12INTEL.K12INTEL_DW.DTBL_TESTS AS TSTS
ON TSTS.TESTS_KEY = TS.TESTS_KEY 
INNER JOIN [VERSIFIT.APS.EDU.ACTD].K12INTEL.K12INTEL_DW.DTBL_STUDENTS AS STUDS
ON STUDS.STUDENT_KEY = TS.STUDENT_KEY 
INNER JOIN [VERSIFIT.APS.EDU.ACTD].K12INTEL.K12INTEL_DW.DTBL_SCHOOLS AS SCH
ON SCH.SCHOOL_KEY = TS.SCHOOL_KEY
INNER JOIN [VERSIFIT.APS.EDU.ACTD].K12INTEL.K12INTEL_DW.DTBL_CALENDAR_DATES CD
ON CD.CALENDAR_DATE_KEY= TS.CALENDAR_DATE_KEY
INNER JOIN [VERSIFIT.APS.EDU.ACTD].K12INTEL.K12INTEL_DW.DTBL_SCHOOL_DATES SD
ON SD.SCHOOL_DATES_KEY = TS.SCHOOL_DATES_KEY 
WHERE TEST_PRODUCT = 'DIBELS Next'
AND TEST_SUBGROUP IN ('TOT','Composite')
AND LOCAL_SCHOOL_YEAR = '2015-2016'
AND TEST_EXTERNAL_CODE = 'END'
)

,Fall_2015_SS AS
(
select  
	   stu.LASTNAME+', ' +stu.FIRSTNAME STUDENT_NAME
	   ,stu.STUDENTID
       ,t.TESTNAME
       ,convert(date,convert(varchar(11),min(r.RESPONSEDATE))) TEST_DATE
       , SUM(case when r.CORRECT=1 then 1 else 0 end) as NUMBER_CORRECT
       , SUM(case when r.CORRECT=0 then 1 else 0 end) as NUMBER_INCORRECT
       , COUNT(r.id) as NUMBER_OF_QUESTIONS
       ,convert(decimal(6,1), SUM(case when r.CORRECT=1 then 1.0 else 0.0 end) / COUNT(r.ID)*100.0,1) PCT_CORRECT
from rev.EGB_TEST t
       join rev.EGB_TEST_SCHEDULED sch on sch.TESTID = t.id
       join rev.EGB_TEST_STUDENTRESPONSES r on r.SCHEDULEDTESTID = sch.ID 
       join rev.EGB_TEST_STUDENTS ts on ts.STUDENTID = r.STUDENTID and ts.SCHEDULEDTESTID = sch.ID
       join rev.EGB_PEOPLE stu on stu.ID = r.STUDENTID
where ts.COMPLETEDATE is not null
and t.TESTNAME LIKE 'SS%'
and t.TESTNAME LIKE '%FORM 1'
group by stu.LASTNAME+', ' +stu.FIRSTNAME, stu.STUDENTID 
       ,t.TESTNAME  
)

,SPRING_2015_SS AS
(
select  
	   stu.LASTNAME+', ' +stu.FIRSTNAME STUDENT_NAME
	   ,stu.STUDENTID
       ,t.TESTNAME
       ,convert(date,convert(varchar(11),min(r.RESPONSEDATE))) TEST_DATE
       , SUM(case when r.CORRECT=1 then 1 else 0 end) as NUMBER_CORRECT
       , SUM(case when r.CORRECT=0 then 1 else 0 end) as NUMBER_INCORRECT
       , COUNT(r.id) as NUMBER_OF_QUESTIONS
       ,convert(decimal(6,1), SUM(case when r.CORRECT=1 then 1.0 else 0.0 end) / COUNT(r.ID)*100.0,1) PCT_CORRECT
from rev.EGB_TEST t
       join rev.EGB_TEST_SCHEDULED sch on sch.TESTID = t.id
       join rev.EGB_TEST_STUDENTRESPONSES r on r.SCHEDULEDTESTID = sch.ID 
       join rev.EGB_TEST_STUDENTS ts on ts.STUDENTID = r.STUDENTID and ts.SCHEDULEDTESTID = sch.ID
       join rev.EGB_PEOPLE stu on stu.ID = r.STUDENTID
where ts.COMPLETEDATE is not null
and t.TESTNAME LIKE '%(SS)%'

group by stu.LASTNAME+', ' +stu.FIRSTNAME, stu.STUDENTID 
       ,t.TESTNAME  
)

,PARCC_ELA_2015 AS
(
SELECT 
	SIS_NUMBER
	,TEST_SCORE
	,PL
FROM
(
SELECT 
	   ROW_NUMBER () OVER (PARTITION BY SIS_NUMBER ORDER BY TEST_SCORE DESC) AS RN
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

       INNER JOIN
       rev.EPC_STU AS Student
       ON Student.STUDENT_GU = StudentTest.STUDENT_GU

WHERE
1 = 1
	   AND TEST_NAME LIKE '%PARC%'
	   AND ADMIN_DATE BETWEEN '2015-08-01 00:00:00' AND '2016-05-30 00:00:00'
	   AND TEST_NAME LIKE '%ELA%'
) AS T1
WHERE RN = 1
)

, PARCC_MATH_2015 AS
(
SELECT 
	SIS_NUMBER
	,TEST_SCORE
	,PL
	,TEST_NAME
FROM
(
SELECT 
	   ROW_NUMBER () OVER (PARTITION BY SIS_NUMBER ORDER BY TEST_SCORE DESC) AS RN
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

       INNER JOIN
       rev.EPC_STU AS Student
       ON Student.STUDENT_GU = StudentTest.STUDENT_GU

	   LEFT JOIN
	   REV.EPC_GRAD_REQ_DEF_TST_GRPYT AS TST_GRPYT
	   ON
	   TEST.TEST_GU = TST_GRPYT.TEST_GU
	   AND PART.TEST_PART_GU = TST_GRPYT.TEST_PART_GU

WHERE
1 = 1
	   AND TEST_NAME LIKE '%PARC%'
	   AND ADMIN_DATE BETWEEN '2015-08-01 00:00:00' AND '2016-05-30 00:00:00'
	   AND TEST_NAME LIKE '%math%'
) AS T1
WHERE RN = 1
)


SELECT
	BS.SIS_NUMBER AS 'SIS ID'
	,BS.FIRST_NAME AS 'First Name'
	,BS.LAST_NAME AS 'Last Name'
	,ENR.GRADE
	,BS.GENDER AS 'Gender'
	,ENR.SCHOOL_NAME AS 'School Location Name'
	,ENR.SCHOOL_CODE AS 'School Location Number'
	,BS.RESOLVED_RACE AS 'Resolved Ethnicity'
	,CASE WHEN BS.LUNCH_STATUS = '2' THEN '(2) Free'
	      WHEN BS.LUNCH_STATUS = 'F' THEN '(F) Free'
		  WHEN BS.LUNCH_STATUS = 'R' THEN '(R) Reduced'
		  WHEN BS.LUNCH_STATUS = 'N' THEN '(N) None'
		  WHEN BS.LUNCH_STATUS IS NULL THEN 'Not Marked'
	END AS 'Free/Reduced Lunch Code & Description'
	,BS.SPED_STATUS AS 'SPED Status'
	,BS.ELL_STATUS AS 'ELL Status'
	,DIB.SCORE AS 'Fall 2015 DIBELS Composite Score'
	,DIB.PERFORMANCE_LEVEL AS 'Fall 2015 DIBELS Proficiency'
	,DIB2.SCORE AS 'Spring 2016 DIBELS Composite Score'
	,DIB2.PERFORMANCE_LEVEL AS 'Spring 2016 DIBELS Proficiency Level'
	,SS_Fall.NUMBER_CORRECT AS 'Fall  2015 SS Raw Score'
	,CASE WHEN SS_Fall.TESTNAME LIKE '%GRADE K%' 
			THEN
				CASE WHEN SS_Fall.PCT_CORRECT < 66.0 THEN 'BASIC'
				     WHEN SS_Fall.PCT_CORRECT BETWEEN 66.0 AND 82.0 THEN 'NEARING PROFICIENT'
					 WHEN SS_Fall.PCT_CORRECT > 82 THEN 'PROFICIENT'
				END
			ELSE
				CASE WHEN SS_Fall.TESTNAME LIKE '%GRADE 1%'
				   THEN 
					CASE WHEN SS_Fall.PCT_CORRECT < 66.0 THEN 'BASIC'
					     WHEN SS_Fall.PCT_CORRECT BETWEEN 66.0 AND 82.0 THEN 'NEARING PROFICIENT'
						 WHEN SS_Fall.PCT_CORRECT > 82.0 THEN 'PROFICIENT'
					END 
			ELSE
				CASE WHEN SS_Fall.TESTNAME LIKE '%GRADE 2%'
				   THEN 
					CASE WHEN SS_Fall.PCT_CORRECT < 68.0 THEN 'BASIC'
					     WHEN SS_Fall.PCT_CORRECT BETWEEN 68.0 AND 83.0 THEN 'NEARING PROFICIENT'
						 WHEN SS_Fall.PCT_CORRECT > 83.0 THEN 'PROFICIENT'
					END 
			ELSE
				CASE WHEN SS_Fall.TESTNAME LIKE '%GRADE 3%'
				   THEN 
					CASE WHEN SS_Fall.PCT_CORRECT < 65.0 THEN 'BASIC'
					     WHEN SS_Fall.PCT_CORRECT BETWEEN 65.0 AND 81.0 THEN 'NEARING PROFICIENT'
						 WHEN SS_Fall.PCT_CORRECT > 81.0 THEN 'PROFICIENT'
					END 
			ELSE
				CASE WHEN SS_Fall.TESTNAME LIKE '%GRADE 4%'
				   THEN 
					CASE WHEN SS_Fall.PCT_CORRECT < 63.0 THEN 'BASIC'
					     WHEN SS_Fall.PCT_CORRECT BETWEEN 63.0 AND 77.0 THEN 'NEARING PROFICIENT'
						 WHEN SS_Fall.PCT_CORRECT > 77.0 THEN 'PROFICIENT'
					END 
			ELSE
				CASE WHEN SS_Fall.TESTNAME LIKE '%GRADE 5%'
				   THEN 
					CASE WHEN SS_Fall.PCT_CORRECT < 66.0 THEN 'BASIC'
					     WHEN SS_Fall.PCT_CORRECT BETWEEN 66.0 AND 81.0 THEN 'NEARING PROFICIENT'
						 WHEN SS_Fall.PCT_CORRECT > 81.0 THEN 'PROFICIENT'
					END 
		END
		END
		END
		END
		END
	END AS 'SS Fall Proficiency Level'
	,SS_SPRING.NUMBER_CORRECT AS 'Spring 2015 SS Raw Score'
	,CASE WHEN SS_SPRING.TESTNAME LIKE '%GRADE K%' 
			THEN
				CASE WHEN SS_SPRING.PCT_CORRECT < 32.99 THEN 'BASIC'
				     WHEN SS_SPRING.PCT_CORRECT BETWEEN 33.0 AND 54.99 THEN 'NEARING PROFICIENT'
					 WHEN SS_SPRING.PCT_CORRECT >= 55 THEN 'PROFICIENT'
				END
			ELSE
				CASE WHEN SS_SPRING.TESTNAME LIKE '%GRADE 1%'
				   THEN 
					CASE WHEN SS_SPRING.PCT_CORRECT < 34.99 THEN 'BASIC'
					     WHEN SS_SPRING.PCT_CORRECT BETWEEN 35.0 AND 56.99 THEN 'NEARING PROFICIENT'
						 WHEN SS_SPRING.PCT_CORRECT >= 57.0 THEN 'PROFICIENT'
					END 
			ELSE
				CASE WHEN SS_SPRING.TESTNAME LIKE '%GRADE 2%'
				   THEN 
					CASE WHEN SS_SPRING.PCT_CORRECT < 32.99 THEN 'BASIC'
					     WHEN SS_SPRING.PCT_CORRECT BETWEEN 33.0 AND 52.99 THEN 'NEARING PROFICIENT'
						 WHEN SS_SPRING.PCT_CORRECT >+ 53 THEN 'PROFICIENT'
					END 
			ELSE
				CASE WHEN SS_SPRING.TESTNAME LIKE '%GRADE 3%'
				   THEN 
					CASE WHEN SS_SPRING.PCT_CORRECT < 36.99 THEN 'BASIC'
					     WHEN SS_SPRING.PCT_CORRECT BETWEEN 37.0 AND 55.99 THEN 'NEARING PROFICIENT'
						 WHEN SS_SPRING.PCT_CORRECT >= 56.0 THEN 'PROFICIENT'
					END 
			ELSE
				CASE WHEN SS_SPRING.TESTNAME LIKE '%GRADE 4%'
				   THEN 
					CASE WHEN SS_SPRING.PCT_CORRECT < 36.99 THEN 'BASIC'
					     WHEN SS_SPRING.PCT_CORRECT BETWEEN 37.0 AND 55.99 THEN 'NEARING PROFICIENT'
						 WHEN SS_SPRING.PCT_CORRECT >= 56.0 THEN 'PROFICIENT'
					END 
			ELSE
				CASE WHEN SS_SPRING.TESTNAME LIKE '%GRADE 5%'
				   THEN 
					CASE WHEN SS_SPRING.PCT_CORRECT < 30.99 THEN 'BASIC'
					     WHEN SS_SPRING.PCT_CORRECT BETWEEN 31.0 AND 49.99 THEN 'NEARING PROFICIENT'
						 WHEN SS_SPRING.PCT_CORRECT >= 50.0 THEN 'PROFICIENT'
					END 
		END
		END
		END
		END
		END
	END AS 'SS Spring Proficiency Level'
	,PARCC_ELA_2015.TEST_SCORE AS 'Spring 2015 PARCC ELA Scores'
	,PARCC_ELA_2015.PL AS 'Spring 2015 PARCC ELA Performance Level'
	,PARCC_MATH_2015.TEST_SCORE AS 'Spring 2015 PARCC MATH Scores'
	,PARCC_MATH_2015.PL AS 'Spring 2015 PARCC MATH Performance Level'
	,'' AS 'Spring 2016 PARCC MATH Scores'
	,'' AS 'Spring 2016 PARCC MATH Performance Level'

FROM
	APS.StudentEnrollmentDetails AS ENR WITH (NOLOCK)
	LEFT JOIN
	rev.EPC_STU AS STU WITH (NOLOCK)
	ON ENR.SIS_NUMBER = STU.SIS_NUMBER

	LEFT JOIN
	rev.REV_PERSON AS PER WITH (NOLOCK)
	ON PER.PERSON_GU = STU.STUDENT_GU

	LEFT JOIN
	APS.BasicStudentWithMoreInfo AS BS WITH (NOLOCK)
	ON BS.SIS_NUMBER = ENR.SIS_NUMBER

	LEFT JOIN
	FALL_2015_DIB AS DIB
	ON DIB.SIS_NUMBER = ENR.SIS_NUMBER

	LEFT JOIN
	SPRING_2016_DIB AS DIB2
	ON DIB2.SIS_NUMBER = ENR.SIS_NUMBER

	LEFT JOIN
	Fall_2015_SS AS SS_Fall
	ON SS_Fall.STUDENTID = ENR.SIS_NUMBER

	LEFT JOIN
	SPRING_2015_SS AS SS_SPRING
	ON SS_SPRING.STUDENTID = ENR.SIS_NUMBER

	LEFT JOIN
	PARCC_ELA_2015 
	ON PARCC_ELA_2015.SIS_NUMBER = ENR.SIS_NUMBER

	LEFT JOIN
	PARCC_MATH_2015
	ON PARCC_MATH_2015.SIS_NUMBER = ENR.SIS_NUMBER

WHERE 1 = 1
	AND	ENR.SCHOOL_YEAR = '2015'
	AND ENR.GRADE IN ('K','01','02','03','04','05','06','07','08')
	AND ENR.EXTENSION = 'R'
	AND EXCLUDE_ADA_ADM IS NULL
	--AND ENR.SIS_NUMBER = '100019603'
ORDER BY [SIS ID]
