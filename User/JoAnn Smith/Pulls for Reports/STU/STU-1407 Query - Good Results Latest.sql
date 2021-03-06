/*
 * Revision 2
 * Last Changed By:    JoAnn Smith
 * Last Changed Date:  1/11/17
 ******************************************************
 This pulls student data for report STU-1407
 ******************************************************
 1-10-2017 Added homeroom teacher

*/
--declare @School uniqueidentifier = 'C1B4D18A-F1A8-47AB-A588-8CC8AF9B1AE6'
--DECLARE @Grade numeric = 11
--declare @Business varchar(1) = 'Y'
--declare @University varchar(1) = 'Y'
--DECLARE @Military varchar(1) = 'Y'

SELECT DISTINCT
       [Student].[FIRST_NAME]
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
       ,[Student].[Parents]
       ,P1.EMAIL AS PARENT_1_EMAIL
       ,P2.EMAIL AS PARENT_2_EMAIL
       ,SCH.[TEACHER NAME]
       ,SCH.[PERIOD_BEGIN]


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

       LEFT JOIN
       (
       SELECT * FROM
       (

       SELECT 
          STUDENT_GU
          ,PARENT_GU
          ,ORDERBY
       FROM
       REV.EPC_STU_PARENT
       ) AS ST
       pivot
       (max(PARENT_GU) FOR ORDERBY IN ([1],[2],[3])) AS UP1
       ) PGU
       ON PGU.STUDENT_GU = STUDENT.STUDENT_GU

       LEFT JOIN
       REV.REV_PERSON AS P1
       ON PGU.[1] = P1.PERSON_GU

       LEFT JOIN
       REV.REV_PERSON AS P2
       ON PGU.[2] = P2.PERSON_GU

WHERE 1 = 1
       AND [Enrollments].[ORGANIZATION_GU] LIKE @School
       AND [Enrollments].[GRADE] LIKE @Grade
     
        --EXCEPTIONS
       AND ([STUDENT_EXCEPTIONS].[EXCLUDE_BUSINESS] IS NULL OR [STUDENT_EXCEPTIONS].[EXCLUDE_BUSINESS] != @Business OR @Business = 'N')
       AND ([STUDENT_EXCEPTIONS].[EXCLUDE_UNIVERSITY] IS NULL OR [STUDENT_EXCEPTIONS].[EXCLUDE_UNIVERSITY] != @University OR @University = 'N')
       AND ([STUDENT_EXCEPTIONS].[EXCLUDE_MILITARY] IS NULL OR [STUDENT_EXCEPTIONS].[EXCLUDE_MILITARY] != @Military OR @Military = 'N')
       
ORDER BY
       [Enrollments].[SCHOOL_NAME]
       ,[Student].[LAST_NAME]