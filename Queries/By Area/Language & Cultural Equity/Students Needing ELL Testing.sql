/* Brian Rieb
 * 8/22/2014
 *
 * List of PHLOTE kids who need testing 
 * **NOTE** This looks at SchoolMax for testing data
 */

SELECT
	Organization.ORGANIZATION_NAME AS SchoolName
	,GradeLevel.VALUE_DESCRIPTION AS GradeLevel
	,Student.SIS_NUMBER
	,Person.LAST_NAME AS LastName
	,Person.FIRST_NAME AS FirstName
	,HomeLanguage.VALUE_DESCRIPTION AS HomeLanguage
FROM
	APS.PrimaryEnrollmentsAsOf(GETDATE()) AS Enroll
	INNER JOIN
	rev.EPC_STU AS Student
	ON 
	Enroll.STUDENT_GU = Student.STUDENT_GU

	LEFT JOIN
	APS.LCELatestEvaluationAsOf(GETDATE()) AS MostRecentTest
	ON
	Enroll.STUDENT_GU = MostRecentTest.STUDENT_GU

	LEFT JOIN
	APS.LCEMostRecentTestWaiverAsOf(GETDATE()) As Waivers
	ON Enroll.STUDENT_GU = Waivers.STUDENT_GU

	-- the rest of the joins is to accomidate the formatted columns
	INNER JOIN
	rev.REV_PERSON AS Person
	ON 
	Enroll.STUDENT_GU = Person.PERSON_GU

	INNER JOIN
	rev.REV_ORGANIZATION_YEAR AS OrgYear
	ON 
	Enroll.ORGANIZATION_YEAR_GU = OrgYear.ORGANIZATION_YEAR_GU

	INNER JOIN
	rev.REV_ORGANIZATION AS Organization
	ON
	OrgYear.ORGANIZATION_GU = Organization.ORGANIZATION_GU

	INNER JOIN
	APS.LookupTable('K12','GRADE') AS GradeLevel
	ON
	Enroll.GRADE = GradeLevel.VALUE_CODE

	INNER JOIN
	APS.LookupTable('K12','Language') AS HomeLanguage
	ON
	Student.HOME_LANGUAGE = HomeLanguage.VALUE_CODE
WHERE
	Student.HOME_LANGUAGE NOT IN ('00','54')
	AND MostRecentTest.STUDENT_GU IS NULL -- No Tests
	AND GradeLevel.VALUE_DESCRIPTION NOT IN ('P1', 'P2', 'PK')
ORDER BY
	Organization.ORGANIZATION_NAME
	,GradeLevel.LIST_ORDER