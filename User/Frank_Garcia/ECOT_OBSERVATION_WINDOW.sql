USE [ST_Production]
GO

/****** Object:  View [APS].E[KOTObservationWindow]    Script Date: 6/8/2017 1:24:01 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER VIEW [APS].[EKOTObservationWindow] AS

	SELECT
		'BOY' AS [WindowName]
		,'001' AS [DistrictCode]
		,[School].[SCHOOL_CODE] AS [LocationCode]
		,CONVERT(VARCHAR(10),CalendarOptions.START_DATE,126) AS START_DATE
		,CONVERT(VARCHAR(10),CalendarOptions.END_DATE,126) AS END_DATE
		,'' AS [Statement]
		,'' AS [ErrorDesc]
	FROM
		rev.EPC_SCH_ATT_CAL_OPT AS CalendarOptions
		
		INNER JOIN
		REV.REV_ORGANIZATION_YEAR AS OrgYear
		ON
		CalendarOptions.ORG_YEAR_GU = OrgYear.ORGANIZATION_YEAR_GU
		
		INNER JOIN
		rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
		ON 
		OrgYear.[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
		
		INNER JOIN 
		rev.EPC_SCH AS [School] -- Contains the School Code / Number
		ON 
		[Organization].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]

		INNER JOIN 
		rev.REV_YEAR AS YEARS
		ON
		OrgYear.YEAR_GU = YEARS.YEAR_GU
	WHERE
		-- Exclude Child Find and Early Childhood
		OrgYear.ORGANIZATION_GU != '42D6D930-6B5F-4E86-ABC9-4D67C79875F5'
		AND YEARS.[SCHOOL_YEAR] = '2017'
		AND EXTENSION IN ('N')
		AND ([School].[SCHOOL_CODE] BETWEEN '200' AND '400'
		OR School.SCHOOL_CODE IN ('069','496','118','058','900'))
		
		--IN ('206','207','210','214','215','225','228','229','339','234','236','118','237','351','244','303','249','252',
		--	'219','069','255','258','261','496','230','270','395','273','279','231','282','285','288','373','291','297',
		--	'336','300','365','364','250','305','307','309','310','324','275','333','330','392','357','280','363','370',
		--	'264','376','379')
	--GROUP BY
	--	OrgYear.YEAR_GU
	--	,EXTENSION
	
	--ORDER BY SCHOOL.SCHOOL_CODE
	
GO


