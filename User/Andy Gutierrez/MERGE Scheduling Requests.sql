-- Merge Bad Course Requests
MERGE INTO rev.EPC_STU_SCHD_REQUEST req
USING
(
      select req2.STUDENT_SCHD_REQUEST_GU,  req2.SCHOOL_YEAR_COURSE_GU AS OLD,  goodSchCrs.SCHOOL_YEAR_COURSE_GU AS NEW_SY_CRS_GU
      from rev.EPC_STU_SCHD_REQUEST req2
      INNER JOIN rev.EPC_STU_SCH_YR ssy on req2.STUDENT_SCHOOL_YEAR_GU = ssy.STUDENT_SCHOOL_YEAR_GU
      inner join rev.EPC_SCH_YR_CRS schCrs on req2.SCHOOL_YEAR_COURSE_GU = schCrs.SCHOOL_YEAR_COURSE_GU
      inner join rev.EPC_SCH_YR_CRS goodSchCrs on schCrs.COURSE_GU = goodSchCrs.COURSE_GU and ssy.ORGANIZATION_YEAR_GU = goodSchCrs.ORGANIZATION_YEAR_GU
      where ssy.ORGANIZATION_YEAR_GU <> schCrs.ORGANIZATION_YEAR_GU
) tmp
ON req.STUDENT_SCHD_REQUEST_GU = tmp.STUDENT_SCHD_REQUEST_GU WHEN MATCHED THEN update SET req.SCHOOL_YEAR_COURSE_GU = tmp.NEW_SY_CRS_GU;
