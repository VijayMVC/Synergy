
/********************************************************************************
	CREATED BY DEBBIE ANN CHAVEZ
	DATE 9/1/2016

	BUS CARDS NEEDED FOR ELEMENTARY ONLY.  PULLS PERIOD 01 FOR HOMEROOM TEACHER

*********************************************************************************/

ALTER VIEW APS.BusCardInfo AS

SELECT
	SCHOOL_CODE
	,SCHOOL_NAME
	,GRADE
	,BS.FIRST_NAME
	,BS.LAST_NAME
	,BS.SIS_NUMBER
	,COURSE_ID
	,COURSE_TITLE
	,PERS.LAST_NAME + ', ' + PERS.FIRST_NAME AS TEACHER_NAME
	,SCH.TERM_CODE
	,SCH.PERIOD_BEGIN
	,SCH.PERIOD_END
	,BS.HOME_ADDRESS
	,BS.HOME_CITY
	,BS.HOME_STATE
	,BS.HOME_ZIP
FROM 
APS.PrimaryEnrollmentDetailsAsOf(GETDATE()) AS PRIM
INNER JOIN 
APS.BasicStudentWithMoreInfo AS BS
ON
PRIM.STUDENT_GU = BS.STUDENT_GU
INNER JOIN
APS.ScheduleDetailsAsOf(GETDATE()) AS SCH
ON
PRIM.STUDENT_GU = SCH.STUDENT_GU
INNER JOIN 
rev.REV_PERSON AS PERS
ON
PERS.PERSON_GU = SCH.STAFF_GU

WHERE
SCHOOL_CODE BETWEEN '200' AND '400'
AND PERIOD_BEGIN = '01'