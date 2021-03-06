
-- Step 1: Create the temp table with identifying information and calculate the hours
-- ------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------------
DECLARE @BEPDetail TABLE(
	STUDENT_GU UNIQUEIDENTIFIER
	,STUDENT_SCHOOL_YEAR_GU UNIQUEIDENTIFIER
	,COURSE_GU UNIQUEIDENTIFIER
	,SECTION_GU UNIQUEIDENTIFIER
	,STAFF_GU UNIQUEIDENTIFIER
	,ORGANIZATION_GU UNIQUEIDENTIFIER

	-- All Section Tags
	,ALSMA NVARCHAR(5) -- Math
	,ALSMP NVARCHAR(5) -- maintenance
	,ALS2W NVARCHAR(5) -- 2 Way 
	,ALSED NVARCHAR(5) -- ELD 
	,ALSSC NVARCHAR(5) -- Science
	,ALSSS NVARCHAR(5) -- Social Studies
	,ALSSH NVARCHAR(5) -- Sheltered Content
	,ALSLA NVARCHAR(5) -- Language Arts
	,ALSES NVARCHAR(5) -- ESL
	,ALSOT NVARCHAR(5) -- Other
	,ALSNV NVARCHAR(5) -- Navajo
	 	 
	--Teacher Endorsments
	,TeacherTESOL INT
	,TeacherESL INT
	,TeacherBilingual INT
	,TeacherNavajo INT
	,TeacherBilingualWaiverOnly INT
	,TeacherTESOLWaiverOnly INT

	-- Student Primary Lnaguage
	,HOME_LANGUAGE nvarchar(5)

	-- Student PHLOTE
	,PHLOTE INT

	-- Student ELL status
	,ELL INT

	-- Student Enroll Grade
	,GRADE NVARCHAR(5)

	-- FEP Status
	,FEP nvarchar(5)

	-- calculations
	,FirstHour INT DEFAULT 0
	,SecondHour INT DEFAULT 0
	,ThirdHour INT DEFAULT 0
	,MaxPotentialHours INT DEFAULT 0 
		
	,[Bilingual Model] NVARCHAR(5) DEFAULT ''
	,TotalHours INT DEFAULT 0	
)

-- Enrollments to Schedules to LCE Classes
INSERT INTO
	@BEPDetail
	(
	STUDENT_GU 
	,STUDENT_SCHOOL_YEAR_GU 
	,COURSE_GU 
	,SECTION_GU 
	,STAFF_GU 
	,ORGANIZATION_GU 
	,ALSMA 
	,ALSMP 
	,ALS2W 
	,ALSED 
	,ALSSC 
	,ALSSS 
	,ALSSH 
	,ALSLA 
	,ALSES 
	,ALSOT 
	,ALSNV 
	,TeacherTESOL 
	,TeacherESL
	,TeacherBilingual 
	,TeacherNavajo 
	,TeacherBilingualWaiverOnly 
	,TeacherTESOLWaiverOnly 
	,HOME_LANGUAGE 
	,PHLOTE 
	,ELL 
	,GRADE
	,FEP
	)
SELECT
	Student.STUDENT_GU
	,Enroll.STUDENT_SCHOOL_YEAR_GU
	,Schedule.COURSE_GU
	,Schedule.SECTION_GU
	,LCEClass.STAFF_GU
	,Schedule.ORGANIZATION_GU

	,LCEClass.ALSMA
	,LCEClass.ALSMP
	,LCEClass.ALS2W
	,LCEClass.ALSED
	,LCEClass.ALSSC
	,LCEClass.ALSSS
	,LCEClass.ALSSH
	,LCEClass.ALSLA
	,LCEClass.ALSES
	,LCEClass.ALSOT
	,LCEClass.ALSNV

	,LCEClass.TeacherTESOL
	,LCEClass.TeacherESL
	,LCEClass.TeacherBilingual
	,LCEClass.TeacherNavajo
	,LCEClass.TeacherBilingualWaiverOnly
	,LCEClass.TeacherTESOLWaiverOnly

	,Student.HOME_LANGUAGE
	,CASE WHEN PHLOTE.STUDENT_GU IS NULL THEN NULL ELSE 1 END AS PHLOTE
	,CASE WHEN ELL.STUDENT_GU IS NULL THEN NULL ELSE 1 END AS ELL
	,Enroll.GRADE
	,CASE WHEN LatestEvaluation.IS_ELL = 0 THEN 1 ELSE NULL END AS FEP
FROM
	APS.EnrollmentsAsOf(GETDATE()) AS Enroll
	INNER JOIN 
	APS.ScheduleAsOf(GETDATE()) AS Schedule
	ON
	Enroll.STUDENT_SCHOOL_YEAR_GU = Schedule.STUDENT_SCHOOL_YEAR_GU

	INNER JOIN
	APS.LCEClassesWithMoreInfoAsOf(GETDATE()) AS LCEClass
	ON
	Schedule.SECTION_GU = LCEClass.SECTION_GU

	-- Need primary language
	INNER JOIN
	rev.EPC_STU AS Student
	ON
	Enroll.STUDENT_GU = Student.STUDENT_GU

	LEFT JOIN
	APS.PHLOTEAsOf(GETDATE()) AS PHLOTE
	ON
	Enroll.STUDENT_GU = PHLOTE.STUDENT_GU

	LEFT JOIN
	APS.ELLAsOf(GETDATE()) AS ELL
	ON
	Enroll.STUDENT_GU = ELL.STUDENT_GU

	LEFT JOIN
	APS.LCELatestEvaluationAsOf(GETDATE()) AS LatestEvaluation
	ON
	Enroll.STUDENT_GU = LatestEvaluation.STUDENT_GU
WHERE
	PHLOTE.STUDENT_GU IS NOT NULL
	OR LCEClass.ALS2W IS NOT NULL
	OR ELL.STUDENT_GU IS NOT NULL  -- Added these two because once PHLOTE, Always phlote (review with Lynne)
	OR LatestEvaluation.IS_ELL = 0 -- Added (FEP kiddos = anyone whose latest evaluation qualifies them to not be ELL)




-- ------------------------------------------------------------------------------------------------------
-- Re-classify Navajo Bilingual Teacher Status
-- ------------------------------------------------------------------------------------------------------
UPDATE
	@BEPDetail
SET
	TeacherBilingual = 1
WHERE
	TeacherBilingual = 0
	AND TeacherNavajo = 1
	AND ALSLA IS NOT NULL
	AND ALSNV IS NOT NULL
	AND HOME_LANGUAGE = '08'
	


-- ------------------------------------------------------------------------------------------------------
-- Calculating Potential 1st Hour  *** GETS 1ST HOUR ***
-- ------------------------------------------------------------------------------------------------------
UPDATE
	@BEPDetail
SET
	FirstHour = 1
WHERE
	-- First hour must be by a bilingually endorsed teacher
	TeacherBilingual = 1
	AND
	(
		ALSLA IS NOT NULL
		AND 
		(
			-- Look for language hookup... May also need to look for specific courses????
			(ALSNV IS NULL AND HOME_LANGUAGE = '01')
			OR
			(ALS2W IS NOT NULL)
			OR
			(ALSNV IS NOT NULL AND HOME_LANGUAGE = '08')
		)
	)


-- ------------------------------------------------------------------------------------------------------
-- Potential 2nd Hour  ** SECOND HOUR HERE **
-- ------------------------------------------------------------------------------------------------------
UPDATE
	@BEPDetail
SET
	SecondHour = 1
WHERE
	(
		(
		ELL IS NOT NULL
		AND (
				(TeacherESL IS NOT NULL -- SHould be TeacherESL
				AND (COALESCE(ALSES,ALSED) IS NOT NULL) 
				)
			OR 
				(
				TeacherBilingual = 1 
				AND(COALESCE(ALSMA, ALSSC, ALSSS, ALSOT) IS NOT NULL)
				)
			)
		)
		OR
		(
			(ELL IS NULL)
			AND (COALESCE(ALSMA, ALSSC, ALSSS, ALSOT) IS NOT NULL)
			AND TeacherBilingual = 1
		)
	)
	

-- ------------------------------------------------------------------------------------------------------
-- Determining potential 3rd hour    ** GIVES A THIRD HOUR **
-- ------------------------------------------------------------------------------------------------------
UPDATE
	@BEPDetail
SET
	ThirdHour = 1
WHERE
	(
	GRADE <= '150' --5th grade
	AND (
			(
			ELL IS NOT NULL
			AND (
					(
					TeacherESL=1
					AND COALESCE(ALSES,ALSED) IS NOT NULL 
					)
					OR
					(
					TeacherBilingual = 1
					AND COALESCE(ALSMA, ALSSC, ALSSS, ALSOT) IS NOT NULL
					)
				)
			)
			OR
			(
				(ELL IS NULL)
				AND TeacherBilingual =1
				AND COALESCE(ALSMA, ALSSC, ALSSS, ALSOT) IS NOT NULL
			)
		)-- end and elementary
	)-- end elementary
	OR
	(
	GRADE >'150' -- > 5th grade
	AND (
			(
			ELL IS NOT NULL
			AND (
					(
					TeacherESL = 1
					AND COALESCE(ALSES,ALSED) IS NOT NULL 
					)
					OR 
					(
					TeacherBilingual =1 
					AND COALESCE(ALSMA, ALSSC, ALSSS, ALSOT) IS NOT NULL
					)
				)
			)
			OR
			(
				ELL IS NULL
				AND TeacherBilingual = 1
				AND COALESCE(ALSMA, ALSSC, ALSSS, ALSOT) IS NOT NULL
			)
		) -- end and secondary

	)-- end secondray



-- ------------------------------------------------------------------------------------------------------
-- Calculating Total Hours & Basic Bilingual Model   ** DUAL ON BOTH 3 HOURS ON BOTH ** 
-- ------------------------------------------------------------------------------------------------------
UPDATE
	Detail
SET
	TotalHours = TH.THours
	,[Bilingual Model] = CASE 
		WHEN MaintenanceSum > DualSum THEN 'MAINT'
		WHEN DualSum > MaintenanceSum THEN 'DUAL'
		ELSE
			'*REV*' -- reviewable. Although these have not shown up since all rules are in place
		END -- END CASE
FROM
	@BEPDetail AS Detail
		
	INNER JOIN
	(
	SELECT
		STUDENT_GU 
		,CASE 				
			WHEN MAX(FirstHour) = 1  AND MAX(SecondHour) = 0 THEN 1
			WHEN MAX(FirstHour) = 1  AND MAX(SecondHour) = 1 AND MAX(ThirdHour) = 0 THEN 2
			WHEN MAX(FirstHour) = 1  AND MAX(SecondHour) = 1 AND MAX(ThirdHour) = 1 THEN 3
			ELSE 
			0
		END AS THours
		,ISNULL(SUM(CASE WHEN ALSMP IS NOT NULL THEN 1 ELSE 0 END),0) AS MaintenanceSum
		,ISNULL(SUM(CASE WHEN ALS2W IS NOT NULL THEN 1 ELSE 0 END),0) AS DualSum
		
	FROM
		@BEPDetail 
	GROUP BY
		STUDENT_GU
	) AS TH
		
	ON
		
	Detail.STUDENT_GU = TH.STUDENT_GU




-- ------------------------------------------------------------------------------------------------------
-- Maximum potential hours is...   ** 2 HOURS EACH ** 
-- ------------------------------------------------------------------------------------------------------
UPDATE
	Detail
SET
	MaxPotentialHours = TH.MaxPot
FROM
	@BEPDetail AS Detail
		
	INNER JOIN
	(
	SELECT
		STUDENT_GU
		-- ESL and ELD can only count as one hour combined (either or), and only for ELL Eligible kids
		,CASE WHEN MAX(ELL) IS NOT NULL AND COALESCE(MAX(ALSED),MAX(ALSES)) IS NOT NULL THEN 1 ELSE 0 END  
		+ CASE WHEN MAX(ALSLA) IS NOT NULL THEN 1 ELSE 0 END 
		+ CASE WHEN MAX(ALSMA) IS NOT NULL THEN 1 ELSE 0 END 
		+ CASE WHEN MAX(ALSSS) IS NOT NULL THEN 1 ELSE 0 END 
		+ CASE WHEN MAX(ALSSC) IS NOT NULL THEN 1 ELSE 0 END 
		+ CASE WHEN MAX(ALSOT) IS NOT NULL THEN 1 ELSE 0 END 
			AS MaxPot
	FROM
		@BEPDetail
	GROUP BY
		STUDENT_GU
	) AS TH
		
	ON
		
	Detail.STUDENT_GU = TH.STUDENT_GU




-- ------------------------------------------------------------------------------------------------------
-- Make sure TotalHours <= MaxPotentialHours   ** MAKES TOTAL HOURS MATCH THE POTENTIAL HOURS 3 GOES TO 2 ** 
-- ------------------------------------------------------------------------------------------------------
UPDATE
	@BEPDetail
SET
	TotalHours = MaxPotentialHours
WHERE
	TotalHours > MaxPotentialHours



-- ------------------------------------------------------------------------------------------------------
-- Exception Rule: If any course shows dual and hours = 3 THEN change program to dual  ** NOTHING CHANGED HERE **
-- ------------------------------------------------------------------------------------------------------
UPDATE
	Detail
SET
	[Bilingual Model] = 'DUAL'
FROM
	@BEPDetail AS Detail
		
	INNER JOIN
		
	(
	-- one record per kid	
	SELECT
		STUDENT_GU
		-- see if they have any dual courses
		,ISNULL(SUM(CASE WHEN ALS2W IS NOT NULL THEN 1 ELSE 0 END),0) AS DualSum		
	FROM
		@BEPDetail
	WHERE
		-- look for existing records with 3 hours that are not marked
		-- two way
		TotalHours = 3
		AND [Bilingual Model] != 'DUAL'
	GROUP BY
		STUDENT_GU
	) AS TH
		
	ON
		
	Detail.STUDENT_GU = TH.STUDENT_GU
		
WHERE
	DualSum > 0




-- ------------------------------------------------------------------------------------------------------
-- Exception Rule: If student has 1 or 2 hours, and has at least 1 dual course, program is determined
--					by ELL status ELL = Maintenance, Non-ELL = Enrichment

-- ** THIS ONE CHANGED HIS DUALS TO MAINT BOTH RECORDS **
-- ------------------------------------------------------------------------------------------------------
UPDATE
	Detail
SET
	[Bilingual Model] = CASE WHEN ELL IS NOT NULL THEN 'MAINT' ELSE 'ENRIC' END
FROM
	@BEPDetail AS Detail
		
	INNER JOIN
		
	(
	-- one record per kid	
	SELECT
		STUDENT_GU
		-- see if they have any dual courses
		,ISNULL(SUM(CASE WHEN ALS2W IS NOT NULL THEN 1 ELSE 0 END),0) AS DualSum		
	FROM
		@BEPDetail
	WHERE
		TotalHours >= 1 AND TotalHours <= 2
	GROUP BY
		STUDENT_GU
	) AS TH
		
	ON
		
	Detail.STUDENT_GU = TH.STUDENT_GU
		
WHERE
	DualSum > 0




-- ------------------------------------------------------------------------------------------------------
-- Exception Rule: If not in 2way dual and not PHLOTE and not ELL then 0 hrs   ** NOTHING HERE **
-- ------------------------------------------------------------------------------------------------------

UPDATE
	Detail
SET
	TotalHours = 0
FROM
	@BEPDetail AS Detail

	LEFT JOIN

	(
	-- one record per kid	
	SELECT
		STUDENT_GU
		-- see if they have any dual courses
		,ISNULL(SUM(CASE WHEN ALS2W IS NOT NULL THEN 1 ELSE 0 END),0) AS DualSum		
	FROM
		@BEPDetail
	GROUP BY
		STUDENT_GU
	) AS Has2Way
	ON
	Detail.STUDENT_GU = Has2Way.STUDENT_GU
WHERE
	Has2Way.STUDENT_GU IS NULL
	AND Detail.PHLOTE IS NULL
	AND Detail.ELL IS NULL


-- ------------------------------------------------------------------------------------------------------
-- Exception Rule: If ELL And Maitenance and 1 hour => change to 2  ** NO CHANGE HERE ** 
-- ------------------------------------------------------------------------------------------------------
UPDATE
	@BEPDetail
SET
	TotalHours = 2
WHERE
	TotalHours = 1
	AND ELL IS NOT NULL 
	AND [Bilingual Model] = 'MAINT'




-- ------------------------------------------------------------------------------------------------------
-- Exception Rule: If (FEP or not ELL) And Maintenance or Transition change model to Enrichment   ** STILL MAINT ** 
-- ------------------------------------------------------------------------------------------------------
UPDATE
	@BEPDetail
SET
	[Bilingual Model] = 'ENRIC'
WHERE
	[Bilingual Model] IN ('MAINT', 'TRANS')
	AND 
		(
		FEP IS NOT NULL 
		OR
		ELL IS NULL
		)



-- ------------------------------------------------------------------------------------------------------
-- Exception Rule: If FEP or Non-ELL And Enrichment and 3 total hours, reduce to 2  ** NO CHANGE HERE ** 
-- ------------------------------------------------------------------------------------------------------
UPDATE
	@BEPDetail
SET
	TotalHours = 2
WHERE
	[Bilingual Model] = 'ENRIC'
	AND TotalHours = 3




-- ------------------------------------------------------------------------------------------------------
-- Exception Rule: No hours if pre-kinders (but still show them)	** NO CHANGE HERE ** 
-- ------------------------------------------------------------------------------------------------------
UPDATE
	@BEPDetail
SET
	TotalHours = 0
WHERE
	GRADE IN ('050', '070', '090')




-- ------------------------------------------------------------------------------------------------------
-- Exception Rule: IF < 3 hours and NON-PHLOTE, Then they do not qualify (0 hours)	** NO CHANGE HERE ** 
-- ------------------------------------------------------------------------------------------------------
-- LOGIC NOT RIGHT <= WORK ON IT
UPDATE
	@BEPDetail
SET
	TotalHours = 0
WHERE
	PHLOTE IS NULL
	AND ELL IS NULL  -- Added these two lines because new rule, once PHLOTE always PHLOTE
	AND FEP IS NULL  -- added line
	AND TotalHours < 3
	AND TotalHours != 0



-- ------------------------------------------------------------------------------------------------------
-- Exception Rule: If no hours... then no model		** NO CHANGE HERE ** 
-- ------------------------------------------------------------------------------------------------------
UPDATE
	@BEPDetail
SET
	[Bilingual Model] = ''
WHERE
	TotalHours = 0		


					SELECT * FROM @BEPDetail WHERE STUDENT_GU = '9373201E-BD8B-4FD1-B88D-F8C11443601E'
/*



-- Only if RunMode is set to 'CreateRecords' Do we actually affect the BEP records
IF @RunMode = 'CreateRecords'
BEGIN
	BEGIN TRANSACTION

	-- ------------------------------------------------------------------------------------------------------
	-- ------------------------------------------------------------------------------------------------------
	-- Step 2: Remove BEP records inside the range we are working for
	-- ------------------------------------------------------------------------------------------------------
	-- ------------------------------------------------------------------------------------------------------
	DELETE FROM
		rev.EPC_STU_PGM_ELL_BEP
	WHERE
		ENTER_DATE BETWEEN @BEPRangeFrom AND @BEPRangeTo



	-- ------------------------------------------------------------------------------------------------------
	-- ------------------------------------------------------------------------------------------------------
	-- Step 3: Close Open BEPS with the start date of the next period
	-- ------------------------------------------------------------------------------------------------------
	-- ------------------------------------------------------------------------------------------------------

	UPDATE
		CurrentBEP
	SET
		EXIT_DATE = DATEADD(day, -1,@BEPRangeFrom) -- Day before
	FROM
		rev.EPC_STU_PGM_ELL_BEP AS CurrentBEP

	WHERE
		CurrentBEP.EXIT_DATE IS NULL


	-- ------------------------------------------------------------------------------------------------------
	-- ------------------------------------------------------------------------------------------------------
	-- Step 4: Insert New Records
	-- ------------------------------------------------------------------------------------------------------
	-- ------------------------------------------------------------------------------------------------------
	INSERT INTO
		rev.EPC_STU_PGM_ELL_BEP
		(
		STU_PGM_ELL_BEP_GU
		,ENTER_DATE
		,STUDENT_GU
		,PROGRAM_INTENSITY
		,PROGRAM_CODE
		)
	SELECT
		NEWID()
		,@BEPRangeFrom
		,StudentBEP.*
	FROM
		(
		SELECT DISTINCT
			STUDENT_GU
			,CONVERT(NVARCHAR,TotalHours) AS TotalHours
			,[Bilingual Model]
		FROM
			@BEPDetail
		WHERE
			TotalHours > 0
			AND [Bilingual Model] != ''
		) AS StudentBEP

	COMMIT
END -- END IF

--DT-1000 slaitnederC ffatS


-- ------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------------
-- Output (When Applicable)
-- ------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------------

IF @Output = 'Detail'
	BEGIN
	--/* **Detail Data**
	SELECT
		Organization.ORGANIZATION_NAME AS School
		,BasicStudent.SIS_NUMBER
		,BasicStudent.LAST_NAME
		,BasicStudent.FIRST_NAME
		,GradeLevel.VALUE_DESCRIPTION AS GRADE

		,BEP.HOME_LANGUAGE AS LanguageCode
		,BEP.ELL
		,BEP.PHLOTE
		,BEP.FEP

		,BEP.[Bilingual Model]
		,BEP.TotalHours
		,DCM.COURSE_ID
		,DCM.COURSE_TITLE
		,Section.SECTION_ID

		,BEP.ALSES AS TagESL
		,BEP.ALSED AS TagELD
		
		,BEP.ALSMP AS TagMaintenance
		,BEP.ALS2W AS TagDual

		,BEP.ALSLA AS TagLangArts
		,BEP.ALSMA AS TagMath
		,BEP.ALSSC AS TagScience
		,BEP.ALSSS AS TagSocStudies
		,BEP.ALSOT AS TagOther
		,BEP.ALSNV AS TagNavajo

		,BEP.TeacherTESOL
		,BEP.TeacherESL
		,BEP.TeacherBilingual
		,BEP.TeacherNavajo
		,BEP.TeacherBilingualWaiverOnly
		,BEP.TeacherTESOLWaiverOnly

		,BEP.FirstHour
		,BEP.SecondHour
		,BEP.ThirdHour
		,BEP.MaxPotentialHours
	FROM
		@BEPDetail AS BEP
		INNER JOIN
		APS.PrimaryEnrollmentsAsOf(GETDATE()) AS Enroll
		ON
		BEP.STUDENT_GU = Enroll.STUDENT_GU

		INNER JOIN
		APS.BasicStudent
		ON
		BEP.STUDENT_GU = BasicStudent.STUDENT_GU

		INNER JOIN
		rev.REV_ORGANIZATION_YEAR AS OrgYear
		ON
		Enroll.ORGANIZATION_YEAR_GU = OrgYear.ORGANIZATION_YEAR_GU

		INNER JOIN
		rev.REV_ORGANIZATION AS Organization
		ON
		OrgYear.ORGANIZATION_GU = Organization.ORGANIZATION_GU

		LEFT JOIN
		APS.LookupTable('k12','Grade') AS GradeLevel
		ON
		Enroll.GRADE = GradeLevel.VALUE_CODE

		INNER JOIN
		rev.EPC_CRS AS DCM
		ON
		BEP.COURSE_GU = DCM.COURSE_GU

		INNER JOIN
		rev.EPC_SCH_YR_SECT AS Section
		ON
		BEP.SECTION_GU = Section.SECTION_GU

	ORDER BY
		Organization.ORGANIZATION_NAME
		,GradeLevel.LIST_ORDER
		,BEP.STUDENT_GU
		,DCM.COURSE_ID
	--*/
	END
-- -----------------------------------------------------------------------------------------------------
ELSE IF @Output = 'Student'
	BEGIN
	-- ** Kids with hours (one per kid) **
	SELECT
		Organization.ORGANIZATION_NAME AS School
		,BasicStudent.SIS_NUMBER
		,BasicStudent.LAST_NAME
		,BasicStudent.FIRST_NAME
		,GradeLevel.VALUE_DESCRIPTION AS GRADE
		,TotalHours
		,[Bilingual Model]
	FROM
		(
		SELECT
			DISTINCT
			STUDENT_GU
			,TotalHours
			,[Bilingual Model]
		FROM
			@BEPDetail 
		WHERE
			TotalHours!=0
			OR [Bilingual Model] != ''
		)AS BEP
		INNER JOIN
		APS.PrimaryEnrollmentsAsOf(GETDATE()) AS Enroll
		ON
		BEP.STUDENT_GU = Enroll.STUDENT_GU

		INNER JOIN
		APS.BasicStudent
		ON
		BEP.STUDENT_GU = BasicStudent.STUDENT_GU

		INNER JOIN
		rev.REV_ORGANIZATION_YEAR AS OrgYear
		ON
		Enroll.ORGANIZATION_YEAR_GU = OrgYear.ORGANIZATION_YEAR_GU

		INNER JOIN
		rev.REV_ORGANIZATION AS Organization
		ON
		OrgYear.ORGANIZATION_GU = Organization.ORGANIZATION_GU

		LEFT JOIN
		APS.LookupTable('k12','Grade') AS GradeLevel
		ON
		Enroll.GRADE = GradeLevel.VALUE_CODE
	ORDER BY
		Organization.ORGANIZATION_NAME
		,GradeLevel.LIST_ORDER
	END
-- -----------------------------------------------------------------------------------------------------
ELSE IF @Output = 'Totals'
	BEGIN
	-- ** Groups by Schools
	SELECT
		Organization.ORGANIZATION_NAME AS School
		,GradeLevel.VALUE_DESCRIPTION AS GRADE
		,[Bilingual Model] + ' - ' + CONVERT(NVARCHAR,TotalHours) AS [Program + Hours]
		,COUNT(*)
	FROM
		(
		SELECT
			DISTINCT
			STUDENT_GU
			,TotalHours
			,[Bilingual Model]
		FROM
			@BEPDetail 
		WHERE
			TotalHours!=0
			OR [Bilingual Model] != ''
		)AS BEP
		INNER JOIN
		APS.PrimaryEnrollmentsAsOf(GETDATE()) AS Enroll
		ON
		BEP.STUDENT_GU = Enroll.STUDENT_GU

		INNER JOIN
		APS.BasicStudent
		ON
		BEP.STUDENT_GU = BasicStudent.STUDENT_GU

		INNER JOIN
		rev.REV_ORGANIZATION_YEAR AS OrgYear
		ON
		Enroll.ORGANIZATION_YEAR_GU = OrgYear.ORGANIZATION_YEAR_GU

		INNER JOIN
		rev.REV_ORGANIZATION AS Organization
		ON
		OrgYear.ORGANIZATION_GU = Organization.ORGANIZATION_GU

		LEFT JOIN
		APS.LookupTable('k12','Grade') AS GradeLevel
		ON
		Enroll.GRADE = GradeLevel.VALUE_CODE
	GROUP BY
		Organization.ORGANIZATION_NAME
		,GradeLevel.VALUE_DESCRIPTION
		,[Bilingual Model] + ' - ' + CONVERT(NVARCHAR,TotalHours)
	ORDER BY
		Organization.ORGANIZATION_NAME
		,GradeLevel.VALUE_DESCRIPTION
		,[Bilingual Model] + ' - ' + CONVERT(NVARCHAR,TotalHours)
*/