SELECT SIS_NUMBER, STATE_STUDENT_NUMBER, SCHOOL_CODE, CAST(ABS_DATE AS DATE) AS ABS_DATE, [Half-Day Unexcused], [Full-Day Unexcused]
FROM 
[APS].[Daily]('2016-05-25')

WHERE
SIS_NUMBER = 970035916