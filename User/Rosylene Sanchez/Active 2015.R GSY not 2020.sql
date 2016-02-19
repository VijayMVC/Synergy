
/* 
* Request by: Andy Gutierrez
*
* Created: February 2016 by 053285
*
* Intial Request: Active 2015.R with GSY not equal 2020	--TABLE: EPC_STU	COLUMN: EXPECTED_GRADUATION_YEAR
* 
* INCLUDE:
*
* Tables Referenced:  
* Views:  APS.StudentEnrolLmentDetails, rev.EPC_STU, APS.BasicStudentWithMoreInfo
*/

SELECT
	MOREINFO.SIS_NUMBER
	,MOREINFO.LAST_NAME
	,MOREINFO.FIRST_NAME

	,ISNULL(MOREINFO.MIDDLE_NAME,'') AS MIDDLE_NAME	--SIMPLIER THAN "CASE"

	,SCHOOL.SCHOOL_CODE
	,SCHOOL.SCHOOL_NAME
	--,SCHOOL.SCHOOL_YEAR
	--,SCHOOL.EXTENSION

	,SCHOOL.GRADE
	,EPC.EXPECTED_GRADUATION_YEAR

FROM
		
	APS.StudentEnrolLmentDetails AS SCHOOL

	RIGHT JOIN
	rev.EPC_STU	as EPC
	ON
	SCHOOL.STUDENT_GU = EPC.STUDENT_GU
		
	INNER HASH JOIN	
	APS.BasicStudentWithMoreInfo AS MOREINFO
	ON
	SCHOOL.STUDENT_GU = MOREINFO.STUDENT_GU

	WHERE
		
	SCHOOL_YEAR = '2015'
	AND SCHOOL.EXTENSION = 'R'
	AND SCHOOL.GRADE = '08'
	AND EPC.EXPECTED_GRADUATION_YEAR != 2020

ORDER BY
	SCHOOL_CODE	--see dups


