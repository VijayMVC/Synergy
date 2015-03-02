
SELECT rev.EPC_SCH.SCHOOL_CODE, rev.REV_ORGANIZATION.ORGANIZATION_NAME, rev.EPC_STU.SIS_NUMBER, rev.REV_PERSON.FIRST_NAME, rev.REV_PERSON.LAST_NAME, rev.EPC_STU_ATT_DAILY.ABS_DATE, rev.EPC_STU_ATT_DAILY.CODE_ABS_REAS1_GU, rev.EPC_STU_ATT_DAILY.ABS_FTE1, rev.EPC_CODE_ABS_REAS.TYPE, rev.EPC_CODE_ABS_REAS.ABBREVIATION, rev.EPC_CODE_ABS_REAS.DESCRIPTION
FROM ((rev.REV_PERSON INNER JOIN ((rev.EPC_SCH INNER JOIN (((((rev.EPC_STU_SCH_YR INNER JOIN rev.EPC_STU_ENROLL ON rev.EPC_STU_SCH_YR.STUDENT_SCHOOL_YEAR_GU = rev.EPC_STU_ENROLL.STUDENT_SCHOOL_YEAR_GU) INNER JOIN rev.EPC_STU_ATT_DAILY ON rev.EPC_STU_ENROLL.ENROLLMENT_GU = rev.EPC_STU_ATT_DAILY.ENROLLMENT_GU) INNER JOIN rev.REV_YEAR ON rev.EPC_STU_SCH_YR.YEAR_GU = rev.REV_YEAR.YEAR_GU) INNER JOIN rev.REV_ORGANIZATION_YEAR ON (rev.REV_YEAR.YEAR_GU = rev.REV_ORGANIZATION_YEAR.YEAR_GU) AND (rev.EPC_STU_SCH_YR.ORGANIZATION_YEAR_GU = rev.REV_ORGANIZATION_YEAR.ORGANIZATION_YEAR_GU)) INNER JOIN rev.REV_ORGANIZATION ON rev.REV_ORGANIZATION_YEAR.ORGANIZATION_GU = rev.REV_ORGANIZATION.ORGANIZATION_GU) ON rev.EPC_SCH.ORGANIZATION_GU = rev.REV_ORGANIZATION.ORGANIZATION_GU) INNER JOIN rev.EPC_STU ON rev.EPC_STU_SCH_YR.STUDENT_GU = rev.EPC_STU.STUDENT_GU) ON rev.REV_PERSON.PERSON_GU = rev.EPC_STU.STUDENT_GU) INNER JOIN rev.EPC_CODE_ABS_REAS_SCH_YR ON (rev.EPC_CODE_ABS_REAS_SCH_YR.CODE_ABS_REAS_SCH_YEAR_GU = rev.EPC_STU_ATT_DAILY.CODE_ABS_REAS1_GU) AND (rev.REV_ORGANIZATION_YEAR.ORGANIZATION_YEAR_GU = rev.EPC_CODE_ABS_REAS_SCH_YR.ORGANIZATION_YEAR_GU)) INNER JOIN rev.EPC_CODE_ABS_REAS ON rev.EPC_CODE_ABS_REAS_SCH_YR.CODE_ABS_REAS_GU = rev.EPC_CODE_ABS_REAS.CODE_ABS_REAS_GU

WHERE 
--SIS_NUMBER = 970040467
(((rev.REV_YEAR.SCHOOL_YEAR)=2014) AND ((rev.REV_YEAR.EXTENSION)='R') AND ((rev.EPC_SCH.SCHOOL_CODE) Between '200' And '400') AND ((rev.EPC_STU_ATT_DAILY.ABS_FTE1) Is Not Null) AND ((rev.EPC_CODE_ABS_REAS.ABBREVIATION) Not In ('ABS','UP','UX')))
ORDER BY ABS_DATE
--rev.EPC_SCH.SCHOOL_CODE, rev.EPC_STU.SIS_NUMBER
