/* Brian Rieb
 * 8/19/2014
 *
 * Checks to see if kid ELL records exist, if so, updates ELL Program status to most recent if they have changed
 * If *NOT*, it creates the records
 */

BEGIN TRANSACTION
-- If They exist, update their status
UPDATE
	ELL
SET
	ELL.ENTRY_DATE = MostRecentELLHistory.ENTRY_DATE
	,ELL.EXIT_DATE = MostRecentELLHistory.EXIT_DATE
	,ELL.EXIT_REASON = MostRecentELLHistory.EXIT_REASON
	,ELL.PROGRAM_CODE = MostRecentELLHistory.PROGRAM_CODE
FROM
	-- Most Recent ELL History Record
	(
	SELECT
		STUDENT_GU
		,ENTRY_DATE
		,PROGRAM_CODE
		,EXIT_DATE
		,EXIT_REASON
	FROM
		(
		SELECT
			STUDENT_GU
			,ENTRY_DATE
			,PROGRAM_CODE
			,EXIT_DATE
			,EXIT_REASON
			,ROW_NUMBER() OVER (PARTITION BY STUDENT_GU ORDER BY COALESCE(EXIT_DATE, CONVERT(DATE, GETDATE())) DESC, ENTRY_DATE) AS RN
		FROM
			Rev.EPC_STU_PGM_ELL_HIS
		)AS ELLHistory
	WHERE
		RN =1
	) AS MostRecentELLHistory

	INNER JOIN
	rev.EPC_STU_PGM_ELL AS ELL
	ON
	MostRecentELLHistory.STUDENT_GU = ELL.STUDENT_GU
WHERE
	-- change only if different
	ELL.ENTRY_DATE != MostRecentELLHistory.ENTRY_DATE
	OR ELL.EXIT_DATE != MostRecentELLHistory.EXIT_DATE
	OR ELL.EXIT_REASON != MostRecentELLHistory.EXIT_REASON
	OR ELL.PROGRAM_CODE != MostRecentELLHistory.PROGRAM_CODE

-- ------------------------------------------------------------------------------------------------------------------------------
-- IF They dont exist, create the ELL Record
-- May need to expand this to have better dfaults for other fields, but as of right now, the insert
-- does not fail
INSERT INTO
	rev.EPC_STU_PGM_ELL
	(
	STUDENT_GU
	,ENTRY_DATE
	,PROGRAM_CODE
	,EXIT_DATE
	,EXIT_REASON
	)
SELECT
	MostRecentELLHistory.STUDENT_GU
	,MostRecentELLHistory.ENTRY_DATE
	,MostRecentELLHistory.PROGRAM_CODE
	,MostRecentELLHistory.EXIT_DATE
	,MostRecentELLHistory.EXIT_REASON
FROM
	-- Most Recent ELL History Record
	(
	SELECT
		STUDENT_GU
		,ENTRY_DATE
		,PROGRAM_CODE
		,EXIT_DATE
		,EXIT_REASON
	FROM
		(
		SELECT
			STUDENT_GU
			,ENTRY_DATE
			,PROGRAM_CODE
			,EXIT_DATE
			,EXIT_REASON
			,ROW_NUMBER() OVER (PARTITION BY STUDENT_GU ORDER BY COALESCE(EXIT_DATE, CONVERT(DATE, GETDATE())) DESC, ENTRY_DATE) AS RN
		FROM
			Rev.EPC_STU_PGM_ELL_HIS
		)AS ELLHistory
	WHERE
		RN =1
	) AS MostRecentELLHistory

	LEFT JOIN
	rev.EPC_STU_PGM_ELL AS ELL
	ON
	MostRecentELLHistory.STUDENT_GU = ELL.STUDENT_GU
WHERE
	-- record does not match
	ELL.STUDENT_GU IS NULL
ROLLBACK