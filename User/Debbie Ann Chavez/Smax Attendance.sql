

SELECT DISTINCT ID_NBR  FROM
DBTSIS.AT030_V AS ABS
WHERE
DST_NBR = 1
AND ABS.CAL_DT BETWEEN '20140105' AND '20140109'
AND SCH_YR = 2014
AND ABS.REAS_CD = 'IL'


SELECT DISTINCT ID_NBR  FROM
DBTSIS.AT020_V AS ABS
WHERE
DST_NBR = 1
AND ABS.CAL_DT BETWEEN '20140105' AND '20140109'
AND SCH_YR = 2014
AND ABS.REAS_CD = 'IL'