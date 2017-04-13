USE [ST_Production]
GO

SELECT DISTINCT
      [IDNBR]
      ,[SCHNBR]
	  ,SCH.SCHOOL_CODE
      --,[EXCLUDE_ADA_ADM]
      ,ATT.[GRADE]
      ,[MEMBERDAYS]
      --,[Total Excused]
      ,[Total Unexcused]
      --,[TOTAL_ABSENCE_DAYS]
  FROM [dbo].[ATTENDANCE_2015] ATT
  JOIN
  REV.EPC_STU AS STU
  ON STU.SIS_NUMBER = ATT.IDNBR
  JOIN
  APS.EnrollmentsForYear ('BCFE2270-A461-4260-BA2B-0087CB8EC26A') ENR
  ON ENR.STUDENT_GU = STU.STUDENT_GU
  JOIN
  REV.EPC_SCH SCH
  ON SCH.ORGANIZATION_GU = ENR.ORGANIZATION_GU
  WHERE 1 = 1
  AND ATT.EXCLUDE_ADA_ADM IS NULL
  AND SCHNBR IN ('496','416','413','420','427','450','425','492','457','418','475','448')
  AND SCH.SCHOOL_CODE = SCHNBR
  AND ATT.GRADE IN ('06','07','08')
