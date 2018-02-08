SELECT 
	COURSE_ID
	,COURSE_TITLE
	,COURSE_SHORT_TITLE
	,DEPARTMENT
	,DEPARTMENT_CODE
	,SUBJECT_AREA_1
	,SUBJECT_AREA_2
	,SUBJECT_AREA_3
	,H.COURSE_LEVEL
	,CRS.STATE_COURSE_CODE 
FROM
	rev.EPC_CRS CRS

LEFT JOIN
	REV.EPC_CRS_LEVEL_LST AS H
	ON CRS.COURSE_GU = H.COURSE_GU
	--WHERE CRS.STATE_COURSE_CODE IS NOT NULL
	AND DEPARTMENT != 'MATH'
WHERE H.COURSE_LEVEL = 'GFT'
	--OR (COURSE_TITLE LIKE '%ALG%' OR COURSE_TITLE LIKE '%GEOM%')
ORDER BY COURSE_TITLE