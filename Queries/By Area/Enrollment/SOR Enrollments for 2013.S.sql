/* Brian Rieb
 * 8/13/2014
 * 
 * SOR Enrollments for 2013.S broken down by shool/grade
 *
 */
SELECT
	/*
	StudentYear.YEAR_GU
	,StudentYear.STUDENT_GU
	,SSY.ORGANIZATION_YEAR_GU
	,SSY.STUDENT_SCHOOL_YEAR_GU
	,SSY.ENTER_DATE
	,SSY.LEAVE_DATE
	,SSY.GRADE
	*/
	Organization.ORGANIZATION_NAME
	,School.STATE_SCHOOL_CODE
	,School.SCHOOL_CODE
	,Grades.VALUE_DESCRIPTION AS GradeLevel
	,COUNT(*) AS NumStudents
FROM
	rev.EPC_STU_YR AS StudentYear -- (SOR)
	INNER JOIN
	rev.EPC_STU_SCH_YR AS SSY
	ON
	StudentYear.STU_SCHOOL_YEAR_GU = SSY.STUDENT_SCHOOL_YEAR_GU

	INNER JOIN
	rev.REV_ORGANIZATION_YEAR AS OrgYear
	ON
	SSY.ORGANIZATION_YEAR_GU = OrgYear.ORGANIZATION_YEAR_GU

	INNER JOIN
	REV.EPC_SCH AS School
	ON
	OrgYear.ORGANIZATION_GU = School.ORGANIZATION_GU

	INNER JOIN
	rev.REV_ORGANIZATION AS Organization
	ON
	OrgYear.ORGANIZATION_GU = Organization.ORGANIZATION_GU

	INNER JOIN
	APS.LookupTable('K12','Grade') AS Grades
	ON
	SSY.GRADE = Grades.VALUE_CODE

WHERE
	StudentYear.YEAR_GU = 'AA26EA9A-B72D-45B6-8D7F-F1078FB756EA'
--	AND SSY.STATUS IS NULL --SSY is not inactive
--	AND SSY.EXCLUDE_ADA_ADM IS NULL -- only primarys
GROUP BY
	Organization.ORGANIZATION_NAME
	,School.STATE_SCHOOL_CODE
	,School.SCHOOL_CODE
	,Grades.VALUE_DESCRIPTION
	,Grades.LIST_ORDER
ORDER BY
	School.STATE_SCHOOL_CODE
	,School.SCHOOL_CODE
	,Grades.LIST_ORDER
