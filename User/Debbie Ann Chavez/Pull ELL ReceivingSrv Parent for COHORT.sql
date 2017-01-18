
EXECUTE AS LOGIN='QueryFileUser'
GO


SELECT 
	T1.*
	,CASE WHEN EVERELL.STATE_STUDENT_NUMBER IS NOT NULL THEN 'Y' ELSE 'N' END AS EVER_ELL
	,CASE WHEN EVERELL.STATE_STUDENT_NUMBER IS NOT NULL THEN EVERELL.[2012] ELSE NULL END AS [2012]
	,CASE WHEN EVERELL.STATE_STUDENT_NUMBER IS NOT NULL THEN EVERELL.[2013] ELSE NULL END AS [2013]
	,CASE WHEN EVERELL.STATE_STUDENT_NUMBER IS NOT NULL THEN EVERELL.[2014] ELSE NULL END AS [2014]
	,CASE WHEN EVERELL.STATE_STUDENT_NUMBER IS NOT NULL THEN EVERELL.[2015] ELSE NULL END AS [2015]
	--,CASE WHEN ESL.COURSE_ID IS NOT NULL THEN 'Y' ELSE 'N' END AS RECEIVED_SERVICES
	--,CASE WHEN PR.WAIVER_TYPE IS NOT NULL THEN 'Y' ELSE 'N' END AS PARENT_REFUSED
	
	FROM
            OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                 'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
                  'SELECT * from Unduplicated.csv'
                ) AS [T1]

LEFT JOIN 
(SELECT * FROM 
(
SELECT 
STATE_STUDENT_NUMBER, CAST(history.ENTRY_DATE AS DATE) AS ENTRY_DATE
,CASE WHEN ENTRY_DATE BETWEEN '2012-07-01' AND '2013-06-30' THEN '2012'
WHEN ENTRY_DATE BETWEEN '2013-07-01' AND '2014-06-30' THEN '2013'
WHEN ENTRY_DATE BETWEEN '2014-07-01' AND '2015-06-30' THEN '2014'
WHEN ENTRY_DATE BETWEEN '2015-07-01' AND '2016-06-30' THEN '2015'
ELSE '' END AS SCHOOL_YEAR

FROM
rev.EPC_STU_PGM_ELL_HIS AS History
INNER JOIN 
rev.EPC_STU AS STU
ON
History.STUDENT_GU = STU.STUDENT_GU

) AS T1		
PIVOT 
(
MAX(ENTRY_DATE)
FOR SCHOOL_YEAR IN ([2015], [2014], [2013], [2012])
)AS PIVOTME
) AS EVERELL
ON
T1.StudentID = EVERELL.STATE_STUDENT_NUMBER
/*	
LEFT JOIN 
(SELECT * FROM (
SELECT DISTINCT STATE_STUDENT_NUMBER, ESL.COURSE_ID, 
ROW_NUMBER() OVER (PARTITION BY STATE_STUDENT_NUMBER ORDER BY COURSE_ID ) AS RN  FROM 
APS.LCEStudentsAndProvidersAsOf('2016-05-25') AS ESL
INNER JOIN 
rev.EPC_STU AS STU
ON
ESL.SIS_NUMBER = STU.SIS_NUMBER
) AS K1
WHERE
RN = 1
)AS ESL
ON
ESL.STATE_STUDENT_NUMBER = T1.StudentID

LEFT JOIN 
(SELECT DISTINCT STATE_STUDENT_NUMBER, WAIVER_TYPE FROM 
	APS.LCEMostRecentALSRefusalAsOf ('2016-05-25') AS PARENTREFUSAL
INNER JOIN 
rev.EPC_STU AS STU
ON
PARENTREFUSAL.STUDENT_GU = STU.STUDENT_GU
) AS PR
ON
PR.STATE_STUDENT_NUMBER = T1.StudentID
*/


REVERT
GO