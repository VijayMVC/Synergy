

SELECT * FROM
rev.REV_AUDIT_TRAIL AS TRAIL
INNER JOIN
rev.REV_AUDIT_TRAIL_PROP AS PROP
ON
TRAIL.AUDIT_TRAIL_GU = PROP.AUDIT_TRAIL_GU
WHERE 
 APPLICATION_CONTEXT = 'View: K12.SpecialEd.NM.StudentIEP.NM'