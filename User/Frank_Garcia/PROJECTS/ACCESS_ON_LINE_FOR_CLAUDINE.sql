/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [State Name Abbreviation]
      ,[District Name]
      ,[District Number]
      ,SCH.SCHOOL_NAME AS [School Name]
      ,SCH.SCHOOL_CODE AS [School Number]
      ,[Student Last Name]
      ,[Student First Name]
      ,[Student MI]
      ,STUD.BIRTH_DATE AS [Birth Date]
      ,STUD.[Gender]
      ,STUD.STATE_STUDENT_NUMBER AS [State Student ID]
      ,STUD.SIS_NUMBER AS [District Student ID]
      ,SCH.GRADE AS [Grade]
      ,HISPANIC_INDICATOR AS [Ethnicity - Hispanic Latino]
      ,CASE WHEN RACE_1 = 'Native American' THEN 'Y' ELSE 'N' END AS [Race - American Indian Alaskan Native]
      ,CASE WHEN RACE_1 = 'Asian' THEN 'Y' ELSE 'N' END AS [Race - Asian]
      ,CASE WHEN RACE_1 = 'African-American' THEN 'Y' ELSE 'N' END AS [Race - Black African American]
      ,CASE WHEN RACE_1 = 'Pacific Islander' THEN 'Y' ELSE 'N' END AS [Race - Pacific Islander Hawaiian]
      ,CASE WHEN RACE_1 = 'White' THEN 'Y' ELSE 'N' END AS [Race - White]
      ,STUD.HOME_LANGUAGE AS [Native (Home) Language]
      ,[Date Student First Enrolled in a US School (regardless of country of origin)]
      ,[Length of Time in LEP ELL Program in a US school(regardless of country of origin)]
      ,[Title III Status]
      ,[Migrant]
      ,STUD.SPED_STATUS AS [IEP Status]
      ,CASE WHEN [504].ACCESS_504 IS NOT NULL THEN 'Y' ELSE 'N' END AS [504 Plan]
      ,[Bilingual ESL Program Type (Services Student Receives) - No Additional Services (NAS)]
      ,[Bilingual ESL Program Type (Services Student Receives) - Content Area Tutoring (CAT)]
      ,[Bilingual ESL Program Type (Services Student Receives) - Content-Based ESL (CBE)]
      ,[Bilingual ESL Program Type (Services Student Receives) - Developmental Bilingual (DBE)]
      ,CASE WHEN BEP.PROGRAM_CODE = 'HERIT' THEN 'Y' ELSE 'N' END AS  [Bilingual ESL Program Type (Services Student Receives) - Heritage Language (HLA)]
      ,[Bilingual ESL Program Type (Services Student Receives) - Pull-Out ESL (POE)]
      ,[Bilingual ESL Program Type (Services Student Receives) - Sheltered English Instruction (SEI)]
      ,[Bilingual ESL Program Type (Services Student Receives) - Structured English Immersion or SDAIE (SEN)]
      ,CASE WHEN BEP.PROGRAM_CODE = 'TRAN' THEN 'Y' ELSE 'N' END AS [Bilingual ESL Program Type (Services Student Receives) - Transitional Bilingual (TBI)]
      ,CASE WHEN BEP.PROGRAM_CODE = 'DUAL' THEN 'Y' ELSE 'N' END AS [Bilingual ESL Program Type (Services Student Receives) - Dual Language & Two-Way Immersion (TWI)]
      ,[State - Support Delivery Model (How Student Receives Services) - Not Applicable (NA)]
      ,[State - Support Delivery Model (How Student Receives Services) - Inclusionary Support (IS)]
      ,[State - Support Delivery Model (How Student Receives Services) - Pull-Out for Individualized Support (PO)]
      ,CASE WHEN PR.WAIVER_TYPE = 'RALS' THEN 'Y' ELSE 'N' END AS [State - Support Delivery Model (How Student Receives Services) - Parental Refusal for Services (PR)]
      ,[State - Support Delivery Model (How Student Receives Services) - Self-Contained (SC)]
      ,[Special Accommodations - Manual Control Item Audio (MC)]
      ,[Special Accommodations - Repeat Item Audio (RA)]
      ,[Special Accommodations - Extended Speaking Test Response Time (ES)]
      ,[Special Accommodations - Large Print Version of Test (LP)]
      ,[Special Accommodations - Braille Version of Test (BR)]
      ,[Special Accommodations - Interpreter Signs Test Directions in ASL (SD)]
      ,[Special Accommodations - Read Aloud Listening Test Response Options by Human Reader (LH)]
      ,[Special Accommodations - Repeat Listening Test Response Options by Human Reader (RL)]
      ,[Special Accommodations - Read Aloud Test Items by Human Reader (IH)]
      ,[Special Accommodations - Repeat Test Items by Human Reader (RI)]
      ,[Special Accommodations - Scribed Response (SR)]
      ,[State Defined Optional Data]
      ,[District Defined Optional Data]
      ,[Is Student Testing Online Paper Unknown?]
      ,[Alternate ACCESS Tester]
      ,[Please indicate Tier information if known for Paper Tests]
      ,[Special Accommodations - Word Processor or Similar Keyboarding Device to Respond to Test Items (WD)]
      ,[Special Accommodations - Student Responds Orally Using External Augmentative and Alternate Communication Device or Software (AC)]
      ,[Special Accommodations - Student Responds Using a Recording Device, Which is Played Back and Transcribed by the Student (RD)]
      ,[Special Accommodations - Student Responds Using Braille Writer or Braille Notetaker (BW)]
      ,[Special Accommodations - Student Uses Assistive Technology to Respond to Test Items (AT)]
      ,[Special Accommodations - Test may be Administered by School Personnel in a Non-School Setting (NS)]
      ,[Special Accommodations - Extended Testing Time Within the School Day (ET)]
      ,[Special Accommodations - Extended Testing Session Over Multiple Days for a Single Domain (EM)]
  FROM [AIMS].[dbo].[001_New_ACCESS_StudentFile_15-16] AS ACC
  left join BASIC_STUDENT_WITH_MORE_INFORMATION AS STUD
  ON [District Student ID] = STUD.SIS_NUMBER

  LEFT JOIN
  FIVEOFOUR AS [504]
  ON ACC.[District Student ID] = [504].SIS_NUMBER

  LEFT JOIN
  BEP AS BEP
  ON ACC.[District Student ID] = BEP.SIS_NUMBER

  LEFT JOIN
  PARENT_REFUSE AS PR
  ON PR.SIS_NUMBER = ACC.[District Student ID]

  LEFT JOIN
  stu_school AS SCH
  ON SCH.SIS_NUMBER = ACC.[District Student ID]

  ORDER BY [School Number]


  