
/*******************************************************************************

CREATED BY DEBBIE ANN CHAVEZ
DATE 11/2/17

UPDATE THE BEP FLAG FOR ALL COURSES IN THE DCM THAT HAVE AN 8 IN THE 5TH DIGIT

*******************************************************************************/



BEGIN TRAN
UPDATE REV.EPC_CRS_LEVEL_LST 
SET COURSE_LEVEL = 'BEP'
FROM 
(
SELECT * FROM 
(
SELECT 
	COURSE_ID, COURSE_LEVEL, COURSE_TITLE, STATE_COURSE_CODE, LVL.COURSE_GU
 FROM 
REV.EPC_CRS AS CRS
INNER JOIN 
REV.EPC_CRS_LEVEL_LST AS LVL
ON
CRS.COURSE_GU = LVL.COURSE_GU
) AS T1

PIVOT
(
MAX(COURSE_LEVEL)
FOR COURSE_LEVEL IN ([BEP],[N],[H],[E],[A],[EXG],[D],[P],[L],[G],[GFT],[ESL],[C],[BLOCK],[EXA],[I])
) AS PivotTable



WHERE
[BEP] != 'BEP'
AND 
SUBSTRING(STATE_COURSE_CODE,5,1) = 8
) AS T2

WHERE
T2.COURSE_GU = REV.EPC_CRS_LEVEL_LST.COURSE_GU

ROLLBACK