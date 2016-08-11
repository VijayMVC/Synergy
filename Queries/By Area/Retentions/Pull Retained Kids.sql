
/*
	
	CREATED:  8/11/2016
	PULL RETAINED KIDS
	2 READS - JUST CHANGE SCHOOL YEARS

*/


SELECT * FROM 
(
SELECT DISTINCT SIS_NUMBER, GRADE, GENDER, HISPANIC_INDICATOR
,CASE WHEN RESOLVED_RACE = 'TWO OR MORE' THEN RACE_1 ELSE RESOLVED_RACE END AS RACE FROM 
(
SELECT MAX(GRADE) AS GRADE, ENR.SIS_NUMBER ,GENDER, HISPANIC_INDICATOR, RACE_1, RESOLVED_RACE  

FROM 
APS.STUDENTENROLLMENTDETAILS AS ENR
INNER JOIN 
APS.BasicStudentWithMoreInfo AS BS
ON
ENR.STUDENT_GU = BS.STUDENT_GU
WHERE
SCHOOL_YEAR = 2015
AND EXTENSION = 'R'
AND EXCLUDE_ADA_ADM IS NULL

GROUP BY ENR.SIS_NUMBER,GENDER, HISPANIC_INDICATOR, RACE_1, RESOLVED_RACE 
) AS SCH
) AS SCH1

INNER JOIN 
(SELECT DISTINCT SIS_NUMBER, GRADE, GENDER, HISPANIC_INDICATOR
,CASE WHEN RESOLVED_RACE = 'TWO OR MORE' THEN RACE_1 ELSE RESOLVED_RACE END AS RACE FROM 
(
SELECT MAX(GRADE) AS GRADE, ENR.SIS_NUMBER ,GENDER, HISPANIC_INDICATOR, RACE_1, RESOLVED_RACE  

FROM 
APS.STUDENTENROLLMENTDETAILS AS ENR
INNER JOIN 
APS.BasicStudentWithMoreInfo AS BS
ON
ENR.STUDENT_GU = BS.STUDENT_GU
WHERE
SCHOOL_YEAR = 2016
AND EXTENSION = 'R'
AND EXCLUDE_ADA_ADM IS NULL

GROUP BY ENR.SIS_NUMBER,GENDER, HISPANIC_INDICATOR, RACE_1, RESOLVED_RACE 
) AS SCH2
)AS SCH3

ON 
SCH1.SIS_NUMBER = SCH3.SIS_NUMBER
AND SCH1.GRADE = SCH3.GRADE 


