USE [ST_Production]
GO

/****** Object:  View [APS].[ExtendedStudentInformation]    Script Date: 3/31/2017 2:22:42 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







alter VIEW [APS].[ExtendedStudentInformation] AS



SELECT 
	StudentCTE.STUDENT_GU
	,StudentCTE.ORGANIZATION_GU
	,StudentCTE.SCHOOL_NAME
	,StudentCTE.SCHOOL_CODE
	,StudentCTE.GRADE_LEVEL
	,StudentCTE.FIRST_NAME + ' ' + STUDENTCTE.LAST_NAME AS [STUDENT_NAME]
	,StudentCTE.SIS_NUMBER
	,STUDENTCTE.BIRTH_DATE
	,StudentCTE.GENDER
	,StudentCTE.RESOLVED_RACE
	,StudentCTE.ELL_STATUS
	,StudentCTE.SPED_STATUS
	,StudentCTE.CLASS_OF
	,StudentCTE.TEACHER_NAME
	,StudentCTE.[ADDRESS]
	,StudentCTE.CITY
	,StudentCTE.[STATE]
	,StudentCTE.[ZIP]
	,StudentCTE.CONTACT_LANGUAGE
	,StudentCTE.PRIMARY_PHONE
	,StudentCTE.STUDENT_EMAIL
	,StudentCTE.EXCLUDE_BUSINESS
	,StudentCTE.EXCLUDE_MILITARY
	,StudentCTE.EXCLUDE_UNIVERSITY
	, PARENTS.P1GU
	, P1FN + ' ' + P1LN AS [PARENT1_NAME]
	, P1TYPE
	, P1EMAIL
	, P1PHONE
	, P2GU
	, P2FN + ' ' + P2LN AS [PARENT2_NAME]
	, P2TYPE
	, P2PHONE
	, P2EMAIL
	, P3GU
	, P3FN + P3LN AS [PARENT3_NAME]
	, P3TYPE
	, P3EMAIL
	, P3PHONE

 FROM 
(
select
		ROW_NUMBER() OVER (PARTITION BY Student.SIS_NUMBER ORDER BY Student.SIS_NUMBER) AS ROWNUM
		,[Student].[STUDENT_GU]
	   ,[Enrollments].ORGANIZATION_GU AS [ORGANIZATION_GU]
       ,[Student].[FIRST_NAME]
       ,[Student].[LAST_NAME]
       ,[Student].[MIDDLE_NAME]
       ,[Student].[SIS_NUMBER]
       ,[Student].[ELL_STATUS]
       ,[Student].[SPED_STATUS]
       ,[Student].[CONTACT_LANGUAGE]
       ,[Student].[GENDER]
       ,Student.RESOLVED_RACE          
       ,[Student].[CLASS_OF]
       ,CONVERT(VARCHAR(10),[Student].[BIRTH_DATE],101) AS [BIRTH_DATE]
       ,[Enrollments].[GRADE] AS [GRADE_LEVEL]
		,[Enrollments].[SCHOOL_NAME]
		,[Enrollments].[SCHOOL_CODE]
       ,CASE WHEN [Student].[MAIL_ADDRESS] IS NULL THEN [Student].[HOME_ADDRESS] ELSE [Student].[MAIL_ADDRESS] END AS [ADDRESS]
		,CASE WHEN [Student].[MAIL_ADDRESS] IS NULL THEN [Student].[HOME_ADDRESS_2] ELSE [Student].[MAIL_ADDRESS_2] END AS [ADDRESS_2]
		,CASE WHEN [Student].[MAIL_CITY] IS NULL THEN [Student].[HOME_CITY] ELSE [Student].[MAIL_CITY] END AS [CITY]
		,CASE WHEN [Student].[MAIL_STATE] IS NULL THEN [Student].[HOME_STATE] ELSE [Student].[MAIL_STATE] END AS [STATE]
		,CASE WHEN [Student].[MAIL_ZIP] IS NULL THEN [Student].[HOME_ZIP] ELSE [Student].[MAIL_ZIP] END AS [ZIP]
       ,PER.EMAIL AS STUDENT_EMAIL
       ,[Student].[PRIMARY_PHONE]
       ,SCH.[TEACHER NAME] AS TEACHER_NAME
       ,SCH.[PERIOD_BEGIN]
	   ,STUDENT_EXCEPTIONS.EXCLUDE_BUSINESS
	   ,STUDENT_EXCEPTIONS.EXCLUDE_MILITARY
	   ,STUDENT_EXCEPTIONS.EXCLUDE_UNIVERSITY

FROM
       APS.PrimaryEnrollmentDetailsAsOf(getdate()) AS [Enrollments]
       
       INNER JOIN
       APS.BasicStudentWithMoreInfo AS [Student] 
       ON
       [Enrollments].[STUDENT_GU] = [Student].[STUDENT_GU]
 
       LEFT JOIN
       rev.[UD_STU] AS [STUDENT_EXCEPTIONS]
       ON
       [Student].[STUDENT_GU] = [STUDENT_EXCEPTIONS].[STUDENT_GU]

       INNER JOIN
       REV.REV_PERSON AS PER
       ON STUDENT.STUDENT_GU = PER.PERSON_GU

       INNER join 
       aps.scheduledetailsasof(getdate()) as SCH
       on sch.STUDENT_GU = student.STUDENT_GU

	   
		inner join
		aps.TermDatesAsOf(getdate()) TDA on TDA.OrgYearGU = Enrollments.ORGANIZATION_YEAR_GU
				and tda.TermCode = SCH.Term_code

          
       inner join
       rev.epc_sch_yr_opt OPT
       ON OPT.HOMEROOM_PERIOD = SCH.PERIOD_BEGIN
          AND OPT.ORGANIZATION_YEAR_GU = Enrollments.ORGANIZATION_YEAR_GU  

)  AS StudentCTE    

INNER JOIN 
(
 SELECT 
	STUDENT_GU
	,MAX(CASE WHEN RN = 1 THEN PARENT_GU END) AS P1GU
	,MAX(CASE WHEN RN = 1 THEN LAST_NAME END) AS P1LN
	,MAX(CASE WHEN RN = 1 THEN FIRST_NAME END) AS P1FN
	,MAX(CASE WHEN RN = 1 THEN VALUE_DESCRIPTION END) AS P1TYPE
	,MAX(CASE WHEN RN = 1 THEN EMAIL END) AS P1EMAIL
	,MAX(CASE WHEN RN = 1 THEN PRIMARY_PHONE END) AS P1PHONE
	,MAX(CASE WHEN RN = 2 THEN PARENT_GU END) AS P2GU
	,MAX(CASE WHEN RN = 2 THEN LAST_NAME END) AS P2LN
	,MAX(CASE WHEN RN = 2 THEN FIRST_NAME END) AS P2FN
	,MAX(CASE WHEN RN = 2 THEN VALUE_DESCRIPTION END) AS P2TYPE
	,MAX(CASE WHEN RN = 2 THEN PRIMARY_PHONE END) AS P2PHONE
	,MAX(CASE WHEN RN = 2 THEN EMAIL END) AS P2EMAIL
	,MAX(CASE WHEN RN = 3 THEN PARENT_GU END) AS P3GU
	,MAX(CASE WHEN RN = 3 THEN LAST_NAME END) AS P3LN
	,MAX(CASE WHEN RN = 3 THEN FIRST_NAME END) AS P3FN
	,MAX(CASE WHEN RN = 3 THEN VALUE_DESCRIPTION END) AS P3TYPE
	,MAX(CASE WHEN RN = 3 THEN EMAIL END) AS P3EMAIL
	,MAX(CASE WHEN RN = 3 THEN PRIMARY_PHONE END) AS P3PHONE


  FROM
       (
       SELECT 
          STUDENT_GU
          ,PARENT_GU
		  ,PER.LAST_NAME
		  ,PER.FIRST_NAME
		  ,PER.EMAIL
		  ,PER.PRIMARY_PHONE
          ,ORDERBY
		  ,VALUE_DESCRIPTION
		  ,ROW_NUMBER() OVER (PARTITION BY STUDENT_GU ORDER BY ORDERBY ) AS RN
       FROM
       REV.EPC_STU_PARENT AS PAR
	   INNER JOIN 
	   APS.LookupTable('K12','RELATION_TYPE') AS LU
	   ON
	   PAR.RELATION_TYPE = LU.VALUE_CODE
	   INNER JOIN
	   REV.REV_PERSON PER
	   ON
	   PARENT_GU = PER.PERSON_GU
       ) AS ST
       
	  GROUP BY STUDENT_GU
	
) AS PARENTS

ON 
PARENTS.STUDENT_GU = StudentCTE.STUDENT_GU




GO


