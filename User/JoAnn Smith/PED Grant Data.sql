/*

JoAnn � can you please work on pulling this data for Kathryn next.  The final deliverable for this request
will be a modified version of the ATD-1301, but Kathryn needs the data fields in the columns on the attached
spreadsheet that have a red YES in them.  The data is needed for all active 17-18 students including any grades
you can find (progress) so far this year.  
Student Name
Student ID
School Name
Grade
Does student have an IEP or 504 plan? 
504 in REV.EPC_STU_SCH_YR (ACCESS_504)
IEP - REV.EP_STUDENT_SPECIAL_ED NEXT_IEP_DATE WHERE EXIT_DATE IS NULL OR EXIT_DATE >= CONVERT(DATE, GETDATE())
ep_student_iep
Quarter 1 grades in Language Arts and Math 
Suspension days - August/September/  rev.epc_stu_inc_discipline

NOTE:  grab REASSIGNMENT DAYS INSTEAD OF DAYS FOR TOTAL DISCIPLINE DAYS FOR THE CODES NEEDED IN THE WHERE CLAUSE

THIS TAKES 23 MINUTES TO RUN 

*/

--SELECT * FROM APS.BasicStudent WHERE STUDENT_GU = '4DADB940-8A51-4D40-9534-0000279F0E6B'
--select * from rev.EP_STUDENT_SPECIAL_ED where NEXT_IEP_DATE is not null
--select * from aps.StudentGrades where SIS_NUMBER = 104179254
--select * from rev.EPC_STU_INC_DISCIPLINE
--select * from aps.BasicStudent where student_gu = '6DF3ED3C-6021-4D24-B640-0002B352AFE0'

--select * from rev.ep_student_iep where student_gu = '6DF3ED3C-6021-4D24-B640-0002B352AFE0'
--select * from aps.LookupTable('K12.SpecialEd', 'DISABILITY_CODE') LU
--INNER JOIN
--REV.EP_STUDENT_IEP I
--ON 
--I.PRIMARY_DISABILITY_CODE = LU.VALUE_CODE

;with All_Students
as
(
select
	ped.SCHOOL_YEAR,
	ped.EXTENSION,
	ped.STUDENT_GU,
	ped.STUDENT_SCHOOL_YEAR_GU,
	ped.GRADE,
	ped.SCHOOL_NAME
from
	aps.PrimaryEnrollmentDetailsAsOf(getdate()) ped
)
--select * from All_Students where student_gu = '09BD273F-D418-4EA9-BDE3-48F350160112'
,IEP
AS
(
select
	row_number() over(partition by s.STUDENT_GU order by s.STUDENT_GU) AS rn,
	s.STUDENT_GU,
	case 
		when(se.NEXT_IEP_DATE IS NOT NULL) then 'Y'
		ELSE
		'N'
	END AS HAS_IEP
from
	All_Students s
inner join
	rev.EP_STUDENT_SPECIAL_ED se
on
	se.STUDENT_GU = s.student_gu
left join
	rev.epc_stu_sch_yr ssy
on
	s.STUDENT_GU = ssy.STUDENT_GU
left join
	aps.basicstudent bs
on
	s.student_gu = bs.student_gu	
where
	se.PRIMARY_DISABILITY_CODE != 'GI'
)
,SEC_504
as
(
select
	row_number() over(partition by s.STUDENT_GU order by s.STUDENT_GU) AS rn,
	s.STUDENT_GU,
	case
		when(ssy.ACCESS_504 = '10') then '504 ON FILE'
		else
		'NOT ON FILE'
	END AS ACCESS_504
from
	All_Students s
inner join
	rev.epc_stu_sch_yr ssy
on
	s.STUDENT_GU = ssy.STUDENT_GU
inner join
	aps.basicstudent bs
on
	s.student_gu = bs.student_gu	
)
--SELECT * FROM sec_504 WHERE RN = 1  and access_504 = '504 ON FILE'

,Student_Grades
as
(
select
	row_number() over(partition by s.STUDENT_GU, COURSE_ID, GRADE_PERIOD ORDER BY S.STUDENT_GU, GRADE_PERIOD DESC) AS RN,
	s.STUDENT_GU,
	g.SIS_NUMBER,
	g.MARK,
	g.GRADE_PERIOD,
	g.COURSE_ID,
	g.COURSE_TITLE
from
	All_Students s
left join
	aps.StudentGrades g
on
	s.STUDENT_GU = g.STUDENT_GU
where
	g.DEPARTMENT in ('ENG', 'MATH')
)
--select * from Student_Grades
,Grade_Results
as
(
select
	g.STUDENT_GU,
	g.SIS_NUMBER,
	g.MARK,
	g.GRADE_PERIOD,
	g.COURSE_ID,
	g.COURSE_TITLE 
from
	 Student_Grades g
WHERE
	 RN = 1
)
--select * from Grade_Results
,Final_Results
as
(
select
	row_number() over(partition by a.SIS_NUMBER, course_id order by a.SIS_NUMBER, GRADE_PERIOD DESC) as rn,
	a.SIS_NUMBER,
	a.STUDENT_GU,
	a.LAST_NAME,
	a.FIRST_NAME,
	s.SCHOOL_YEAR,
	s.EXTENSION,
	s.SCHOOL_NAME,
	s.GRADE,
	case
		when (i.HAS_IEP is null) then 'N'
		else
		i.HAS_IEP
	end as HAS_IEP,
	case	
		when (s5.ACCESS_504 is null) then 'NOT ON FILE'
	else
		s5.ACCESS_504
	end as ACCESS_504,
	g.COURSE_ID,
	g.COURSE_TITLE,
	g.MARK,
	g.GRADE_PERIOD
	--d.DISP_CODE,
	--convert(VARCHAR(10), D.DISPOSITION_START_DATE, 101) AS DISPOSITION_START_DATE,
	--CONVERT(VARCHAR(10), d.DISPOSITION_END_DATE, 101) as DISPOSITION_END_DATE,
	--d.SUSPENSION_DAYS,
	--d.DESCRIPTION


from
	All_Students s
left join
	IEP i
on
	s.STUDENT_GU = i.STUDENT_GU
left join
	SEC_504 s5
on
	s.STUDENT_GU = s5.STUDENT_GU
--full outer join
--	Suspension_Days d
--on
--	s.STUDENT_GU = d.STUDENT_GU
left join
	aps.BasicStudent a
on
	a.STUDENT_GU = s.STUDENT_GU
left join
	 Student_Grades G
on
	g.STUDENT_GU = s.STUDENT_GU
)
--select * from Final_Results WHERE RN = 1 
,Suspension_Days
as
(
select	
	d.STUDENT_GU,
	--d.STUDENT_SCHOOL_YEAR_GU,
	--CAST(d.INCIDENT_ROLE_DESC AS VARCHAR(MAX)) AS INCIDENT_ROLE,
	--d.DAYS,
	SUM(Disposition.REASSIGNMENT_DAYS) AS SUSPENSION_DAYS,
	Disposition.DISPOSITION_START_DATE,
	Disposition.DISPOSITION_END_DATE,
	Disposition_Code.DISP_CODE,
	Disposition_Code.DESCRIPTION,
	cast(Disposition.ADDITIONAL_TEXT AS  NVARCHAR(MAX)) AS DISPOSITION
	--d.SUSP_CONFERENCE_DATE,
	--d.SUSP_CONFERENCE
	--yr.SCHOOL_YEAR,
	--yr.extension
from
	All_Students s
left join
	rev.EPC_STU_INC_DISCIPLINE D
on
	s.STUDENT_GU = d.STUDENT_GU

LEFT OUTER JOIN
	rev.EPC_SCH_INCIDENT AS [INCIDENT]
ON
	D.[SCH_INCIDENT_GU] = [INCIDENT].[SCH_INCIDENT_GU]
	    
LEFT OUTER JOIN
	[rev].[EPC_STU_INC_DISPOSITION] AS [Disposition]
ON
	d.[STU_INC_DISCIPLINE_GU] = Disposition.STU_INC_DISCIPLINE_GU
	    
LEFT OUTER JOIN
	[rev].[EPC_CODE_DISP] AS [Disposition_Code]
ON
[Disposition].[CODE_DISP_GU] = [Disposition_Code].[CODE_DISP_GU]
left join
	rev.EPC_STU_SCH_YR ssy
on
	ssy.STUDENT_SCHOOL_YEAR_GU = d.STUDENT_SCHOOL_YEAR_GU
left join
	rev.REV_ORGANIZATION_YEAR oy
on
	ssy.ORGANIZATION_YEAR_GU = oy.ORGANIZATION_YEAR_GU
left join
	rev.rev_year yr 
on
	oy.YEAR_GU = yr.YEAR_GU
where
	yr.SCHOOL_YEAR = '2017'
and
	yr.EXTENSION = 'R'
and
	[Disposition_Code].[DISP_CODE] IN ('S OSS','S ISS', 'S BUS', 'S EXTRA')

GROUP BY
	D.STUDENT_GU,
	Disposition.DISPOSITION_START_DATE,
	disposition.DISPOSITION_END_DATE,
	CAST(DISPOSITION.ADDITIONAL_TEXT AS NVARCHAR(MAX)),
	Disposition_Code.DISP_CODE,
	Disposition_Code.DESCRIPTION

)		
--SELECT * FROM suspension_days where student_gu = '2E679F28-0212-44B8-A3A5-CBBEF0DA5A72'
--ORDER BY STUDENT_GU
,
SUSPENSIONS
AS
(
select 
	row_number() over(partition by F.SIS_NUMBER, DISPOSITION_START_DATE order by F.SIS_NUMBER) as ROWNUM,
	F.SIS_NUMBER,
	f.LAST_NAME,
	f.FIRST_NAME,
	isnull(d.DISP_CODE,'') as DISP_CODE,
	isnull(convert(VARCHAR(10), D.DISPOSITION_START_DATE, 101), '') AS DISPOSITION_START_DATE,
	isnull(CONVERT(VARCHAR(10), d.DISPOSITION_END_DATE, 101), '') as DISPOSITION_END_DATE,
	ISNULL(d.SUSPENSION_DAYS,0) AS SUSPENSION_DAYS,
	ISNULL(d.DESCRIPTION, '') AS DESCRIPTION

from
	 Final_Results f
LEFT OUTER join
	Suspension_Days d
on
	d.STUDENT_GU = f.STUDENT_GU
where RN = 1 
--AND
--	SIS_NUMBER = 468772819
)
SELECT
	*
FROM
	SUSPENSIONS
WHERE ROWNUM = 1 

ORDER BY SIS_NUMBER,
DISPOSITION_START_DATE

