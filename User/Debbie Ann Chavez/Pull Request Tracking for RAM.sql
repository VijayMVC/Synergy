
EXECUTE AS LOGIN='QueryFileUser'
GO


SELECT 
CAREER.*
,CAST(TRACK.RELEASE_DATE AS DATE)AS RELEAST_DATE
,ORG.NAME AS NON_DISTRICT_SCHOOL
,TRACK.PERSON_RELEASED_TO
,PERS.VALUE_DESCRIPTION AS PERSON_TITLE
,PURP.VALUE_DESCRIPTION AS RELEASE_PURPOSE
,REQ.NOTES
,CAST(TRACK.REQUEST_DATE AS DATE) AS REQUEST_DATE
,DEL.VALUE_DESCRIPTION AS DELIVERY_TYPE

FROM

            OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                  'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
                  'SELECT * from RAM.csv'
                ) AS [CAREER]

INNER JOIN 
rev.EPC_STU AS STU
ON
[CAREER].SIS_NUMBER = STU.SIS_NUMBER

LEFT JOIN 
rev.EPC_STU_REQUEST_TRACKING AS TRACK
ON
STU.STUDENT_GU = TRACK.STUDENT_GU

LEFT JOIN 
rev.UD_STU_REQUEST_TRACKING AS REQ
ON
REQ.STU_REQUEST_TRACKING_GU = TRACK.STU_REQUEST_TRACKING_GU

LEFT JOIN 
rev.EPC_SCH_NON_DST AS ORG
ON
TRACK.SCHOOL_NON_DISTRICT_GU = ORG.SCHOOL_NON_DISTRICT_GU

LEFT JOIN 
APS.LookupTable ('K12.CourseHistoryInfo','Person_Title') AS PERS
ON
PERS.VALUE_CODE = TRACK.PERSON_TITLE

LEFT JOIN 
APS.LookupTable ('K12.CourseHistoryInfo','Release_Purpose') AS PURP
ON
PURP.VALUE_CODE = TRACK.RELEASE_PURPOSE

LEFT JOIN 
APS.LookupTable ('K12.CourseHistoryInfo','Delivery_Type') AS DEL
ON
DEL.VALUE_CODE = TRACK.DELIVERY_TYPE


      REVERT
GO