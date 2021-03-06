
--LAST DAY 
--AND 2013-2014- 20140522 
--AND 2012-2013- 20130522 
--AND 2011-2012- 20120529

DECLARE @asOfDate DECIMAL (8,0) = 20120529

--INTERESTING, TAKES FOREVER TO RUN USING THIS, SO YEAR IS HARD-CODED *CHANGE 2 SPOTS*
DECLARE @SchoolYear INT = 2012

---------------------PART 1 COUNT ABSENCES ON CYCLE DAY ---------------------------------------------
;WITH [HighSchoolTruant] AS 
(
    SELECT
	   PERIOD.ID_NBR
	   ,PERIOD.SCH_NBR
	   ,CAL.CAL_DT
	   ,CAL.CYCLE_DAY
	   ,COUNT(PERIOD.CAL_DT) AS  [Count For Day]
    FROM
	   DBTSIS.AT030_V AS PERIOD
	   
	   INNER JOIN 
	   DBTSIS.AT015_V AS CODES
	   ON
	   PERIOD.DST_NBR = CODES.DST_NBR
	   AND PERIOD.SCH_NBR = CODES.SCH_NBR
	   AND PERIOD.REAS_CD = CODES.REAS_CD
	   
	   INNER JOIN 
	   DBTSIS.CA005_V AS CAL
	   ON
	   CAL.DST_NBR = PERIOD.DST_NBR
	   AND CAL.SCH_YR = PERIOD.SCH_YR
	   AND CAL.SCH_NBR = PERIOD.SCH_NBR
	   AND CAL.CAL_DT = PERIOD.CAL_DT

    WHERE
	   PERIOD.DST_NBR = 1
	   AND PERIOD.SCH_YR = 2012
	   AND PERIOD.ATT_STAT = 'A'
	   AND (CODES.EXCSD_ABS IN ('E', 'U') AND CODES.REAS_CD != 'AC'	   )
	   AND PERIOD.CAL_DT<= @asOfDate
	   --AND ID_NBR = 102785458
	   --AND PERIOD.SCH_NBR = '550'
    
	GROUP BY
	   PERIOD.ID_NBR
	   ,PERIOD.SCH_NBR
	   ,CAL.CAL_DT
	   ,CAL.CYCLE_DAY

---------------------PART 2 COUNT CLASSES ON CYCLE DAY ---------------------------------------------

), [HSSchedCount] AS 
(
SELECT 
	SCH.ID_NBR
	,SCH.SCH_NBR
	,CAL.CAL_DT
	,CYC.CYCLE_DAY 
	,COUNT (*) AS [Total Classes]

FROM 
DBTSIS.SC055_V AS SCH
INNER JOIN 
DBTSIS.SC065_V AS CYC
ON
SCH.DST_NBR = CYC.DST_NBR
AND SCH.SCH_YR = CYC.SCH_YR
AND SCH.VERSION = CYC.VERSION
AND SCH.SCH_NBR = CYC.SCH_NBR
AND SCH.CRS_ASG = CYC.COURSE
AND SCH.SECT_ASG = CYC.XSECTION

INNER JOIN 
DBTSIS.SC060_V AS TERMS
ON
TERMS.DST_NBR = SCH.DST_NBR
AND TERMS.SCH_YR = SCH.SCH_YR
AND TERMS.VERSION = SCH.VERSION
AND TERMS.SCH_NBR = SCH.SCH_NBR
AND TERMS.COURSE = SCH.CRS_ASG
AND TERMS.XSECTION = SCH.SECT_ASG


INNER JOIN 
DBTSIS.CA005_V AS CAL
ON
CAL.DST_NBR = SCH.DST_NBR
AND CAL.SCH_YR = SCH.SCH_YR
AND CAL.SCH_NBR = SCH.SCH_NBR
AND CAL.CYCLE_DAY = CYC.CYCLE_DAY
AND (CAL.CAL_DT>=SCH.DATE_ASG  OR SCH.DATE_ASG= 0) 
AND (CAL.CAL_DT<=SCH.DATE_DROP OR SCH.DATE_DROP = 0)

INNER JOIN 
APS.SchoolTermsAndDates AS TRMS
ON
TRMS.DST_NBR = SCH.DST_NBR
AND TRMS.SCH_YR = SCH.SCH_YR
AND TRMS.VERSION = SCH.VERSION
AND TRMS.SCH_NBR = SCH.SCH_NBR
AND TERMS.TERM_CD = TRMS.TERM_CD
AND CAL.CAL_DT BETWEEN TRMS.BEG_DT AND TRMS.END_DT

WHERE
--ID_NBR = 102785458
--AND CAL.CAL_DT = '20130820'

SCH.DST_NBR = 1
AND SCH.SCH_YR = 2012
AND SCH.VERSION = '00'
--AND SCH.SCH_NBR = '550'


GROUP BY 
	SCH.ID_NBR
	,SCH.SCH_NBR
	,CAL.CAL_DT
	,CYC.CYCLE_DAY 

)

---------------------PART 3 DIVIDE AND SUM UP HALF DAY AND FULL DAY ----------------------------------
---------------------SAME LOGIC AS SYNERGY -----------------------------------------------------------

INSERT INTO dbo.ATTENDANCE_2011

SELECT
 ID_NBR
 ,SCH_NBR
	,[Half Days]*0.5 AS [Half Day]
    ,[Full Days] AS [Full Day]
	,([Half Days]*0.5)+[Full Days]  AS [Total]

FROM
    
(

SELECT
	[Truants].ID_NBR
	,[Truants].SCH_NBR
	,SUM([Truants].[Half Days]) AS [Half Days]
	,SUM([Truants].[Full Days]) AS [Full Days]

FROM
(
SELECT 
    [Truant].ID_NBR
    ,[Truant].SCH_NBR
    ,ISNULL(SUM(CASE
	   WHEN [Truant].[Count For Day] >= 2 THEN
		  CASE WHEN [Truant].[Truant Percentage]<=50.00 THEN 1.00
		       ELSE 0
		  END
	   ELSE
		  0
     END),0.00) AS [Half Days]
    ,ISNULL(SUM(CASE
	   WHEN [Truant].[Count For Day] >= 2 THEN
		       CASE WHEN ([Truant].[Truant Percentage]>50.00 AND [Truant].[Truant Percentage]>0) THEN 1.00
		       ELSE 0.00
		  END
	   ELSE
		  0
     END),0.00) AS [Full Days]
    ,ISNULL(SUM(CASE
	   WHEN [Truant].[Count For Day] >= 2 THEN
			  CASE WHEN ([Truant].[Truant Percentage]<=50.00 AND [Truant].[Truant Percentage]>0) THEN 0.50
				  WHEN [Truant].[Truant Percentage]>50.00 THEN 1.00
		       ELSE 0
		  END
	   ELSE
		  0
     END),0.00) AS [Total]
FROM
(
SELECT
    [Truant1].*
    ,[SchedCount].[Total Classes]
    ,([Truant1].[Count For Day]/[SchedCount].[Total Classes])*100 AS [Truant Percentage]
FROM
[HighSchoolTruant] AS [Truant1]

LEFT JOIN
(
SELECT
    
    ID_NBR
	,SCH_NBR
    ,CAL_DT
    ,CYCLE_DAY
    ,CAST(SUM([Total Classes]) AS DECIMAL(5,2)) AS [Total Classes]
FROM
	[HSSchedCount] AS [SchedCount]

GROUP BY
    
    ID_NBR
	,SCH_NBR
    ,CAL_DT
    ,CYCLE_DAY
) AS [SchedCount]
ON
[Truant1].ID_NBR=[SchedCount].ID_NBR
AND Truant1.SCH_NBR = SchedCount.SCH_NBR
AND [Truant1].CAL_DT=[SchedCount].CAL_DT
AND [Truant1].[Count For Day]>=2
) AS [Truant]

WHERE
 [Truant].CAL_DT<=@asOfDate
GROUP BY
    [Truant].ID_NBR
    ,[Truant].SCH_NBR
) AS Truants

GROUP BY 
	[Truants].ID_NBR
	,[Truants].SCH_NBR

) AS T1



UNION ALL 

SELECT 
	TDAILY.*
	,HALF_DAYS + FULL_DAYS AS TOTAL_ABSENCES
 FROM 
(
SELECT 
	ID_NBR
	,SCH_NBR
	,SUM(CASE WHEN HALF_DAYS = 1 THEN .5 ELSE 0 END) AS HALF_DAYS
	,SUM(CASE WHEN HALF_DAYS = 2 THEN 1 ELSE 0 END) AS FULL_DAYS
 FROM 
DBTSIS.AT020_V AS DAILY
WHERE
DST_NBR = 1
AND SCH_YR = 2012
--AND SCH_NBR = '276'
AND ATT_STAT = 'A'
--AND ID_NBR = 970086956

GROUP BY 
	ID_NBR
	,SCH_NBR
) AS TDAILY


