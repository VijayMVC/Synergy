


SELECT
      [STUDENT].[SIS_NUMBER]
      ,[STUDENT].[STATE_STUDENT_NUMBER]
      ,[STUDENT].[FIRST_NAME]
      ,[STUDENT].[LAST_NAME]
      ,[STUDENT].[MIDDLE_NAME]
      ,[STUDENT].[GENDER]
      ,[ENROLLMENT].[SCHOOL_CODE]
      ,[ENROLLMENT].[SCHOOL_NAME]
      ,[ENROLLMENT].[SCHOOL_YEAR]
      ,[ENROLLMENT].[EXTENSION]
      ,[ENROLLMENT].[GRADE]
      ,[ENROLLMENT].[SUMMER_WITHDRAWL_CODE]
      ,[ENROLLMENT].[YEAR_END_STATUS]
      ,[ENROLLMENT].[EXCLUDE_ADA_ADM]
      ,[ENROLLMENT].[CONCURRENT]
      ,[ENROLLMENT].[ACCESS_504]
      ,[ENROLLMENT].[ENTER_DATE]
      ,[ENROLLMENT].[ENTER_CODE]
      ,[ENTER_CODE].[ALT_CODE_2]
      ,[ENROLLMENT].[LEAVE_DATE]
      ,[ENROLLMENT].[LEAVE_CODE]
      ,[LEAVE_CODE].[ALT_CODE_2] AS [STATE_CODE]
      ,[StudentSchoolYear].[ENR_USER_DD_4] AS [HOME/CHARTER]
      
      --,[LEAVE_CODE].*
      
FROM
	APS.StudentEnrollmentDetails AS [ENROLLMENT]

	INNER JOIN
	rev.EPC_STU_SCH_YR AS [StudentSchoolYear]
	ON
	[ENROLLMENT].[STUDENT_SCHOOL_YEAR_GU] = [StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU]

	INNER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	[ENROLLMENT].[STUDENT_GU] = [STUDENT].[STUDENT_GU]

	LEFT OUTER JOIN
	APS.LookupTable('K12.ENROLLMENT','LEAVE_CODE') AS [LEAVE_CODE]
	ON
	[ENROLLMENT].[LEAVE_CODE] = [LEAVE_CODE].[VALUE_CODE]
	
	LEFT OUTER JOIN
	APS.LookupTable('K12.ENROLLMENT','ENTER_CODE') AS [ENTER_CODE]
	ON
	[ENROLLMENT].[ENTER_CODE] = [ENTER_CODE].[VALUE_CODE]
      
WHERE
      --[ENROLLMENT].[SCHOOL_YEAR] = '2014'
      --AND [ENROLLMENT].[EXTENSION] = 'R'
      [ENROLLMENT].[ENTER_DATE] BETWEEN '05/23/2014' AND '05/22/2015'
      
      --AND [ENR_USER_DD_4] IS NOT NULL
