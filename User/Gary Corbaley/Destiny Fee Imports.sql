
BEGIN TRAN

DECLARE @FeeCodes TABLE ([FEE_CODE_GU] UNIQUEIDENTIFIER, [FEE_CODE] VARCHAR(256), [FEE_DESCRIPTION] VARCHAR(256), [START_DATE] DATETIME, [END_DATE] DATETIME )

INSERT INTO
	@FeeCodes

	SELECT
		[FEE_CODE_GU]
		,[FEE_CODE]
		,[FEE_DESCRIPTION]
		,[CalendarOptions].[START_DATE]
		,[CalendarOptions].[END_DATE]
	FROM
		[rev].[EPC_SCH_YR_FEE]
		
		INNER JOIN 
		rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
		ON 
		[EPC_SCH_YR_FEE].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
		
		INNER JOIN 
		rev.REV_YEAR AS [RevYear] -- Contains the School Year
		ON 
		[OrgYear].[YEAR_GU] = [RevYear].[YEAR_GU]
		
		INNER JOIN
		rev.EPC_SCH_ATT_CAL_OPT AS [CalendarOptions]
		ON
		[OrgYear].[ORGANIZATION_YEAR_GU] = [CalendarOptions].[ORG_YEAR_GU]
		
	WHERE
		[FEE_DESCRIPTION] = 'Library'


--INSERT INTO
--	[rev].[EPC_STU_FEE] 

--	([STUDENT_FEE_GU],[STUDENT_SCHOOL_YEAR_GU],[STUDENT_GU],[TRANSACTION_DATE],[DESCRIPTION],[FEE_CATEGORY],[FEE_CODE_GU],[CREDIT_AMOUNT]
--	,[NOTE],[REFUND_NEEDED],[FEE_STATUS],[ADD_DATE_TIME_STAMP])	

SELECT
	NEWID() AS [STUDENT_FEE_GU]
	,APS.NearestStudentSchoolYear([stu].[STUDENT_GU],RIGHT([LIBRARY_FINE].[PatronSiteShortName],3),CONVERT(DATETIME,LEFT(RIGHT([LIBRARY_FINE].[FineCreatedDate],4),2) + '/' + RIGHT([LIBRARY_FINE].[FineCreatedDate],2) + '/' + LEFT([LIBRARY_FINE].[FineCreatedDate],4))) AS [STUDENT_SCHOOL_YEAR_GU]
	--,[ENROLLMENT].[STUDENT_SCHOOL_YEAR_GU] AS [STUDENT_SCHOOL_YEAR_GU]
	,[stu].[STUDENT_GU] AS [STUDENT_GU]
	,CONVERT(DATETIME,LEFT(RIGHT([LIBRARY_FINE].[FineCreatedDate],4),2) + '/' + RIGHT([LIBRARY_FINE].[FineCreatedDate],2) + '/' + LEFT([LIBRARY_FINE].[FineCreatedDate],4)) AS [TRANSACTION_DATE]
	,[FEECODE].[FEE_DESCRIPTION] AS [FEE_DESCRIPTION]
	,'LIBR' AS [FEE_CATEGORY]
	,[FEECODE].[FEE_CODE_GU] AS [FEE_CODE_GU]
	,[LIBRARY_FINE].[FineAmount] AS [CREDIT_AMOUNT]
	,CASE WHEN [LIBRARY_FINE].[ItemBarCode] IS NULL THEN '' ELSE [LIBRARY_FINE].[ItemBarCode] END
	 + ' ' + 
	 CASE WHEN [LIBRARY_FINE].[FineDescription] IS NULL THEN '' ELSE [LIBRARY_FINE].[FineDescription] END
	 + ' ' + 
	 CASE WHEN [LIBRARY_FINE].[ItemTitle] IS NULL THEN '' ELSE REPLACE([LIBRARY_FINE].[ItemTitle],',','') END AS [NOTE]
	,'N' AS [REFUND_NEEDED]
	,0 AS [FEE_STATUS]
	,GETDATE() AS [ADD_DATE_TIME_STAMP]
	 
	--,[FEECODE].[FEE_CODE]
	--,RIGHT([LIBRARY_FINE].[PatronDistrictID],9) AS [PERM_ID]
	--,[ENROLLMENT].[SCHOOL_CODE]
	--,[ENROLLMENT].[SCHOOL_YEAR]
	--,[ENROLLMENT].[SCHOOL_NAME]
	
	--,[LIBRARY_FINE].*
FROM
	[180-SMAXODS-01.APS.EDU.ACTD].[HELPER].[DBO].[FINE] AS [LIBRARY_FINE]
	
	INNER JOIN
	@FeeCodes AS [FEECODE]
	ON
	CONVERT(DATETIME,LEFT(RIGHT([LIBRARY_FINE].[FineCreatedDate],4),2) + '/' + RIGHT([LIBRARY_FINE].[FineCreatedDate],2) + '/' + LEFT([LIBRARY_FINE].[FineCreatedDate],4)) BETWEEN [FEECODE].[START_DATE] AND [FEECODE].[END_DATE]
	AND RIGHT([LIBRARY_FINE].[FineSiteShortName],3) = LEFT([FEECODE].[FEE_CODE],3)
	
	-- GET STUDENT GU	
	INNER JOIN
	[rev].[EPC_STU] as [stu]
	ON
	RIGHT([LIBRARY_FINE].[PatronDistrictID],9)=[stu].[SIS_NUMBER]
	
	--LEFT OUTER JOIN
	--APS.StudentEnrollmentDetails AS [ENROLLMENT]
	--ON
	--[stu].[STUDENT_GU] = [ENROLLMENT].[STUDENT_GU]
	--AND LEFT([LIBRARY_FINE].[FineCreatedDate],4) = [ENROLLMENT].[SCHOOL_YEAR]
	--AND RIGHT([LIBRARY_FINE].[FineSiteShortName],3) = [ENROLLMENT].[SCHOOL_CODE]
	
	LEFT JOIN
	[rev].[EPC_STU_FEE] AS [fee]
	ON
	CAST([fee].[NOTE] AS VARCHAR(4000)) = 
	CAST(
	CASE WHEN [LIBRARY_FINE].[ItemBarCode] IS NULL THEN '' ELSE [LIBRARY_FINE].[ItemBarCode] END
	 + ' ' + 
	 CASE WHEN [LIBRARY_FINE].[FineDescription] IS NULL THEN '' ELSE [LIBRARY_FINE].[FineDescription] END
	 + ' ' + 
	 CASE WHEN [LIBRARY_FINE].[ItemTitle] IS NULL THEN '' ELSE REPLACE([LIBRARY_FINE].[ItemTitle],',','') END
	 AS VARCHAR(4000))
	 
WHERE
	[LIBRARY_FINE].[CollectionType] = 'Library'
	AND [LIBRARY_FINE].[ItemBarCode] IS NOT NULL
	AND [fee].[STUDENT_FEE_GU] IS NULL
	
ORDER BY
	[stu].[STUDENT_GU]
	
	
--SELECT
--	*
--FROM
--	[rev].[EPC_SCH_YR_FEE]
	
--WHERE
----	[FEE_CODE] = '712990'
--	[FEE_DESCRIPTION] = 'Library'

--ROLLBACK
COMMIT