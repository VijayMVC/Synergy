/**
 * 
 * $LastChangedBy: Gary Corbaley
 * $LastChangedDate: 08/29/2014 $
 *
 * Request By: Brian Rieb
 * InitialRequestDate: 08/28/2014
 * 
 * This script will pull basic information about all scheduled classes
 * One Record Per Class Per Student
 */


SELECT
	-- Class information
	[Class].[STUDENT_CLASS_GU]
	,[Class].[STUDENT_SCHOOL_YEAR_GU]
	,[Class].[SECTION_GU]
	,[Class].[ENTER_DATE] AS [COURSE_ENTER_DATE]
	,[Class].[LEAVE_DATE] AS [COURSE_LEAVE_DATE]
	
	-- Section information
	,[Section].[ORGANIZATION_YEAR_GU]
	,[Section].[STAFF_SCHOOL_YEAR_GU]
	,[Section].[SCHOOL_YEAR_COURSE_GU]
	,[Section].[ROOM_GU]
	,[Section].[SECTION_ID]
	,[Section].[ROOM_SIMPLE]
	,[Section].[TERM_CODE]
	,[Section].[PERIOD_BEGIN]
	,[Section].[PERIOD_END]
	
	-- School Course information
	,[SchoolYearCourse].[COURSE_GU]
	,[SchoolYearCourse].*
	
	-- Organization information
	,[OrgYear].[ORGANIZATION_GU]
	,[OrgYear].[YEAR_GU]
	
	-- Staff information
	,[StaffSchoolYear].[STAFF_GU]
	
	-- Student information
	,[StudentSchoolYear].[STUDENT_GU]
	,[StudentSchoolYear].[ENTER_DATE] AS [ENROLLMENT_ENTER_DATE]
	,[StudentSchoolYear].[LEAVE_DATE] AS [ENROLLMENT_LEAVE_DATE]
	,[StudentSchoolYear].[GRADE]
	
FROM
	-- Get all Scheduled Classes
	rev.[EPC_STU_CLASS] AS [Class]
	
	-- Get all Scheduled Sections
	INNER JOIN 
	rev.[EPC_SCH_YR_SECT] AS [Section]
	ON [Class].[SECTION_GU] = [Section].[SECTION_GU]
	
	-- Get all Courses for Each School Year
	INNER JOIN 
	rev.[EPC_SCH_YR_CRS] AS [SchoolYearCourse]
	ON [Section].[SCHOOL_YEAR_COURSE_GU] = [SchoolYearCourse].[SCHOOL_YEAR_COURSE_GU]
	
	-- Get all Schools for each Year
	INNER JOIN
	rev.[REV_ORGANIZATION_YEAR] AS [OrgYear]
	ON [Section].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
	
	-- Get all Staff for each Year
	LEFT OUTER JOIN
	rev.[EPC_STAFF_SCH_YR] AS [StaffSchoolYear]
	ON
	[Section].[STAFF_SCHOOL_YEAR_GU] = [StaffSchoolYear].[STAFF_SCHOOL_YEAR_GU]
	
	-- Get all enrolled Students for each Year
	LEFT OUTER JOIN
	rev.[EPC_STU_SCH_YR] AS [StudentSchoolYear] -- Contains Grade and Start Date 	
	ON
	[Class].[STUDENT_SCHOOL_YEAR_GU] = [StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU]
