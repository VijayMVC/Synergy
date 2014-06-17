
--DELETE REV.REV_PERSON_PHONE 

SELECT 
	* 
FROM 
(
		SELECT 
			ROW_NUMBER ()OVER (PARTITION BY PERSON.PERSON_GU, PHONE ORDER BY PHONE) AS RN
			,PERSON.PRIMARY_PHONE
			,PERSON.PERSON_GU
			,PPHONE.PERSON_PHONE_GU
		 FROM
		REV.EPC_STAFF AS STAFF
		INNER JOIN REV.REV_PERSON AS PERSON
		ON
		STAFF.STAFF_GU = PERSON.PERSON_GU
		INNER JOIN
		REV.REV_PERSON_PHONE AS PPHONE
		ON
		PERSON.PERSON_GU = PPHONE.PERSON_GU

		WHERE
		BADGE_NUM = 'E139953'
) AS T1

WHERE
	RN != 1

