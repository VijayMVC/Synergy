


/***********************************************************************************************

THREE HOUR DUAL FOR NON EL STUDENTS

--HERITAGE 3 HOUR IS ONLY FOR THE FOLLOWING SCHOOLS	('206', '210', '213', '215', '216', '225', '339', '243', '244', '249', '252', '262', '255',
 '496', '285', '291', '300', '250', '327', '275', '333', '330', '392', '280', '370', '376', '379', '385', 
 '405', '450', '415', '416', '475', '465', '470', '590', '576' )

*************************************************************************************************/


SELECT T6.*, PERS.LAST_NAME, PERS.FIRST_NAME
FROM (
SELECT * FROM 
(
SELECT 
	STUDENT_GU, SIS_NUMBER, MAX(RN) AS MAXCOUNT 
FROM( 
--THIS IS BOTH T1 AND T2
SELECT 
	T2.STUDENT_GU, T2.SIS_NUMBER
	,ROW_NUMBER() OVER (PARTITION BY SIS_NUMBER, COURSE_LEVEL ORDER BY STATE_COURSE_CODE) AS RN
FROM 
(
-------------------------------------------------------------------------------------------------
--FIRST PULL NON ELL STUDENTS THAT HAVE A BEP TAGGED COURSE BETWEEN 1274-1274 STATE COURSE CODES
-------------------------------------------------------------------------------------------------

SELECT DISTINCT PRIM.STUDENT_GU
 FROM 
APS.PrimaryEnrollmentDetailsAsOf(GETDATE()) AS PRIM
LEFT JOIN 
APS.ELLCalculatedAsOf(GETDATE()) AS ELL
ON
PRIM.STUDENT_GU = ELL.STUDENT_GU
LEFT JOIN 
APS.ScheduleDetailsAsOf(GETDATE()) AS SCH
ON
PRIM.STUDENT_GU = SCH.STUDENT_GU
INNER JOIN 
rev.EPC_CRS_LEVEL_LST AS LST
ON
SCH.COURSE_GU = LST.COURSE_GU
INNER JOIN 
REV.EPC_CRS AS CRS
ON
SCH.COURSE_GU = CRS.COURSE_GU
WHERE
LST.COURSE_LEVEL = 'BEP'
AND LEFT(CRS.STATE_COURSE_CODE,4) BETWEEN '1271' AND '1274'

-- non-EL STUDENTS
AND ELL.STUDENT_GU IS NULL

--DUAL 3 HOUR IS ONLY FOR THE FOLLOWING SCHOOLS
AND PRIM.SCHOOL_CODE IN ('206', '210', '213', '215', '216', '225', '339', '243', '244', '249', '252', '262', '255',
 '496', '285', '291', '300', '250', '327', '275', '333', '330', '392', '280', '370', '376', '379', '385', 
 '405', '450', '415', '416', '475', '465', '470', '590', '576' )

) AS T1

--6,173 ROWS

-------------------------------------------------------------------------------------------------
--FOR STUDENTS ABOVE PULL ALL BEP CLASSES THEN FILTER FOR STUDENTS THAT HAVE 3 TOTAL
-------------------------------------------------------------------------------------------------

INNER JOIN 
(
SELECT 
	STUDENT_GU, SIS_NUMBER, SCH.COURSE_ID, SCH.COURSE_TITLE, COURSE_LEVEL, STATE_COURSE_CODE
 FROM 

APS.ScheduleDetailsAsOf(GETDATE()) AS SCH
INNER JOIN 
rev.EPC_CRS_LEVEL_LST AS LST
ON
SCH.COURSE_GU = LST.COURSE_GU
INNER JOIN 
REV.EPC_CRS AS CRS
ON
SCH.COURSE_GU = CRS.COURSE_GU
WHERE
COURSE_LEVEL IN ('BEP')

) AS T2
ON
T1.STUDENT_GU = T2.STUDENT_GU
) AS T3
GROUP BY STUDENT_GU, SIS_NUMBER

) AS T4

WHERE
	MAXCOUNT > 2
) AS T5

---------------------------------------------------------------------------------------------------
----FOR STUDENTS ABOVE THAT HAVE MORE THAN 2 OTHER BEP COURSES PULL DETAILS
---------------------------------------------------------------------------------------------------

INNER JOIN 
(
SELECT 
	ORGANIZATION_NAME,
	STUDENT_GU, SIS_NUMBER, SCH.COURSE_ID, SCH.COURSE_TITLE, COURSE_LEVEL, STATE_COURSE_CODE
 FROM 

APS.ScheduleDetailsAsOf(GETDATE()) AS SCH
INNER JOIN 
rev.EPC_CRS_LEVEL_LST AS LST
ON
SCH.COURSE_GU = LST.COURSE_GU
INNER JOIN 
REV.EPC_CRS AS CRS
ON
SCH.COURSE_GU = CRS.COURSE_GU
WHERE
COURSE_LEVEL IN ('BEP')

) AS T6

ON
T5.STUDENT_GU = T6.STUDENT_GU

INNER JOIN 
REV.REV_PERSON AS PERS
ON
T6.STUDENT_GU = PERS.PERSON_GU

ORDER BY ORGANIZATION_NAME, SIS_NUMBER, STATE_COURSE_CODE