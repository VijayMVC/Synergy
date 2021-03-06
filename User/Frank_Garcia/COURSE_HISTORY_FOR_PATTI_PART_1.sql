/****
 
 * $LastChangedBy: Frank Garcia
 * $LastChangedDate: 09/21/2016 $
 *
 * Request By: ANDY FOR PATTIN
 * InitialRequestDate: Monday, September 19, 2016 10:00 AM
 * 
 * Initial Request:
 * Frank – please work on this request below for Patti when you return tomorrow.  
 * The first pull will be from Course History looking for any transcript entry with the course numbers she has provided.  
 * Please pull a file with the data she requests after the list of courses below.  
 * For Part 2, you will need to look at current SY schedules (SchedulesAsOf) to pull another file of these 
 * students with the same detail minus the grade but please also include section number and term code.  Thanks -Andy
 * 
	
****/
--SELECT
--	 SY
--	,[SCHOOL LOCATION]
--	,[COURSE NUMBER]
--	,[COURSE NAME]
--	,COUNT (ID) AS 'COUNT OF STUDENTS TOOK'
--FROM
--(
SELECT 
	  --DISTINCT
	  CRSH.SCHOOL_YEAR AS SY
	  ,CASE WHEN ORG.ORGANIZATION_NAME IS NULL THEN SCHN.NAME
	  ELSE ORG.ORGANIZATION_NAME
	  END AS 'SCHOOL LOCATION'
	  ,CRSH.COURSE_ID AS 'COURSE NUMBER'
	  ,CRSH.COURSE_TITLE AS 'COURSE NAME'
	  ,PER.LAST_NAME +', '+PER.FIRST_NAME AS 'STUDENT NAME'
	  ,STU.SIS_NUMBER AS 'ID'
	  ,GRADE.VALUE_DESCRIPTION AS 'GRADE LEVEL'
	  ,CRSH.MARK AS 'GRADE MARK'
	  --,[STU_COURSE_HISTORY_GU]
   --   ,CRSH.[STUDENT_GU]
   --   ,CRSH.[COURSE_GU]
   --   ,CRSH.[COURSE_ID]
   --   ,CRSH.[COURSE_TITLE]
   --   ,[CALENDAR_MONTH]
   --   ,[CALENDAR_YEAR]
   --   ,CRSH.[SCHOOL_YEAR]
   --   ,[YEAR_TYPE_TITLE]
   --   ,[TEACHER_NAME]
   --   ,[SCHOOL_IN_DISTRICT_GU]
   --   ,[SCHOOL_NON_DISTRICT_GU]
   --   ,[ATTENDANCE_TOTAL1]
   --   ,[ATTENDANCE_TOTAL2]
   --   ,CRSH.[REPEAT_TAG_GU]
   --   ,CRSH.[TERM_CODE]
   --   ,[CREDIT_ATTEMPTED]
   --   ,[CREDIT_COMPLETED]
   --   ,[MARK]
   --   ,[NUMERIC_MARK]
   --   ,CRSH.[GRADE]
   --   ,[STU_SCHOOL_YEAR_GRD_PRD_MK_GU]
   --   ,[CLASS_BEGIN_DATE]
   --   ,[CLASS_END_DATE]
   --   ,[CONDUCT]
   --   ,[COURSE_WORK_TYPE]
   --   --,[COURSE_HISTORY_TYPE]
   --   ,[STU_ALC_SUM_GU]
   --   ,CRSH.[CHANGE_DATE_TIME_STAMP]
   --   ,CRSH.[CHANGE_ID_STAMP]
   --   ,CRSH.[ADD_DATE_TIME_STAMP]
   --   ,CRSH.[ADD_ID_STAMP]
   --   ,[VC1_TYPE]
   --   ,[VC1_NOTE]
   --   ,[VC2_TYPE]
   --   ,[VC2_NOTE]
   --   ,[EFFORT]
   --   ,[SCH_ATT_HIST_GU]
   --   ,[STU_SCH_ATT_HIST_GU]
   --   --,[AUDIT_CLASS]
   --   ,[CP_TSA_PROFICIENCY]
   --   ,[TERM_CODE_ACTUAL]
   --   ,[VC1_AWARD_TST_GRP_GU]
   --   ,[VC2_AWARD_TST_GRP_GU]
   --   ,[SUBSTITUTE_CREDIT_REASON]
   --   --,[COLLEGE_CODE]
   --   --,[COLLEGE_COURSE_CODE]
   --   --,[COLLEGE_COURSE_TITLE]
   --   ,[COLLEGE_CREDIT_EARNED]
   --   ,[TEACHER_ID]
   --   --,[MODIFIED]
   --   --,[INSTRUCTIONAL_METHOD]
   --   --,[RIGOR_POINT]
   --   ,[TEACHER_STATE_ID]
   --   ,CRSH.[TECH_PREP_STATUS]
   --   --,[SECTION_ID]
   --   ,[CLASS_PERIOD]
  FROM [ST_Production].[rev].[EPC_STU_CRS_HIS] AS CRSH
  LEFT JOIN
  REV.EPC_STU AS STU
  ON CRSH.STUDENT_GU = STU.STUDENT_GU
  LEFT JOIN
  REV.REV_PERSON AS PER
  ON PER.PERSON_GU = STU.STUDENT_GU
  LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') grade 
  ON grade.VALUE_CODE = CRSH.GRADE

  LEFT JOIN
  REV.REV_ORGANIZATION AS ORG
  ON CRSH.SCHOOL_IN_DISTRICT_GU = ORG.ORGANIZATION_GU

  LEFT JOIN
  REV.EPC_SCH_NON_DST AS SCHN
  ON SCHN.SCHOOL_NON_DISTRICT_GU = CRSH.SCHOOL_NON_DISTRICT_GU
  WHERE 
  1 = 1
  AND CRSH.COURSE_ID IN ('205751','205752','215361','215362','215371','215372','515041','515042','51504c','515071','515072','afst1150','amst183','amst185','amst186','CCS201')
  AND ORGANIZATION_NAME IS NOT NULL

--) AS T1

--GROUP BY SY, [SCHOOL LOCATION], [COURSE NUMBER], [COURSE NAME]

  ORDER BY SY, [SCHOOL LOCATION]
