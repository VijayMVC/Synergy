--<APS - DataDirector - SchoolList>
SELECT DISTINCT
           org.ORGANIZATION_NAME                AS [school_name]
         , sch.SCHOOL_CODE                      AS [school_code]
         , lowgrd.VALUE_DESCRIPTION
           + ' - '   + higgrd.VALUE_DESCRIPTION AS [grade_span]
FROM     rev.REV_ORGANIZATION           org
         JOIN rev.EPC_SCH               sch  on sch.ORGANIZATION_GU       = org.ORGANIZATION_GU
         JOIN rev.REV_ORGANIZATION_YEAR oyr  on oyr.ORGANIZATION_GU       = org.ORGANIZATION_GU
         JOIN rev.REV_YEAR              yr   on yr.YEAR_GU                = oyr.YEAR_GU
                                                --AND yr.YEAR_GU IN (SELECT YEAR_GU FROM APS.YearDates WHERE (GETDATE() BETWEEN YearDates.START_DATE AND YearDates.END_DATE))
                                                --AND yr.YEAR_GU = '26F066A3-ABFC-4EDB-B397-43412EDABC8B'
                                                AND yr.SCHOOL_YEAR = '2014'
         JOIN rev.EPC_SCH_YR_OPT        sopt on sopt.ORGANIZATION_YEAR_GU = oyr.ORGANIZATION_YEAR_GU
         LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') lowgrd on lowgrd.VALUE_CODE = 
                                                                     (select min(cast(G.GRADE as int)) from rev.EPC_SCH_GRADE G WHERE G.ORGANIZATION_YEAR_GU = oyr.ORGANIZATION_YEAR_GU)
         LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') higgrd on higgrd.VALUE_CODE = 
                                                                    (select max(cast(G.GRADE as int)) from rev.EPC_SCH_GRADE G WHERE G.ORGANIZATION_YEAR_GU = oyr.ORGANIZATION_YEAR_GU)
where    sch.SCHOOL_CODE is not NULL
order by org.ORGANIZATION_NAME, sch.SCHOOL_CODE