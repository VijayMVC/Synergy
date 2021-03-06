/****** Script for SelectTopNRows command from SSMS  ******/
SELECT  [sequence_num]
      ,[xfer_id]
      ,[APS_ID]
      ,[Student_First_Name]
      ,[Student_Last_Name]
      ,[Student_DOB]
      ,[Student_Gender]
      ,[Synergy_Parent_GU]
      ,[Current_School]
      ,[SPED_LOI]
      ,[SPED_Primary_Disability]
      ,[Reason_For_Request]
      ,[School_Requested_1]
      ,[School_1_SPED_Availability]
      ,[School_Requested_2]
      ,[School_2_SPED_Availability]
      ,[School_Requested_3]
      ,[School_3_SPED_Availability]
      ,[SPED_comments]
      ,[grade_entering]
      ,[Status]
      ,[Sibling_First_Name]
      ,[Sibling_Last_Name]
      ,[Sibling_APS_ID]
      ,[Sibling_School]
      ,[Rank]
      ,[F_School]
      ,[School_Accepted]
      ,[Email]
      ,[Email_Status]
      ,[Tumble_Number]
      ,[Last_Tumble_Processed]
      ,[Comments]
      ,[Record_Inserted_Date]
      ,[School_Year]
  FROM [StudentTransfersProd].[dbo].[APS_Xfer_Request]
  WHERE
  1 = 1 
  --AND School_Accepted IS NOT NULL 
  --AND School_Accepted != '---'
  --AND School_Accepted != '...'
  --AND School_Accepted != ''
  AND Email_Status IS NULL
  AND Email != ''
  AND Status = 'No Space Available'
  ORDER BY Status



  /****** Script for SelectTopNRows command from SSMS  ******/
SELECT  [sequence_num]
      ,[xfer_id]
      ,[Student_First_Name]
      ,[Student_Middle_Name]
      ,[Student_Last_Name]
      ,[Student_DOB]
      ,[Student_Gender]
      ,[Parent_First_Name]
      ,[Parent_Last_Name]
      ,[Phone]
      ,[Email]
      ,[Email_Status]
      ,[APS_Student_ID_Number]
      ,[Student_Address]
      ,[Student_Address_City]
      ,[Student_Address_State]
      ,[Student_Address_Zip]
      ,[Parent_Gaurdian_1_First_Name]
      ,[Parent_Gaurdian_1_Last_Name]
      ,[Parent_Gaurdian_1_Phone_1]
      ,[Parent_Gaurdian_1_Phone_2]
      ,[Parent_Gaurdian_1_Email]
      ,[Parent_Gaurdian_2_First_Name]
      ,[Parent_Gaurdian_2_Last_Name]
      ,[Parent_Gaurdian_2_Phone_1]
      ,[Parent_Gaurdian_2_Phone_2]
      ,[Parent_Gaurdian_2_Email]
      ,[Grade_Entering]
      ,[Child_Currently_Enrolled_in_APS]
      ,[Currently_Enrolled_School]
      ,[SPED_Services_Requested]
      ,[SPED_LOI]
      ,[SPED_Primary_Disability]
      ,[School_Requested_1]
      ,[School_1_SPED_Availability]
      ,[School_Requested_2]
      ,[School_2_SPED_Availability]
      ,[School_Requested_3]
      ,[School_3_SPED_Availability]
      ,[SPED_comments]
      ,[Reason_After_School_Care]
      ,[Reason_Child_Care_Siblings]
      ,[Reason_Child_of_Employee]
      ,[Reason_Child_of_Employee_First_Name]
      ,[Reason_Child_of_Employee_Last_Name]
      ,[Reason_Child_of_Employee_Badge_Number]
      ,[Reason_Extreme_Hardship]
      ,[Reason_Location_of_Previous_School]
      ,[Reason_Student_Safety]
      ,[Reason_Sibling_Attending_School]
      ,[Reason_Sibling_1_Attending_School_First_Name]
      ,[Reason_Sibling_1_Attending_School_Last_Name]
      ,[Reason_Sibling_1_Attending_School_DOB]
      ,[Reason_Sibling_1_Attending_School_APS_ID]
      ,[Reason_Sibling_2_Attending_School_First_Name]
      ,[Reason_Sibling_2_Attending_School_Last_Name]
      ,[Reason_Sibling_2_Attending_School_DOB]
      ,[Reason_Sibling_2_Attending_School_APS_ID]
      ,[Reason_Siblings_Applying_for_Same_School]
      ,[Reason_Siblings_Applying_for_Same_School_Sibling_1_First_Name]
      ,[Reason_Siblings_Applying_for_Same_School_Sibling_1_Last_Name]
      ,[Reason_Siblings_Applying_for_Same_School_Sibling_1_DOB]
      ,[Reason_Siblings_Applying_for_Same_School_Sibling_1_APS_ID]
      ,[Reason_Siblings_Applying_for_Same_School_Sibling_2_First_Name]
      ,[Reason_Siblings_Applying_for_Same_School_Sibling_2_Last_Name]
      ,[Reason_Siblings_Applying_for_Same_School_Sibling_2_DOB]
      ,[Reason_Siblings_Applying_for_Same_School_Sibling_2_APS_ID]
      ,[Reason_Active_Military]
      ,[Reason_Active_Military_Unit]
      ,[Reason_Active_Military_Unit_Phone_Number]
      ,[Reason_Other]
      ,[Name_of_Parent_Gaurdian_Completing_Form]
      ,[Rank]
      ,[Status]
      ,[School_Accepted]
      ,[Tumble_Number]
      ,[Last_Tumble_Processed]
      ,[Reason_For_Request]
      ,[Comments]
      ,[Record_Inserted_Date]
      ,[School_Year]
	  --begin tran
	  --UPDATE Non_APS_Xfer_Request SET Status = 'No Space Available'
  FROM [StudentTransfersProd].[dbo].[Non_APS_Xfer_Request]
    WHERE
	--status = 'Wait List'
	--rollback
  1 = 1 
  --AND School_Accepted IS NOT NULL 
  --AND School_Accepted != '---'
  --AND School_Accepted != '...'
  --AND School_Accepted != ''
  AND Email_Status IS NULL
  AND Parent_Gaurdian_1_Email != ''
  AND Status = 'No Space Available'
  ORDER BY Status