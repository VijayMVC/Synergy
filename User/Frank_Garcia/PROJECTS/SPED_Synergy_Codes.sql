/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [ApsLocNumber]
      ,[State_Location_Code]
      ,[APS_Stu_ID]
      ,[State_ID]
      ,[LAST NAME]
      ,[FIRST NAME]
      ,[APS_Grade]
      ,[State_GRADE]
      ,[GIFTED]
      ,[SPECIAL EDUCATION]
      ,[11_Primary_Disability]
      ,[12_Secondary_Disability]
      ,[13_Last_IEP_Date]
      ,[14_Last_Evaluation_Date]
      ,[LEVEL OF INTEGRATION]
      ,[44_Primary_Setting]
      ,[21_Expected_Diploma_Type]
      ,[38_Dis_Primary_Cause]
      ,[45_Transition_IEP_Status]
      ,[59_Primary_Exceptionality]
      ,[EXPECTED GRADUATION TIMEFRAME]
      ,[SPECIAL EDUCATION TRANSITION]
      ,[28_ESY]
      ,[42_Tert_Disability]
      ,[43_Quart_Disability]
      ,[Caseload_Teacher_ID]
      ,SYNERGY_CODE_NUMBER = 
      CASE
		WHEN [SPECIAL EDUCATION] = 'Y' AND GIFTED = 'N' AND [59_Primary_Exceptionality] = 'SE' THEN '1'
		WHEN [SPECIAL EDUCATION] = 'N' AND GIFTED = 'Y' AND [59_Primary_Exceptionality] = 'G' THEN '2'
		WHEN [SPECIAL EDUCATION] = 'Y' AND GIFTED = 'Y' AND [59_Primary_Exceptionality] = 'SE' THEN '4'
		WHEN [SPECIAL EDUCATION] = 'Y' AND GIFTED = 'Y' AND [59_Primary_Exceptionality] = 'G' THEN '5'
		
		
	 END	
      ,SYNERGY_CODE_TEXT = 
      CASE
		WHEN [SPECIAL EDUCATION] = 'Y' AND GIFTED = 'N' AND [59_Primary_Exceptionality] = 'SE' THEN 'SPED Only'
		WHEN [SPECIAL EDUCATION] = 'N' AND GIFTED = 'Y' AND [59_Primary_Exceptionality] = 'G' THEN 'Gifted Only'
		WHEN [SPECIAL EDUCATION] = 'Y' AND GIFTED = 'Y' AND [59_Primary_Exceptionality] = 'SE' THEN 'SPED Primary, Gifted Secondary'
		WHEN [SPECIAL EDUCATION] = 'Y' AND GIFTED = 'Y' AND [59_Primary_Exceptionality] = 'G' THEN 'Gifted Primary, SPED Secondary'
		
		
	 END		
	 	
      ,[Column 27]
      ,[Column 28]
      ,[Column 29]
  FROM [SchoolNet].[dbo].[SPED_Data_1 13 14 (2)]