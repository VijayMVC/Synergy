DECLARE @SCHOOLYEAR VARCHAR (4) = '2014'
SELECT
	[ID Number]
	,ELEM_AREA
	,JR_AREA
	,SR_AREA
FROM
(	
SELECT
	ROW_NUMBER () OVER (PARTITION BY STUDENTS.ID_NBR ORDER BY STUDENTS.ID_NBR DESC) AS RN
	,ENROLLMENTS.SCH_NBR AS [School Number]
	,STUDENTS.ID_NBR AS [ID Number]
	,STUDENTS.STATE_ID AS [State ID]
	,STUDENTS.LST_NME AS [Last Name]
	,STUDENTS.FRST_NME AS [First Name]
	,STUDENTS.M_NME AS [Middle Name]
	,ENROLLMENTS.GRDE AS Grade
	
	,FAMINFO.HomePhone AS [Home Ph #]
	,FAMINFO.[HoH1 CellPhone] AS [Secondary Ph #]
	
	,GOODDWELL.HOUSE_NUMBER AS [House Number]
	,GOODDWELL.STR_NME AS [Street Name]
	,GOODDWELL.STR_TAG AS [Street Tag]
	,GOODDWELL.STR_DIR AS [Street Direction]
	,GOODDWELL.RURAL_BOX AS [Rural Box Number]
	,GOODDWELL.RURAL_RTE AS [Rural Route]
	,GOODDWELL.CTY AS Cty
	,GOODDWELL.STE AS [State]
	,GOODDWELL.APT_UNIT AS [Apartment Number]
	,GOODDWELL.ZIP_CD AS [Zip Code]
	
	,STUDENTS.GENDER AS Gender
	
	,ALLSTU.ETHN_CD AS [Ethnic Code]
	,ALLSTU.ETHN_CD2 AS [Ethnic Code 2]
	,ALLSTU.ETHN_CD3 AS [Ethnic Code 3]
	,ALLSTU.ETHN_CD4 AS [Ethnic Code 4]
	,ALLSTU.ETHN_CD5 AS [Ethnic Code 5]
	,ALLSTU.ETHN_CD6 AS [Ethnic Code 6]
	,ALLSTU.HISPLAT
	
	,ALLSTU.BRTH_DT AS [Birth Date]
	
	,CASE
		WHEN CEC.ID_NBR = STUDENTS.ID_NBR THEN 'X'
		ELSE ''
		END
		AS CEC
	,PHLOTE.[Primary Language] AS [PHLOTE Desc]
/*	,CASE
		CAST (PHLOTE.[Primary Language] AS VARCHAR (2))
		WHEN '0' THEN '0 - ENGLISH'
		WHEN '1' THEN '1 - SPANISH'
		WHEN '2' THEN '2 - VIETNAMESE'
		WHEN '3' THEN '3 - HMONG'
		WHEN '4' THEN '4 - CANTONESE'
		WHEN '5' THEN '5 - KHMER(CAMBODIAN)'
		WHEN '6' THEN '6 - KOREAN'
		WHEN '7' THEN '7 - LAOTIAN'
		WHEN '8' THEN '8 - NAVAJO'
		WHEN '9' THEN '9 - PILIPINO (TAGALOG)'
		WHEN '10' THEN '10 - RUSSIAN)'
		WHEN '11' THEN '11 - CREOLE'
		WHEN '12' THEN '12 - ARABIC'
		WHEN '13' THEN '13 - PORTUGUESE'
		WHEN '14' THEN '14 - JAPANESE'
		WHEN '15' THEN '15 - OTHER NON-ENGLISH'
		WHEN '16' THEN '16 - TIWA'
		WHEN '17' THEN '17 - TEWA'
		WHEN '18' THEN '18 - TOWA'
		WHEN '19' THEN '19 - KERES'
		WHEN '20' THEN '20 - JICARILLA APACHE'
		WHEN '21' THEN '21 - MESCALERO APACHE'
		WHEN '22' THEN '22 - ZUNI'
		WHEN '23' THEN '23 - ALBANIAN'
		WHEN '24' THEN '24 - BOSNIAN'
		WHEN '25' THEN '25 - BULGARIAN'
		WHEN '26' THEN '26 - CHINESE'
		WHEN '27' THEN '27 - CORATIAN'
		WHEN '28' THEN '28 - DANISH'
		WHEN '29' THEN '29 - FARSI (PERSIAN)'
		WHEN '30' THEN '30 - FRENCH'
		WHEN '31' THEN '31 - GERMAN'
		WHEN '32' THEN '32 - GREEK'
		WHEN '33' THEN '33 - HEBREW'
		WHEN '34' THEN '34 - INDONESIAN'
		WHEN '35' THEN '35 - IRAQI'
		WHEN '36' THEN '36 - ITALIAN'
		WHEN '37' THEN '37 - KURDISH'
		WHEN '38' THEN '38 - LITHUANIAN'
		WHEN '39' THEN '39 - MANDARIN'
		WHEN '40' THEN '40 - POLISH'
		WHEN '41' THEN '41 - ROMANIAN'
		WHEN '42' THEN '42 - SINHALESE'
		WHEN '43' THEN '43 - SINHALESE'
		WHEN '44' THEN '44 - SOMALIA'
		WHEN '45' THEN '45 - SWAHILI'
		WHEN '46' THEN '46 - THAI'
		WHEN '47' THEN '47 - TIBETAN'
		WHEN '48' THEN '48 - TURKISH'
		WHEN '49' THEN '49 - URDU'
		WHEN '50' THEN '50 - SERBO-CROATIAN'
		WHEN '51' THEN '51 - AMERICAN SIGN LANGUAGE'
		WHEN '52' THEN '52 - ENGLISH BASED SIGN SYSTEM'
		END 
		 AS [PHLOTE Desc]
*/		 
	,CASE ALLSTU.LNCH_FLG
		WHEN 1 THEN 'F'
		WHEN 2 THEN 'R'
		WHEN 4 THEN 'F'
		ELSE 'N' 
		END AS [New Lunch Flag]
	,CASE	
		WHEN ELL.ID_NBR IS NOT NULL THEN 'ELL'
		ELSE ''
		END
		AS [ELL Status]
	,CASE	
		WHEN SPED.ID_NBR IS NOT NULL THEN SPED.[Primary Disability]
		ELSE ''
		END
		AS [PRIM_DISAB]		
		
	,FAMINFO.FAM_NBR
	,GOODDWELL.DWELL AS [Dwelling Number]
	
	,FEEDER.ELEM_AREA
	,FEEDER.INTRM_AREA
	,FEEDER.JR_AREA
	,FEEDER.SR_AREA
	,FAMINFO.MailingAddress1 [Address 1]
	,FAMINFO.ApartmentUnit AS [Address 2]
	,FAMINFO.ADDR_TO AS [Address To]
	,FAMINFO.City
	,FAMINFO.State AS STE
	,FAMINFO.Zip AS [ZIP Code]
	
	,'' AS LAS_CAT
	,'' AS [SPANISH LAS_CAT]
	
	,ENROLLMENTS.BEG_ENR_DT AS [Begin Enrollment Date]
	,ENROLLMENTS.END_ENR_DT AS [End Enrolment Date]
	
	
FROM
	APS.BasicStudent AS STUDENTS
	LEFT JOIN
	APS.EnrollmentsAsOf (GETDATE()) AS ENROLLMENTS
	ON
	STUDENTS.DST_NBR = ENROLLMENTS.DST_NBR
	AND STUDENTS.ID_NBR = ENROLLMENTS.ID_NBR
	
	
------ Getting students at 592 and mark them as X for CEC.  -----	
	LEFT JOIN
	(
		SELECT	
		 ADA.ID_NBR
		 FROM
		 APS.EnrollmentsAsOf (GETDATE()) ADA
		 WHERE
		 SCH_NBR = '592'
		 AND ADA.SCH_YR = 2013
		 )AS CEC
		 
		ON
		STUDENTS.ID_NBR = CEC.ID_NBR
   ----------------------------------------------------------------------	 
		
	
	LEFT JOIN
	DBTSIS.CE020_V AS ALLSTU
	ON
	STUDENTS.DST_NBR = ALLSTU.DST_NBR
	AND STUDENTS.ID_NBR = ALLSTU.ID_NBR
	
	LEFT JOIN
	APS.FamilyInformation AS FAMINFO
	ON
	STUDENTS.[Primary Family Number] = FAMINFO.FAM_NBR
	
	LEFT JOIN
	APS.CurrentELLStudents AS ELL
	ON
	STUDENTS.DST_NBR = ELL.DST_NBR
	AND STUDENTS.ID_NBR = ELL.ID_NBR
	AND ELL.SCH_YR = ENROLLMENTS.SCH_YR
	
	LEFT JOIN
	APS.SpedAsOf (GETDATE()) AS SPED
	ON
	STUDENTS.DST_NBR = SPED.DST_NBR
	AND STUDENTS.ID_NBR = SPED.ID_NBR
	AND ENROLLMENTS.SCH_YR = SPED.SCH_YR
	
	LEFT JOIN
	APS.PhloteStatusAsOf (GETDATE()) AS PHLOTE
	ON
	STUDENTS.DST_NBR = PHLOTE.DST_NBR
	AND STUDENTS.ID_NBR = PHLOTE.ID_NBR
	
	
	
					-------------READ BAD DWELLINGS TO BLANK OUT--------------------------------
		LEFT HASH JOIN  -- REMOVED HASH, RAN ABOUT 20 SEC LONGER
			(
				SELECT
					DWL_NBR AS DWELL
					,LTRIM(HSE_NBR)+' '+STR_NME+' '+STR_TAG+' '+STR_DIR AS DWL_ADDR
					,LTRIM(HSE_NBR) AS HOUSE_NUMBER
					,STR_NME
					,STR_TAG
					,STR_DIR
					,APT_UNIT
					,RURAL_BOX
					,RURAL_RTE
					,DBTSIS.CE005_V.CITY AS CTY
					,STATE AS STE
					,ZIP_CD
				FROM
					DBTSIS.CE005_V
				WHERE
					DST_NBR = 1
					AND (
						HSE_NBR > ''
						OR STR_NME LIKE '%P.O. BOX%'
						OR STR_NME LIKE '%PO BOX%'
						)
					AND STR_NME NOT LIKE ''
					AND STR_NME NOT LIKE '%ABANDONED%'
					AND STR_NME NOT LIKE '%UNKNOWN%'
					AND ZIP_CD != 0
			) AS GOODDWELL

		ON
		FAMINFO.DWL_NBR = GOODDWELL.[DWELL]
	
	---- CE006 CONTAINS THE FEEDER SCHOOLS ----	
	LEFT JOIN DBTSIS.CE006_V AS FEEDER
	ON
	FEEDER.DWL_NBR = FAMINFO.DWL_NBR
	AND FEEDER.DST_NBR = FAMINFO.DST_NBR
WHERE
	ENROLLMENTS.SCH_YR = @SCHOOLYEAR
	AND STUDENTS.DST_NBR = 1
	AND ENROLLMENTS.NONADA_SCH != 'X'
	--AND STUDENTS.ID_NBR = 103437976
--ORDER BY 
	--STUDENTS.ID_NBR
) AS T2
