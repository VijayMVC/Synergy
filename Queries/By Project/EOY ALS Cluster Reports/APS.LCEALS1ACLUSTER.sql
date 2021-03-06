

/*
	Created By:  Debbie Ann Chavez
	Date:  6/4/2015
*/


IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[APS].[LCEALS1ACLUSTER]'))
	EXEC ('CREATE VIEW APS.LCEALS1ACLUSTER AS SELECT 0 AS DUMMY')
GO

ALTER VIEW APS.LCEALS1ACLUSTER AS

SELECT 
	CLUSTER
	,1 AS DISTRICT_CODE
	,'ALS' AS DISTRICT
	,SUM([K12 Stus]) AS [K12 Stus]
	,SUM([PHLOTE]) AS PHLOTE
	,SUM([No HLS]) AS [No HLS]
	,SUM([Total ELL]) AS [Total ELL]
	,SUM([ELL]) AS ELL
	,SUM([Entering]) AS Entering
	,SUM([Emerging]) AS Emerging
	,SUM([Developing]) AS Developing
	,SUM([Expanding]) AS Expanding
	,SUM([FEP Bridging/Reaching]) AS [FEP Bridging/Reaching]

 FROM 

(
SELECT * FROM APS.LCEALS1A

) AS T1

GROUP BY CLUSTER

