USE
db_Logon
GO
--BEGIN TRAN

		   TRUNCATE TABLE EMPLOYEE_FILE
DECLARE @DATE_CREATE AS VARCHAR (10) = (GETDATE())
           Insert into dbo.Employee_File
			  SELECT
			   
			   EMPLOYEE_ID
               ,LOC_NUM
               ,LOC_DESCRIPTION
               ,ACCESS_CODE
               ,FIRST_NAME
               ,LAST_NAME
               ,LAWSON_JOB_TITLE
               ,JOB_TITLE_ABBREVIATION
               ,[GROUPS] AS 'GROUP'
               ,SECURITY_LVL
               ,DATE_CREATE
               ,BIRTHYEAR
               ,EMAIL_ADDRESS
               --,DATE_ASSIGN
FROM
(
SELECT 
	  DISTINCT 
	  ROW_NUMBER () OVER (PARTITION BY [EMPLOYEE_ID] ORDER BY [JOB_TITLE_ABBREVIATION]) AS RN
	  ,[EMPLOYEE_ID]
      ,[LOCATION] AS LOC_NUM
      ,LT.fld_LocDesc AS [LOC_DESCRIPTION]
      ,[ACCESS_CODE]
      ,[FIRST_NAME]
      ,[LAST_NAME]
      ,[LAWSON_JOB_TITLE]
      ,[JOB_TITLE_ABBREVIATION]
      ,PC.[GROUPS] AS GROUPS
      ,CASE
			WHEN RDA LIKE 'RDA%' THEN '2' ELSE PC.[SECURITY_LVL] 
	   END AS 'SECURITY_LVL'
	  ,@DATE_CREATE AS DATE_CREATE
      ,[EMAIL_ADDRESS]
      ,[USER_LEVEL]
      ,BIRTHYEAR
      ,[POSITION]
      ,[END_DATE]
      ,[JOB_CODE]
      ,[RDA]
      ,[DATE_ASSIGN] AS DATE_ASSIGN
  FROM [db_Logon].[dbo].[LAWSON_EMP] AS EMP

  LEFT JOIN
  Positions_Conversion AS PC
  ON PC.ABBREVIATION = EMP.JOB_TITLE_ABBREVIATION

  LEFT JOIN
  Location_Table AS LT
  ON LT.fld_LocNum = EMP.LOCATION
) AS T1
  WHERE RN = 1
  --AND EMPLOYEE_ID = '89408'

  --ROLLBACK