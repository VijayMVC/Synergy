
/*
THIS EMPLOYEE NEEDS 7 RECORDS - 03, 27, 32, 45, 51, 60, 67
*/

BEGIN TRANSACTION

INSERT INTO
rev.EPC_STAFF_CRD (STAFF_CREDENTIAL_GU, STAFF_GU, AUTHORIZED_TCH_AREA, CREDENTIAL_TYPE, DATE_EARNED, DOCUMENT_NUMBER, 
CHANGE_DATE_TIME_STAMP, CHANGE_ID_STAMP, ADD_DATE_TIME_STAMP, ADD_ID_STAMP)

SELECT 

NEWID () AS STAFF_CREDENTIAL_GU
,'4BE68352-24E0-49FB-A208-4E7D7FDEC9FC' AS STAFF_GU
,'67' AS AUTHORIZED_TCH_AREA
,'0300' AS CREDENTIAL_TYPE
,2014-07-01 AS DATE_EARNED
,'0362290' AS DOCUMENT_NUMBER
,NULL AS CHANGE_DATE_TIME_STAMP
,NULL AS CHANGE_ID_STAMP
,GETDATE() AS ADD_DATE_TIME_STAMP
,'27CDCD0E-BF93-4071-94B2-5DB792BB735F' AS ADD_ID_STAMP

--FROM
--rev.EPC_STAFF AS STAFF

COMMIT

