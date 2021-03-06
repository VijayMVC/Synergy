
/**
 * $Revision: 1 $
 * $LastChangedBy: e104090 $
 * $LastChangedDate: 2015-09-29 $
 */
 
-- Removing function if it exists
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[ELLPercentageAsOf]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	EXEC('CREATE FUNCTION APS.ELLPercentageAsOf() RETURNS TABLE AS RETURN (SELECT 0 AS DUMMY)')
GO

/**
 * FUNCTION APS.ELLPercentageAsOf
 * Pulls Ell and All Enrollment counts to do percentages by school.
 *
 */

ALTER FUNCTION APS.ELLPercentageAsOf(@AsOfDate DATE)
RETURNS TABLE
AS
RETURN	


SELECT 
	ORGANIZATION_NAME
	,COUNT_OF_ENROLLMENTS
	,COUNT_OF_ELL_STUDENTS
	,CASE WHEN COUNT_OF_ELL_STUDENTS != 0 THEN CAST(CAST(COUNT_OF_ELL_STUDENTS AS NUMERIC (16,6))/CAST(COUNT_OF_ENROLLMENTS AS NUMERIC (16,6)) * 100 AS DECIMAL (18,2))  ELSE 0 END AS PERCENTAGE
FROM 
(SELECT 
	ORGANIZATION_NAME
	,COUNT (*) AS COUNT_OF_ENROLLMENTS
	,SUM(CASE WHEN ELL.STUDENT_GU IS NOT NULL THEN 1 ELSE 0 END) AS COUNT_OF_ELL_STUDENTS

 FROM 
APS.PrimaryEnrollmentsAsOf(GETDATE()) AS ENROLL
LEFT JOIN 
APS.ELLAsOf(GETDATE()) AS ELL
ON
ENROLL.STUDENT_GU = ELL.STUDENT_GU

INNER JOIN 
rev.REV_ORGANIZATION_YEAR AS ORG
ON
ENROLL.ORGANIZATION_YEAR_GU = ORG.ORGANIZATION_YEAR_GU
INNER JOIN
rev.REV_ORGANIZATION AS ORG2
ON
ORG2.ORGANIZATION_GU = ORG.ORGANIZATION_GU

GROUP BY 
ORGANIZATION_NAME


) AS T1

--ORDER BY 
--ORGANIZATION_NAME