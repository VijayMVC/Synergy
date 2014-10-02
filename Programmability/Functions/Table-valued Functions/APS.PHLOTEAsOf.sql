/**
 * $Revision$
 * $LastChangedBy$
 * $LastChangedDate$
 */
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[PHLOTEAsOf]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	EXEC('CREATE FUNCTION APS.PHLOTEAsOf()RETURNS TABLE AS RETURN (SELECT 0 AS DUMMY)')
GO

/**
 * FUNCTION APS.PhloteStatusAsOf
 * Pulls StudentGUs of anyone who is PHLOTE
 * Tables Used: UD_HLS_HISTORY
 *
 * #param DATETIME @asOfDate Date to pull PHLOTE status from
 * 
 * #return TABLE PHLOTE Info as of date
 */
ALTER FUNCTION APS.PHLOTEAsOf(@asOfDate DATETIME)
RETURNS TABLE
AS
RETURN
SELECT
	STUDENT_GU
	,DATE_ASSIGNED
FROM
	(
	SELECT
		STUDENT_GU
		,Q1_LANGUAGE_SPOKEN_MOST
		,Q2_CHILD_FIRST_LANGUAGE
		,Q3_LANGUAGES_SPOKEN
		,Q4_OTHER_LANG_UNDERSTOOD
		,Q5_OTHER_LANG_COMMUNICATED
		,ROW_NUMBER() OVER (PARTITION BY STUDENT_GU ORDER BY DATE_ASSIGNED DESC) AS RN
		,DATE_ASSIGNED
	FROM
		rev.UD_HLS_HISTORY AS HLSHistory
	WHERE
		DATE_ASSIGNED <= @asOfDate
	) AS RowedHLS
WHERE
	RN = 1
	AND Q1_LANGUAGE_SPOKEN_MOST + Q2_CHILD_FIRST_LANGUAGE + Q3_LANGUAGES_SPOKEN + Q4_OTHER_LANG_UNDERSTOOD + Q5_OTHER_LANG_COMMUNICATED != '0000000000'
	