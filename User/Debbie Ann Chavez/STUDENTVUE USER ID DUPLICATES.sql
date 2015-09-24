
SELECT 
	PARENTS.USER_ID, PARENTS.DISABLED, PARENTS.LOGIN_ATTEMPTS, EMAILS.EMAIL_1, EMAILS.EMAIL_2, EMAILS.EMAIL_3, EMAILS.EMAIL_4, EMAILS.EMAIL_5,
	STUDENTS.USER_ID, STUDENTS.DISABLED, STUDENTS.LOGIN_ATTEMPTS
 FROM 
(
SELECT * FROM 
rev.REV_USER_NON_SYS AS SYST
INNER JOIN
rev.EPC_PARENT AS PARENTS
ON
SYST.PERSON_GU = PARENTS.PARENT_GU
) AS PARENTS

INNER JOIN
(
SELECT * FROM 
rev.REV_USER_NON_SYS AS SYST
INNER JOIN
rev.EPC_STU AS STU
ON
SYST.PERSON_GU = STU.STUDENT_GU
) AS STUDENTS

ON
PARENTS.USER_ID = STUDENTS.USER_ID

INNER JOIN
rev.EPC_PARENT_PXP AS EMAILS
ON 
EMAILS.PARENT_PXP_GU = PARENTS.PARENT_GU

ORDER BY EMAIL_1

