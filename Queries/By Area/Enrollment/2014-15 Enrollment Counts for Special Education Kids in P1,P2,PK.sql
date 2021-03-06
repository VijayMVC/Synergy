/* Don Jarrett
 * 9/26/2014
 *
 * Student enrollment counts for 2014.R for all special education kids in P1,P2,PK.
 */
SELECT
    *
FROM
(
SELECT
    [School].[ORGANIZATION_GU]
    ,[SchoolNumbers].[SCHOOL_CODE]
    ,[School].[ORGANIZATION_NAME]
    ,[Grades].[VALUE_DESCRIPTION]
FROM
    APS.PrimaryEnrollmentsAsOf(GETDATE()) AS Enrollment

    INNER JOIN
    [rev].[REV_PERSON] AS [Person]

    ON
    [Enrollment].[STUDENT_GU]=[Person].[PERSON_GU]

    INNER JOIN
    [rev].[EPC_STU_SCH_YR] AS [StudentSchoolYear]

    ON
    [Person].[PERSON_GU]=[StudentSchoolYear].[STUDENT_GU]

    INNER JOIN
    [APS].[LookupTable]('K12','GRADE') AS [Grades]

    ON
    [StudentSchoolYear].[GRADE]=[Grades].[VALUE_CODE]

    INNER JOIN
    [rev].[REV_ORGANIZATION_YEAR] AS [OrgYear]

    ON
    [StudentSchoolYear].[ORGANIZATION_YEAR_GU]=[OrgYear].[ORGANIZATION_YEAR_GU]

    INNER JOIN
    [rev].[REV_YEAR] AS [Year]

    ON
    [OrgYear].[YEAR_GU]=[Year].[YEAR_GU]

    INNER JOIN
    [rev].[REV_ORGANIZATION] AS [School]

    ON
    [OrgYear].[ORGANIZATION_GU]=[School].[ORGANIZATION_GU]

    INNER JOIN
    [rev].[EPC_SCH] AS [SchoolNumbers]

    ON
    [School].[ORGANIZATION_GU]=[SchoolNumbers].[ORGANIZATION_GU]

WHERE
    ([Year].[SCHOOL_YEAR]=2014 AND [Year].[EXTENSION]='R')
    AND [Grades].[VALUE_DESCRIPTION] IN ('P1','P2','PK')
    AND 
    [Enrollment].[STUDENT_GU] NOT IN
    (
	SELECT
		  CurrentSPED.STUDENT_GU
	   FROM   
		  APS.PrimaryEnrollmentsAsOf(GETDATE()) AS Enrollment
    
		  LEFT JOIN
		  (
			 SELECT
				STUDENT_GU
				,PRIMARY_DISABILITY_CODE
			 FROM
				REV.EP_STUDENT_SPECIAL_ED AS SPED
			 WHERE
				NEXT_IEP_DATE IS NOT NULL
				AND (
				    EXIT_DATE IS NULL 
				    OR EXIT_DATE >= CONVERT(DATE, GETDATE())
				    )
		  ) AS CurrentSPED
    
		  ON
		  Enrollment.STUDENT_GU = CurrentSPED.STUDENT_GU

	   WHERE 
		  CurrentSPED.STUDENT_GU IS NOT NULL
    )

UNION ALL
SELECT
    [School].[ORGANIZATION_GU]
    ,[SchoolNumbers].[SCHOOL_CODE]
    ,[School].[ORGANIZATION_NAME]
    ,CASE
	   WHEN [Grades].[VALUE_DESCRIPTION]='P1' THEN 'SPED-P1'
	   WHEN [Grades].[VALUE_DESCRIPTION]='P2' THEN 'SPED-P2'
	   WHEN [Grades].[VALUE_DESCRIPTION]='PK' THEN 'SPED-PK'
     END AS [VALUE_DESCRIPTION]
FROM
    (
	   SELECT
		  CurrentSPED.STUDENT_GU
	   FROM   
		  APS.PrimaryEnrollmentsAsOf(GETDATE()) AS Enrollment
    
		  LEFT JOIN
		  (
			 SELECT
				STUDENT_GU
				,PRIMARY_DISABILITY_CODE
			 FROM
				REV.EP_STUDENT_SPECIAL_ED AS SPED
			 WHERE
				NEXT_IEP_DATE IS NOT NULL
				AND (
				    EXIT_DATE IS NULL 
				    OR EXIT_DATE >= CONVERT(DATE, GETDATE())
				    )
		  ) AS CurrentSPED
    
		  ON
		  Enrollment.STUDENT_GU = CurrentSPED.STUDENT_GU

	   WHERE 
		  CurrentSPED.STUDENT_GU IS NOT NULL
    ) AS [Sped]

    INNER JOIN
    [rev].[REV_PERSON] AS [Person]

    ON
    [Sped].[STUDENT_GU]=[Person].[PERSON_GU]

    INNER JOIN
    [rev].[EPC_STU_SCH_YR] AS [StudentSchoolYear]

    ON
    [Person].[PERSON_GU]=[StudentSchoolYear].[STUDENT_GU]

    INNER JOIN
    [APS].[LookupTable]('K12','GRADE') AS [Grades]

    ON
    [StudentSchoolYear].[GRADE]=[Grades].[VALUE_CODE]

    INNER JOIN
    [rev].[REV_ORGANIZATION_YEAR] AS [OrgYear]

    ON
    [StudentSchoolYear].[ORGANIZATION_YEAR_GU]=[OrgYear].[ORGANIZATION_YEAR_GU]

    INNER JOIN
    [rev].[REV_YEAR] AS [Year]

    ON
    [OrgYear].[YEAR_GU]=[Year].[YEAR_GU]

    INNER JOIN
    [rev].[REV_ORGANIZATION] AS [School]

    ON
    [OrgYear].[ORGANIZATION_GU]=[School].[ORGANIZATION_GU]

    INNER JOIN
    [rev].[EPC_SCH] AS [SchoolNumbers]

    ON
    [School].[ORGANIZATION_GU]=[SchoolNumbers].[ORGANIZATION_GU]

WHERE
    ([Year].[SCHOOL_YEAR]=2014 AND [Year].[EXTENSION]='R')
    AND [Grades].[VALUE_DESCRIPTION] IN ('P1','P2','PK')
) AS [Counts]

PIVOT
(
    COUNT([ORGANIZATION_GU])
    FOR [VALUE_DESCRIPTION] IN ([P1],[P2],[PK],[SPED-P1],[SPED-P2],[SPED-PK])
) AS [Pivot]

ORDER BY
    [Pivot].[SCHOOL_CODE]