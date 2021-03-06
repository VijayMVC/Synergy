USE [StudentTransfers]
GO
/****** Object:  StoredProcedure [dbo].[Get_Student_Transfer_Info]    Script Date: 10/19/2015 3:14:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/


--ALTER PROCEDURE [dbo].[Get_Student_Transfer_Info](
--     @StudentID VARCHAR(9)
--    ,@StudentBirthday VARCHAR(10)
--    ,@ParentLastName VARCHAR(50)
--    ,@ParentFirstName VARCHAR(50)
--    ,@StudentLastName VARCHAR(50)
--    ,@StudentFirstName VARCHAR(50)
--) AS
--BEGIN

/*	Created: SDS - used GetUserKey as starting template.
	Removed @UserType (1 or 2) check

	---USE SPED LEVEL OF INTEGRATION as per Frank
*/

    SELECT 
	--pper.last_name, pper.first_name, per.last
		   stu.SIS_NUMBER                                 AS [student_contact_code]
		 , CONVERT(VARCHAR(10), per.BIRTH_DATE, 120)      AS [student_dob]
		 , pper.LAST_NAME                                 AS [parent_last_name]
		 , pper.FIRST_NAME                                AS [parent_first_name]
		 , pper.MIDDLE_NAME                               AS [parent_middle_name]
		 , per.LAST_NAME                                  AS [student_last_name]
		 , per.FIRST_NAME                                 AS [student_first_name]
		 , per.GENDER									  AS [student_gender]
		 , sys.ACTIVATE_KEY                               AS [key]
		 , sys.USER_ID                                    AS [user_id]
		 , spar.CONTACT_ALLOWED                           AS [contact_allowed]
		 --, grade.value_description						  AS [grade]
		 , sch.school_code								  AS [current_school_code]
		 , org.organization_name						  AS [current_school_name]
		 , stu.indicator_speced							  AS [sped]
		 , grade.value_description						  AS [current_grade]
		 , grade.alt_code_sif							  AS [next_grade]
		 , LI.VALUE_DESCRIPTION							  AS [sped_level_of_integration]
		 --, org_next.organization_name					  AS [next_school_name]
		 , grid.grid_gu
		 , case 
			when grade.alt_code_sif in ('P1','P2','PK','K','01','02','03','04','05') then 
				(select ORGANIZATION_NAME from [SYNERGYDBDC].ST_Production.rev.REV_ORGANIZATION 
				where ORGANIZATION_GU = grid.elem_school_gu)
			when grade.alt_code_sif in ('06','07','08') then 
				(select ORGANIZATION_NAME from [SYNERGYDBDC].ST_Production.rev.REV_ORGANIZATION 
				where ORGANIZATION_GU = grid.jr_high_school_gu)
			when grade.alt_code_sif in ('09','10','11','12','T1','T2','T3','T4','C1','C2','C3','C4') then 
				(select ORGANIZATION_NAME from [SYNERGYDBDC].ST_Production.rev.REV_ORGANIZATION 
				where ORGANIZATION_GU = grid.sr_high_school_gu)
		   end as next_school
    FROM   [SYNERGYDBDC].ST_Production.rev.EPC_STU                  stu
		 JOIN [SYNERGYDBDC].ST_Production.rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
		 JOIN [SYNERGYDBDC].ST_Production.rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
										and oyr.YEAR_GU = (select YEAR_GU from [SYNERGYDBDC].ST_Production.rev.SIF_22_Common_CurrentYearGU)
		 JOIN [SYNERGYDBDC].ST_Production.rev.REV_YEAR              yr   ON yr.YEAR_GU = oyr.YEAR_GU
		 JOIN [SYNERGYDBDC].ST_Production.rev.EPC_STU_PARENT        spar ON spar.STUDENT_GU = stu.STUDENT_GU
		 JOIN [SYNERGYDBDC].ST_Production.rev.REV_PERSON            pper ON pper.PERSON_GU  = spar.PARENT_GU
		 JOIN [SYNERGYDBDC].ST_Production.rev.REV_ADDRESS           hadr ON hadr.ADDRESS_GU = pper.HOME_ADDRESS_GU
		 JOIN [SYNERGYDBDC].ST_Production.rev.REV_PERSON            per  ON per.PERSON_GU = stu.STUDENT_GU
		 LEFT JOIN [SYNERGYDBDC].ST_Production.rev.REV_USER_NON_SYS sys  ON sys.PERSON_GU = pper.PERSON_GU
		 LEFT JOIN [LookupTable]('K12','Grade') grade ON grade.VALUE_CODE = ssy.GRADE
		 
		 LEFT JOIN [SYNERGYDBDC].ST_Production.rev.EPC_NM_STU_SPED_RPT rpt ON rpt.STUDENT_GU = stu.STUDENT_GU 
		 LEFT JOIN LookupTable ('K12.SpecialEd.IEP', 'LEVEL_INTEGRATION') AS LI ON LI.VALUE_CODE = rpt.LEVEL_INTEGRATION 
		 JOIN [SYNERGYDBDC].ST_Production.rev.EPC_SCH               sch	 ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
	     JOIN [SYNERGYDBDC].ST_Production.rev.REV_ORGANIZATION      org	 ON sch.ORGANIZATION_GU = org.ORGANIZATION_GU
		 left join [SYNERGYDBDC].[ST_Production].[rev].[EPC_GRID] grid on stu.grid_code = grid.grid_code
		 
		 
    WHERE 
		  stu.SIS_NUMBER =  '970053485'
		  AND ssy.ENTER_DATE is not null
		  --AND CONVERT(VARCHAR(10), per.BIRTH_DATE, 120) =  @StudentBirthday
		  --AND pper.LAST_NAME  =  @ParentLastName
		  --AND pper.FIRST_NAME =  @ParentFirstName
		  --AND per.LAST_NAME =  @StudentLastName
		  --AND per.FIRST_NAME =  @StudentFirstName
		  --AND SPAR.CONTACT_ALLOWED = 'Y'
--end



