DECLARE @ALGEBRA TABLE(
COURSE VARCHAR (10)
)

INSERT INTO 
	@ALGEBRA
VALUES
 ('311001'),
 ('311002'),
 ('312001'),
 ('312002'),
 ('312101'),
 ('312102'),
 ('330400'),
 ('330401'),
 ('330402'),
 ('330403'),
 ('330471'),
 ('330472'),
 ('330801'),
 ('330802'),
 ('330811'),
 ('330812'),
 ('3304000'),
 ('060C41'),
 ('060C42'),
 ('061C1'),
 ('061C11'),
 ('061C12'),
 ('061C41'),
 ('061C42'),
 ('061C51'),
 ('061C52'),
 ('062C11'),
 ('062C12'),
 ('3110B1'),
 ('3110B'),
 ('3110D'),
 ('3110B2'),
 ('3110D1'),
 ('31100'),
 ('3110D2'),
 ('330401de1'),
 ('330401de2'),
 ('33040C'),
 ('33040C1'),
 ('33040C2'),
 ('33040DE1'),
 ('33040DE2'),
 ('33040DI1'),
 ('33040DI2'),
 ('3304A1'),
 ('3304A2'),
 ('MATH322')


 DECLARE @FLANG TABLE(
COURSE VARCHAR (10)
)

INSERT INTO 
	@FLANG
VALUES
	 ('600101'),
 ('600102'),
 ('600103'),
 ('60010de1'),
 ('60010de2'),
 ('600111'),
 ('600112'),
 ('600113'),
 ('60011de1'),
 ('60011de2'),
 ('600121'),
 ('600122'),
 ('60012de1'),
 ('60012de2'),
 ('600131'),
 ('600132'),
 ('60013de1'),
 ('60013de2'),
 ('600141'),
 ('600142'),
 ('60014de1'),
 ('60014de2'),
 ('6001i1'),
 ('6001i2'),
 ('6002i1'),
 ('6002i2'),
 ('6003i1'),
 ('6003i2'),
 ('6004i1'),
 ('6004i2'),
 ('605101'),
 ('605102'),
 ('605103'),
 ('60510c'),
 ('60510c1'),
 ('60510c2'),
 ('605111'),
 ('605112'),
 ('605113'),
 ('60511c'),
 ('60511c1'),
 ('60511c2'),
 ('605121'),
 ('605122'),
 ('60512c'),
 ('60512c1'),
 ('60512c2'),
 ('605131'),
 ('605132'),
 ('60513c1'),
 ('60513c2'),
 ('605141'),
 ('605142'),
 ('610101'),
 ('610102'),
 ('610103'),
 ('61010c1'),
 ('61010c2'),
 ('61010de1'),
 ('61010de2'),
 ('610111'),
 ('610112'),
 ('610113'),
 ('61011bl1'),
 ('61011bl2'),
 ('61011c1'),
 ('61011c2'),
 ('61011de1'),
 ('61011de2'),
 ('610121'),
 ('610122'),
 ('61012bl1'),
 ('61012bl2'),
 ('61012de1'),
 ('61012de2'),
 ('610131'),
 ('610132'),
 ('61013bl1'),
 ('61013bl2'),
 ('61013de1'),
 ('61013de2'),
 ('610141'),
 ('610142'),
 ('6101i1'),
 ('6101i2'),
 ('610251'),
 ('610252'),
 ('61025bl1'),
 ('61025bl2'),
 ('610261'),
 ('610262'),
 ('61026bl1'),
 ('61026bl2'),
 ('61026de1'),
 ('61026de2'),
 ('610271'),
 ('610272'),
 ('610281'),
 ('610282'),
 ('610291'),
 ('610292'),
 ('6102i1'),
 ('6102i2'),
 ('610301'),
 ('610302'),
 ('610311'),
 ('610312'),
 ('6103i1'),
 ('6103i2'),
 ('6104i1'),
 ('6104i2'),
 ('610501'),
 ('610502'),
 ('610511'),
 ('610512'),
 ('611101'),
 ('611102'),
 ('61110c1'),
 ('61110c2'),
 ('61110c3'),
 ('61110c4'),
 ('611111'),
 ('611112'),
 ('61111c1'),
 ('61111c2'),
 ('61111c3'),
 ('61111c4'),
 ('611121'),
 ('611122'),
 ('61112c'),
 ('61112c1'),
 ('61112c2'),
 ('615101'),
 ('615102'),
 ('615111'),
 ('615112'),
 ('615121'),
 ('615122'),
 ('615131'),
 ('615132'),
 ('615141'),
 ('615142'),
 ('620101'),
 ('620102'),
 ('620111'),
 ('620112'),
 ('621112'),
 ('621122'),
 ('621132'),
 ('625c0c'),
 ('625c0c1'),
 ('625c0c2'),
 ('625c3c'),
 ('625c3c1'),
 ('625c3c2'),
 ('626c0c'),
 ('626c3c'),
 ('627c0c'),
 ('627c3c'),
 ('628c0c'),
 ('628c3c'),
 ('629c0c1'),
 ('629c0c2'),
 ('629c3c1'),
 ('629c3c2'),
 ('630101'),
 ('630102'),
 ('630111'),
 ('630112'),
 ('630121'),
 ('630122'),
 ('630131'),
 ('630132'),
 ('630141'),
 ('630142'),
 ('631101'),
 ('631102'),
 ('631121'),
 ('631122'),
 ('632c0c'),
 ('632c1c'),
 ('632c2c'),
 ('632c3c'),
 ('632c4c'),
 ('632c5c'),
 ('632c6c'),
 ('632c7c'),
 ('632c8c'),
 ('632c9c'),
 ('633c0c1'),
 ('633c0c2'),
 ('63510de1'),
 ('63510de2'),
 ('63520de1'),
 ('63520de2'),
 ('63530de1'),
 ('63530de2'),
 ('63540de1'),
 ('63540de2'),
 ('635c3c1'),
 ('635c3c2'),
 ('635c4c1'),
 ('635c4c2'),
 ('635c5c1'),
 ('635c5c2'),
 ('635c6c1'),
 ('635c6c2'),
 ('635c7c1'),
 ('635c7c2'),
 ('635c8c1'),
 ('635c8c2'),
 ('635c9c1'),
 ('635c9c2'),
 ('636011'),
 ('636012'),
 ('644111'),
 ('644112')

 
   SELECT 
	DEPARTMENT 
	,SUM(CASE WHEN FAILURES = 1 THEN 1 ELSE 0 END) AS COUNT_FAILURES
	,COUNT (*) AS DENOMINATOR
	,CAST(CAST(SUM(CASE WHEN FAILURES = 1 THEN 1 ELSE 0 END)AS NUMERIC (16,6)) / CAST(COUNT(*)AS NUMERIC (16,6)) AS DECIMAL (18,2)) AS PERCENTAGE_OF_FAILURES
FROM
(


SELECT 
	CALENDAR_YEAR
	,CASE WHEN ORG.ORGANIZATION_NAME IS NOT NULL THEN ORG.ORGANIZATION_NAME ELSE ORG2.ORGANIZATION_NAME END AS SCHOOL
	,SIS_NUMBER
	,HIST.COURSE_ID
	,HIST.COURSE_TITLE
	,TERM_CODE
	,MARK
	,CASE WHEN FLANG.COURSE IS NOT NULL THEN 'FLANG'
		  WHEN ALGEBRA.COURSE IS NOT NULL THEN 'ALG' ELSE DEPARTMENT END AS DEPARTMENT
	,CASE WHEN MARK = 'F' THEN 1 ELSE 0 END AS FAILURES
		
 FROM 
rev.EPC_STU_CRS_HIS AS HIST
INNER JOIN
rev.EPC_STU AS STU
ON
HIST.STUDENT_GU = STU.STUDENT_GU
INNER JOIN
rev.EPC_CRS AS CRS
ON
HIST.COURSE_GU = CRS.COURSE_GU


LEFT JOIN
@ALGEBRA AS ALGEBRA
ON
ALGEBRA.COURSE = HIST.COURSE_ID

LEFT JOIN
@FLANG AS FLANG
ON
FLANG.COURSE = HIST.COURSE_ID


LEFT JOIN
rev.REV_ORGANIZATION AS ORG
ON
ORG.ORGANIZATION_GU = HIST.SCHOOL_IN_DISTRICT_GU

LEFT JOIN
rev.REV_ORGANIZATION AS ORG2
ON
ORG2.ORGANIZATION_GU = HIST.SCHOOL_NON_DISTRICT_GU

WHERE
--HIST.STUDENT_GU = 'A33C78F4-2C03-4434-8113-6280F7802499'
--AND
CALENDAR_YEAR IN ('2014')
 AND HIST.COURSE_HISTORY_TYPE = 'HIGH'
--AND MARK = 'F'
AND TERM_CODE IN ('T1', 'S1')

--ORDER BY SIS_NUMBER, CALENDAR_YEAR

) AS T1

GROUP BY DEPARTMENT
