
SELECT
	*
FROM
	APS.LCEStudentsAndProvidersAsOf (GETDATE())
WHERE
	TCH_NME IS NULL
	AND PARENT_REFUSAL = 'N'
ORDER BY
	FULL_NME


