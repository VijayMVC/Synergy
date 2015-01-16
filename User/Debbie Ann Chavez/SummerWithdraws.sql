

SELECT * FROM
(
SELECT SIS_NUMBER, SCHOOL_YEAR, NO_SHOW_STUDENT, SUMMER_WITHDRAWL_CODE, SUMMER_WITHDRAWL_DATE, ENTER_DATE, LEAVE_DATE, ORGANIZATION_GU
FROM
rev.EPC_STU_SCH_YR AS SSY
INNER JOIN
rev.EPC_STU AS STU
ON
SSY.STUDENT_GU = STU.STUDENT_GU
INNER JOIN
rev.REV_ORGANIZATION_YEAR AS ORGYR
ON
ORGYR.ORGANIZATION_YEAR_GU = SSY.ORGANIZATION_YEAR_GU
INNER JOIN
rev.REV_YEAR AS YRS
ON
ORGYR.YEAR_GU = YRS.YEAR_GU

WHERE
 SCHOOL_YEAR = '2014'
 AND SUMMER_WITHDRAWL_CODE IS NOT NULL
 AND EXTENSION = 'R'
 ) AS SUMMERWITHDRAWS

 INNER JOIN
(
SELECT SIS_NUMBER, SCHOOL_YEAR, NO_SHOW_STUDENT, ENTER_DATE, LEAVE_DATE, ORGANIZATION_GU
FROM
rev.EPC_STU_SCH_YR AS SSY
INNER JOIN
rev.EPC_STU AS STU
ON
SSY.STUDENT_GU = STU.STUDENT_GU
INNER JOIN
rev.REV_ORGANIZATION_YEAR AS ORGYR
ON
ORGYR.ORGANIZATION_YEAR_GU = SSY.ORGANIZATION_YEAR_GU
INNER JOIN
rev.REV_YEAR AS YRS
ON
ORGYR.YEAR_GU = YRS.YEAR_GU

WHERE
 SCHOOL_YEAR = '2014'
 AND ENTER_DATE = '2014-08-13'
 AND LEAVE_DATE IS NULL
 ) AS ENROLLED

 ON
 SUMMERWITHDRAWS.SIS_NUMBER = ENROLLED.SIS_NUMBER
 AND SUMMERWITHDRAWS.ORGANIZATION_GU = ENROLLED.ORGANIZATION_GU



