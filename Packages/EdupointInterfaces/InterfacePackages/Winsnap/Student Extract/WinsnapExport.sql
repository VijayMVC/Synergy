--<APS - Food Services Student Extract File>
-- Only active students in current school year at the time of each pull 
--(no future dated Enter Date enrollments).  
--File needs to include Summer School enrollments in the current year 
--when they start being created

; with ParentNames As
(
  SELECT 
     stu.STUDENT_GU
  , CASE 
         WHEN 
          spar.ORDERBY = ROW_NUMBER() OVER(PARTITION BY spar.STUDENT_GU order by spar.STUDENT_GU) 
		  THEN 
		  spar.ORDERBY
		  ELSE ROW_NUMBER() OVER(PARTITION BY spar.STUDENT_GU order by spar.STUDENT_GU)

	  END       rn
   , pper.FIRST_NAME + ' ' +  pper.LAST_NAME [pname]
   , lng.VALUE_DESCRIPTION ParentLang
   FROM rev.EPC_STU stu
   JOIN rev.EPC_STU_PARENT spar ON spar.STUDENT_GU = stu.STUDENT_GU AND spar.CONTACT_ALLOWED = 'Y'
   JOIN rev.REV_PERSON pper     ON pper.PERSON_GU  = spar.PARENT_GU
   LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12','LANGUAGE') lng on lng.VALUE_CODE = pper.PRIMARY_LANGUAGE
), HispanicRaceCode AS
(
select 
    seth.PERSON_GU
  , ROW_NUMBER() OVER(PARTITION by seth.PERSON_GU order by seth.person_gu) rno
  , e.ALT_CODE_3 as Race1
from  rev.REV_PERSON_SECONDRY_ETH_LST seth
      join rev.REV_PERSON per on per.PERSON_GU = seth.PERSON_GU
	  left join rev.SIF_22_Common_GetLookupValues('Revelation', 'ETHNICITY') e on e.VALUE_CODE = seth.ETHNIC_CODE
where per.HISPANIC_INDICATOR = 'Y'
), HomeRoomPrdTeacher AS
(
SELECT
        row_number() over(partition by stu.student_gu order by stu.student_gu, cls.enter_date desc) rn 
      , stu.STUDENT_GU
	  , stfp.LAST_NAME TeacherName
	  , symd.MEET_DAY_CODE
FROM  rev.EPC_STU                          stu
      JOIN rev.EPC_STU_SCH_YR              ssy   ON ssy.STUDENT_GU             = stu.STUDENT_GU
      JOIN rev.REV_ORGANIZATION_YEAR       oyr   ON oyr.ORGANIZATION_YEAR_GU   = ssy.ORGANIZATION_YEAR_GU
      JOIN rev.REV_YEAR                    yr    ON yr.YEAR_GU                 = oyr.YEAR_GU
                                                    and yr.SCHOOL_YEAR         = (select SCHOOL_YEAR from rev.SIF_22_Common_CurrentYear)
      JOIN rev.EPC_SCH                     sch   ON sch.ORGANIZATION_GU        = oyr.ORGANIZATION_GU
	  JOIN rev.EPC_SCH_YR_OPT              sopt  ON sopt.ORGANIZATION_YEAR_GU  = oyr.ORGANIZATION_YEAR_GU
      JOIN rev.EPC_STU_CLASS               cls   ON cls.STUDENT_SCHOOL_YEAR_GU = ssy.STUDENT_SCHOOL_YEAR_GU
      JOIN rev.EPC_SCH_YR_SECT             sect  ON sect.SECTION_GU            = cls.SECTION_GU
                                                    AND sect.PERIOD_BEGIN      = sopt.HOMEROOM_PERIOD
      LEFT JOIN rev.EPC_SCH_YR_SECT_MET_DY sysmd ON sysmd.SECTION_GU           = sect.SECTION_GU
	  LEFT JOIN rev.EPC_SCH_YR_MET_DY      symd  ON symd.SCH_YR_MET_DY_GU      = sysmd.SCH_YR_MET_DY_GU
	                                                and symd.SCH_YR_MET_DY_GU  = sopt.HRM_SCH_YR_MET_DY_GU
      LEFT JOIN rev.EPC_STAFF_SCH_YR       stf   ON stf.STAFF_SCHOOL_YEAR_GU   = sect.STAFF_SCHOOL_YEAR_GU
	  LEFT JOIN rev.REV_PERSON             stfp  ON stfp.PERSON_GU             = stf.STAFF_GU
WHERE (cls.LEAVE_DATE IS NULL OR cls.LEAVE_DATE >= GETDATE())
       AND cls.ENTER_DATE <= GETDATE()
       AND cls.ENTER_DATE <= GETDATE()
), SummarSchoolStu AS
(
   select 
        stu.student_gu
   FROM rev.EPC_STU                    stu
        JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
                                            and ssy.STATUS is NULL
                                            and ssy.EXCLUDE_ADA_ADM is null --exclude concurrent enrollment
											and ssy.LEAVE_DATE is null
											and ssy.SUMMER_WITHDRAWL_CODE is null -- exclude summer withdrawal
											and ssy.SUMMER_WITHDRAWL_DATE is null -- exclude summer withdrawal
        JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
        JOIN rev.REV_YEAR              yr   ON yr.YEAR_GU = oyr.YEAR_GU
                                               and yr.SCHOOL_YEAR = (select SCHOOL_YEAR from rev.SIF_22_Common_CurrentYear)
                                               and yr.EXTENSION = 'S'

)
SELECT
       stu.SIS_NUMBER                                           AS [Student ID Number]
     , per.LAST_NAME                                            AS [Student Last Name]
     , per.FIRST_NAME                                           AS [Student First Name]
     , per.MIDDLE_NAME                                          AS [Student Middle Name]
     , hadr.ADDRESS                                             AS [Student Address]
     , hadr.CITY                                                AS [Student Home Address City]
     , hadr.STATE                                               AS [Student Home Address State]
     , hadr.ZIP_5                                               AS [Student Home Zip Code]
     , grd.VALUE_DESCRIPTION                                    AS [Student Current SOR Enrollment Grade Level]
     , CASE
        WHEN per.RESOLVED_ETHNICITY_RACE = '__HIS' THEN hrc.Race1
        WHEN per.RESOLVED_ETHNICITY_RACE = '__TWO' THEN 'T'
        ELSE eth.ALT_CODE_3
       END                                                      AS [Student Race]
     , per.HISPANIC_INDICATOR                                   AS [Student Hispanic Indicator]
     , per.PRIMARY_PHONE                                        AS [Student Home Phone Number]
     , REPLACE(CONVERT(VARCHAR(10), per.BIRTH_DATE,1), '/', '') AS [Student Birthdate]
     , 'A'                                                      AS [Active Student Indicator]
     , sch.SCHOOL_CODE                                          AS [SOR School Number]
     , pnm.pname                                                AS [Parent Name]
     , hmt.TeacherName                                          AS [Homeroom Teacher]
	 , stu.STATE_STUDENT_NUMBER                                 AS [StudentStateID]
     , pnm.ParentLang                                           AS [Preferred Parent Contact language]
FROM rev.EPC_STU                    stu
     JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
                                            and ssy.STATUS is NULL
                                            and ssy.EXCLUDE_ADA_ADM is null --exclude concurrent enrollment
											and ssy.SUMMER_WITHDRAWL_CODE is null -- exclude summer withdrawal
											and ssy.SUMMER_WITHDRAWL_DATE is null -- exclude summer withdrawal
     JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
     JOIN rev.REV_YEAR              yr   ON yr.YEAR_GU = oyr.YEAR_GU
                                            and yr.SCHOOL_YEAR = (select SCHOOL_YEAR from rev.SIF_22_Common_CurrentYear)
											and yr.EXTENSION = 'R'
											and ssy.LEAVE_DATE is null
     JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU 
     JOIN rev.REV_PERSON            per  ON per.PERSON_GU = stu.STUDENT_GU
     LEFT JOIN rev.REV_ADDRESS      hadr ON hadr.ADDRESS_GU = per.HOME_ADDRESS_GU
     LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') grd ON grd.VALUE_CODE = ssy.GRADE
     LEFT JOIN ParentNames          pnm  ON pnm.STUDENT_GU = stu.STUDENT_GU and pnm.rn = 1
     LEFT JOIN rev.SIF_22_Common_GetLookupValues('Revelation', 'ETHNICITY') eth on eth.VALUE_CODE = per.RESOLVED_ETHNICITY_RACE
	 LEFT JOIN HispanicRaceCode     hrc  ON hrc.PERSON_GU = stu.STUDENT_GU and hrc.rno = 1
	 LEFT JOIN HomeRoomPrdTeacher   hmt  ON hmt.STUDENT_GU = stu.STUDENT_GU and hmt.rn = 1
	 -- to select only 1 reguler school enrollment
WHERE sch.SCHOOL_CODE NOT IN ('510')
      -- to exclude those students who have a summar school enrollment
	 and not exists (select ss.student_gu from SummarSchoolStu ss where ss.STUDENT_GU = stu.STUDENT_GU)
-- Only Summer School enrollments
UNION
SELECT
       stu.SIS_NUMBER                                           AS [Student ID Number]
     , per.LAST_NAME                                            AS [Student Last Name]
     , per.FIRST_NAME                                           AS [Student First Name]
     , per.MIDDLE_NAME                                          AS [Student Middle Name]
     , hadr.ADDRESS                                             AS [Student Address]
     , hadr.CITY                                                AS [Student Home Address City]
     , hadr.STATE                                               AS [Student Home Address State]
     , hadr.ZIP_5                                               AS [Student Home Zip Code]
     , grd.VALUE_DESCRIPTION                                    AS [Student Current SOR Enrollment Grade Level]
     , CASE
        WHEN per.RESOLVED_ETHNICITY_RACE = '__HIS' THEN hrc.Race1
        WHEN per.RESOLVED_ETHNICITY_RACE = '__TWO' THEN 'T'
        ELSE eth.ALT_CODE_3
       END                                                      AS [Student Race]
     , per.HISPANIC_INDICATOR                                   AS [Student Hispanic Indicator]
     , per.PRIMARY_PHONE                                        AS [Student Home Phone Number]
     , REPLACE(CONVERT(VARCHAR(10), per.BIRTH_DATE,1), '/', '') AS [Student Birthdate]
     , 'A'                                                      AS [Active Student Indicator]
     , sch.SCHOOL_CODE                                          AS [SOR School Number]
     , pnm.pname                                                AS [Parent Name]
     , hmt.TeacherName                                          AS [Homeroom Teacher]
     , stu.STATE_STUDENT_NUMBER                                 AS [StudentStateID]
     , pnm.ParentLang                                           AS [Preferred Parent Contact language]
FROM rev.EPC_STU                    stu
     JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
                                            and ssy.STATUS is NULL
                                            and ssy.EXCLUDE_ADA_ADM is null --exclude concurrent enrollment
											and ssy.LEAVE_DATE is null
											and ssy.SUMMER_WITHDRAWL_CODE is null -- exclude summer withdrawal
											and ssy.SUMMER_WITHDRAWL_DATE is null -- exclude summer withdrawal
     JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
     JOIN rev.REV_YEAR              yr   ON yr.YEAR_GU = oyr.YEAR_GU
                                            and yr.SCHOOL_YEAR = (select SCHOOL_YEAR from rev.SIF_22_Common_CurrentYear)
											and yr.EXTENSION = 'S'
     JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU 
     JOIN rev.REV_PERSON            per  ON per.PERSON_GU = stu.STUDENT_GU
     LEFT JOIN rev.REV_ADDRESS      hadr ON hadr.ADDRESS_GU = per.HOME_ADDRESS_GU
     LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') grd ON grd.VALUE_CODE = ssy.GRADE
     LEFT JOIN ParentNames          pnm  ON pnm.STUDENT_GU = stu.STUDENT_GU and pnm.rn = 1
     LEFT JOIN rev.SIF_22_Common_GetLookupValues('Revelation', 'ETHNICITY') eth on eth.VALUE_CODE = per.RESOLVED_ETHNICITY_RACE
	 LEFT JOIN HispanicRaceCode     hrc  ON hrc.PERSON_GU = stu.STUDENT_GU and hrc.rno = 1
	 LEFT JOIN HomeRoomPrdTeacher   hmt  ON hmt.STUDENT_GU = stu.STUDENT_GU and hmt.rn = 1

WHERE sch.SCHOOL_CODE NOT IN ('510')
