
/*
*	Created By:  Debbie Ann Chavez
*	Date:  6/27/2014
*
*	CLEAR OUT SSN FOR STAFF THAT WAS LOADED ON FIRST STAFF IMPORT
*/

BEGIN TRANSACTION

UPDATE REV.REV_PERSON
SET SOCIAL_SECURITY_NUMBER = NULL 

--SELECT *
FROM REV.REV_PERSON WHERE SOCIAL_SECURITY_NUMBER IS NOT NULL

ROLLBACK