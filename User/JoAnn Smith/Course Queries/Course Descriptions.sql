select distinct lu.VALUE_CODE, lu.VALUE_DESCRIPTION
	--course.COURSE_ID,
	--course.COURSE_TITLE,
	--list.COURSE_LEVEL,
	--lu.VALUE_DESCRIPTION 
from rev.EPC_CRS as Course
inner join rev.EPC_CRS_LEVEL_LST as List
	on course.COURSE_GU = list.COURSE_GU
inner join aps.LookupTable ('K12.CourseInfo', 'Sced_Course_Level') as LU
	on LU.VALUE_CODE = List.COURSE_LEVEL
	where course.COURSE_ID = '0620911'
