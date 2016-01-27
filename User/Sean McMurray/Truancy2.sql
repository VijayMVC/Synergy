--Created by: e207878/Sean McMurray
--Created on: 1/24/2016
--Purpose: Data extract to pull truancy information
--Note: Need to create function/report

SELECT 
  rev.EPC_STU.SIS_NUMBER AS [Student ID]
  --,TRUANCYLOG.UDTRUANCY_LOG_GU --TAKE THIS OUT!!!!!!!!!!!!  ONLY FOR FINDING STUDENT 186184
  ,CONVERT(VARCHAR(25), TRUANCYLOG.ADD_DATE_TIME_STAMP, 1) AS [Date Added]
  --Jude is going to add a new date field, so if TRUANCYLOG.ADD_Date_Time_Stamp is null, look at this new field
  ,rev.REV_PERSON.LAST_NAME AS [Last Name]
  ,rev.REV_PERSON.FIRST_NAME AS [First Name]
  ,rev.REV_PERSON.MIDDLE_NAME AS [Middle Name]
  ,MOSTRECENTENROLL.GRADE AS [Grade]
  ,MOSTRECENTENROLL.SCHOOL_CODE AS [School Code]
  ,MOSTRECENTENROLL.SCHOOL_NAME AS [School]
  ,CONTACTTYPE.VALUE_DESCRIPTION AS [Contact Type]
  ,CONTACT.VALUE_DESCRIPTION AS [Contact With]
  --Need to trim less so more characters in notes
  ,LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(CAST(TRUANCYLOG.NOTES AS VARCHAR), CHAR(9), ' '), CHAR(13), ' '), CHAR(10), ' '))) AS [Notes]
  ,OUTCOME1.VALUE_DESCRIPTION AS [Outcome]
  ,OUTCOME2.VALUE_DESCRIPTION AS [Outcome 2]
  ,STAFF.VALUE_DESCRIPTION AS [Staff]
  ,TITLE.VALUE_DESCRIPTION AS [Staff Title]  
  ,rev.UD_TRUANT_STUDENT.SCHOOL_YEAR AS [School Year]
  ,MAX(rev.UD_TRUANT_STUDENT.FIVE_DAY_TRUANT) AS [Five Day Truant]
  ,MAX(rev.UD_TRUANT_STUDENT.TEN_DAY_TRUANT) AS [Ten Day Truant]
  ,MAX(rev.UD_TRUANT_STUDENT.TWO_DAY_TRUANT) AS [Two Day Truant]
  ,MOSTRECENTENROLL.LEAVE_DATE AS [Leave Date]
  ,MOSTRECENTENROLL.LEAVE_DESCRIPTION AS [Leave Description]
  
From
  rev.UD_TRUANCY_LOG AS TRUANCYLOG 
  
  INNER JOIN 
  rev.EPC_STU
  ON
  rev.EPC_STU.STUDENT_GU = TRUANCYLOG.STUDENT_GU
  
  INNER JOIN
  rev.REV_PERSON 
  ON 
  rev.EPC_STU.STUDENT_GU = rev.REV_PERSON.PERSON_GU
  
  INNER JOIN
  rev.UD_TRUANT_STUDENT 
  ON 
  rev.EPC_STU.STUDENT_GU = rev.UD_TRUANT_STUDENT.STUDENT_GU
  
  INNER JOIN
  (
  SELECT 
  * 
  FROM (
	  SELECT 
		ROW_NUMBER() OVER (PARTITION BY STU.STUDENT_GU ORDER BY ENTER_DATE DESC, EXCLUDE_ADA_ADM) AS RN
		,GRADE
		,SCHOOL_CODE
		,SCHOOL_NAME
		,STU.STUDENT_GU
		,ENR.LEAVE_DATE
		,ENR.LEAVE_DESCRIPTION
	   FROM 
	   APS.StudentEnrollmentDetails AS ENR

		INNER JOIN
		rev.EPC_STU AS STU
		ON
		ENR.STUDENT_GU = STU.STUDENT_GU
		WHERE
		ENR.EXCLUDE_ADA_ADM IS NULL
		AND ENR.SCHOOL_YEAR = '2015'
		AND ENR.EXTENSION = 'R'
		) AS T1
		WHERE RN = 1
		) AS MOSTRECENTENROLL
		ON
		MOSTRECENTENROLL.STUDENT_GU = rev.EPC_STU.STUDENT_GU

--Lookup Tables
	LEFT JOIN
	APS.LookupTable('Revelation.UD.Truancy','Outcome_1') AS OUTCOME1
	ON
	TRUANCYLOG.OUTCOME_1 = OUTCOME1.VALUE_CODE

	LEFT JOIN
	APS.LookupTable('Revelation.UD.Truancy','Outcome_2') AS OUTCOME2
	ON
	TRUANCYLOG.OUTCOME_2 = OUTCOME2.VALUE_CODE

	LEFT JOIN
	APS.LookupTable('Revelation.UD.Truancy','Truancy_Staff') AS STAFF
	ON
	TRUANCYLOG.TRUANCY_STAFF = STAFF.VALUE_CODE

	LEFT JOIN
	APS.LookupTable('Revelation.UD.Truancy','Truancy_Staff_Title') AS TITLE
	ON
	TRUANCYLOG.TRUANCY_STAFF_TITLE = TITLE.VALUE_CODE

	LEFT JOIN
	APS.LookupTable('revelation.ud.truancy','contact_with') AS CONTACT
	ON
	TRUANCYLOG.CONTACT_WITH = CONTACT.VALUE_CODE

	LEFT JOIN
	APS.LookupTable('revelation.ud.truancy','contact_type') AS CONTACTTYPE
	ON
	TRUANCYLOG.CONTACT_TYPE = CONTACTTYPE.VALUE_CODE

	WHERE 
	TRUANCYLOG.UDTRUANCY_LOG_GU IS NOT NULL

	GROUP BY 
	rev.EPC_STU.SIS_NUMBER 
	  ,TRUANCYLOG.UDTRUANCY_LOG_GU
	  ,TRUANCYLOG.ADD_DATE_TIME_STAMP 
	  ,rev.REV_PERSON.LAST_NAME 
	  ,rev.REV_PERSON.FIRST_NAME 
	  ,rev.REV_PERSON.MIDDLE_NAME 
	  ,MOSTRECENTENROLL.GRADE 
	  ,MOSTRECENTENROLL.SCHOOL_CODE
	  ,MOSTRECENTENROLL.SCHOOL_NAME 
	  ,CONTACTTYPE.VALUE_DESCRIPTION 
	  ,CONTACT.VALUE_DESCRIPTION
	  ,LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(CAST(TRUANCYLOG.NOTES AS VARCHAR), CHAR(9), ' '), CHAR(13), ' '), CHAR(10), ' '))) 
	  ,OUTCOME1.VALUE_DESCRIPTION
	  ,OUTCOME2.VALUE_DESCRIPTION 
	  ,STAFF.VALUE_DESCRIPTION 
	  ,TITLE.VALUE_DESCRIPTION 
	  ,rev.UD_TRUANT_STUDENT.SCHOOL_YEAR
	  ,MOSTRECENTENROLL.LEAVE_DATE
	  ,MOSTRECENTENROLL.LEAVE_DESCRIPTION

	ORDER BY
	SCHOOL_NAME
