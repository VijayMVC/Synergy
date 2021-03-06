/*
Created By:   Debbie Ann Chavez
Date:  11/11/2015
*/


/*
BEGIN TRANSACTION

UPDATE rev.EGB_REPORTCARDSCORES
SET MARK = ''
*/

select 
stu.STUDENTID
,T1.SIS_NUMBER
,T1.ORGANIZATION_NAME
,(tch.LASTNAME + ', ' + tch.FIRSTNAME) as TEACHER
,(stu.LASTNAME + ', ' + stu.FIRSTNAME) as STUDENT
, rci.ITEM
--, rcs.MARK 
,per.PERIOD
,rcs.*

from 
rev.EGB_REPORTCARDSCORES rcs
join rev.EGB_PEOPLE stu on stu.ID = rcs.STUDENTID
join rev.EGB_SCHOOLYEAR sy on sy.ID = rcs.SCHOOLYEARID
join rev.EGB_REPORTCARDITEMS rci on rci.ID = rcs.REPORTCARDITEMID
join rev.EGB_PEOPLE tch on tch.ID = rcs.TEACHERID
join rev.EGB_PERIODS per on per.ID = rcs.PERIODID

LEFT JOIN 
(SELECT ORGANIZATION_NAME, SIS_NUMBER FROM 
APS.LatestPrimaryEnrollmentInYear('BCFE2270-A461-4260-BA2B-0087CB8EC26A') AS PRIM
INNER JOIN 
rev.EPC_STU AS STU 
ON 
PRIM.STUDENT_GU = STU.STUDENT_GU
INNER JOIN
rev.REV_ORGANIZATION_YEAR AS ORGYR
ON
PRIM.ORGANIZATION_YEAR_GU = ORGYR.ORGANIZATION_YEAR_GU
INNER JOIN
rev.REV_ORGANIZATION AS ORG
ON
ORGYR.ORGANIZATION_GU = ORG.ORGANIZATION_GU

) AS T1

ON
T1.SIS_NUMBER = stu.STUDENTID

where 
	PERIOD IN ('Tri 2 Grade', 'Tri 3 Grade')

	AND ITEM NOT IN (
	'Access Score:'
	,'SP LAS Links Score:'
	,'ESL/ELD'
	,'SSL'
	,'SLA'
	,'Navajo'
	,'Uses English and or'
	,'Reading Interim Assessment'
	)
	AND ORGANIZATION_NAME LIKE '%Elementary%'

--sy.ID = @SchoolyearID
--and per.ID = @GradingPeriodID
--group by tch.LASTNAME,  tch.FIRSTNAME, stu.LASTNAME, stu.FIRSTNAME, rci.SEQ, rci.ITEM, rcs.MARK, per.PERIOD, stu.STUDENTID, stu.PEOPLETYPEID
--order by tch.LASTNAME,  tch.FIRSTNAME, stu.LASTNAME, stu.FIRSTNAME, rci.SEQ, rcs.MARK


--ROLLBACK