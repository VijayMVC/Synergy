USE [SchoolNet]
GO
/****** Object:  StoredProcedure [dbo].[accuplacer_load]    Script Date: 04/12/2013 15:11:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[accuplacer_load] as

/****************
      ACCUPLACER TEST
	  *******************/
	  
-- ACCUPLACER only picks up one year. We can only send up one year per day. ---	  
declare @testName varchar(10) = 'Accuplacer';

truncate table test_result;
INSERT INTO [dbo].[TEST_RESULT]
           ([student_code]
           ,[school_year]
           ,[school_code]
           ,[test_date_code]
           ,[test_type_code]
           ,[test_type_name]
           ,[test_section_code]
           ,[test_section_name]
           ,[parent_test_section_code]
           ,[low_test_level_code]
           ,[high_test_level_code]
           ,[test_level_name]
           ,[version_code]
           ,[score_group_name]
           ,[score_group_code]
           ,[score_group_label]
           ,[last_name]
           ,[first_name]
           ,[dob]
           ,[raw_score]
           ,[scaled_score]
           ,[nce_score]
           ,[percentile_score]
           ,[score_1]
           ,[score_2]
           ,[score_raw_name]
           ,[score_scaled_name]
           ,[score_nce_name]
           ,[score_percentile_name]
           ,[score_1_name]
           ,[score_2_name])
       SELECT 
			aps_id student_code, 
			a. [School Year], 
			a.school_code, 
			a.test_date_code, 
			test,
			test_type_name,
			left(subtest,4) test_section_code, 
			subtest test_section_name, 
			parent_test_section_code,
			RIGHT('0'+ CONVERT(VARCHAR,low_test_level_code),2) low_test_level_code, 
			RIGHT('0'+ CONVERT(VARCHAR,high_test_level_code),2) high_test_level_code, 
			/*RIGHT('0'+ CONVERT(VARCHAR,a.grade_level),2)*/ null as test_level_name, 
			version_code,
			dbo.passFail_fn(template.test_name, subtest, score) as score_group_name, 
			dbo.passFail_fn(template.test_name, subtest, score) as score_group_code,
			score_group_label, 
			lname, 
			fname, 
			SUBSTRING(a.dob,1,4)+'-'+SUBSTRING(a.dob,5,2)+'-'+SUBSTRING(a.dob,7,2) as dob,
			raw_score, 
			score as scaled_score, 
			nce_score, 
			percentile_score,
			score_1, 
			score_2,
			score_raw_name, 
			score_scaled_name, 
			score_nce_name, 
			score_percentile_name, 
			score_1_name, 
			score_2_name
	   from [Accuplacer] a
	   inner join pass_fail pf on (pf.aps_subtest_name = a.SUBTEST)
	   , TEST_RESULT_template template
	   where
	   template.test_name = @testName
	   and pf.test_name = @testName
	   and a.score <> '--';



