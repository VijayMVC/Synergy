EXECUTE AS LOGIN='QueryFileUser'
GO

BEGIN TRANSACTION 

DELETE rev.EPC_STREET 

FROM (
SELECT DISTINCT 
	STREET.STREET_GU, 
	T1.*
	
	FROM
            OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                 'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
                  'SELECT * from DELSTREET.csv'
                ) AS [T1]


LEFT JOIN 
	 (SELECT STREET1.*, VALUE_DESCRIPTION AS STREET_TYPE_DESCR FROM 
	 rev.EPC_STREET AS STREET1
	 LEFT JOIN 
	 [APS].[LookupTable]('K12.AddressInfo','STREET_TYPE') AS LU
	 ON
	 LU.VALUE_CODE = [STREET_TYPE] 
	 WHERE SCHOOL_YEAR = 2016
	 ) AS STREET
ON
ISNULL(T1.STREET_LOW_ADDRESS,'') = ISNULL(STREET.STREET_LOW_ADDRESS,'')
AND ISNULL(T1.STREET_NAME,'') = ISNULL(STREET.STREET_NAME,'')
AND ISNULL(T1.STREET_TYPE,'') = ISNULL(STREET.STREET_TYPE_DESCR,'') 
AND ISNULL(T1.STREET_POST_DIRECTION,'') = ISNULL(STREET.STREET_POST_DIRECTION,'')
AND ISNULL(T1.CITY,'') = ISNULL(STREET.CITY,'')
AND ISNULL(T1.STATE,'') = ISNULL(STREET.STATE,'')
AND ISNULL(T1.ZIP_5,'') = ISNULL(STREET.ZIP_5,'')
AND STREET.SCHOOL_YEAR = 2016

) AS T1
--ORDER BY STREET.STREET_GU

WHERE
T1.STREET_GU = rev.EPC_STREET.STREET_GU

ROLLBACK

REVERT
GO