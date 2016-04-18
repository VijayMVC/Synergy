


EXECUTE AS LOGIN='QueryFileUser'
GO

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
		LEFT([FEE_CODE],3) IN ('525','540','550','560','570','576','580')
		
-----------------------------------------------------------------------------------	

INSERT INTO
	[rev].[EPC_STU_FEE] 

	([STUDENT_FEE_GU],[STUDENT_SCHOOL_YEAR_GU],[STUDENT_GU],[TRANSACTION_DATE],[DESCRIPTION],[FEE_CATEGORY],[FEE_CODE_GU],[CREDIT_AMOUNT]
	,[NOTE],[REFUND_NEEDED],[FEE_STATUS],[ADD_DATE_TIME_STAMP])	

SELECT
	NEWID() AS [STUDENT_FEE_GU]
	,APS.NearestStudentSchoolYear([stu].[STUDENT_GU],[Lost].[CampusID],[Lost].[ModifiedDate]) AS [STUDENT_SCHOOL_YEAR_GU]
	,[stu].[STUDENT_GU]
	,[Lost].[ModifiedDate] AS [TRANSACTION_DATE]
	,CASE WHEN [FEECODES_CURRENT].[FEE_DESCRIPTION] IS NULL THEN [FEECODES_PREVIOUS].[FEE_DESCRIPTION] ELSE [FEECODES_CURRENT].[FEE_DESCRIPTION] END AS [DESCRIPTION]
	,'ACT' AS [FEE_CATEGORY]
	,CASE WHEN [FEECODES_CURRENT].[FEE_CODE_GU] IS NULL THEN [FEECODES_PREVIOUS].[FEE_CODE_GU] ELSE [FEECODES_CURRENT].[FEE_CODE_GU] END AS [FEE_CODE_GU]
	,[Lost].[Price] AS [CREDIT_AMOUNT]
	,CAST([Lost].[ISBN] AS VARCHAR(255))+' '+CAST([Lost].[Accession] AS VARCHAR(255))+' '+[Lost].[Title] + ' LST' AS [NOTE] 
	,'N' AS [REFUND_NEEDED]
	,0 AS [FEE_STATUS]
	,GETDATE() AS [ADD_DATE_TIME_STAMP]
	
FROM
	-- READ FEES FROM FILE
	OPENROWSET (
		'Microsoft.ACE.OLEDB.12.0', 
		'Text;Database=\\SynTempSSIS.aps.edu.actd\Files\TempQuery\;HDR=YES;', 
		'SELECT * from APSLostBooks.csv'
		) AS [Lost]

	-- GET FEE CODES		
	LEFT OUTER JOIN
	@FeeCodes AS [FEECODES_CURRENT]
	ON
	[FEECODES_CURRENT].[FEE_DESCRIPTION] = 'Textbooks Lost'
	AND LEFT([FEECODES_CURRENT].[FEE_CODE],3) = [Lost].[CampusID]
	AND 
	-- GET CURRENT SCHOOL YEAR
	[Lost].[ModifiedDate] BETWEEN [FEECODES_CURRENT].[START_DATE] AND [FEECODES_CURRENT].[END_DATE]
	
	LEFT OUTER JOIN
	@FeeCodes AS [FEECODES_PREVIOUS]
	ON
	[FEECODES_PREVIOUS].[FEE_DESCRIPTION] = 'Textbooks Lost'
	AND LEFT([FEECODES_PREVIOUS].[FEE_CODE],3) = [Lost].[CampusID]
	AND 
	-- GET PREVIOUS SCHOOL YEAR WHERE END DATES ARE IN THE SAME YEAR AS THE DATE FROM THE FILE
	([Lost].[ModifiedDate] > [FEECODES_PREVIOUS].[END_DATE] AND YEAR([Lost].[ModifiedDate]) = YEAR([FEECODES_PREVIOUS].[END_DATE]))	
	
	-- GET STUDENT GU	
	INNER JOIN
	[rev].[EPC_STU] as [stu]
	ON
	[Lost].[StudentID]=[stu].[SIS_NUMBER]

	LEFT JOIN
	[rev].[EPC_STU_FEE] AS [fee]
	ON
	CAST([fee].[NOTE] AS VARCHAR(4000))=CAST([Lost].[ISBN] AS VARCHAR(255))+' '+CAST([Lost].[Accession] AS VARCHAR(255))+' '+[Lost].[Title] + ' LST'
	
WHERE
	[Lost].[CampusID] IN ('525','540','550','560','570','576','580')
	AND [fee].[STUDENT_FEE_GU] IS NULL
	AND [Lost].[ModifiedDate] IS NOT NULL

---------------------------------------------------------------------------------------------------	
--/*
INSERT INTO
	[rev].[EPC_STU_FEE] 

	([STUDENT_FEE_GU],[STUDENT_SCHOOL_YEAR_GU],[STUDENT_GU],[TRANSACTION_DATE],[DESCRIPTION],[FEE_CATEGORY],[FEE_CODE_GU],[CREDIT_AMOUNT]
	,[NOTE],[REFUND_NEEDED],[FEE_STATUS],[ADD_DATE_TIME_STAMP])	
	
SELECT
	NEWID() AS [STUDENT_FEE_GU]
	,APS.NearestStudentSchoolYear([stu].[STUDENT_GU],[Damaged].[CampusID],[Damaged].[ModifiedDate]) AS [STUDENT_SCHOOL_YEAR_GU]
	,[stu].[STUDENT_GU]
	,[Damaged].[ModifiedDate] AS [TRANSACTION_DATE]
	,CASE WHEN [FEECODES_CURRENT].[FEE_DESCRIPTION] IS NULL THEN [FEECODES_PREVIOUS].[FEE_DESCRIPTION] ELSE [FEECODES_CURRENT].[FEE_DESCRIPTION] END AS [DESCRIPTION]
	,'ACT' AS [FEE_CATEGORY]
	,CASE WHEN [FEECODES_CURRENT].[FEE_CODE_GU] IS NULL THEN [FEECODES_PREVIOUS].[FEE_CODE_GU] ELSE [FEECODES_CURRENT].[FEE_CODE_GU] END AS [FEE_CODE_GU]
	,[Damaged].[ChargeAmount] AS [CREDIT_AMOUNT]
	,CAST([Damaged].[ISBN] AS VARCHAR(255))+' '+CAST([Damaged].[Accession] AS VARCHAR(255))+' '+[Damaged].[Title] + ' DMG' AS [NOTE] 
	,'N' AS [REFUND_NEEDED]
	,0 AS [FEE_STATUS]
	,GETDATE() AS [ADD_DATE_TIME_STAMP]
FROM
	-- READ FEES FROM FILE
	OPENROWSET (
		'Microsoft.ACE.OLEDB.12.0', 
		'Text;Database=\\SynTempSSIS.aps.edu.actd\Files\TempQuery\;HDR=YES;', 
		'SELECT * from APSDamagedBooks.csv'
		) AS [Damaged]

	-- GET FEE CODES		
	LEFT OUTER JOIN
	@FeeCodes AS [FEECODES_CURRENT]
	ON
	[FEECODES_CURRENT].[FEE_DESCRIPTION] = 'Textbooks Damaged'
	AND LEFT([FEECODES_CURRENT].[FEE_CODE],3) = [Damaged].[CampusID]
	AND 
	-- GET CURRENT SCHOOL YEAR
	[Damaged].[ModifiedDate] BETWEEN [FEECODES_CURRENT].[START_DATE] AND [FEECODES_CURRENT].[END_DATE]
	
	LEFT OUTER JOIN
	@FeeCodes AS [FEECODES_PREVIOUS]
	ON
	[FEECODES_PREVIOUS].[FEE_DESCRIPTION] = 'Textbooks Damaged'
	AND LEFT([FEECODES_PREVIOUS].[FEE_CODE],3) = [Damaged].[CampusID]
	AND 
	-- GET PREVIOUS SCHOOL YEAR WHERE END DATES ARE IN THE SAME YEAR AS THE DATE FROM THE FILE
	([Damaged].[ModifiedDate] > [FEECODES_PREVIOUS].[END_DATE] AND YEAR([Damaged].[ModifiedDate]) = YEAR([FEECODES_PREVIOUS].[END_DATE]))	
	
	-- GET STUDENT GU	
	INNER JOIN
	[rev].[EPC_STU] as [stu]
	ON
	[Damaged].[StudentID]=[stu].[SIS_NUMBER]

	LEFT JOIN
	[rev].[EPC_STU_FEE] AS [fee]
	ON
	CAST([fee].[NOTE] AS VARCHAR(4000))=CAST([Damaged].[ISBN] AS VARCHAR(255))+' '+CAST([Damaged].[Accession] AS VARCHAR(255))+' '+[Damaged].[Title] + ' DMG'
	
WHERE
	[Damaged].[CampusID] IN ('525','540','550','560','570','576','580')
	AND [fee].[STUDENT_FEE_GU] IS NULL
	AND [Damaged].[ModifiedDate] IS NOT NULL
--*/

--ROLLBACK
COMMIT
		
REVERT
GO