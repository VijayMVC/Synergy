select * from APS.BasicStudent
where LAST_NAME = 'Owle'


select * from APS.StudentEnrollmentDetails SD
where SD.SIS_NUMBER = '970049663'

select * from APS.AttendancePeriod AD
where AD.SIS_NUMBER = '970049663'

select * from rev.REV_BOD_LOOKUP_VALUES
where value_code = 'ABS'

select * from APS.BasicStudentWithMoreInfo AA


--mail address GUID 61418971-751D-4A80-88D5-FCE811432494

select * from APS.APSStudentsforPED
where [Student Last Name] = 'Owle'

select * from aps.attendanceperiod
where SIS_NUMBER = '970049663'

select * from rev.EPC_CODE_ABS_REAS

select * from aps.basicschedule bsd
where bsd.STUDENT_GU = '7A8654B0-0793-4774-80A7-D7803E623257'

select * from aps.CumGPA 
where SIS_NUMBER = '970049663'

select * from aps.CurrentStudentMailingDetails
where SIS_NUMBER = '970049663'

select * from aps.DailyUnexcused
where SIS_NUMBER = '970049663'

select * from APS.GeoCode
where [Student ID Number] = '970049663'

select * from aps.parentcontact
where [Student ID Number] = '970049663'

select * from aps.studentgrades
where SIS_NUMBER = '970049663'

select * from aps.studentimmunizations
where student_gu = '7A8654B0-0793-4774-80A7-D7803E623257'

select * from aps.studentpotentialrepeats
where sis_number = '970049663'

select * from aps.studentscheduledetails
where student_gu = '7A8654B0-0793-4774-80A7-D7803E623257'

select * from aps.studentSchoolofRecord
where student_gu = '7A8654B0-0793-4774-80A7-D7803E623257'

select * from aps.studenttesthistory
where sis_number = '970049663'

select * from aps.studenttruancy t
where t.[Student ID] = '970049663'

select * from rev.EGB_GRADEBOOKSUBJECTS

(FormatDateTime(Fields!COURSE_LEAVE_DATE.Value, DateFormat.ShortDate)

=Iif(IsNothing(Fields!COURSE_ENTER_DATE.Value), "", 
Fields!COURSE_LEAVE_DATE.Value)

--example of retrieving value from aps.lookuptable
--select [Language].VALUE_DESCRIPTION as StudentContactLanguage

--K12 is the namespace, Language is the argument
	--LEFT JOIN
	--APS.LookupTable ('K12',	'LANGUAGE') AS [Language]	
	--ON
	--sTUDENT.HOME_LANGUAGE = [Language].VALUE_CODE

	select * from aps.CumGPAForYear('2016')
	where SIS_NUMBER = '970049663'

	select * from aps.studenttestparcc('PARCC HS Geometry')
		where SIS_NUMBER = '970049663'

		select * from  aps.TITLE_1_HOMELESS_ASOF('2012-12-13')
		where school_name = 'Manzano High School'
 

 --
 select * from aps.StudentEnrollmentDetails
where sis_number = '970027417'
and school_year = '2015'
and extension = 'R' --0EA95017-53B0-4A7E-AB70-93D68334AA26


select * from aps.BasicStudentWithMoreInfo STU 
where stu.SIS_NUMBER = '100019603' --0EA95017-53B0-4A7E-AB70-93D68334AA26

select * from dbo.STUDENT_SCHOOL_MEMBERDAYS_2015 S where s.STUID = '104581293'
select * from dbo.STUDENT_ATTENDANCE_2015 where [SIS Number] = '104581293'

select * from dbo.STUDENT_ATTENDANCE_2014 where [SIS Number] = '104579099'

SELECT * FROM rev.EPC_STU_SCH_YR

--	LOOKUP TABLE
SELECT
		LookupValues.*
	FROM
		rev.REV_BOD_LOOKUP_DEF AS LookupDef
		INNER JOIN
		rev.REV_BOD_LOOKUP_VALUES As LookupValues
		ON
		LookupDef.LOOKUP_DEF_GU = LookupValues.LOOKUP_DEF_GU
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

	SELECT * FROM REV.EPC_STU_PGM_ell_wav WAIVER
	WHERE WAIVER.STU_PGM_ELL_WAV_GU = '970109590'

	select * from APS.PrimaryEnrollmentsAsOf('2016-12-19')
select * from APS.ScheduleAsOf('2016-12-19')
select * from APS.LCEClassesWithMoreInfoAsOf('2016-12-19')
select * from REV.EP_STUDENT_SPECIAL_ED
select * from APS.ELLAsOf('2016-12-19')
select * from APS.BasicStudent
select * from APS.LCELatestEvaluationAsOf('2016-12-19')
select * from rev.EPC_STU_TEST_PART
select * from rev.EPC_STU_TEST_PART_SCORE
select * from rev.EPC_TEST_DEF_SCORE
select * from rev.REV_PERSON
select * from REV.EP_STUDENT_SPECIAL_ED
select * from APS.LCEMostRecentALSRefusalAsOf('2016-12-19')

select * from aps.BasicStudentWithMoreInfo where STUDENT_GU = '4A9F4498-C98F-48BA-B452-3B92E00EC2D4'
	SELECT * FROM REV.EPC_STU_PGM_ell_wav waive where waive.STUDENT_GU = '4A9F4498-C98F-48BA-B452-3B92E00EC2D4'

	--find home room teacher
	select * from APS.BasicStudent bs where SIS_NUMBER = '970064618'

	select * from rev.epc_stu_sch_yr where student_gu = '40E73C91-414B-4EBC-8BC8-B0EA72B1543F'
	--FCA4F517-28B1-49DF-A260-DBDF6216DB72  homeroom section guid

	select primary_teacher from rev.epc_staff_sch_yr sy
	inner join aps.SectionsAndAllStaffAssigned ss on sy.homeroom_section_gu = ss.section_gu
	where homeroom_section_gu = 'FCA4F517-28B1-49DF-A260-DBDF6216DB72'
	select distinct homeroom_gu from rev.epc_staff_sch_yr where homeroom_gu like 'F%'


--get grade codes from look file
SELECT distinct value_code, value_description FROM 
APS.LookupTable('K12', 'GRADE')
order by value_code

select * from rev.epc_staff where BADGE_NUM = 'e211395' --9F899E44-0472-4F9E-AC07-2D234400337B
select * from rev.epc_staff_comp where staff_gu = '9F899E44-0472-4F9E-AC07-2D234400337B'

select saa.SECTION_GU, saa.STAFF_GU, saa.PRIMARY_TEACHER teacher from aps.StudentEnrollmentDetails sed
inner join aps.SectionsAndAllStaffAssigned saa on sed.HOMEROOM_SECTION_GU = saa.SECTION_GU
where sis_number = '970049663'

select * from rev.rev_person

select * from aps.

INNER JOIN
	rev.[EPC_STAFF] AS [STAFF]
	ON
	[SCHEDULE].[STAFF_GU] = [STAFF].[STAFF_GU]

	INNER JOIN
	rev.[REV_PERSON] AS [STAFF_PERSON]
	ON
	[STAFF].[STAFF_GU] = [STAFF_PERSON].[PERSON_GU]


--HOMEROOM_SECTION_GU from APS.StudentEnrollmentDetails
--SECTION_GU from APS.SectionsAndAllStaffAssigned
--STAFF_GU and SECTION_GU from APS.StudentScheduleDetails
--SCHEDULE_GU FROM APS.BasicSchedule
--STAFF_GU and PERSON_GU are the same

select * from aps.SectionsAndAllStaffAssigned where section_gu = '9A61CF8C-EDE8-41D6-A024-94F479946891' and PRIMARY_TEACHER = 'y'
select * from rev.rev_person p where p.PERSON_GU = 'BAE66CB1-49B8-4D2C-8950-B7918BF3910A'

--for elementary primary teacher will be Y
select
	 p.LAST_NAME, p.FIRST_NAME, saa.SECTION_GU, saa.STAFF_GU, saa.PRIMARY_TEACHER teacher
from
	 aps.StudentEnrollmentDetails sed
inner join
	 aps.SectionsAndAllStaffAssigned saa on sed.HOMEROOM_SECTION_GU = saa.SECTION_GU
inner join
	 rev.REV_PERSON p on p.PERSON_GU = saa.STAFF_GU
where
	 sis_number = '104033006'
	and sed.HOMEROOM_SECTION_GU = saa.SECTION_GU

select * from aps.SectionsAndAllStaffAssigned


			--select * from APS.BasicStudent bs where SIS_NUMBER = '104033006'
			--select * from rev.epc_stu_sch_yr where student_gu = 'F7D074E1-953A-4EFF-9576-5234C00915B0'
			----F1B45D5D-225B-49C9-973A-055FA37288BC (homeroom section gu)




select saa.SECTION_GU, saa.STAFF_GU, saa.PRIMARY_TEACHER, sed.HOMEROOM_SECTION_GU teacher from aps.StudentEnrollmentDetails sed
inner join aps.SectionsAndAllStaffAssigned saa on sed.HOMEROOM_SECTION_GU = saa.SECTION_GU
where sis_number = '104033006'
--and sed.HOMEROOM_SECTION_GU = '0BE526B7-2E77-4C5C-9029-DCDE92B4E25F'



select P.last_name, p.FIRST_NAME from rev.rev_person p where p.PERSON_GU = '5D089117-A6EB-4BCC-9C54-01AA478730BC'


