
SELECT STU.STATE_STUDENT_NUMBER ,LCE.SIS_NUMBER, ORGANIZATION_NAME, PARENT_REFUSED ,PARENT_REFUSAL_STATUS 
FROM 
APS.LCEStudentsAndProvidersAsOf_2('10-11-2017') AS LCE
INNER JOIN rev.EPC_STU AS STU
ON
LCE.SIS_NUMBER = STU.SIS_NUMBER

WHERE
--[STATUS] = 'No Appropriate Course Assigned'
--AND PARENT_REFUSED = ''
COURSE_ID IS NOT NULL 
AND QUALIFIED_CLASS IN ('W', 'Y')
