BEGIN TRAN

SELECT
	CONTACT.EMPLOYEE_ID
	,EMP.EMPLOYEE_ID
FROM
	Employee_ListServe AS CONTACT
	LEFT JOIN
	EMPLOYEE_FILE AS EMP
	ON CONTACT.EMPLOYEE_ID = EMP.EMPLOYEE_ID
WHERE	
	EMP.EMPLOYEE_ID IS NULL

ROLLBACK