
/*
*	CREATED BY: DEBBIE ANN CHAVEZ
*	DATE: 8/8/2014
*
*NIGHTLY PROCESS TO UPDATE THE HOME LANGUAGE
*
*	UPDATES THE STUDENT TABLE
*	
*/

/*===============================================================================
 UPDATES THE HOME LANGUAGE AND HOME LANGUAGE DATE IN STUDENT

================================================================================*/

USE ST_Production
GO


-- Remove Procedure if it exists
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[UpdateHomeLanguage]') AND type in (N'P', N'PC'))
	EXEC ('CREATE PROCEDURE [APS].UpdateHomeLanguage AS SELECT 0')
GO


ALTER PROC [APS].[UpdateHomeLanguage]

(
	@ValidateOnly INT
)


AS
BEGIN

BEGIN TRANSACTION

	UPDATE rev.EPC_STU
		SET HOME_LANGUAGE = UPDATESELECT.HOME_LANGUAGE, HOME_LANGUAGE_DATE = UPDATESELECT.DATE_ASSIGNED

	FROM
	(
	
	SELECT 
		STUDENT.STUDENT_GU
		,STURECORD.LANGUAGE_CODE AS HOME_LANGUAGE
		,DATE_ASSIGNED
	FROM
		rev.EPC_STU AS STUDENT

		LEFT JOIN
		(
		SELECT
			ALLHLS.STUDENT_GU
			,ALLHLS.LANGUAGE_CODE 
			,DATE_ASSIGNED
		FROM

--THIS PULLS ALL STUDENTS THAT HAVE NON ENGLISH RECORDS FOR THEIR MOST RECENT HLS RECORD
--, AND PULLS THE GREATER OF THE ANSWERS TO DETERMINE HOME LANGUAGE
		(
			SELECT
				STUDENT_GU
				 ,LANGUAGE_CODE
				 ,DATE_ASSIGNED
			 FROM
				(
				SELECT
                     STUDENT_GU
                     ,LANGUAGE_CODE
                     ,LANGCOUNT
                     ,ROW_NUMBER() OVER (PARTITION BY STUDENT_GU ORDER BY LANGCOUNT DESC, LANGUAGE_CODE ASC) AS RN
					 ,DATE_ASSIGNED
				FROM
                     (
                     SELECT
                           STUDENT_GU
                           ,LANGUAGE_CODE
                           ,COUNT(*) AS LANGCOUNT
						   ,DATE_ASSIGNED
                     FROM
                           (
                           SELECT
                                  *
                           FROM
                                  (
                                  SELECT
                                         *
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
                                                rev.UD_HLS_HISTORY
                                         ) AS HLS
                                  WHERE
                                         RN = 1
                                  ) AS MOSTRECENTHLS

                                  UNPIVOT
                                  (LANGUAGE_CODE FOR QUESTIONS IN (Q1_LANGUAGE_SPOKEN_MOST
                                         ,Q2_CHILD_FIRST_LANGUAGE
                                         ,Q3_LANGUAGES_SPOKEN
                                         ,Q4_OTHER_LANG_UNDERSTOOD
                                         ,Q5_OTHER_LANG_COMMUNICATED)
                                  ) AS T1
                                  WHERE
                                  LANGUAGE_CODE != '00'
                           ) AS UNPIVOTS
                     GROUP BY
                           STUDENT_GU
                           ,LANGUAGE_CODE
						   ,DATE_ASSIGNED
                     ) AS GROUPS
              ) AS RNGROUPS
		WHERE
             RN = 1

--THIS PULLS THE STUDENTS THAT ANSWERED ALL 5 HLS QUESTIONS ENGLISH 
UNION
			
              SELECT
                     STUDENT_GU
                     ,'00' 
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
                                  rev.UD_HLS_HISTORY
                           ) AS RawHLS
                     WHERE
                           RN = 1
                     ) AS MostRecent
              WHERE
                     Q1_LANGUAGE_SPOKEN_MOST + Q2_CHILD_FIRST_LANGUAGE + Q3_LANGUAGES_SPOKEN + Q4_OTHER_LANG_UNDERSTOOD + Q5_OTHER_LANG_COMMUNICATED = '0000000000'

	) AS ALLHLS
) STURECORD
ON
STUDENT.STUDENT_GU = STURECORD.STUDENT_GU

)UPDATESELECT

WHERE
UPDATESELECT.STUDENT_GU = rev.EPC_STU.STUDENT_GU
AND
( rev.EPC_STU.HOME_LANGUAGE IS NULL
OR rev.EPC_STU.HOME_LANGUAGE != UPDATESELECT.HOME_LANGUAGE)

--------------------------------------------------------------------------------------------------------------------------------------------
UPDATE rev.EPC_STU
	SET HOME_LANGUAGE = '54'

FROM 
APS.PrimaryEnrollmentDetailsAsOf(GETDATE()) AS PRIM
LEFT JOIN
APS.LCEMostRecentHLSAsOf(GETDATE()) AS HLS
ON
PRIM.STUDENT_GU = HLS.STUDENT_GU
LEFT JOIN
APS.BasicStudent AS BS
ON
PRIM.STUDENT_GU = BS.STUDENT_GU

WHERE
HLS.STUDENT_GU IS NULL
AND PRIM.STUDENT_GU = rev.EPC_STU.STUDENT_GU
----------------------------------------------------------------------------------------------------------------------------------------------


--Validation Check to see how many records will be processed, 0 = INSERT-WILL UPDATE, 1 = ROLLBACK-WILL NOT UPDATE
IF @ValidateOnly = 0
	BEGIN
		PRINT 'UPDATED HOME LANGUAGE'
		COMMIT 

	END
ELSE
	BEGIN
		PRINT 'HOME LANGUAGE NOT UPDATED'
		ROLLBACK
	END

/*
SELECT SIS_NUMBER, HOME_LANGUAGE, HOME_LANGUAGE_DATE FROM
rev.EPC_STU
WHERE HOME_LANGUAGE_DATE > CAST(LEFT(GETDATE(),11)AS DATE) 
*/

END
GO

