
SELECT ENR.SCHOOL_YEAR, ENR.EXTENSION, SCHOOL_NAME, SCHOOL_CODE, ENR.SIS_NUMBER, ENR.GRADE, MARK, HIST.TERM_CODE, HIST.COURSE_TITLE, DEPARTMENT
,TOTATT.[Total Unexcused]
--DISTINCT DEPARTMENT

 FROM 
APS.StudentEnrollmentDetails AS ENR
INNER JOIN 
rev.EPC_STU_CRS_HIS AS HIST
ON
ENR.STUDENT_GU = HIST.STUDENT_GU
AND ENR.SCHOOL_YEAR = HIST.SCHOOL_YEAR
AND ENR.ORGANIZATION_GU = HIST.SCHOOL_IN_DISTRICT_GU
INNER JOIN 
rev.EPC_CRS AS CRS
ON
HIST.COURSE_GU = CRS.COURSE_GU

INNER JOIN 
(SELECT SIS_NUMBER, [Unexc Absences] AS [Total Unexcused]  FROM
APS.AttendanceTruancyPrevYrAsOf('2015-05-22')
WHERE 
[Unexc Absences] >= 5
AND [Grade] = '08'
) AS TOTATT
ON
TOTATT.SIS_NUMBER = ENR.SIS_NUMBER

WHERE
ENR.SCHOOL_YEAR = '2014'
AND EXTENSION = 'R'
AND ENR.GRADE = '08'
AND MARK LIKE 'F%'
AND DEPARTMENT NOT IN ('Advis', 'Ele', 'Noc', 'P/FA', 'PE', 'Sped', 'Hea')

