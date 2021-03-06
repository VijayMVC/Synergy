

EXECUTE AS LOGIN='QueryFileUser'
GO

BEGIN TRAN
UPDATE REV.EPC_STAFF

SET STATE_ID = STATEID

FROM 
(

SELECT T2.*, STF.STATE_ID AS STATEID, STF.STAFF_GU

FROM (
SELECT 
	T1.*
	, CASE WHEN BADGE2 IS NOT NULL THEN BADGE2 ELSE BADGE END AS REALBADGE
	--, STF.STATE_ID
	
	FROM
            OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                 'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
                  'SELECT 
				  *
				   from CONTRACTORS.csv'
                ) AS [T1]
)AS T2

	INNER JOIN 
	
	[SYNSECONDDB.APS.EDU.ACTD].ST_STARS.REV.EPC_STAFF AS STF
	ON
	T2.REALBADGE = STF.BADGE_NUM


) AS T3

WHERE

REV.EPC_STAFF.STAFF_GU = T3.STAFF_GU

COMMIT 

--ORDER BY STATE_ID

	
REVERT
GO


