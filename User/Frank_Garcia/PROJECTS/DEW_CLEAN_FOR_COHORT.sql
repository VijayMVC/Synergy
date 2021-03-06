
select * from (
SELECT
	ROW_NUMBER () OVER (PARTITION BY [StudentID] ORDER BY [EndEnrollDate] DESC, [EndStatusDescription]) AS RN2
	,*
FROM
(
SELECT
	*
FROM
(
SELECT
	  ROW_NUMBER () OVER (PARTITION BY [StudentID] ORDER BY [EndEnrollDate] DESC, [SchoolName] DESC) AS RN
	  ,[Num]
      ,[StudentID]
      ,[LastName]
      ,[FirstName]
      ,[SchoolNum]
      ,[SchoolName]
      ,[GradeLevel]
      ,[GradStandardYear]
      ,[BeginEnrollDate]
      ,CONVERT(VARCHAR(10),[EndEnrollDate], 101) AS [EndEnrollDate]
	  --CONVERT(VARCHAR(10), per.BIRTH_DATE, 120) 
      ,[EndStatus]
      ,[EndStatusDescription]
      ,[TransferVerifyDate]
      ,[ToSchoolName]
      ,[ToCity]
      ,[ToState]
      ,[TransferVerifyComment]
      ,[ToStateSchool]
      ,[Reason]
  FROM [AIMS].[dbo].[DEW ShowStudents-All EndEnrollmentdata 2012-2013]
  ) T1
  WHERE RN = 1 OR EndStatusDescription = 'Graduated with Diploma'
  )T2
  )t3
  --where rn2 = 1