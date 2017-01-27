--note this takes 8 1/2 minutes to run


EXECUTE AS LOGIN='QueryFileUser'
GO


SELECT 
		t1.*
		,BS.FIRST_NAME as FRST_NME
		,BS.LAST_NAME as LST_NME
		,T1.APS_ID as APS_ID
		,BS.STATE_STUDENT_NUMBER as STATE_ID
		,ESO.SCHOOL_TYPE
		,PRIM.SCHOOL_YEAR AS SY
		,'FALL' as Semester
		,PRIM.GRADE AS GRDE
		,PRIM.SCHOOL_CODE as SCH_NBR
		,PRIM.SCHOOL_NAME as SCH_NME
		,CASE WHEN ESO.SCHOOL_TYPE = '2'
			THEN (SELECT GPA.[MS Cum Flat] FROM APS.CUMGPA AS GPA WHERE GPA.SIS_NUMBER = BS.SIS_NUMBER) 
		END AS MS_FLAT_GPA
		,CASE WHEN ESO.SCHOOL_TYPE = '3'
			THEN (SELECT GPA.[HS Cum Flat] FROM APS.CUMGPA GPA WHERE GPA.SIS_NUMBER = BS.SIS_NUMBER)
		END as HS_FLAT_GPA
		,CASE WHEN ESO.SCHOOL_TYPE = '3'
			THEN (SELECT GPA.[HS Cum Weighted] FROM APS.CUMGPA GPA WHERE GPA.SIS_NUMBER = BS.SIS_NUMBER) 
		END AS HS_WEIGHTED_GPA       
FROM
	OPENROWSET (
		'Microsoft.ACE.OLEDB.12.0', 
		'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
		'SELECT * from LutheranFamilysERVICESRequest.csv'
                ) AS [T1]

LEFT JOIN
		APS.BasicStudentWithMoreInfo AS BS
		ON T1.APS_ID = BS.SIS_NUMBER

LEFT JOIN 
       APS.PrimaryEnrollmentDetailsAsOf(GETDATE()) AS PRIM
       ON BS.STUDENT_GU = PRIM.STUDENT_GU 

LEFT JOIN
		APS.CumGPA GPA
		ON bs.SIS_NUMBER = gpa.SIS_NUMBER

Left join
		REV.EPC_SCH_YR_OPT ESO
		ON ESO.ORGANIZATION_YEAR_GU = PRIM.ORGANIZATION_YEAR_GU
ORDER BY
	LAST_NAME, FRST_NME

       
REVERT
GO


