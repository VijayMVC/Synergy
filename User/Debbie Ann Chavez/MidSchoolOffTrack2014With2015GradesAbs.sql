
SELECT DISTINCT YR2014.SIS_NUMBER, YR2015.*
,ORG.ORGANIZATION_NAME AS LAST_SCHOOL_ATTENDED 
,MRE.LEAVE_DATE
, LU.VALUE_DESCRIPTION AS LEAVE_DESCRIPTION 
,MRE.SUMMER_WITHDRAWL_DATE
, CASE WHEN MRE.SUMMER_WITHDRAWL_DATE IS NOT NULL AND LU2.VALUE_CODE IS NULL THEN LU3.VALUE_DESCRIPTION ELSE LU2.VALUE_DESCRIPTION END AS SUMMER_WITHDRAWL_CODE
FROM 

(
SELECT ENR.SCHOOL_YEAR, ENR.EXTENSION, SCHOOL_NAME, SCHOOL_CODE, ENR.SIS_NUMBER, ENR.GRADE, MARK, HIST.TERM_CODE, HIST.COURSE_TITLE, DEPARTMENT
,TOTATT.[Total Unexcused], ENR.STUDENT_GU
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

) AS YR2014

LEFT JOIN 

(
SELECT ENR.SCHOOL_YEAR, ENR.EXTENSION, SCHOOL_NAME, SCHOOL_CODE, ENR.SIS_NUMBER, ENR.GRADE, MARK, HIST.TERM_CODE, HIST.COURSE_TITLE, DEPARTMENT
--,ENR.LEAVE_DATE, ENR.LEAVE_DESCRIPTION
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

LEFT JOIN 
(SELECT SIS_NUMBER, [Unexc Absences] AS [Total Unexcused]  FROM
APS.AttendanceTruancyAsOf('2016-05-25')

) AS TOTATT
ON
TOTATT.SIS_NUMBER = ENR.SIS_NUMBER

WHERE
ENR.SCHOOL_YEAR = '2015'
AND EXTENSION = 'R'
--AND ENR.GRADE = '08'
--AND MARK LIKE 'F%'
AND DEPARTMENT NOT IN ('Advis', 'Ele', 'Noc', 'P/FA', 'PE', 'Sped', 'Hea')

) AS YR2015

ON
YR2014.SIS_NUMBER = YR2015.SIS_NUMBER

LEFT JOIN 
APS.LatestPrimaryEnrollmentInYear('BCFE2270-A461-4260-BA2B-0087CB8EC26A') AS MRE
ON
MRE.STUDENT_GU = YR2014.STUDENT_GU

LEFT JOIN 
APS.LookupTable('K12.ENROLLMENT', 'LEAVE_CODE') AS LU
ON
MRE.LEAVE_CODE = LU.VALUE_CODE

LEFT JOIN 
rev.REV_ORGANIZATION AS ORG
ON
MRE.ORGANIZATION_GU = ORG.ORGANIZATION_GU

LEFT JOIN 
APS.LookupTable('K12.ENROLLMENT', 'WITHDRAWAL_REASON_CODE') AS LU2
ON
LU2.VALUE_CODE = MRE.SUMMER_WITHDRAWL_CODE

LEFT JOIN 
APS.LookupTable('K12.ENROLLMENT', 'WITHDRAWAL_REASON_CODE') AS LU3
ON
LU3.ALT_CODE_1 = MRE.SUMMER_WITHDRAWL_CODE