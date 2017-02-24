
-- PULL KIDS THAT HAVE MORE RETURNED TO SAME SCHOOL

SELECT * FROM
(
SELECT 
	ROW_NUMBER() OVER (PARTITION BY SIS_NUMBER, SCHOOL_CODE ORDER BY SCHOOL_CODE ASC) AS RN
	,MEM.*
 FROM 
STUDENT_SCHOOL_MEMBERDAYS_2014 AS MEM

) AS T1

WHERE RN > 1

 