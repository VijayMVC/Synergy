/*
Written by:  JoAnn Smith
Date Written: June 20, 2017

This script combines information on students to include parent emails,
parent relationship, parent phones as well as basic student information.
It also includes exceptions for each student (EXCLUDE_MILITARY, EXCLUDE_BUSINESS,
EXCLUDE_UNIVERSITY). 

Andy wanted a way to run this report for two scenarios:
1.  Filter by exception code
2.  Ignore exception code and provide all students regardless of exception

The way I did this was with GOTO statements.  Branch One excecutes the
first one, and branch two executes the second.
*/

/* FOR TESTING PURPOSES
--declare @Year uniqueidentifier = 'F7D112F7-354D-4630-A4BC-65F586BA42EC'
--declare @School uniqueidentifier = 'D5A94E6F-8232-4BF8-AEBF-9A7DB98A91A3'
--declare @grade nvarchar(2) = '%'
--declare @DNE nvarchar(100) = 'EXCLUDE_MILITARY'
*/

BEGIN
	IF @DNE = 'EXCLUDE_BUSINESS' OR @DNE = 'EXCLUDE_MILITARY' OR @DNE = 'EXCLUDE_UNIVERSITY' GOTO Branch_One
	IF @DNE = 'ALL' GOTO Branch_Two

Branch_One:
;with StudentCTE
as
(
select	
	en.ENTER_DATE,
	en.LEAVE_DATE,
	case
	when en.EXCLUDE_ADA_ADM = 1 then 'NO EXCLUDE ADA/ADM'
	when en.EXCLUDE_ADA_ADM = 2 then 'CONCURRENT'
	END AS EXCLUDE_ADA_ADM,
	lu.value_description as GRADE,
	en.ORGANIZATION_GU,
	o.ORGANIZATION_NAME,
	en.YEAR_GU,
	bs.STUDENT_GU,
	bs.FIRST_NAME + ' ' + bs.last_name as STUDENT_NAME,
	bs.SIS_NUMBER,
    CONVERT(VARCHAR(10), bs.BIRTH_DATE, 101) AS [BIRTH_DATE],
	bs.gender,
	bs.RESOLVED_RACE,
	bs.ELL_STATUS,
	bs.SPED_STATUS,
	bs.CLASS_OF,
    CASE WHEN bs.[MAIL_ADDRESS] IS NULL THEN bs.[HOME_ADDRESS] ELSE bs.[MAIL_ADDRESS] END AS [ADDRESS],
	CASE WHEN bs.[MAIL_ADDRESS] IS NULL THEN bs.[HOME_ADDRESS_2] ELSE bs.[MAIL_ADDRESS_2] END AS [ADDRESS_2],
	CASE WHEN bs.[MAIL_CITY] IS NULL THEN bs.[HOME_CITY] ELSE bs.[MAIL_CITY] END AS [CITY],
	CASE WHEN bs.[MAIL_STATE] IS NULL THEN bs.[HOME_STATE] ELSE bs.[MAIL_STATE] END AS [STATE],
	CASE WHEN bs.[MAIL_ZIP] IS NULL THEN bs.[HOME_ZIP] ELSE bs.[MAIL_ZIP] END AS [ZIP],
	bs.HOME_CITY,
	bs.HOME_STATE,
	bs.HOME_ZIP,
	bs.CONTACT_LANGUAGE,
	bs.PRIMARY_PHONE,
	per.email as [STUDENT_EMAIL],
	e.EXCLUDE_BUSINESS,
	e.EXCLUDE_MILITARY,
	e.EXCLUDE_UNIVERSITY
	

from
	aps.BasicStudentWithMoreInfo bs
	
inner join
	aps.ENROLLMENTSFORYEAR(@Year) en
on
	en.STUDENT_GU = bs.student_gu
left join
	rev.[UD_STU] AS e
on
    bs.STUDENT_GU = e.STUDENT_GU
inner join
     REV.REV_PERSON AS PER
ON
	bs.STUDENT_GU = per.PERSON_GU
inner join
	rev.rev_organization o
on
	o.ORGANIZATION_GU = en.ORGANIZATION_GU
inner join
	   APS.LookupTable('K12','Grade') AS LU
on
	lu.value_code = en.grade
WHERE
	 YEAR_GU = @Year
AND
	 en.[ORGANIZATION_GU] LIKE @School
AND
	 en.GRADE LIKE @Grade
AND
	CASE WHEN @DNE = 'EXCLUDE_BUSINESS' THEN EXCLUDE_BUSINESS
	WHEN @DNE = 'EXCLUDE_MILITARY' THEN EXCLUDE_MILITARY
	WHEN @DNE = 'EXCLUDE_UNIVERSITY' THEN EXCLUDE_UNIVERSITY
	END = 'N'
AND 
	en.LEAVE_DATE IS NULL
)
,ParentCTE
as
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
)
 
 
 SELECT 
	S.*,
	MAX(CASE WHEN RN = 1 THEN PARENT_GU END) AS P1GU,
	MAX(CASE WHEN RN = 1 THEN LAST_NAME END) AS P1LN,
	MAX(CASE WHEN RN = 1 THEN FIRST_NAME END) AS P1FN,
	MAX(CASE WHEN RN = 1 THEN VALUE_DESCRIPTION END) AS P1TYPE,
	MAX(CASE WHEN RN = 1 THEN EMAIL END) AS P1EMAIL,
	MAX(CASE WHEN RN = 1 THEN p.PRIMARY_PHONE END) AS P1PHONE,
	MAX(CASE WHEN RN = 2 THEN PARENT_GU END) AS P2GU,
	MAX(CASE WHEN RN = 2 THEN LAST_NAME END) AS P2LN,
	MAX(CASE WHEN RN = 2 THEN FIRST_NAME END) AS P2FN,
	MAX(CASE WHEN RN = 2 THEN VALUE_DESCRIPTION END) AS P2TYPE,
	MAX(CASE WHEN RN = 2 THEN p.PRIMARY_PHONE END) AS P2PHONE,
	MAX(CASE WHEN RN = 2 THEN EMAIL END) AS P2EMAIL,
	MAX(CASE WHEN RN = 3 THEN PARENT_GU END) AS P3GU,
	MAX(CASE WHEN RN = 3 THEN LAST_NAME END) AS P3LN,
	MAX(CASE WHEN RN = 3 THEN FIRST_NAME END) AS P3FN,
	MAX(CASE WHEN RN = 3 THEN VALUE_DESCRIPTION END) AS P3TYPE,
	MAX(CASE WHEN RN = 3 THEN EMAIL END) AS P3EMAIL,
	MAX(CASE WHEN RN = 3 THEN p.PRIMARY_PHONE END) AS P3PHONE


from
	StudentCTE S
left join
	ParentCTE P
on
	P.STUDENT_GU = S.STUDENT_GU
GROUP BY
	S.ADDRESS,
	S.ADDRESS_2,
	S.BIRTH_DATE,
	S.CITY,
	S.CLASS_OF,
	S.CONTACT_LANGUAGE,
	S.ELL_STATUS,
	S.STUDENT_EMAIL,
	S.ENTER_DATE,
	S.EXCLUDE_ADA_ADM,
	S.LEAVE_DATE,
	s.EXCLUDE_BUSINESS,
	s.EXCLUDE_MILITARY,
	s.EXCLUDE_UNIVERSITY,
	S.GENDER,
	S.GRADE,
	S.HOME_CITY,
	S.HOME_STATE,
	S.HOME_ZIP,
	s.ORGANIZATION_GU,
	S.PRIMARY_PHONE,
	S.RESOLVED_RACE,
	s.ORGANIZATION_NAME,
	S.SIS_NUMBER,
	S.SPED_STATUS,
	S.STATE,
	S.STUDENT_GU,
	S.STUDENT_NAME,
	s.year_gu,
	S.ZIP 

Branch_Two:
	;with StudentCTE
as
(
select	
	en.ENTER_DATE,
	en.leave_date,
	case
	when en.EXCLUDE_ADA_ADM = 1 then 'NO EXCLUDE ADA/ADM'
	when en.EXCLUDE_ADA_ADM = 2 then 'CONCURRENT'
	END AS EXCLUDE_ADA_ADM,
	lu.VALUE_DESCRIPTION as GRADE,
	en.ORGANIZATION_GU,
	o.ORGANIZATION_NAME,
	en.YEAR_GU,
	bs.STUDENT_GU,
	bs.FIRST_NAME + ' ' + bs.last_name as STUDENT_NAME,
	bs.SIS_NUMBER,
    CONVERT(VARCHAR(10), bs.BIRTH_DATE, 101) AS [BIRTH_DATE],
	bs.gender,
	bs.RESOLVED_RACE,
	bs.ELL_STATUS,
	bs.SPED_STATUS,
	bs.CLASS_OF,
    CASE WHEN bs.[MAIL_ADDRESS] IS NULL THEN bs.[HOME_ADDRESS] ELSE bs.[MAIL_ADDRESS] END AS [ADDRESS],
	CASE WHEN bs.[MAIL_ADDRESS] IS NULL THEN bs.[HOME_ADDRESS_2] ELSE bs.[MAIL_ADDRESS_2] END AS [ADDRESS_2],
	CASE WHEN bs.[MAIL_CITY] IS NULL THEN bs.[HOME_CITY] ELSE bs.[MAIL_CITY] END AS [CITY],
	CASE WHEN bs.[MAIL_STATE] IS NULL THEN bs.[HOME_STATE] ELSE bs.[MAIL_STATE] END AS [STATE],
	CASE WHEN bs.[MAIL_ZIP] IS NULL THEN bs.[HOME_ZIP] ELSE bs.[MAIL_ZIP] END AS [ZIP],
	bs.HOME_CITY,
	bs.HOME_STATE,
	bs.HOME_ZIP,
	bs.CONTACT_LANGUAGE,
	bs.PRIMARY_PHONE,
	per.email as [STUDENT_EMAIL],
	e.EXCLUDE_BUSINESS,
	e.EXCLUDE_MILITARY,
	e.EXCLUDE_UNIVERSITY
	

from
	aps.BasicStudentWithMoreInfo bs
	
inner join
	aps.ENROLLMENTSFORYEAR(@Year) en
on
	en.STUDENT_GU = bs.student_gu
left join
	rev.[UD_STU] AS e
on
    bs.STUDENT_GU = e.STUDENT_GU
inner join
     REV.REV_PERSON AS PER
ON
	bs.STUDENT_GU = per.PERSON_GU
inner join
	rev.rev_organization o
on
	o.ORGANIZATION_GU = en.ORGANIZATION_GU
inner join
	   APS.LookupTable('K12','Grade') AS LU
on
	lu.value_code = en.grade

WHERE
	 YEAR_GU = @Year
AND
	 en.[ORGANIZATION_GU] LIKE @School
AND
	 en.GRADE LIKE @Grade
and
	EN.LEAVE_DATE IS NULL
)
--SELECT * FROM StudentCTE
,ParentCTE
as
(
SELECT 
          STUDENT_GU
          ,PARENT_GU
		  ,PER.LAST_NAME
		  ,PER.FIRST_NAME
		  ,PER.EMAIL
		  ,PER.PRIMARY_PHONE
          ,ORDERBY
		  ,lu.VALUE_DESCRIPTION
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
)
 
 
 SELECT 
	S.*,
	MAX(CASE WHEN RN = 1 THEN PARENT_GU END) AS P1GU,
	MAX(CASE WHEN RN = 1 THEN LAST_NAME END) AS P1LN,
	MAX(CASE WHEN RN = 1 THEN FIRST_NAME END) AS P1FN,
	MAX(CASE WHEN RN = 1 THEN VALUE_DESCRIPTION END) AS P1TYPE,
	MAX(CASE WHEN RN = 1 THEN EMAIL END) AS P1EMAIL,
	MAX(CASE WHEN RN = 1 THEN p.PRIMARY_PHONE END) AS P1PHONE,
	MAX(CASE WHEN RN = 2 THEN PARENT_GU END) AS P2GU,
	MAX(CASE WHEN RN = 2 THEN LAST_NAME END) AS P2LN,
	MAX(CASE WHEN RN = 2 THEN FIRST_NAME END) AS P2FN,
	MAX(CASE WHEN RN = 2 THEN VALUE_DESCRIPTION END) AS P2TYPE,
	MAX(CASE WHEN RN = 2 THEN p.PRIMARY_PHONE END) AS P2PHONE,
	MAX(CASE WHEN RN = 2 THEN EMAIL END) AS P2EMAIL,
	MAX(CASE WHEN RN = 3 THEN PARENT_GU END) AS P3GU,
	MAX(CASE WHEN RN = 3 THEN LAST_NAME END) AS P3LN,
	MAX(CASE WHEN RN = 3 THEN FIRST_NAME END) AS P3FN,
	MAX(CASE WHEN RN = 3 THEN VALUE_DESCRIPTION END) AS P3TYPE,
	MAX(CASE WHEN RN = 3 THEN EMAIL END) AS P3EMAIL,
	MAX(CASE WHEN RN = 3 THEN p.PRIMARY_PHONE END) AS P3PHONE


from
	StudentCTE S
left join
	ParentCTE P
on
	P.STUDENT_GU = S.STUDENT_GU



GROUP BY
	S.ADDRESS,
	S.ADDRESS_2,
	S.BIRTH_DATE,
	S.CITY,
	S.CLASS_OF,
	S.CONTACT_LANGUAGE,
	S.ELL_STATUS,
	S.STUDENT_EMAIL,
	S.ENTER_DATE,
	S.EXCLUDE_ADA_ADM,
	s.LEAVE_DATE,
	s.EXCLUDE_BUSINESS,
	s.EXCLUDE_MILITARY,
	s.EXCLUDE_UNIVERSITY,
	S.GENDER,
	S.GRADE,
	S.HOME_CITY,
	S.HOME_STATE,
	S.HOME_ZIP,
	s.ORGANIZATION_GU,
	S.PRIMARY_PHONE,
	S.RESOLVED_RACE,
	s.ORGANIZATION_NAME,
	S.SIS_NUMBER,
	S.SPED_STATUS,
	S.STATE,
	S.STUDENT_GU,
	S.STUDENT_NAME,
	s.year_gu,
	S.ZIP 	

end
