/*
Pull data for for 40-Day Joann Sanchez  ITEM #2
I need the following 40-day files from you:
1.	ALL students enrolled in APS on the 40th day minus the Charter schools
2.	SPED students (only those with Related Services on their IEP) on the 40th day
3.	SPED students (receiving Special Transportation) on the 40th day
*/
--***********************************************************
--total student enrollments from RDAVM/Synergy Data Set 1
; WITH STUDENTCTE 
AS
(
SELECT 
		ROW_NUMBER() over(partition by BS.SIS_NUMBER order by BS.SIS_NUMBER, O.ORGANIZATION_NAME) as RN

		,'2017-2018' AS SCHOOL_YEAR
		,SCH.SCHOOL_CODE
		,O.ORGANIZATION_NAME AS SCHOOL_NAME
		,BS.SIS_NUMBER AS STUDENT_ID
		,BS.LAST_NAME
		,BS.FIRST_NAME
		,BS.MIDDLE_NAME
		,BS.STUDENT_GU
		,BS.BIRTH_DATE
		,[CURRENT GRADE LEVEL] AS GRADE_LEVEL
	FROM
	[RDAVM.APS.EDU.ACTD].[db_STARS_History].[dbo].[STUD_SNAPSHOT]  AS STARS
	LEFT JOIN 
	rev.EPC_SCH AS SCH
	ON
	STARS.[LOCATION CODE] = SCH.STATE_SCHOOL_CODE
	INNER JOIN 
	APS.BasicStudentWithMoreInfo AS BS
	ON
	BS.SIS_NUMBER = [ALTERNATE STUDENT ID]
	LEFT JOIN 
	APS.LookupTable('K12.SpecialEd','DISABILITY_CODE') AS LU
	ON
	LU.VALUE_CODE = BS.PRIMARY_DISABILITY_CODE	
	LEFT JOIN
		REV.REV_ORGANIZATION O
	ON
	O.ORGANIZATION_GU = SCH.ORGANIZATION_GU
	LEFT JOIN 
	rev.EPC_STU_PGM_ELL e
	ON
	E.STUDENT_GU = BS.STUDENT_GU
	left join
	aps.ScheduleDetailsAsOf('2017-10-01') P
	on
	p.SIS_NUMBER = bs.SIS_NUMBER
	left join
	rev.EPC_CRS C
	on
	p.COURSE_GU = c.COURSE_GU
	WHERE
	[Period] = '2017-10-01'
	AND [District Code] = '001'
	AND SPED_STATUS = 'Y'
)
--SELECT * FROM STUDENTCTE where RN = 1 
,Related_Services
as
(SELECT
    	*
FROM
(
    SELECT
		
	   [District CD]
	   ,[School CD]
	   ,[School Name]
	   ,[Student ID]
	   --,[Medicaid ID]
	   ,[Last Name]
	   ,[First Name]
	   ,[Middle Name]
	   ,[DOB (MM/DD/YYYY)]
	   --,'' AS [SSN]
	   ,[Gender CD]
	   ,CONVERT(VARCHAR(10),MAX([IEP Start Date]),101) AS [IEP Start Date]
	   ,CONVERT(VARCHAR(10),MIN([IEP End Date]),101) AS [IEP End Date]
	   ,MAX([Audiology on IEP?]) AS [Audiology on IEP?]
	   ,'' AS [Case Management on IEP?]
	   ,'' AS [Mental Health-Counseling on IEP?]
	   --,MAX([Mental Health-Counseling on IEP?])AS [Mental Health-Counseling on IEP?]
	   ,MAX([Nursing Services on IEP?]) AS [Nursing Services on IEP?]
	   ,'' AS [Nutritional Services on IEP?]
	   ,MAX([Occupational Therapy on IEP?]) AS [Occupational Therapy on IEP?]
	   ,MAX([Physical Therapy on IEP?]) AS [Physical Therapy on IEP?]
	   ,MAX([Speech Therapy on IEP?]) AS [Speech Therapy on IEP?]
	   ,MAX([Special Transportation on IEP?]) AS [Special Transportation on IEP?]
	   ,'' AS [BH-Mental Health Counselor/Therapist on IEP?]
	   ,'' AS [BH-Psychologist on IEP?]
	   ,'' AS [BH-School Psychologist on IEP?]
	   ,MAX([Mental Health-Counseling on IEP?]) AS [BH-Social Worker on IEP?]
    FROM
    (
	   SELECT
		  '01' AS [District CD]
		  ,RIGHT('0000'+[School].[SCHOOL_CODE], 4)  AS [School CD]
		  ,[Org].[ORGANIZATION_NAME] AS [School Name]
		  ,RIGHT('000000000'+[Student].[SIS_NUMBER],9) AS [Student ID]
		  ,NULL AS [Medicaid ID]
		  ,[Person].[LAST_NAME] AS [Last Name]
		  ,[Person].[FIRST_NAME] AS [First Name]
		  ,[Person].[MIDDLE_NAME] AS [Middle Name]
		  ,CONVERT(VARCHAR(10),[Person].[BIRTH_DATE],101) AS [DOB (MM/DD/YYYY)]
		  ,[Person].[GENDER] AS [Gender CD]
		  ,[Address].[ADDRESS] AS [Student Address1]
		  ,[Address].[ADDRESS2] AS [Student Address2]
		  ,[Address].[CITY] AS [City]
		  ,[Address].[STATE] AS [State]
		  ,CASE WHEN [Address].[ZIP_5]='NoZip' THEN '' ELSE COALESCE([Address].[ZIP_5],'87110') END AS [Zip Code]
		  ,[IEPS].[START_DATE] AS [IEP Start Date]
		  ,[IEPS].[END_DATE] AS [IEP End Date]
		  ,[IEPS].[START_DATE] AS [PCP Prescription Start Date]
		  ,[IEPS].[END_DATE] AS [PCP Prescription End Date]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE]='AU' AND [IEPS].[NUM_MINUTES] IS NOT NULL THEN 'Y' ELSE '' END AS [Audiology on IEP?]
		  
		 ,CASE WHEN [SSRV].[STATE_REPORTING_CODE]='SW' AND [IEPS].[NUM_MINUTES] IS NOT NULL THEN 'Y' ELSE '' END AS [Mental Health-Counseling on IEP?]
		  
		  ,CASE WHEN [SSRV].[SERVICE_TYPE]='080' AND [IEPS].[NUM_MINUTES] IS NOT NULL THEN 'Y' ELSE '' END AS [Nursing Services on IEP?]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE]='OT' AND [IEPS].[NUM_MINUTES] IS NOT NULL THEN 'Y' ELSE '' END AS [Occupational Therapy on IEP?]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE]='PT' AND [IEPS].[NUM_MINUTES] IS NOT NULL THEN 'Y' ELSE '' END AS [Physical Therapy on IEP?]
		  ,CASE WHEN ([SSRV].[STATE_REPORTING_CODE] IN ('SS','SO') OR [SSRV].[SERVICE_TYPE]='070') AND [IEPS].[NUM_MINUTES] IS NOT NULL THEN 'Y' ELSE '' END AS [Speech Therapy on IEP?]
		  ,CASE WHEN [AIEP].[SERV_TRANSPORT_YN]='Y' AND [AIEP].[SERV_TRANSPORT_ADULT_YN]='Y' THEN 'Y' ELSE '' END AS [Special Transportation on IEP?]
		  ,CASE 
			 WHEN [Sped].[MEDICAID_CONSENT]='010' THEN 'Y'
			 WHEN [Sped].[MEDICAID_CONSENT]='020' THEN 'N'
			 WHEN [Sped].[MEDICAID_CONSENT]='030' THEN ''
			 WHEN [Sped].[MEDICAID_CONSENT] IS NULL THEN ''
		   END AS [Parent Consent]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE]='AU' THEN COALESCE(CAST(CAST(([IEPS].[NUM_MINUTES]/60) AS NUMERIC(6,2)) AS VARCHAR(10)),'') ELSE '' END AS [AD Hours]
		  
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE]='SW' THEN COALESCE(CAST(CAST(([IEPS].[NUM_MINUTES]/60) AS NUMERIC(6,2)) AS VARCHAR(10)),'') ELSE '' END AS [MHC Hours]
		  
		  ,CASE WHEN [SSRV].[SERVICE_TYPE]='080' THEN COALESCE(CAST(CAST(([IEPS].[NUM_MINUTES]/60) AS NUMERIC(6,2)) AS VARCHAR(10)),'') ELSE '' END AS [NURS Hours]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE]='OT' THEN COALESCE(CAST(CAST(([IEPS].[NUM_MINUTES]/60) AS NUMERIC(6,2)) AS VARCHAR(10)),'') ELSE '' END AS [OT Hours]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE]='PT' THEN COALESCE(CAST(CAST(([IEPS].[NUM_MINUTES]/60) AS NUMERIC(6,2)) AS VARCHAR(10)),'') ELSE '' END AS [PT Hours]
		  ,CASE WHEN ([SSRV].[STATE_REPORTING_CODE] IN ('SS','SO') OR [SSRV].[SERVICE_TYPE]='070') THEN COALESCE(CAST(CAST(([IEPS].[NUM_MINUTES]/60) AS NUMERIC(6,2)) AS VARCHAR(10)),'') ELSE '' END AS [SP Hours]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE]='AU' THEN [Freq].[VALUE_DESCRIPTION] ELSE '' END AS [AD Frequency]

		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE]='SW' THEN [Freq].[VALUE_DESCRIPTION] ELSE '' END AS [MHC Frequency]
		  
		  ,CASE WHEN [SSRV].[SERVICE_TYPE]='080' THEN [Freq].[VALUE_DESCRIPTION] ELSE '' END AS [NURS Frequency]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE]='OT' THEN [Freq].[VALUE_DESCRIPTION] ELSE '' END AS [OT Frequency]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE]='PT' THEN [Freq].[VALUE_DESCRIPTION] ELSE '' END AS [PT Frequency]
		  ,CASE WHEN ([SSRV].[STATE_REPORTING_CODE] IN ('SS','SO') OR [SSRV].[SERVICE_TYPE]='070') THEN [Freq].[VALUE_DESCRIPTION] ELSE '' END AS [SP Frequency]
		  ,CASE 
			 WHEN (SELECT TOP 1 [P].[PHONE] FROM [rev].[REV_PERSON_PHONE] AS [P] WHERE [Student].[STUDENT_GU]=[P].[PERSON_GU] AND [P].[PHONE_TYPE]='H') IS NULL THEN '' 
			 WHEN LEN((SELECT TOP 1 [P].[PHONE] FROM [rev].[REV_PERSON_PHONE] AS [P] WHERE [Student].[STUDENT_GU]=[P].[PERSON_GU] AND [P].[PHONE_TYPE]='H'))<10 THEN '505'+(SELECT TOP 1 [P].[PHONE] FROM [rev].[REV_PERSON_PHONE] AS [P] WHERE [Student].[STUDENT_GU]=[P].[PERSON_GU] AND [P].[PHONE_TYPE]='H')
			 ELSE (SELECT TOP 1 [P].[PHONE] FROM [rev].[REV_PERSON_PHONE] AS [P] WHERE [Student].[STUDENT_GU]=[P].[PERSON_GU] AND [P].[PHONE_TYPE]='H') 
		   END AS [Phone Nbr]
		   ,IEP_STATUS
	   ,[SEC_SRV_SHOW]

	   FROM
		  [rev].[EP_STUDENT_SPECIAL_ED] AS [Sped]

		  INNER JOIN
		  [rev].[EPC_STU] AS [Student]
		  ON
		  [Sped].[STUDENT_GU]=[Student].[STUDENT_GU]

		  INNER JOIN
		  [rev].[REV_PERSON] AS [Person]
		  ON
		  [Student].[STUDENT_GU]=[Person].[PERSON_GU]

		  INNER JOIN 
		  (
			 SELECT
				SSY.*
				,ROW_NUMBER() OVER (PARTITION BY STUDENT_GU ORDER BY ENTER_DATE DESC) AS [RN]
			 FROM
				[rev].[EPC_STU_SCH_YR] AS SSY
				INNER JOIN 
				REV.REV_YEAR AS YRS
				ON
				SSY.YEAR_GU = YRS.YEAR_GU
				AND YRS.YEAR_GU IN (SELECT * FROM REV.SIF_22_Common_CurrentYearGU) 
			 WHERE
				[EXCLUDE_ADA_ADM] IS NULL
				AND ([LEAVE_DATE] IS NULL
				OR [LEAVE_DATE]<=GETDATE())
		  ) AS [SSY]
		  ON
		  [Student].[STUDENT_GU]=[SSY].[STUDENT_GU]
		  AND [SSY].[RN]=1
    
		  INNER JOIN
		  [rev].[REV_ORGANIZATION_YEAR] AS [OrgYear]
		  ON
		  [SSY].[ORGANIZATION_YEAR_GU]=[OrgYear].[ORGANIZATION_YEAR_GU]

		  INNER JOIN
		  [rev].[REV_ORGANIZATION] AS [Org]
		  ON
		  [OrgYear].[ORGANIZATION_GU]=[Org].[ORGANIZATION_GU]

		  INNER JOIN
		  [rev].[EPC_SCH] AS [School]
		  ON
		  [Org].[ORGANIZATION_GU]=[School].[ORGANIZATION_GU]

		  INNER JOIN
		  [rev].[EP_STUDENT_IEP] AS [IEP]
		  ON
		  [Sped].[STUDENT_GU]=[IEP].[STUDENT_GU]

		  INNER JOIN
		  [rev].[EP_STU_IEP_SERVICE] AS [IEPS]
		  ON
		  [IEP].[IEP_GU]=[IEPS].[IEP_GU]
    
		  INNER JOIN
		  [rev].[EP_SPECIAL_ED_SERVICE] AS [ISRV]
		  ON
		  [ieps].[SERVICE_GU]=[isrv].[SERVICE_GU]

		  LEFT JOIN
		  [APS].[LookupTable]('K12.SpecialEd.IEP','SERVICE_FREQUENCY') AS [Freq]
		  ON
		  [IEPS].[FREQUENCY_UNIT_DD]=[Freq].[VALUE_CODE]

		  LEFT JOIN
		  [rev].[REV_ADDRESS] AS [Address]
		  ON
		  [Person].[HOME_ADDRESS_GU]=[Address].[ADDRESS_GU]

		  LEFT JOIN
		  [rev].[EP_AZ_STUDENT_IEP] AS [AIEP]
		  ON
		  [IEP].[IEP_GU]=[AIEP].[IEP_GU]
		  AND [IEP].[NEXT_IEP_DATE]>=GETDATE()

		  INNER JOIN 
		  [rev].[EP_SPECIAL_ED_SERVICE] AS [SSRV]
		  ON
		  [IEPS].[SERVICE_GU]=[SSRV].[SERVICE_GU]
		  AND (SSRV.STATE_REPORTING_CODE IS NOT NULL OR SSRV.SERVICE_DESCRIPTION = 'Related Service School Health'
		  OR SSRV.SERVICE_DESCRIPTION = 'SE SLP-only')

		  LEFT JOIN
		  [rev].[EP_AZ_IEP_LRE] AS [LRE]
		  ON
		  [IEP].[IEP_GU]=[LRE].[IEP_GU]

       WHERE
		  [IEP].[IEP_STATUS]='CU'
		  AND [IEP].[IEP_VALID]='Y'
		  --AND [IEPS].[START_DATE] > '20150101'
		  AND ([LRE].[SEC_SRV_SHOW]='N' OR [LRE].[SEC_SRV_SHOW] IS NULL)

    ) AS [IEP]

    GROUP BY
		
		IEP_STATUS
	   ,[SEC_SRV_SHOW]
	   ,[District CD]
	   ,[School CD]
	   ,[School Name]
	   ,[Student ID]
	   ,[Medicaid ID]
	   ,[Last Name]
	   ,[First Name]
	   ,[Middle Name]
	   ,[DOB (MM/DD/YYYY)]
	   ,[Gender CD]
	   ,[Student Address1]
	   ,[Student Address2]
	   ,[City]
	   ,[State]
	   ,[Zip Code]
	   /*,[IEP Start Date]
	   ,[IEP End Date]
	   ,[PCP Prescription Start Date]
	   ,[PCP Prescription End Date]*/
	   ,[Phone Nbr]
) AS [IEP]

WHERE
    'Y' IN (
		  [Audiology on IEP?]
		  ,[Case Management on IEP?]
		  ,[BH-Social Worker on IEP?]
		  ,[Nursing Services on IEP?]
		  ,[Nutritional Services on IEP?]
		  ,[Occupational Therapy on IEP?]
		  ,[Physical Therapy on IEP?]
		  ,[Speech Therapy on IEP?])
)
,Results
as
(
select
	ROW_NUMBER() over (partition by s.STUDENT_ID order by s.STUDENT_ID, SCHOOL_NAME) AS rn, 
	s.SCHOOL_YEAR,
	s.SCHOOL_CODE,
	s.SCHOOL_NAME,
	s.STUDENT_ID,
	s.LAST_NAME,
	s.FIRST_NAME,
	s.MIDDLE_NAME,
	s.BIRTH_DATE,
	s.GRADE_LEVEL,
	r.[Audiology on IEP?],
	r.[BH-Mental Health Counselor/Therapist on IEP?],
	r.[BH-Psychologist on IEP?],
	r.[BH-School Psychologist on IEP?],
	r.[BH-Social Worker on IEP?],
	r.[Case Management on IEP?],
	r.[Nursing Services on IEP?],
	r.[Nutritional Services on IEP?],
	r.[Occupational Therapy on IEP?],
	r.[Physical Therapy on IEP?],
	r.[Special Transportation on IEP?],
	r.[Speech Therapy on IEP?]
from
	STUDENTCTE s
left join
	Related_Services r
on
	s.STUDENT_ID = r.[Student ID]
)
select * from Results where rn = 1 and     'Y' IN (
		  [Audiology on IEP?]
		  ,[Case Management on IEP?]
		  ,[BH-Social Worker on IEP?]
		  ,[Nursing Services on IEP?]
		  ,[Nutritional Services on IEP?]
		  ,[Occupational Therapy on IEP?]
		  ,[Physical Therapy on IEP?]
		  ,[Speech Therapy on IEP?])


