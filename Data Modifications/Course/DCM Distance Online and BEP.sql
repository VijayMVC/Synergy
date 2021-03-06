
/*
CREATED BY DEBBIE ANN CHAVEZ
DATE 12/15/2016

UPDATING SECTIONS FROM THE DCM FOR BEP AND DISTANCE AND ONLINE COURSES

*/


BEGIN TRANSACTION 


--Update Sections BEP from the DCM
--------------------------------------------------------------------------------------------------------------------------
/*
UPDATE rev.EPC_SCH_YR_SECT 
SET INSTRUCTIONAL_STRATEGY = 'BEP' 
*/
SELECT 
	ORGANIZATION_NAME, CRS.COURSE_ID, CRS.COURSE_TITLE, LST.COURSE_LEVEL, CRS.DISTANCE_LEARNING, CRS.ONLINE_COURSE,
	SECT.SECTION_ID, INSTRUCTIONAL_METHOD, INSTRUCTIONAL_CONTENT, INSTRUCTIONAL_STRATEGY
	
 FROM 
rev.EPC_CRS AS CRS
INNER JOIN 
rev.EPC_SCH_YR_CRS AS CRSYR
ON
CRS.COURSE_GU = CRSYR.COURSE_GU
INNER JOIN 
rev.EPC_SCH_YR_SECT AS SECT
ON
CRSYR.SCHOOL_YEAR_COURSE_GU = SECT.SCHOOL_YEAR_COURSE_GU
INNER JOIN 
rev.REV_ORGANIZATION_YEAR AS ORGYR
ON
CRSYR.ORGANIZATION_YEAR_GU = ORGYR.ORGANIZATION_YEAR_GU
INNER JOIN 
rev.REV_ORGANIZATION AS ORG
ON
ORGYR.ORGANIZATION_GU = ORG.ORGANIZATION_GU
INNER JOIN 
rev.EPC_CRS_LEVEL_LST AS LST
ON
LST.COURSE_GU = CRS.COURSE_GU 
INNER JOIN 
rev.REV_YEAR AS YRS
ON
ORGYR.YEAR_GU = YRS.YEAR_GU

WHERE
LST.COURSE_LEVEL = 'BEP'
AND INSTRUCTIONAL_STRATEGY IS NULL
/*
OR
CRS.DISTANCE_LEARNING = 'Y'
OR CRS.ONLINE_COURSE = 'Y'
*/
AND SCHOOL_YEAR = (SELECT * FROM rev.SIF_22_Common_CurrentYear)
-----------------------------------------------------------------------------------------------------------------------------------


--Update Sections from DCM for Distance and Online Courses 
------------------------------------------------------------------------------------------------------------------------------------
/*
UPDATE rev.EPC_SCH_YR_SECT 
SET INSTRUCTIONAL_METHOD = 'DL'
	,INSTRUCTIONAL_CONTENT = 4
*/
SELECT 
	ORGANIZATION_NAME, CRS.COURSE_ID, CRS.COURSE_TITLE, LST.COURSE_LEVEL, CRS.DISTANCE_LEARNING, CRS.ONLINE_COURSE,
	SECT.SECTION_ID, INSTRUCTIONAL_METHOD, INSTRUCTIONAL_CONTENT, INSTRUCTIONAL_STRATEGY
	
 FROM 
rev.EPC_CRS AS CRS
INNER JOIN 
rev.EPC_SCH_YR_CRS AS CRSYR
ON
CRS.COURSE_GU = CRSYR.COURSE_GU
INNER JOIN 
rev.EPC_SCH_YR_SECT AS SECT
ON
CRSYR.SCHOOL_YEAR_COURSE_GU = SECT.SCHOOL_YEAR_COURSE_GU
INNER JOIN 
rev.REV_ORGANIZATION_YEAR AS ORGYR
ON
CRSYR.ORGANIZATION_YEAR_GU = ORGYR.ORGANIZATION_YEAR_GU
INNER JOIN 
rev.REV_ORGANIZATION AS ORG
ON
ORGYR.ORGANIZATION_GU = ORG.ORGANIZATION_GU
INNER JOIN 
rev.EPC_CRS_LEVEL_LST AS LST
ON
LST.COURSE_GU = CRS.COURSE_GU 
INNER JOIN 
rev.REV_YEAR AS YRS
ON
ORGYR.YEAR_GU = YRS.YEAR_GU

WHERE
/*LST.COURSE_LEVEL = 'BEP'*/

(CRS.DISTANCE_LEARNING = 'Y'
OR CRS.ONLINE_COURSE = 'Y')
AND SECT.INSTRUCTIONAL_METHOD IS NULL
AND SCHOOL_YEAR = (SELECT * FROM rev.SIF_22_Common_CurrentYear)
-----------------------------------------------------------------------------------------------------------------------------------


--Update Sections to FF for all sections that are not tagged Distance or Online Courses 
------------------------------------------------------------------------------------------------------------------------------------
/*UPDATE rev.EPC_SCH_YR_SECT 
SET INSTRUCTIONAL_METHOD = 'FF'
*/

SELECT 
	ORGANIZATION_NAME, CRS.COURSE_ID, CRS.COURSE_TITLE, LST.COURSE_LEVEL, CRS.DISTANCE_LEARNING, CRS.ONLINE_COURSE,
	SECT.SECTION_ID, INSTRUCTIONAL_METHOD, INSTRUCTIONAL_CONTENT, INSTRUCTIONAL_STRATEGY
	
 FROM 
rev.EPC_CRS AS CRS
INNER JOIN 
rev.EPC_SCH_YR_CRS AS CRSYR
ON
CRS.COURSE_GU = CRSYR.COURSE_GU
INNER JOIN 
rev.EPC_SCH_YR_SECT AS SECT
ON
CRSYR.SCHOOL_YEAR_COURSE_GU = SECT.SCHOOL_YEAR_COURSE_GU
INNER JOIN 
rev.REV_ORGANIZATION_YEAR AS ORGYR
ON
CRSYR.ORGANIZATION_YEAR_GU = ORGYR.ORGANIZATION_YEAR_GU
INNER JOIN 
rev.REV_ORGANIZATION AS ORG
ON
ORGYR.ORGANIZATION_GU = ORG.ORGANIZATION_GU
INNER JOIN 
rev.EPC_CRS_LEVEL_LST AS LST
ON
LST.COURSE_GU = CRS.COURSE_GU 
INNER JOIN 
rev.REV_YEAR AS YRS
ON
ORGYR.YEAR_GU = YRS.YEAR_GU

WHERE
/*LST.COURSE_LEVEL = 'BEP'*/

(CRS.DISTANCE_LEARNING != 'Y'
OR CRS.ONLINE_COURSE != 'Y')
AND SECT.INSTRUCTIONAL_METHOD IS NULL 

AND ORGANIZATION_NAME NOT IN ('Central NM Comm College', 'University of NM', 'Institute of American Indian Arts')

AND SCHOOL_YEAR = (SELECT * FROM rev.SIF_22_Common_CurrentYear)


ROLLBACK 

