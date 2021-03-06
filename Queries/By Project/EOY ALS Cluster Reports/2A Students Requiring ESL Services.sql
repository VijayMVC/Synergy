
/*
	Created By:  Debbie Ann Chavez
	Date:  6/3/2015
*/
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[APS].[LCEALS2A]'))
	EXEC ('CREATE VIEW APS.LCEALS2A AS SELECT 0 AS DUMMY')
GO


ALTER VIEW APS.LCEALS2A AS

SELECT 
	ORG2.ORGANIZATION_NAME AS CLUSTER
	,ESL.ORGANIZATION_NAME
	
	,[Req ESL Current]
	,[Received ESL Current Quarter]
	,COALESCE([Received ESL Current Quarter]*100/NULLIF([Req ESL Current],0),0) * 1.0 AS CurrentPercent

	,[Req ESL Prior]
	,[Received ESL Prior Quarter]
	,COALESCE([Received ESL Prior Quarter]*100/NULLIF([Req ESL Prior],0),0) *1.0  AS PriorPercent

	,CREQ AS [Year Ago 5/22/2014 Req ESL]
	,CREC AS [Year Ago 5/22/2014 Received ESL]
	,CURP AS [Year Ago 5/22/2014 Percent]


 FROM 

 ----------------------------------------------------------------------------------------------
 --CURRENT ESL STUDENTS
(
SELECT 
		ORGANIZATION_NAME
		,COUNT(*) AS [Req ESL Current]
		,SUM(CASE WHEN [STATUS] = '' THEN 1 ELSE 0 END) AS [Received ESL Current Quarter]
FROM 
(
SELECT 
		*
		,ROW_NUMBER() OVER (PARTITION BY SIS_NUMBER ORDER BY STATUS DESC) AS RN
 FROM 
APS.LCEStudentsAndProvidersAsOf('2015-05-22') AS ESL
) AS T1
WHERE RN =1
AND [STATUS] != 'Parent Refused'
AND GRADE NOT IN ('P1', 'P2', 'PK', 'T1', 'T2', 'T3', 'T4', 'C1', 'C2', 'C3', 'C4')
GROUP BY 
	ORGANIZATION_NAME

)AS ESL
-------------------------------------------------------------------------------------------------
--PRIOR ESL STUDENTS
LEFT JOIN
(
SELECT 
		ORGANIZATION_NAME
		,COUNT(*) AS [Req ESL Prior]
		,SUM(CASE WHEN [STATUS] = '' THEN 1 ELSE 0 END) AS [Received ESL Prior Quarter]

FROM 
(
SELECT 
		*
		,ROW_NUMBER() OVER (PARTITION BY SIS_NUMBER ORDER BY STATUS DESC) AS RN
 FROM 
APS.LCEStudentsAndProvidersAsOf('2015-03-15') AS ESL

) AS T1
WHERE RN =1
AND [STATUS] != 'Parent Refused'
AND GRADE NOT IN ('P1', 'P2', 'PK', 'T1', 'T2', 'T3', 'T4', 'C1', 'C2', 'C3', 'C4')
GROUP BY 
	ORGANIZATION_NAME
) AS T1

ON
ESL.ORGANIZATION_NAME = T1.ORGANIZATION_NAME


--------------------------------------------------------------------------------------------------
--GET YEAR AGO FROM CURRENT LAST YEAR
LEFT JOIN
(SELECT 
	CLUSTER
	,SCHOOL
	,CREQ
	,CREC 
	,CURP 
FROM
            dbo.[LCE_REQ_ESL] AS ALS

) AS YAGO

ON YAGO.SCHOOL = ESL.ORGANIZATION_NAME

-------------------------------------------------------------------------------------------------

	INNER JOIN
	rev.EPC_SCH AS SCHOOL
	ON
	CAST(YAGO.CLUSTER AS VARCHAR) = SCHOOL.SCHOOL_CODE

	INNER JOIN
	rev.REV_ORGANIZATION AS ORG2
	ON
	SCHOOL.ORGANIZATION_GU = ORG2.ORGANIZATION_GU


