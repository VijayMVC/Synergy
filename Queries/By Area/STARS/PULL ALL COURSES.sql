
/*
	Created by Debbie Ann Chavez
	Pulls all courses open and closed for students enrolled
	-Just change the reporting date
*/


DECLARE @asOfDate DATE = '10-12-2016'

SELECT

	SCHOOL.STATE_SCHOOL_CODE AS STATE_SCHOOL
	,ORG.ORGANIZATION_NAME AS SCHOOL_NAME
	,STU.STATE_STUDENT_NUMBER
	,CourseMaster.STATE_COURSE_CODE
	,CourseMaster.COURSE_ID + '-' + BasicSchedule.SECTION_ID+ '-' + SUBSTRING(STAFF.BADGE_NUM,2,6) AS SECTION_CODE_LONG
	,CAST(BasicSchedule.COURSE_ENTER_DATE AS DATE) AS COURSE_ENTER_DATE
	,CAST(BasicSchedule.COURSE_LEAVE_DATE AS DATE) AS COURSE_LEAVE_DATE


FROM
	APS.BasicSchedule
	INNER JOIN
	rev.EPC_CRS AS CourseMaster
	ON
	BasicSchedule.COURSE_GU = CourseMaster.COURSE_GU
	INNER JOIN
	rev.REV_ORGANIZATION AS ORG
	ON
	BasicSchedule.ORGANIZATION_GU = ORG.ORGANIZATION_GU
	INNER JOIN
	rev.EPC_STU AS STU
	ON
	STU.STUDENT_GU = BasicSchedule.STUDENT_GU
	INNER JOIN
	rev.EPC_SCH AS SCHOOL
	ON
	SCHOOL.ORGANIZATION_GU = ORG.ORGANIZATION_GU
	INNER JOIN
	rev.EPC_STAFF AS STAFF
	ON
	BasicSchedule.STAFF_GU = STAFF.STAFF_GU
	INNER HASH JOIN
	APS.PrimaryEnrollmentsAsOf(@AsOfDate) AS PE
	ON
	PE.STUDENT_GU = BasicSchedule.STUDENT_GU
	AND PE.ORGANIZATION_YEAR_GU = BasicSchedule.ORGANIZATION_YEAR_GU

	
--WHERE
	--@asOfDate BETWEEN BasicSchedule.COURSE_ENTER_DATE AND COALESCE(BasicSchedule.COURSE_LEAVE_DATE, @asOfDate)
	--STU.STUDENT_GU = '5F2F60D8-66F9-4A55-8A03-7C8DCA218F5C'

	ORDER BY 
	SCHOOL.STATE_SCHOOL_CODE 
	,ORG.ORGANIZATION_NAME 
	,STU.STATE_STUDENT_NUMBER
	,SECTION_CODE_LONG