

SELECT SCHOOL_NAME, LAST_NAME, FIRST_NAME, SIS_NUMBER, GRADE, SCHOOL_YEAR, HOME_LANGUAGE FROM 
APS.PrimaryEnrollmentDetailsAsOf(GETDATE()) AS PRIM
LEFT JOIN
APS.LCEMostRecentHLSAsOf(GETDATE()) AS HLS
ON
PRIM.STUDENT_GU = HLS.STUDENT_GU
LEFT JOIN
APS.BasicStudent AS BS
ON
PRIM.STUDENT_GU = BS.STUDENT_GU

WHERE
HLS.STUDENT_GU IS NULL
AND HOME_LANGUAGE != '54'

ORDER BY SCHOOL_YEAR, SCHOOL_NAME, GRADE
