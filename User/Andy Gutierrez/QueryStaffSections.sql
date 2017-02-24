

SELECT ORGANIZATION_NAME, SECTION_ID, STF.BADGE_NUM
FROM 
rev.EPC_SCH_YR_SECT AS SECT
INNER JOIN 
rev.REV_ORGANIZATION_YEAR AS ORGYR
ON
SECT.ORGANIZATION_YEAR_GU = ORGYR.ORGANIZATION_YEAR_GU
INNER JOIN 
rev.REV_ORGANIZATION AS ORG
ON
ORGYR.ORGANIZATION_GU = ORG.ORGANIZATION_GU
INNER JOIN 
rev.EPC_STAFF_SCH_YR AS SFTYR
ON
SFTYR.STAFF_SCHOOL_YEAR_GU = SECT.STAFF_SCHOOL_YEAR_GU

INNER JOIN
rev.EPC_STAFF AS STF
ON
SFTYR.STAFF_GU = STF.STAFF_GU

WHERE
SECT.STAFF_SCHOOL_YEAR_GU = '9120E771-E30E-4911-8901-B957563FC6BE'