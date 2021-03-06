
EXECUTE AS LOGIN='QueryFileUser'
GO

BEGIN TRANSACTION

UPDATE rev.EPC_STU_PGM_FRM
SET ELIGIBILITY_CODE = FRMUPDATE.[STATUS]

FROM 
(
SELECT 
	T1.customerid, T1.[STATUS], FRM.STUDENT_GU
	
	FROM
            OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                 'Text;Database=\\SYNTEMPSSIS\Files\Import\Food Services\FRM;',
                  'SELECT * from Field131.txt'
                ) AS [T1]


INNER JOIN 
(SELECT SIS_NUMBER, HIS.ELIGIBILITY_CODE, ENTER_DATE, HIS.STUDENT_GU
  FROM rev.EPC_STU_PGM_FRM AS HIS
  INNER JOIN 
rev.EPC_STU AS STU
ON
HIS.STUDENT_GU = STU.STUDENT_GU
) AS FRM
ON 
T1.customerid = FRM.SIS_NUMBER
) AS FRMUPDATE

WHERE
FRMUPDATE.STUDENT_GU = rev.EPC_STU_PGM_FRM.STUDENT_GU
	

UPDATE rev.EPC_STU_PGM_FRM_HIS
SET ELIGIBILITY_CODE = FRMUPDATE.[STATUS]

FROM 
(
SELECT 
	T1.customerid, T1.[STATUS], FRM.STU_PGM_FRM_HIS_GU
	
	FROM
            OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                 'Text;Database=\\SYNTEMPSSIS\Files\Import\Food Services\FRM;',
                  'SELECT * from Field131.txt'
                ) AS [T1]


INNER JOIN 
(SELECT SIS_NUMBER, HIS.ELIGIBILITY_CODE, ENTER_DATE, HIS.STU_PGM_FRM_HIS_GU
  FROM rev.EPC_STU_PGM_FRM_HIS AS HIS
  INNER JOIN 
rev.EPC_STU AS STU
ON
HIS.STUDENT_GU = STU.STUDENT_GU
WHERE
HIS.EXIT_DATE IS NULL
) AS FRM
ON 
T1.customerid = FRM.SIS_NUMBER
) AS FRMUPDATE

WHERE
FRMUPDATE.STU_PGM_FRM_HIS_GU = rev.EPC_STU_PGM_FRM_HIS.STU_PGM_FRM_HIS_GU
	
COMMIT


REVERT
GO