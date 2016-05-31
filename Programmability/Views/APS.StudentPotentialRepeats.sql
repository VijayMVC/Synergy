/**
 * 
 * $LastChangedBy: Debbie Chavez
 * $LastChangedDate: 5/6/2016 $
 */


IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[APS].[StudentPotentialRepeats]'))
	EXEC ('CREATE VIEW APS.StudentPotentialRepeats AS SELECT 0 AS DUMMY')
GO

ALTER VIEW [APS].[StudentPotentialRepeats] AS


SELECT DISTINCT
SIS_NUMBER, LAST_NAME, FIRST_NAME
,SCHOOL_CODE, SCHOOL_NAME, T2.GRADE, GETBACKTRANS.COURSE_ID, GETBACKTRANS.COURSE_TITLE, 
RPT.NAME AS REPEAT_TAG
,GETBACKTRANS.[GROUP]

,GETBACKTRANS.TERM_CODE, GETBACKTRANS.CREDIT_COMPLETED, GETBACKTRANS.MARK, GETBACKTRANS.SCHOOL
,ORGANIZATION_GU

 FROM 

(
SELECT * FROM 
(
SELECT 
ROW_NUMBER() OVER (PARTITION BY SIS_NUMBER,[GROUP] ORDER BY [GROUP]) AS RN
,SIS_NUMBER, SCHOOL_CODE, SCHOOL_NAME, PRIM.GRADE
,[GROUP]
,HIST.STUDENT_GU
,ORGANIZATION_GU
FROM 
APS.PrimaryEnrollmentDetailsAsOf(GETDATE()) AS PRIM
INNER JOIN 
rev.EPC_STU_CRS_HIS AS HIST
ON
PRIM.STUDENT_GU = HIST.STUDENT_GU
AND COURSE_HISTORY_TYPE = 'HIGH'

INNER JOIN 
rev.UD_CRS_GROUP AS GRP
ON
HIST.COURSE_GU = GRP.COURSE_GU
AND [GROUP] < 'a'

INNER JOIN 
rev.EPC_STU AS STU
ON
PRIM.STUDENT_GU = STU.STUDENT_GU 

) AS T1

WHERE
RN > 1
) AS T2

INNER JOIN 

(SELECT HIST.STUDENT_GU, [GROUP], COURSE_ID, COURSE_TITLE, CREDIT_COMPLETED, MARK, TERM_CODE, REPEAT_TAG_GU,
CASE WHEN HIST.SCHOOL_NON_DISTRICT_GU IS NULL THEN ORG.ORGANIZATION_NAME ELSE ORG2.NAME END AS SCHOOL
 FROM 
rev.EPC_STU_CRS_HIS AS HIST
INNER JOIN 
rev.UD_CRS_GROUP AS GRP
ON
HIST.COURSE_GU = GRP.COURSE_GU
AND [GROUP] < 'a'
AND COURSE_HISTORY_TYPE = 'HIGH'
LEFT JOIN 
rev.REV_ORGANIZATION AS ORG
ON
HIST.SCHOOL_IN_DISTRICT_GU = ORG.ORGANIZATION_GU
LEFT JOIN 
rev.EPC_SCH_NON_DST AS ORG2
ON
ORG2.SCHOOL_NON_DISTRICT_GU = HIST.SCHOOL_NON_DISTRICT_GU


) AS GETBACKTRANS

ON
T2.STUDENT_GU = GETBACKTRANS.STUDENT_GU
AND T2.[GROUP] = GETBACKTRANS.[GROUP]

INNER JOIN 
rev.REV_PERSON AS PERS
ON
PERS.PERSON_GU = T2.STUDENT_GU

LEFT JOIN
rev.EPC_REPEAT_TAG AS RPT
ON
GETBACKTRANS.REPEAT_TAG_GU = RPT.REPEAT_TAG_GU

--ORDER BY SIS_NUMBER, [GROUP]
