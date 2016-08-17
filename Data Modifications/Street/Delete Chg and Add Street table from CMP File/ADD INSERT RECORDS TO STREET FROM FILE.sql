EXECUTE AS LOGIN='QueryFileUser'
GO

/**********************************************************************************

	FIRST REPLACE THE .CSV FILE 
	
	MAKE SURE COLUMN HEADINGS MATCH THE FIELDS IN EPC_STREET

	RUN ON ROLLBACK - MAKE SURE COUNTS ARE THE SAME AND GRID_CODE LOOKS GOOD 
	(IF GRID CODE NOT FOUND, OUT OF DISTRICT WILL BE USED)


***********************************************************************************/


BEGIN TRANSACTION 

INSERT rev.EPC_STREET

([STREET_GU]  
,[STREET_NAME]  ,[STREET_LOW_ADDRESS]  ,[STREET_HIGH_ADDRESS] ,[STREET_INC_ADDRESS] ,[STREET_ODD_EVEN]
      ,[STREET_DIRECTION] ,[STREET_POST_DIRECTION]  ,[STREET_TYPE]  ,[USE_STREET_TYPE]  ,[IS_PO_BOX]  ,[GRID_GU]
      ,[SCHOOL_YEAR] ,[CITY] ,[STATE] ,[ZIP_CODE] ,[ZIP_5] ,[ZIP_4],[CHANGE_ID_STAMP] ,[CHANGE_DATE_TIME_STAMP]
      ,[ADD_ID_STAMP] ,[ADD_DATE_TIME_STAMP] ,[STREET_SUPPLEMENT] )


SELECT 
NEWID() AS STREET_GU
, T1.STREET_NAME AS STREET_NAME
, CASE WHEN CAST(T1.STREET_LOW_ADDRESS AS INT) IS NULL THEN dbo.udf_GetNumeric(T1.STREET_NAME) ELSE CAST(T1.STREET_LOW_ADDRESS AS INT) END AS STREET_LOW_ADDRESS
, CASE WHEN CAST(T1.STREET_LOW_ADDRESS AS INT) IS NULL THEN dbo.udf_GetNumeric(T1.STREET_NAME) ELSE CAST(T1.STREET_LOW_ADDRESS AS INT) END AS STREET_HIGH_ADDRESS
,1 AS STREET_INC_ADDRESS
, NULL AS STREET_ODD_EVEN
, NULL AS STREET_DIRECTION 
,CASE WHEN T1.STREET_POST_DIRECTION = 'OUT OF DST' THEN NULL ELSE T1.STREET_POST_DIRECTION END AS STREET_POST_DIRECTION
,LU.VALUE_CODE AS STREET_TYPE
,'Y' AS [USE_STREET_TYPE]
,'N' AS IS_PO_BOX
,CASE WHEN GRD.GRID_GU IS NULL THEN '8CBEC487-6ECF-42C6-A57C-C3EC344EF2BA' ELSE GRD.GRID_GU END AS GRID_GU
,2016 AS SCHOOL_YEAR
,T1.CITY AS CITY
,T1.[STATE] AS STATE
,NULL AS ZIP_CODE
,T1.ZIP_5 AS ZIP_5
,NULL AS ZIP_4
,NULL AS CHANGE_ID_STAMP
,NULL AS CHANGE_DATE_TIME_STAMP
,'27CDCD0E-BF93-4071-94B2-5DB792BB735F' AS ADD_ID_STAMP
,GETDATE() AS ADD_DATE_TIME_STAMP
,NULL AS STREET_SUPPLEMENT


	FROM
            OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                 'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
                  'SELECT * from ADDCMP112.csv'
                ) AS [T1]

LEFT JOIN 
rev.EPC_GRID AS GRD
ON
CAST(T1.GridCode AS VARCHAR) = GRD.GRID_CODE
AND GRD.SCHOOL_YEAR = 2016

LEFT JOIN 
	 [APS].[LookupTable]('K12.AddressInfo','STREET_TYPE') AS LU
	 ON
	 LU.VALUE_DESCRIPTION = T1.[STREET_TYPE] 


SELECT SEEME.GRID_CODE, SEE.* FROM 
rev.EPC_STREET AS SEE
INNER JOIN 
rev.EPC_GRID AS SEEME
ON
SEE.GRID_GU = SEEME.GRID_GU
WHERE
SEE.ADD_ID_STAMP = '27CDCD0E-BF93-4071-94B2-5DB792BB735F' 
AND SEE.ADD_DATE_TIME_STAMP >= GETDATE()


ROLLBACK


REVERT
GO
