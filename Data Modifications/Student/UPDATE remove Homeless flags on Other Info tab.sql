/* Update script remove Homeless flag in Other Info>Address History */

UPDATE [STU_ADR_HST]
      SET [STU_ADR_HST].[HOME_LESS] = NULL
FROM
      rev.EPC_STU_ADDRESS_HISTORY AS [STU_ADR_HST]
      
WHERE
      [STU_ADR_HST].[HOME_LESS] = 'X'

