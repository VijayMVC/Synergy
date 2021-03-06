/*
*	Created By:  Don Jarrett
*	Date:  9/30/2014
*
*    This query takes an Excel file with 504 students from 2013-14 and 2014-15 and joins in
*    the following information from Synergy:
*    First Name, Last Name, SIS Number, Current Primary School, Current Grade Level    
*/

SELECT
    ISNULL([Person].[FIRST_NAME],'') AS [First Name]
    ,ISNULL([Person].[LAST_NAME],'') AS [Last Name]
    ,ISNULL([Student].[SIS_NUMBER],CAST([504Students].[ID#] AS INT)) AS [SIS Number]
    ,ISNULL([Organization].[ORGANIZATION_NAME],'') AS [Current Primary School]
    ,ISNULL([Grades].[VALUE_DESCRIPTION],'') AS [Current Grade Level]
FROM
    (
    /*This is 3 pulls from the same Excel spreadsheet union'ed together.
    to get all the id's with data in the 2013-14 and 2014-2015 columns.*/
    SELECT 
	   * 
    FROM 
	   OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0; 
				HDR=YES; IMEX=1; Database=\\syntempssis.aps.edu.actd\Files\TempQuery\504Data.xlsx', 'SELECT [ID#] FROM [HIGH$] WHERE [2013-14] IS NOT NULL OR [2014-2015] IS NOT NULL')

    WHERE
	   [ID#] IS NOT NULL

    UNION

    SELECT 
	   * 
    FROM 
	   OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0; 
				HDR=YES; IMEX=1; Database=\\syntempssis.aps.edu.actd\Files\TempQuery\504Data.xlsx', 'SELECT [ID#] FROM [MIDDLE$] WHERE [2013-14] IS NOT NULL OR [2014-2015] IS NOT NULL')

    WHERE
	   [ID#] IS NOT NULL

    UNION

    SELECT 
	   * 
    FROM 
	   OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0; 
				HDR=YES; IMEX=1; Database=\\syntempssis.aps.edu.actd\Files\TempQuery\504Data.xlsx', 'SELECT [ID#] FROM [ELEMENTARY$] WHERE [2013-14] IS NOT NULL OR [2014-2015] IS NOT NULL')

    WHERE
	   [ID#] IS NOT NULL
    ) AS [504Students]

    LEFT JOIN --join student to get their GU
    [rev].[EPC_STU] AS [Student]
    ON
    [504Students].[ID#]=[Student].[SIS_NUMBER]

    LEFT JOIN --join Person to get their First/Last Name
    [rev].[REV_PERSON] AS [Person]
    ON
    [Student].[STUDENT_GU]=[Person].[PERSON_GU]

    LEFT JOIN --Join enrollments for their current grade and organization_year gu
    [APS].[PrimaryEnrollmentsAsOf](GETDATE()) AS [Enroll]
    ON
    [Student].[STUDENT_GU]=[Enroll].[STUDENT_GU]

    LEFT JOIN --join orgyear to get the school gu
    [rev].[REV_ORGANIZATION_YEAR] AS [OrgYear]
    ON
    [Enroll].[ORGANIZATION_YEAR_GU]=[OrgYear].[ORGANIZATION_YEAR_GU]

    LEFT JOIN --finally join organization to get their school name
    [rev].[REV_ORGANIZATION] AS [Organization]
    ON
    [OrgYear].[ORGANIZATION_GU]=[Organization].[ORGANIZATION_GU]

    LEFT JOIN --join the k12.grade lookup to get their grade level
    [APS].[LookupTable]('K12','GRADE') AS [Grades]
    ON
    [Enroll].[GRADE]=[Grades].[VALUE_CODE]
