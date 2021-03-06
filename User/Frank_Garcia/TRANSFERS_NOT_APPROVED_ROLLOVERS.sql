





declare @school_year varchar (9) = '2018-2019'




	SELECT 	 xfers.xfer_id
			--distinct
			, stu.SIS_NUMBER									AS "SIS Number"						
			, per.first_name								AS "First Name"
			, per.last_name									AS "Last Name"
			, CONVERT(VARCHAR(10), per.BIRTH_DATE, 120)     AS [Student DOB]
			, sch.school_code								AS [Current School Code]
			, org.organization_name							AS [Current School Name]
			, xfers.School_Accepted							AS [Transfers School Code]
			, grade.value_description						AS [Current Grade]
			, case 
					when yr.year_gu = (select year_gu from synergydbdc.st_production.rev.SIF_22_Common_CurrentYearGU) then	--Current Enrollment			
						--Current Xfer Year
						case when left(@school_year,4) = (select school_year from [Synergydbdc].ST_Production.rev.SIF_22_Common_CurrentYear) then	-- Current Year Xfer
							case grade.value_description
								when 'P1' then 'K'
								when 'P2' then 'K'
								else grade.value_description
							end
						--Next Xfer Year
						else 		--Current Enrollment / Next Year Xfer
							-- Xfer dept does not handle PK / P1 / P2
							case grade.value_description  --Look at current grade
								when 'P1' then 'K'
								when 'P2' then 'K'
							else grade.alt_code_sif		--return next years grade
							end
						end  --School_Year check
					else		--No current enrollment, return null
						null
				end as [Transfer Grade]

			, enrollment.enter_date							AS [Enter Date]
			, enrollment.leave_date							AS [Leave Date]
			,  
			case when xfers.email is null or xfers.email = '' then
				(
					select top 1 pper.email --, spar.orderby, innerstu.sis_number, spar.contact_allowed
					FROM   [SYNERGYDBDC].ST_Production.rev.EPC_STU					   innerstu WITH (NOLOCK)
								JOIN [SYNERGYDBDC].ST_Production.rev.EPC_STU_PARENT        spar WITH (NOLOCK) ON spar.STUDENT_GU = innerstu.STUDENT_GU
								JOIN [SYNERGYDBDC].ST_Production.rev.REV_PERSON            pper WITH (NOLOCK) ON pper.PERSON_GU  = spar.PARENT_GU
					where 1=1
					  and innerstu.sis_number = stu.sis_number
					  and spar.contact_allowed = 'Y'
					order by orderby
				)
				else xfers.email 
				end as email
				, xfers.Email_Status
				, xfers.Status
	FROM   [SYNERGYDBDC].ST_Production.rev.EPC_STU						stu
			
			JOIN [SYNERGYDBDC].ST_Production.rev.EPC_STU_SCH_YR			ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
			JOIN [SYNERGYDBDC].ST_Production.rev.REV_ORGANIZATION_YEAR	oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
										and oyr.YEAR_GU =(select year_gu from synergydbdc.st_production.rev.SIF_22_Common_CurrentYearGU)
			JOIN [SYNERGYDBDC].ST_Production.rev.REV_YEAR				yr   ON yr.YEAR_GU = oyr.YEAR_GU
			JOIN [SYNERGYDBDC].ST_Production.rev.REV_PERSON				per  ON per.PERSON_GU = stu.STUDENT_GU
			LEFT JOIN [LookupTable]('K12','Grade') grade ON grade.VALUE_CODE = ssy.GRADE
			JOIN [SYNERGYDBDC].ST_Production.rev.EPC_SCH				sch	 ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
			JOIN [SYNERGYDBDC].ST_Production.rev.REV_ORGANIZATION		org	 ON sch.ORGANIZATION_GU = org.ORGANIZATION_GU
			INNER JOIN synergydbdc.st_production.rev.EPC_STU_ENROLL AS	Enrollment ON SSY.STUDENT_SCHOOL_YEAR_GU = Enrollment.STUDENT_SCHOOL_YEAR_GU
			join APS_Xfer_Request										xfers on xfers.APS_ID = stu.sis_number 
																			  and xfers.School_Accepted = sch.school_code
			join Schools s													  on s.school_code = xfers.School_Accepted
																			  --and s.program = xfers.Program_Accepted
	WHERE 1=1
		and enrollment.leave_date is null
		--and ssy.enter_date <= GETDATE()	--Only include actual enrollments, future enrollments caused by New Year Rollover can result in null school codes and names
		and yr.extension = 'R'	--don't include summer schools since that's not their home school enrollment.
		and xfers.School_Year <> cast(year(getdate()) as varchar) + '-' + cast(year(getdate()) + 1 as varchar)
		--Don't include 5th or 8th graders
		and grade.alt_code_sif not in ('06','09','12','NULL','C1','C2')
		and xfers.status not in ('Parent Accepted','Approved')