

SELECT 

	[SIS Number]
	,STU.STATE_STUDENT_NUMBER
	,[School Code]
	,SCH.[STATE_SCHOOL_CODE]
	,ATT.EXCLUDE_ADA_ADM
	,[Member Days] AS DAYS_ATTENDED
	,[Member Days] - [Total Unexcused] AS DAYS_PRESENT
	,CAST(ATT.ENTER_DATE AS DATE) AS ENTER_DATE
	--,CAST(ATT.LEAVE_DATE AS DATE) AS LEAVE_DATE
	-- THIS IS FOR STUDENTS THAT LEFT AND RETURNED TO THE SAME SCHOOL
	,NULL AS LEAVE_DATE
	,ATT.Grade
	
 FROM 
STUDENT_ATTENDANCE AS ATT
INNER JOIN 
REV.EPC_STU AS STU
ON
ATT.[SIS Number] = STU.SIS_NUMBER
INNER JOIN 
REV.EPC_SCH AS SCH
ON
ATT.[School Code] = SCH.SCHOOL_CODE

--ONLY READ STUDENTS THAT WERE ENROLLED ON 40DAY -- THIS REMOVES KIDS WITHDRAWN
INNER JOIN 
APS.PrimaryEnrollmentDetailsAsOf('20171201')AS PRIM
ON
PRIM.STUDENT_GU = STU.STUDENT_GU
AND ATT.[School Code] = PRIM.SCHOOL_CODE

WHERE 
ATT.Grade NOT IN ('PK', 'P1', 'P2')
AND ATT.[School Code] NOT IN ('058', '022') 
AND [School Code] = '496'
/*
AND 
[SIS Number] IN ( 
980041103,
980039542,
980033717,
980046123,
980017138,
980033099,
970096541,
980046120,
980003982,
980048818,
980039128,
980037829,
980045643,
980045649,
980040567,
980007737,
980042726,
980035106,
970041686,
970060597,
970043283,
980048666,
980048681)
*/

ORDER BY [SIS Number]