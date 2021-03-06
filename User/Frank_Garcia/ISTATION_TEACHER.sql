

SELECT
    distinct
	SCH.SCHOOL_CODE AS campus_id
	,PER.FIRST_NAME AS tfname
	,PER.LAST_NAME AS tlname
	,PER.EMAIL AS email
	,STF.STATE_ID AS tid
	,LEFT(PER.FIRST_NAME, 1) + PER.LAST_NAME AS tlogin_id
	,'' AS grade
	,CASE WHEN STF.TYPE = 'SSS' THEN 'Y' ELSE 'N' END 
	 AS ismgr
	--,YR.SCHOOL_YEAR
	--,stf.TYPE
	
FROM
	REV.EPC_STAFF AS STF
	JOIN
	REV.EPC_STAFF_SCH_YR SYR
	ON SYR.STAFF_GU = STF.STAFF_GU
	JOIN
	REV.REV_ORGANIZATION_YEAR OYR 
	ON OYR.ORGANIZATION_YEAR_GU = SYR.ORGANIZATION_YEAR_GU
	JOIN
	REV.REV_YEAR AS YR
	ON YR.YEAR_GU = OYR.YEAR_GU
	JOIN
	REV.REV_ORGANIZATION AS ORG 
	ON ORG.ORGANIZATION_GU = OYR.ORGANIZATION_GU
	JOIN
	REV.EPC_SCH AS SCH
	ON SCH.ORGANIZATION_GU = OYR.ORGANIZATION_GU
	JOIN
	REV.REV_PERSON AS PER
	ON PER.PERSON_GU = STF.STAFF_GU



WHERE 1 = 1
AND STF.TYPE IN ('TE','SSS')
--AND LAST_NAME = 'ST JOHN'
AND YR.SCHOOL_YEAR = '2016'
AND (SCH.SCHOOL_CODE BETWEEN '200' AND '400' OR SCH.SCHOOL_CODE = '496')
AND PER.FIRST_NAME NOT IN ('TEACHER','PLACEMENT')
--AND SCH.SCHOOL_CODE = '329'
ORDER BY PER.FIRST_NAME



