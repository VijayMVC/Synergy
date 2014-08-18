SELECT
	*
FROM	
	APS.PrimaryEnrollmentsAsOf(GETDATE()) AS Enrollment

	LEFT JOIN
	(
	SELECT
		STUDENT_GU
--		,NEXT_IEP_DATE
--		,EXIT_DATE
		,PRIMARY_DISABILITY_CODE
	FROM
		REV.EP_STUDENT_SPECIAL_ED AS SPED
	WHERE
		NEXT_IEP_DATE IS NOT NULL
		AND (
			EXIT_DATE IS NULL 
			OR EXIT_DATE >= CONVERT(DATE, GETDATE())
			)
	) AS CurrentSPED

	ON
	Enrollment.STUDENT_GU = CurrentSPED.STUDENT_GU
WHERE 
	CurrentSPED.STUDENT_GU IS NOT NULL