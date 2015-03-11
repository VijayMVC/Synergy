/**
 * 
 * $LastChangedBy: Gary Corbaley
 * $LastChangedDate: 03/11/2015
 *
 * Request By: Andy Gutierrez
 * InitialRequestDate: 02/23/2015
 * 
 * Description: This script sets students primary race indicator with their first race code when a student only has 1 race code.
 */


--SELECT
--	-- Basic Student Demographics
--	[STUDENT].[STUDENT_GU]
--	,[STUDENT].[SIS_NUMBER]
--	,[STUDENT].[STATE_STUDENT_NUMBER]
--	,[STUDENT].[LAST_NAME]
--	,[STUDENT].[FIRST_NAME]
--	,[STUDENT].[MIDDLE_NAME]
--	,[STUDENT].[BIRTH_DATE]
--	,[STUDENT].[GENDER]
    
--    ,[STUDENT].[HISPANIC_INDICATOR]
--    ,[ETHNIC_CODES].[RACE_1]
--    ,[ETHNIC_CODES].[RACE_2]
--    ,[ETHNIC_CODES].[RACE_3]
--    ,[ETHNIC_CODES].[RACE_4]
--    ,[ETHNIC_CODES].[RACE_5]

UPDATE [PERSON] 

SET [PRIMARY_RACE_INDICATOR] = [ETHNIC_CODES].[RACE_1]
    
FROM
	APS.BasicStudent AS [STUDENT]
	
	INNER JOIN
	rev.REV_PERSON AS [PERSON]
	ON
	[STUDENT].[STUDENT_GU] = [PERSON].[PERSON_GU]
	
	-- Get All Racial Codes
	LEFT JOIN
	(
	SELECT
		[ETHNIC_PIVOT].[PERSON_GU]
		,[ETHNIC_PIVOT].[1] AS [RACE_1]
		,[ETHNIC_PIVOT].[2] AS [RACE_2]
		,[ETHNIC_PIVOT].[3] AS [RACE_3]
		,[ETHNIC_PIVOT].[4] AS [RACE_4]
		,[ETHNIC_PIVOT].[5] AS [RACE_5]
	FROM
		(
		SELECT
			[SECONDARY_ETHNIC_CODES].[PERSON_GU]
			,[SECONDARY_ETHNIC_CODES].[ETHNIC_CODE]
			,ROW_NUMBER() OVER(PARTITION by [SECONDARY_ETHNIC_CODES].[PERSON_GU] order by [SECONDARY_ETHNIC_CODES].[ETHNIC_CODE]) [RN]
		FROM
			rev.REV_PERSON_SECONDRY_ETH_LST AS [SECONDARY_ETHNIC_CODES]
		) [PVT]
		PIVOT (MIN(ETHNIC_CODE) FOR [RN] IN ([1],[2],[3],[4],[5])) AS [ETHNIC_PIVOT]
	) AS [ETHNIC_CODES]
	ON
	[STUDENT].[STUDENT_GU] = [ETHNIC_CODES].[PERSON_GU]	
	
WHERE
	[ETHNIC_CODES].[RACE_2] IS NULL