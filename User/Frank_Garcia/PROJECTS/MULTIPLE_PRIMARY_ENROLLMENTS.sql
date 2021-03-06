
SELECT
	T1.SCHOOL_YEAR
	,T1.SIS_NUMBER
	,T1.STATE_STUDENT_NUMBER
	,T1.LAST_NAME
	,T1.FIRST_NAME
	,T1.ORGANIZATION_NAME
	,T1.SCHOOL_CODE
	,T1.ENTER_DATE
	,T1.ENTER_CODE
	,CASE WHEN T1.LEAVE_DATE IS NULL THEN '' ELSE T1.LEAVE_DATE
	END AS LEAVE_DATE
	--,T1.GRADE
	,CASE WHEN T1.EXCLUDE_ADA_ADM IS NULL THEN '' ELSE T1.EXCLUDE_ADA_ADM
	END AS EXCLUDE_ADA_ADM
	--,T1.STUDENT_SCHOOL_YEAR_GU
	--,T1.CurrentPrimarySSY
	--,T1. RowedSSY
FROM
(
SELECT
	STU.SIS_NUMBER
	,ROW_NUMBER() OVER (PARTITION BY STU.SIS_NUMBER, ENROLLMENT.ENTER_CODE ORDER BY Enrollment.ENTER_DATE) AS RowedSSY
FROM
	rev.EPC_STU_ENROLL AS Enrollment
	INNER JOIN
	rev.EPC_STU_SCH_YR AS SSY
	ON
	Enrollment.STUDENT_SCHOOL_YEAR_GU = SSY.STUDENT_SCHOOL_YEAR_GU

	INNER JOIN
	rev.REV_ORGANIZATION_YEAR AS OrgYear
	ON
	SSY.ORGANIZATION_YEAR_GU = OrgYear.ORGANIZATION_YEAR_GU

	JOIN
	REV.REV_ORGANIZATION ORG
	ON ORG.ORGANIZATION_GU = OrgYear.ORGANIZATION_GU

	JOIN 
	REV.REV_YEAR YR
	ON YR.YEAR_GU = SSY.YEAR_GU

	JOIN
	REV.EPC_STU STU
	ON STU.STUDENT_GU = SSY.STUDENT_GU

	JOIN 
	REV.REV_PERSON PER
	ON PER.PERSON_GU = STU.STUDENT_GU

	LEFT JOIN
	rev.EPC_STU_YR AS SOR
	ON
	Enrollment.STUDENT_SCHOOL_YEAR_GU = SOR.STU_SCHOOL_YEAR_GU
WHERE
	SSY.YEAR_GU = ('F7D112F7-354D-4630-A4BC-65F586BA42EC')
	AND Enrollment.ENTER_CODE = 'FIRST'
	--AND Enrollment.LEAVE_DATE IS NULL
	AND Enrollment.EXCLUDE_ADA_ADM IS NULL
) TT

JOIN
	(
	SELECT
	YR.SCHOOL_YEAR
	,ORG.ORGANIZATION_NAME
	,SCH.SCHOOL_CODE
	,STU.SIS_NUMBER
	,STU.STATE_STUDENT_NUMBER
	,PER.LAST_NAME
	,PER.FIRST_NAME
	,Enrollment.ENTER_DATE
	,Enrollment.LEAVE_DATE
	,Enrollment.ENTER_CODE
	,Enrollment.GRADE
	,Enrollment.EXCLUDE_ADA_ADM
	,Enrollment.STUDENT_SCHOOL_YEAR_GU
	,CASE WHEN SOR.STU_SCHOOL_YEAR_GU IS NOT NULL THEN 'Y' END AS CurrentPrimarySSY
	,ROW_NUMBER() OVER (PARTITION BY STU.SIS_NUMBER, ENROLLMENT.ENTER_CODE ORDER BY Enrollment.ENTER_DATE) AS RowedSSY
FROM
	rev.EPC_STU_ENROLL AS Enrollment
	INNER JOIN
	rev.EPC_STU_SCH_YR AS SSY
	ON
	Enrollment.STUDENT_SCHOOL_YEAR_GU = SSY.STUDENT_SCHOOL_YEAR_GU

	INNER JOIN
	rev.REV_ORGANIZATION_YEAR AS OrgYear
	ON
	SSY.ORGANIZATION_YEAR_GU = OrgYear.ORGANIZATION_YEAR_GU

	JOIN
	REV.REV_ORGANIZATION ORG
	ON ORG.ORGANIZATION_GU = OrgYear.ORGANIZATION_GU

	JOIN 
	REV.EPC_SCH SCH
	ON SCH.ORGANIZATION_GU = ORG.ORGANIZATION_GU

	JOIN 
	REV.REV_YEAR YR
	ON YR.YEAR_GU = SSY.YEAR_GU

	JOIN
	REV.EPC_STU STU
	ON STU.STUDENT_GU = SSY.STUDENT_GU

	JOIN 
	REV.REV_PERSON PER
	ON PER.PERSON_GU = STU.STUDENT_GU

	LEFT JOIN
	rev.EPC_STU_YR AS SOR
	ON
	Enrollment.STUDENT_SCHOOL_YEAR_GU = SOR.STU_SCHOOL_YEAR_GU
WHERE
	SSY.YEAR_GU = ('F7D112F7-354D-4630-A4BC-65F586BA42EC')
	AND Enrollment.ENTER_CODE = 'FIRST'
	--AND Enrollment.LEAVE_DATE IS NULL
	AND Enrollment.EXCLUDE_ADA_ADM IS NULL
) T1
ON T1.SIS_NUMBER = TT.SIS_NUMBER
WHERE 1 = 1
AND TT.RowedSSY > 1
--AND SIS_NUMBER IN ('980023887','980037339')
ORDER BY SIS_NUMBER