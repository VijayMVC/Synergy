/**
 * $Revision: 222 $
 * $LastChangedBy: e211395 $
 * $LastChangedDate: 2016-12-12 14:25
 * 
 * Used in report.  Basic list of ELL kids, their primary school, grade and latest evaluation
 * Added student contact language
 */
SELECT
	Organization.ORGANIZATION_NAME
	,Student.SIS_NUMBER
	,Person.LAST_NAME
	,Person.FIRST_NAME
	,Person.MIDDLE_NAME
	,GradeLevel.VALUE_DESCRIPTION AS GradeLevel
	,[Language].VALUE_DESCRIPTION as StudentContactLanguage
	,ELL.ENTRY_DATE
	,Test.ADMIN_DATE
	,Test.TEST_NAME
	,PerformanceLevel.VALUE_DESCRIPTION as PerfomanceLevel
FROM
	APS.ELLAsOf(@asOfDate) AS ELL
	INNER JOIN
	rev.REV_ORGANIZATION_YEAR AS OrgYear
	ON
	ELL.ORGANIZATION_YEAR_GU = OrgYear.ORGANIZATION_YEAR_GU

	INNER JOIN
	rev.REV_ORGANIZATION AS Organization
	ON
	OrgYear.ORGANIZATION_GU = Organization.ORGANIZATION_GU

	INNER JOIN
	rev.EPC_STU AS Student
	ON
	ELL.STUDENT_GU = Student.STUDENT_GU

	INNER JOIN
	rev.REV_PERSON AS Person
	ON
	ELL.STUDENT_GU = Person.PERSON_GU

	LEFT JOIN
	APS.LookupTable('K12', 'Grade') AS GradeLevel
	ON
	ELL.GRADE = GradeLevel.VALUE_CODE

	LEFT JOIN
	APS.LCELatestEvaluationAsOf(@asOfDate) AS Test
	ON
	ELL.STUDENT_GU = Test.STUDENT_GU

	LEFT JOIN
	APS.LookupTable ('K12.TestInfo',	'PERFORMANCE_LEVELS') AS PerformanceLevel
	ON
	Test.PERFORMANCE_LEVEL = PerformanceLevel.VALUE_CODE

	LEFT JOIN
	APS.LookupTable ('K12',	'LANGUAGE') AS [Language]	
	ON
	sTUDENT.HOME_LANGUAGE = [Language].VALUE_CODE
WHERE
	OrgYear.ORGANIZATION_GU LIKE @School


