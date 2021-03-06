USE [ST_Production]
GO

/****** Object:  UserDefinedFunction [APS].[AttendanceTotalsByPeriod]    Script Date: 2/23/2017 12:03:21 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER FUNCTION [APS].[AttendanceTotalsByPeriod](@AsOfDate DATETIME)
RETURNS TABLE
AS
RETURN


SELECT
    [STUDENT_GU]
    ,[SIS_NUMBER]
    ,[SCHOOL_CODE]
	,EXCLUDE_ADA_ADM
	,PERIOD_BEGIN
    ,CAST(COUNT(*) AS DECIMAL(5,2)) AS [Total Count By Period]
FROM (
SELECT
	 [stu].[STUDENT_GU]
    ,[stu].[SIS_NUMBER]
    ,[sch].[SCHOOL_CODE]
	,[ssy].EXCLUDE_ADA_ADM
    ,[atd].[ABS_DATE]
    ,[cal].[ROTATION]
	,ssy.ORGANIZATION_YEAR_GU
	,sect.TERM_CODE
	,SECT.PERIOD_BEGIN
FROM
    [rev].[EPC_STU_ATT_DAILY] AS [atd] WITH (NOLOCK)

    INNER JOIN
    [rev].[EPC_STU_ATT_PERIOD] AS [atp] WITH (NOLOCK)
    ON
    [atd].[DAILY_ATTEND_GU]=[atp].[DAILY_ATTEND_GU]

    INNER JOIN
    [rev].[EPC_STU_ENROLL] AS [enr] WITH (NOLOCK)
    ON
    [atd].[ENROLLMENT_GU]=[enr].[ENROLLMENT_GU]
    AND [enr].[EXCLUDE_ADA_ADM] IS NULL

    INNER JOIN
    [rev].[EPC_STU_SCH_YR] AS [ssy] WITH (NOLOCK)
    ON
    [enr].[STUDENT_SCHOOL_YEAR_GU]=[ssy].[STUDENT_SCHOOL_YEAR_GU]
    AND [ssy].[EXCLUDE_ADA_ADM] IS NULL

    INNER JOIN
    [rev].[REV_ORGANIZATION_YEAR] AS [oy] WITH (NOLOCK)
    ON
    [ssy].[ORGANIZATION_YEAR_GU]=[oy].[ORGANIZATION_YEAR_GU]

    INNER JOIN
    [rev].[EPC_SCH] AS [sch] WITH (NOLOCK)
    ON
    [oy].[ORGANIZATION_GU]=[sch].[ORGANIZATION_GU]

	INNER JOIN
	[APS].[YearDates] AS [yr] WITH (NOLOCK)
	ON
	[oy].[YEAR_GU]=[yr].[YEAR_GU]
	AND (@AsOfDate BETWEEN [yr].[START_DATE] AND [yr].[END_DATE])
	AND [yr].EXTENSION = 'R'
    LEFT JOIN
    [rev].[EPC_SCH_ATT_CAL] AS [cal] WITH (NOLOCK)
    ON
    [oy].[ORGANIZATION_YEAR_GU]=[cal].[SCHOOL_YEAR_GU] 
    AND [atd].[ABS_DATE]=[cal].[CAL_DATE]

    LEFT JOIN
    [rev].[EPC_SCH_YR_BELL_SCHED] AS [bs] WITH (NOLOCK)
    ON
    [oy].[ORGANIZATION_YEAR_GU]=[bs].[ORGANIZATION_YEAR_GU]
    AND [cal].[BELL_SCHEDULE]=[bs].[BELL_SCHEDULE_CODE]

    LEFT JOIN
    [rev].[EPC_SCH_YR_BELL_SCHED_PER] AS [bel] WITH (NOLOCK)
    ON
    [bs].[BELL_SCHEDULE_GU]=[bel].[BELL_SCHEDULE_GU]
    AND [atp].[BELL_PERIOD]=[bel].[BELL_PERIOD]

    LEFT JOIN
    [rev].[EPC_CODE_ABS_REAS_SCH_YR] AS [abry] WITH (NOLOCK)
    ON
    [atp].[CODE_ABS_REAS_GU]=[abry].[CODE_ABS_REAS_SCH_YEAR_GU]

    LEFT JOIN
    [rev].[EPC_CODE_ABS_REAS] AS [abr] WITH (NOLOCK)
    ON
    [abry].[CODE_ABS_REAS_GU]=[abr].[CODE_ABS_REAS_GU]

	INNER JOIN 
	APS.TermDates()	 AS TERMS
	ON
	TERMS.OrgYearGU = SSY.ORGANIZATION_YEAR_GU
	AND ATD.ABS_DATE BETWEEN TERMS.TermBegin AND TERMS.TermEnd
	AND TERMS.YEAR_GU = YR.YEAR_GU

    INNER JOIN
    [rev].[EPC_STU_CLASS] AS [scls] WITH (NOLOCK)
    ON
    [ssy].[STUDENT_SCHOOL_YEAR_GU]=[scls].[STUDENT_SCHOOL_YEAR_GU]
    AND
    ([atd].[ABS_DATE]<=[scls].[LEAVE_DATE] OR [scls].[LEAVE_DATE] IS NULL)
    AND 
    [atd].[ABS_DATE]>=[scls].[ENTER_DATE]

    INNER JOIN
    [rev].[EPC_SCH_YR_SECT] AS [sect] WITH (NOLOCK)
    ON
    [scls].[SECTION_GU]=[sect].[SECTION_GU]
    AND
    ([atp].[BELL_PERIOD]=[sect].[PERIOD_BEGIN] OR [atp].[BELL_PERIOD]=[sect].[PERIOD_END])
	AND sect.TERM_CODE = TERMS.TermCode
    
    INNER JOIN
    [rev].[EPC_STU] AS [stu] WITH (NOLOCK)
    ON
    [ssy].[STUDENT_GU]=[stu].[STUDENT_GU]

	INNER JOIN 
	REV.EPC_SCH_YR_OPT AS SETUP
	ON
	SETUP.ORGANIZATION_YEAR_GU = OY.ORGANIZATION_YEAR_GU

WHERE
    [abr].[TYPE] IN ('UNE', 'EXC')
  	AND SETUP.SCHOOL_ATT_TYPE IN ('P', 'B')
	--AND SIS_NUMBER = 102790268
	) AS T1

INNER HASH JOIN 
	APS.TermDates()	 AS TERMS
	ON
	TERMS.OrgYearGU = T1.ORGANIZATION_YEAR_GU
	AND T1.ABS_DATE BETWEEN TERMS.TermBegin AND TERMS.TermEnd
	AND T1.TERM_CODE = TERMS.TermCode

GROUP BY
    [STUDENT_GU]
    ,[SIS_NUMBER]
    ,[SCHOOL_CODE]
	,EXCLUDE_ADA_ADM
	,PERIOD_BEGIN

	

GO


