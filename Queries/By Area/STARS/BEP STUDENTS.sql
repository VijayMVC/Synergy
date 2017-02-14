/*
Created By Debbie Ann Chavez
- Just change reporting date

--This pulls all BEP students for STARS 
*/

SELECT SIS_NUMBER, STATE_STUDENT_NUMBER, PROGRAM_CODE, PROGRAM_INTENSITY AS PROGRAM_HOURS,
CASE WHEN PROGRAM_CODE = 'MAINT' THEN 2
	WHEN PROGRAM_CODE = 'ENRIC' THEN 3
	WHEN PROGRAM_CODE = 'DUAL' THEN 1
ELSE '' END AS PARTICIPATION_MODEL

FROM 
APS.LCEBilingualAsOf('02-08-2017') AS BIL
INNER JOIN
rev.EPC_STU AS STU
ON
BIL.STUDENT_GU = STU.STUDENT_GU