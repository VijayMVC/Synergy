/*
 * Revision 1
 * Last Changed By:    JoAnn Smith
 * Last Changed Date:  1/30/17
 * Written by:         JoAnn Smith
 ******************************************************
 Native American Access Test Performance Levels
 Pull test data for all APS Native American students
 for SY 2016 and SY2015
 ******************************************************
 */

--Get all data students taking the ACCESS test on a certain date
--Debbie knew the test dates so I used those

; WITH ACCESSCTE
AS
(
select 
	 TEST.TEST_GU,
	 TEST.TEST_NAME,
	 STUDENTTEST.ADMIN_DATE,
	 STUDENTTEST.ORGANIZATION_GU,
	 STUDENTTEST.STUDENT_TEST_GU,
	 STUDENTTEST.STUDENT_GU
from
     REV.EPC_TEST AS TEST
inner join
	 REV.EPC_STU_TEST STUDENTTEST
ON	
	 TEST.TEST_GU = STUDENTTEST.TEST_GU
inner join
	 rev.EPC_STU student
ON
	  STUDENTTEST.STUDENT_GU = Student.STUDENT_GU

where
		test.TEST_GU = '477ECCAA-57FD-4961-B904-38252F7B87BE'
AND
		--SY 2015 >= 2014-06-30 and <= 2015-06-30
		STUDENTTEST.ADMIN_DATE >= '2015-06-30' AND STUDENTTEST.ADMIN_DATE <= '2016-06-30'
)
--SELECT * FROM ACCESSCTE 
--ORDER BY STUDENT_GU

--Get performance level for all the above students
,
SCORECTE
AS
(
SELECT
    ROW_NUMBER() OVER (PARTITION BY STUDENT_GU ORDER BY ADMIN_DATE DESC) AS ROWNUM,
	ACCESS.ADMIN_DATE,
	ACCESS.ORGANIZATION_GU,
	ACCESS.STUDENT_TEST_GU,
	STU_PART.PERFORMANCE_LEVEL,
	ACCESS.STUDENT_GU

FROM
	ACCESSCTE ACCESS
LEFT JOIN
	       
       rev.EPC_TEST_PART AS PART
       ON ACCESS.TEST_GU = PART.TEST_GU

       JOIN
       rev.EPC_STU_TEST_PART AS STU_PART
       ON PART.TEST_PART_GU = STU_PART.TEST_PART_GU
       AND STU_PART.STUDENT_TEST_GU = ACCESS.STUDENT_TEST_GU

		INNER JOIN
		rev.EPC_STU_TEST_PART_SCORE AS SCORES
		ON
		SCORES.STU_TEST_PART_GU = STU_PART.STU_TEST_PART_GU
)

--SELECT * FROM SCORECTE
--ORDER BY STUDENT_GU


-- filter out Native American students	
,
RESULTS
AS
(
SELECT
    SCORE.ROWNUM,
	BSI.SIS_NUMBER,
	ORG.ORGANIZATION_NAME,
	SCORE.ADMIN_DATE,
	SCORE.PERFORMANCE_LEVEL

FROM
	SCORECTE SCORE
LEFT JOIN
	APS.BasicStudentWithMoreInfo BSI
ON
	BSI.STUDENT_GU = SCORE.STUDENT_GU
LEFT JOIN
	REV.REV_ORGANIZATION ORG
ON	
	ORG.ORGANIZATION_GU = SCORE.ORGANIZATION_GU
WHERE
	RACE_1 = 'Native American' OR
	RACE_1 = 'Native American' OR
	RACE_3 = 'Native American' OR
	RACE_4 = 'Native American' OR
	RACE_5 = 'Native American'
)

select * from RESULTS
WHERE ROWNUM = 1
ORDER BY
ORGANIZATION_NAME, SIS_NUMBER