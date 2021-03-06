/****** Script for SelectTopNRows command from SSMS  ******/
--SELECT TOP 1000 [Student APS ID]
--      ,[PARCC MATHEMATICS Overall Performance Level]
--      ,[PARCC ELA Overall Performance Level]
--  FROM [ST_Daily].[dbo].[PARCC_ELA_MATH_2015]
   
  --SELECT * FROM dbo.Active_Military_2014 a
  --left join
  --dbo.dbo.dibels_2014 d
  --on
  --a.

  --select * from rev.EPC_STU_CRS_HIS
  --select * from rev.epc_crs
  --select * from aps.StudentEnrollmentDetails sed where sed.SIS_NUMBER = 970022625

  ;with Main
as

	(select
		row_number() over (partition by h.student_gu, h.course_id, h.term_code order by h.student_gu) as RN,
		bs.SIS_NUMBER,
		h.student_gu,
		
		h.SCHOOL_IN_DISTRICT_GU,
		h.SCHOOL_NON_DISTRICT_GU,
		o.ORGANIZATION_gu,
		o.ORGANIZATION_NAME,	
		bs.LAST_NAME,
		bs.FIRST_NAME,
		s.grade,
		h.course_id AS COURSE_ID,
		h.course_title AS COURSE_TITLE,
		--h.CREDIT_ATTEMPTED as CRS_HIST_CREDIT_ATTEMPTED,
		h.CREDIT_COMPLETED as CRS_HIS_CREDIT_COMPLETED,
		c.CREDIT as DCM_CREDIT,
		H.TERM_CODE,
		H.SCHOOL_YEAR,
		h.calendar_year
	from
		rev.epc_stu_crs_his h
	inner join
		rev.epc_crs C
	on
		h.course_gu = c.course_gu
	inner join
		aps.StudentEnrollmentDetails s
	on
		s.student_gu = h.student_gu
	left join
		aps.BasicStudent bs
	on
		bs.STUDENT_GU = h.student_gu
	inner join
		rev.REV_ORGANIZATION_YEAR y
	on
		s.ORGANIZATION_YEAR_GU = y.ORGANIZATION_YEAR_GU 
	INNER JOIN
		REV.REV_ORGANIZATION O
	ON
		(case
			when h.SCHOOL_IN_DISTRICT_GU is not null then h.SCHOOL_IN_DISTRICT_GU
			when h.SCHOOL_NON_DISTRICT_GU is not null then h.SCHOOL_NON_DISTRICT_GU
		end) = o.organization_gu
		
	where 1 = 1
	AND
		h.CREDIT_COMPLETED <> c.CREDIT
	and
		h.credit_completed > 0
	and
		s.grade in ('09', '10', '11', '12') 			
)
select
	*
from
	Main m
where rn = 1
order by SCHOOL_YEAR, STUDENT_GU, grade, course_id, term_code
--select * from rev.epc_stu_crs_his where student_gu = 'F48B8894-2201-434D-9685-004CE81A74C7'

