/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
	  NON.[PERSON_GU]
      ,[USER_ID]
      ,[ACTIVATE_KEY]
      ,[PASSWORD]
      ,[LAST_ACCESSED]
      ,[LAST_ACCESSED_IP]
      ,[ACTIVATION_DATETIME]
      ,[ACTIVATE_KEY_DATETIME]
      ,[USER_TYPE]
      ,[DISABLED]
      ,[LOGIN_ATTEMPTS]
      ,[PREFERENCES]
      ,[ACTIVATED_VIA_REG]
  FROM [ST_Production].[rev].[REV_USER_NON_SYS] AS NON
  --JOIN
  --REV.REV_PERSON AS PER
  --ON PER.PERSON_GU = NON.PERSON_GU

  JOIN
  REV.EPC_STU_PARENT AS PAR
  ON PAR.PARENT_GU = NON.PERSON_GU

  WHERE 
	NON.[USER_ID] IS NOT NULL
	AND NON.[PASSWORD] IS NOT NULL
	AND NON.[DISABLED] = 'N'
	--AND NON.[USER_TYPE] = '2'
	AND NON.ACTIVATION_DATETIME IS NOT NULL
ORDER BY LAST_ACCESSED