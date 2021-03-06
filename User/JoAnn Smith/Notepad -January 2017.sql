
--	LOOKUP TABLE
SELECT
		LookupValues.*
	FROM
		rev.REV_BOD_LOOKUP_DEF AS LookupDef
		INNER JOIN
		rev.REV_BOD_LOOKUP_VALUES As LookupValues
		ON
		LookupDef.LOOKUP_DEF_GU = LookupValues.LOOKUP_DEF_GU
		where value_description = 'H'
			  oRDER BY VALUE_CODE

	--WHERE
	--	LookupDef.LOOKUP_NAMESPACE = @namespace
	--	AND LookupDef.LOOKUP_DEF_CODE = @lookupname

	SELECT * FROM REV.REV_BOD_LOOKUP_DEF
	where LOOKUP_DEF_CODE like '%School%'
	ORDER BY LOOKUP_NAMESPACE

	select * from rev.REV_BOD_LOOKUP_VALUES
	where VALUE_DESCRIPTION like '%Montoya%'

	select * from APS.LookupTable('K12.Enrollment', 'School')

--rev.EPC_CRS_LEVEL_LST As CourseLevel

--APS.LookupTable('k12.CourseInfo','Sced_course_level') AS CourseLevelDescription

select * from aps.LookupTable('k12.CourseInfo','Sced_course_level')

select * from rev.EPC_STAFF_SCH_YR where homeroom_gu is not null
select * from rev.EPC_STU_SCH_YR

--REGULAR TABLES no data
select
	 p.LAST_NAME, p.FIRST_NAME, STSY.HOMEROOM_GU, STSY.STAFF_GU 
from
	 rev.EPC_STU_SCH_YR SSY
inner join
	 rev.EPC_STAFF_SCH_YR STSY on STSY.HOMEROOM_GU= SSY.HOMEROOM_SECTION_GU
inner join
	 rev.REV_PERSON p on p.PERSON_GU = STSY.STAFF_GU
where
	 sis_number = '970064618'

	--views
select
	 p.LAST_NAME, p.FIRST_NAME, saa.SECTION_GU, saa.STAFF_GU
from
	 aps.StudentEnrollmentDetails sed
inner join
	 aps.SectionsAndAllStaffAssigned saa on sed.HOMEROOM_SECTION_GU = saa.SECTION_GU
inner join
	 rev.REV_PERSON p on p.PERSON_GU = saa.STAFF_GU
where
	 sis_number = '970064618'
	and sed.HOMEROOM_SECTION_GU = saa.SECTION_GU
	select distinct value_code, VALUE_DESCRIPTION from aps.LookupTable('K12', 'GRADE')
	order by value_code 

	select * from aps.SK_Schedule_Today where GRADE in ('190', '200', '210', '220')
	select * from aps.StudentEnrollmentDetails where extension = 'R' and grade in ('09', '10', '11', '12') --get 'R' from here
	select * from APS.LookupTable('k12.CourseInfo','Subject_Area') AS Subject1 --get HS English classes from there
	where VALUE_DESCRIPTION like ('HS English%')  --value code = E09 E10 E11 E12

	select * from rev.epc_stu_sch_yr ssy where ssy.STUDENT_GU = '40E73C91-414B-4EBC-8BC8-B0EA72B1543F'
	SELECT * FROM REV.EPC_STAFF
	select * from REV.REV_Person


select * from aps.scheduleasof(getdate()) sao --where ENROLLMENT_GRADE_LEVEL in ('160', '170', '180', '190', '200', '210', '220') 
inner join aps.TermDatesAsOf(getdate()) tda on sao.ORGANIZATION_YEAR_GU = tda.OrgYearGU and sao.TERM_CODE = tda.TermCode
where sao.SIS_NUMBER = '970098808'

select top 10 * from aps.scheduleasof(getdate()) where sis_number = 103450391

inner join aps.StudentEnrollmentDetails sed on sao.SIS_NUMBER = sed.SIS_NUMBER
 where grade in ('06', '07', '08', '09', '10', '11', '12')

select * from rev.epc_crs

SELECT *  FROM 
rev.EPC_CRS AS CRS
INNER JOIN 
REV.EPC_CRS_LEVEL_LST  as lst on
crs.COURSE_GU = lst.COURSE_GU
--where COURSE_LEVEL = 'E'

select * from rev.epc_stu where GRADUATION_DATE is null
select * from aps.StudentEnrollmentDetails
select * from aps.BasicStudent


SELECT * FROM 
APS.TermDatesAsOf(GETDATE()) 

select * from APS.PrimaryEnrollmentDetailsAsOf(getdate())

select sis_number, sao.ENROLLMENT_GRADE_LEVEL, course_title, term_code
from
	aps.TermDatesAsOf(getdate()) TDA
	left join aps.scheduleasof(getdate()) sao on sao.organization_Year_gu = tda.OrgYearGU
	and tda.TermCode = sao.TERM_CODE
	WHERE SAO.SIS_NUMBER = '970098808'

	select sao.sis_number, sao.ENROLLMENT_GRADE_LEVEL, sao.COURSE_TITLE, tda.SCHOOL_YEAR, sao.ORGANIZATION_YEAR_GU from aps.scheduleasof(getdate())sao
	inner join aps.TermDatesAsOf(getdate()) tda on tda.OrgYearGU = sao.ORGANIZATION_YEAR_GU
	where SIS_NUMBER = '970025365'
	AND TDA.TermCode = SAO.TERM_CODE

	--8B405B49-0B98-4831-A52F-3FD4828C6FFA
	select * from 
	   rev.epc_sch_yr_opt OPT inner join aps.TermDatesAsOf(getdate()) TDA
       ON OPT.HOMEROOM_PERIOD = SCH.PERIOD_BEGIN
          AND OPT.ORGANIZATION_YEAR_GU = Enrollments.ORGANIZATION_YEAR_GU        


 select distinct(student.SIS_NUMBER)
 
 from 
	APS.PrimaryEnrollmentDetailsAsOf(getdate()) AS [Enrollments]
       
       LEFT JOIN
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

       LEFT join 
       aps.scheduledetailsasof(getdate()) as SCH
       on sch.STUDENT_GU = student.STUDENT_GU

	   inner join
	   aps.TermDatesAsOf(getdate()) tda on tda.OrgYearGU = sch.ORGANIZATION_YEAR_GU and tda.TermCode = sch.TERM_CODE

	   where student.SIS_NUMBER = '970025365'
          
       --inner join
       --rev.epc_sch_yr_opt OPT
       --ON OPT.HOMEROOM_PERIOD = SCH.PERIOD_BEGIN
       --   AND OPT.ORGANIZATION_YEAR_GU = Enrollments.ORGANIZATION_YEAR_GU  
	   
	   select * from aps.BasicStudentWithMoreInfo where SIS_NUMBER = 980030331 --student gu A468D0BF-DC23-424A-BAC7-75FAA772E150
	   select * from aps.PrimaryEnrollmentDetailsAsOf(getdate()) where STUDENT_GU = 'A468D0BF-DC23-424A-BAC7-75FAA772E150'
	   --homeroom section gu 3242972E-FF1A-452E-BF9A-1A7A5FA06B78

	   select * from rev.UD_STU where student_gu = 'A468D0BF-DC23-424A-BAC7-75FAA772E150'
	   select * from rev.REV_PERSON p inner join aps.BasicStudentWithMoreInfo s on p.PERSON_GU = s.STUDENT_GU and STUDENT_GU = 'A468D0BF-DC23-424A-BAC7-75FAA772E150'

	   select * from aps.BasicStudentWithMoreInfo
	   select * from aps.PrimaryEnrollmentDetailsAsOf(getdate())

	   select * from aps.scheduleasof(getdate()) where sis_number = 970025365

	   select * from aps.studentgrades where SIS_NUMBER = 970025365

	   select * from rev.EPC_CRS
	   where COURSE_TITLE like '%ALG%'
	   select * from aps.StudentGrades
	   where SIS_NUMBER = '970049663'
	   and grade_period = 'S1 Grade'

	   select * from aps.ScheduleDetailsAsOf(getdate()) where SIS_NUMBER = 970049663

	   	select * from aps.StudentGrades where sis_number = 104513239
		and grade_period = 'S1' 
		and COURSE_Id = '33040'

		select count(*) from aps.StudentEnrollmentDetails where grade = '08'
		

		select ECRS.Course_ID, ECRS.COURSE_TITLE from rev.ud_crs CRS
		inner join
		rev.UD_CRS_GROUP GRP on crs.COURSE_GU = grp.COURSE_GU
		and grp.[GROUP] like 'ALG 1 S1%'
		inner join
		rev.EPC_CRS ECRS on ECRS.COURSE_GU = CRS.COURSE_GU
		where crs.COURSE_GU = 'ACADD63B-6029-4314-B3D5-B542F110C838'	

		select * from aps.ScheduleAsOf(getdate())
		where SIS_NUMBER = 104513239

		select ecrs.course_Id, Ecrs.Course_title from rev.epc_crs ecrs
		--where ecrs.COURSE_DURATION = 'ACADD63B-6029-4314-B3D5-B542F110C838'
		where ecrs.COURSE_TITLE like '%ALG%'

		select * from rev.epc_stu_crs_his 
		where STUDENT_GU = '43273858-EB28-4602-BAB4-3A6624C6FD18'
		and course_title like '%ALG%'

		select * from aps.BasicStudent where SIS_NUMBER = 104513239

		select * from aps.basicschedule where student_gu = '43273858-EB28-4602-BAB4-3A6624C6FD18'
		select * from aps.StudentEnrollmentDetails where student_gu = '43273858-EB28-4602-BAB4-3A6624C6FD18'
		select * from aps.PrimaryEnrollmentDetailsAsOf(getdate()) --where student_gu = '43273858-EB28-4602-BAB4-3A6624C6FD18'
		select * from aps.ScheduleAsOf(getdate()) --where student_gu = '43273858-EB28-4602-BAB4-3A6624C6FD18'
		select * from aps.ScheduleDetailsAsOf(getdate()) where student_gu = '43273858-EB28-4602-BAB4-3A6624C6FD18'

		SELECT * FROM 
APS.MeetCodeRotationMismatch

SELECT * FROM 
APS.GradebookReadyAssessments
where 

select * from aps.ActiveGiftedMiddleSchoolStudents

SELECT * FROM APS.BasicStudent WHERE SIS_NUMBER = 103410320
select * from rev.epc_stu
select * from rev.epc_stu_enroll

select * from rev.rev_person p where p.LAST_NAME = 'Rodriguez' and p.FIRST_NAME = 'Amy'
select * from aps.basicstudentwithmoreinfo where SIS_NUMBER = 	980022613

select 
	*
FROM
       rev.EPC_STU_TEST AS StudentTest

       JOIN
       rev.EPC_TEST_PART AS PART
       ON StudentTest.TEST_GU = PART.TEST_GU

       JOIN
       rev.EPC_STU_TEST_PART AS STU_PART
       ON PART.TEST_PART_GU = STU_PART.TEST_PART_GU
       AND STU_PART.STUDENT_TEST_GU = StudentTest.STUDENT_TEST_GU

    INNER JOIN
    rev.EPC_STU_TEST_PART_SCORE AS SCORES
    ON
    SCORES.STU_TEST_PART_GU = STU_PART.STU_TEST_PART_GU

    LEFT JOIN
    rev.EPC_TEST_SCORE_TYPE AS SCORET
    ON
    SCORET.TEST_GU = StudentTest.TEST_GU
    AND SCORES.TEST_SCORE_TYPE_GU = SCORET.TEST_SCORE_TYPE_GU

    LEFT JOIN
    rev.EPC_TEST_DEF_SCORE AS SCORETDEF
    ON
    SCORETDEF.TEST_DEF_SCORE_GU = SCORET.TEST_DEF_SCORE_GU

       LEFT JOIN
       rev.EPC_TEST AS TEST
       ON TEST.TEST_GU = StudentTest.TEST_GU


--=IIF(Fields!END_DATE.Value is nothing, nothing, Format(Cdate(Fields!END_DATE.Value), "MM/dd/yyyy"))
select * from aps.CumGPA where school_year = 2016
SELECT *  FROM APS.CumGPA WHERE GRADE = 'C1'

SELECT * FROM APS.PrimaryEnrollmentDetailsAsOf(GETDATE())

SELECT * FROM REV.EPC_SCH_YR_OPT

--01
--02
--03
--04
--05
--06
--07
--08
--09
--10
--11
--12
--K

SELECT * FROM APS.CumGPA WHERE SIS_NUMBER = 980019019
select * from rev.epc_stu_test
select * from rev.EPC_TEST_PART

select 
	*
FROM
       rev.EPC_STU_TEST AS StudentTest

       JOIN
       rev.EPC_TEST_PART AS PART
       ON StudentTest.TEST_GU = PART.TEST_GU

       JOIN
       rev.EPC_STU_TEST_PART AS STU_PART
       ON PART.TEST_PART_GU = STU_PART.TEST_PART_GU
       AND STU_PART.STUDENT_TEST_GU = StudentTest.STUDENT_TEST_GU

    INNER JOIN
    rev.EPC_STU_TEST_PART_SCORE AS SCORES
    ON
    SCORES.STU_TEST_PART_GU = STU_PART.STU_TEST_PART_GU

    LEFT JOIN
    rev.EPC_TEST_SCORE_TYPE AS SCORET
    ON
    SCORET.TEST_GU = StudentTest.TEST_GU
    AND SCORES.TEST_SCORE_TYPE_GU = SCORET.TEST_SCORE_TYPE_GU

    LEFT JOIN
    rev.EPC_TEST_DEF_SCORE AS SCORETDEF
    ON
    SCORETDEF.TEST_DEF_SCORE_GU = SCORET.TEST_DEF_SCORE_GU

       LEFT JOIN
       rev.EPC_TEST AS TEST
       ON TEST.TEST_GU = StudentTest.TEST_GU

	   select *
	   from
	   	rev.EPC_STU_TEST AS StudentTest
	where studenttest.STUDENT_GU = '4AE6F34D-1B07-4FDC-A191-BEB58D05F142 '

	select student_gu from aps.BasicStudent bs 


	where bs.SIS_NUMBER = 970110724


		--SELECT STUDENT_GU FROM APS.BasicStudent WHERE SIS_NUMBER = 980018276

	SELECT * FROM REV.EPC_STU_TEST ST
	WHERE ST.STUDENT_GU = '62552634-064D-421F-B199-676CE19B2DD6'
	and test_gu = '477ECCAA-57FD-4961-B904-38252F7B87BE1'

	--SELECT * FROM REV.EPC_TEST TST WHERE TEST_GU = '1E77E2B0-C106-40A6-96DE-86A736BA2A31'
	----ACCESS 477ECCAA-57FD-4961-B904-38252F7B87BE
	----WAPT 1E77E2B0-C106-40A6-96DE-86A736BA2A31

	SELECT * FROM REV.EPC_TEST_PART WHERE TEST_GU = '477ECCAA-57FD-4961-B904-38252F7B87BE'
	--TEST DESCRIPTION = ACCESSFROM TEST_GU

	SELECT * FROM rev.EPC_STU_TEST_PART PT WHERE TEST_PART_GU = '148B5F46-0D5D-47C8-9337-D6283396A784'
	--GETS PERFORMANCE LEVEL FROM TEST_PART_GU
	
	--can take WAPT only once
	--ACCESS can be taken multiple years

	SELECT * FROM DBO.STUDENT_ATTENDANCE WHERE [SIS Number] = 980035882

	select * from rev.epc_stu WHERE SIS_NUMBER = 980036443

	select * from aps.PrimaryEnrollmentDetailsAsOf(getdate())

	select * from rev.REV_ORGANIZATION where ORGANIZATION_NAME like 'Rio%'

	select * from aps.StudentScheduleDetails
	where student_gu = '59DBD304-776F-49B6-BEBE-8C07F41F0263'

	select * from aps.basicstudent
	where SIS_NUMBER = 980035971
select * from aps.PrimaryEnrollmentDetailsAsOf(getdate())
where STUDENT_GU = '7A8654B0-0793-4774-80A7-D7803E623257'

	'

	