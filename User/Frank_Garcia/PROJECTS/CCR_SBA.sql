
UPDATE
	[180-SMAXODS-01].SchoolNet.dbo.[SBA_Spring_StudentFile_2014]
SET
	SchoolNet.dbo.[SBA_Spring_StudentFile_2014].[NASISID] = STUDENT.[ALTERNATE STUDENT ID]
	--,SchoolNet.dbo.[SBA_Spring_StudentFile_2014].DisCode = STUDENT.[DISTRICT CODE]

	

	
--SELECT
--	STUDENT.[ALTERNATE STUDENT ID]
--	,STUDENT.[STUDENT ID]
--	,SBA.[rptStudID]
--	,SBA.FName
--	,SBA.LName
--	,SBA.DOB
--	,STUDENT.BIRTHDATE
--	,STUDENT.Period
FROM
	[180-SMAXODS-01].SchoolNet.dbo.[SBA_Spring_StudentFile_2014] AS SBA
	
LEFT JOIN
	[046-WS02].[db_STARS_History].[dbo].[STUDENT] AS STUDENT
	ON
	SBA.[rptStudID] = STUDENT.[STUDENT ID]
	--AND STUDENT.SY = '2014'
	--AND STUDENT.PERIOD = '2014-03-01'
WHERE NASISID IS NULL
--ORDER BY [ALTERNATE STUDENT ID]


