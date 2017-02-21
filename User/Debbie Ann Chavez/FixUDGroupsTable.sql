
BEGIN TRANSACTION

UPDATE rev.UD_CRS_GROUP
SET [GROUP] = T1.VALUE_DESCRIPTION, [CODE] = T1.VALUE_CODE
FROM
(
SELECT DCM.COURSE_ID, DCM.COURSE_TITLE, GRPS.[GROUP], GRPS.CODE,LU.VALUE_DESCRIPTION, GRPS.UDCRS_GROUP_GU, LU.VALUE_CODE

 FROM 
rev.EPC_CRS AS DCM
INNER JOIN 
rev.UD_CRS_GROUP AS GRPS
ON 
GRPS.COURSE_GU = DCM.COURSE_GU
INNER JOIN 
APS.LookupTable('Revelation.UD.Course','Course_Group') AS LU
ON
LU.VALUE_CODE = GRPS.[GROUP]

WHERE
[GROUP] LIKE 'R%'
) AS T1
WHERE
T1.UDCRS_GROUP_GU = rev.UD_CRS_GROUP.UDCRS_GROUP_GU
ROLLBACK
